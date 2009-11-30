package com.as3evolver.repository
{
	import org.as3commons.reflect.ClassUtils;

	/**
	 * <p>
	 * Represents a repository for objects, with functions to manage,
	 * retrieve and create new objects. It indexes objects by a unique
	 * property (primary key), so it is only useful in case of objects
	 * with such a characteristic.
	 * </p>
	 *
	 * <p>
	 * This class mirrors the functionality of a db table wrapper, with some
	 * important additions. It was created with RemoteObject VOs in mind,
	 * but can be used for any sort of objects which have a unique key.
	 * </p>
	 *
	 * <p>
	 * <strong>Features:</strong><br/>
	 *  <ul>
	 * 	 <li>"primary key" paradigm, which makes indexing very fast.</li>
	 * 	 <li>functions to help ensure that only one instance of a particular
	 *  	 object exists in your application (search is done by primary key)</li>
	 * 	 <li>can create new items of the handled type</li>
	 * 	 <li>can find items by primary key</li>
	 *  </ul>
	 * </p>
	 *
	 * <p>
	 * Current limitations:
	 *  <ul>
	 *   <li>only one primary key field allowed;</li>
	 *  </ul>
	 * </p>
	 *
	 * <p>
	 * To implement a repository, extend this class and set the type of the object in
	 * the constructor:
	 * <listing>
	   public class SubjectsRepository extends AbstractRepository
	   {
	   public function SubjectsRepository()
	   {
	   super(SubjectVO, 'subjectID');
	   }
	   }
	   </listing>
	 * </p>
	 *
	 * <p>
	 * <strong>TODO:</strong>
	 * - decide if support for multiple primary keys is useful
	 * <p>
	 *
	 * @see com.as3evolver.repository.IAbstractRepository
	 *
	 * @author Mihai Chira
	 * */

	public class AbstractRepository implements IAbstractRepository
	{
		protected var primaryKey : String;
		protected var handledClass : Class;
		protected var items : Array = []; //indexed by the primary key value


		/**
		 * <p>
		 * Creates an <code>AbstractRepository</code> instance. Should never be used directly.
		 * Instead, subclass the <code>AbstractRepository</code> class and call super().
		 * </p>
		 *
		 * @param handledClass the class of items to manage in this repository. Can be an interface
		 * as well, which increases flexibility.
		 * @param primaryKey the name of the property containing the unique key by which to index
		 * the objects. The <code>handledClass</code> class needs to have a property by this name.
		 * */
		public function AbstractRepository( handledClass : Class = null, primaryKey : String = 'id' )
		{
			if( !handledClass )
				handledClass = Object;
			this.handledClass = handledClass;

			if( !primaryKey )
				primaryKey = 'id';
			this.primaryKey = primaryKey;
		}



		public function get all() : Array
		{
			//return an array not indexed by id (because, for instance, this can
			//be turned into an ArrayCollection and used for the view components
			var unindexedItems : Array = [];

			for each( var item : Object in this.items )
				unindexedItems.push( item );

			return unindexedItems;
		}



		/**
		 * <p>
		 * Attempts to add an item to the repository. First, it checks whether the object
		 * is 'valid' (see <code>getObjectIfValid()</code> ), if its primary key is non-null, then
		 * it checks whether an object by that particular id exists already. If no, it adds
		 * the object to the repository and returns the object.
		 * </p>
		 *
		 * @param val the object to add. Must be an instance of <code>handledClass</code> or
		 * of a subclass of <code>handledClass</code>.
		 *
		 * @return the added object, or null if it wasn't added for any reason.
		 *
		 * @see #addMany()
		 * */
		public function add( val : Object ) : Object
		{
			val = this.getObjectIfValid( val );

			if( val && val[ this.primaryKey ])
			{
				var existingObjWithSamePrimaryKey : Object = this.findOne( val[ this.primaryKey ].toString());

				if( !existingObjWithSamePrimaryKey )
					return this.items[ val[ this.primaryKey ].toString()] = val;
			}
			return null;
		}



		/**
		 * <p>
		 * Attempts to add an object or array of objects to the repository. It uses the
		 * <code>add()</code> function, and the <code>getValidObjectsFromArray()</code> function.
		 * </p>
		 *
		 * @param val the object or array of objects to add.
		 *
		 * @return an array of the objects which were added to the repository.
		 *
		 * @see #add()
		 * */
		public function addMany( val : Object ) : Array
		{
			var objectsToAdd : Array;

			if( val is Array )
				objectsToAdd = this.getValidObjectsFromArray( val as Array );
			else
			{
				val = this.getObjectIfValid( val );

				if( val )
					objectsToAdd = [ val ];
			}

			var addedItems : Array = [];

			for each( var item : Object in objectsToAdd )
				if( this.add( item ))
					addedItems.push( item );

			return addedItems;
		}


		/**
		 * <p>
		 * Attempts to create a new object of the <code>handledClass</code> type and add
		 * it to the repository. It first checks if an object by that id already exists.
		 * </p>
		 *
		 * @param val the object or array of objects to add.
		 *
		 * @return true if the object was successfully created and added to the repository,
		 * false otherwise.
		 *
		 * @see #add()
		 * @see #findOne()
		 * */
		public function create( id : String, ... constructorArgs ) : Boolean
		{
			if( id && !this.findOne( id ))
			{
				var newInstance : Object = ClassUtils.newInstance( this.handledClass, constructorArgs );

				if( newInstance && ( newInstance.hasOwnProperty( this.primaryKey )))
				{
					newInstance[ this.primaryKey ] = id;
					return this.add( newInstance );
				}
			}

			return false;
		}


		/**
		 * <p>
		 * Removes an item from the repository based on id.
		 * </p>
		 *
		 * <p>
		 * <strong>TODO:</strong> allow the id to be either Number, String, or Array.
		 * </p>
		 *
		 * @param id the id of the object as String.
		 *
		 * @return true if an item was removed, false if an item by that id doesn't exist.
		 *
		 * @see #add()
		 * */
		public function remove( id : String ) : Boolean
		{
			if( this.items[ id ])
			{
				this.items[ id ] = null;
				return true;
			}
			return false;
		}


		/**
		 * <p>
		 * Searches for objects based on the id input parameter. Makes use of <code>performSearch()</code>
		 * </p>
		 *
		 * @example
		 * <p>
		 * <strong>Usage:</strong>
		 * <listing>
		 * repository.find('3'); //String id
		 * repository.find(3); //Number id
		 * repository.find([3, '4', getLastObjectId()]); //Array of ids</listing>
		 * </p>
		 *
		 * <p>
		 * <strong>Example usage:</strong>
		 * <listing>
		 * productFromServer.yearsObjects = this.yearsRepository.find(productFromServer.years); //productFromServer.years is an array of ids
		 * </listing>
		 * </p>
		 *
		 * @param id the Number or String value of the id property to search against,
		 * or an array of such values.
		 *
		 * @return the objects found based on the 'id' input parameter.
		 *
		 * @see #performSearch()
		 * */
		public function find( id : Object ) : Array
		{
			if( id )
			{
				//determine the ids we need to search against
				var ids : Array = this.determineIdsFromUnknownType( id );

				//do the search
				return this.performSearch( ids );

			}

			return null;
		}


		/**
		 * <p>
		 * Returns the object with the id value of 'id', if it exists, and null otherwise.
		 * </p>
		 *
		 * @param id the value of the id property to search against. <code>toStringId</code> for
		 * converting an unknown id type into String.
		 *
		 * @return the object with the id value of 'id', or null if no such object exists in
		 * the repository.
		 *
		 * @see #toStringId()
		 * */
		public function findOne( id : String ) : Object
		{
			if( this.items[ id ])
				return this.items[ id ];

			return null;
		}




		/**
		 * <p>
		 * Function is a 'filter' for an array of objects - any objects which
		 * have an id value which we already have in the repository are included
		 * in the return array with their local reference (avoids duplication),
		 * and any non-existing ones are added to the repository and included in
		 * the returned array.
		 * </p>
		 *
		 * <p>
		 * Useful when using ValueObjects for AMF transmissions and data of the
		 * same type keeps coming back - this function will help you ensure that
		 * you don't duplicate objects.
		 * </p>.
		 *
		 * <p>
		 * <strong>Example usage:</strong>
		 * <listing>
		 * var nonDuplicatedSubjects:Array = this.subjectsRepository.getOrAddMany(subjectVOs);
		 * </listing>
		 * </p>
		 *
		 * @param val can be an Object of the type <code>this.handledClass</code> or an Array
		 * of such objects
		 *
		 * @see #getOrAdd()
		 * */
		public function getOrAddMany( val : Object ) : Array
		{
			var objectsToGetOrAdd : Array;

			if( val is Array )
				objectsToGetOrAdd = this.getValidObjectsFromArray( val as Array );
			else
			{
				val = this.getObjectIfValid( val );

				if( val )
					objectsToGetOrAdd = [ val ];
			}

			var result : Array = [];
			var oldOrNewItem : Object;

			if( objectsToGetOrAdd )
			{
				for each( var item : Object in objectsToGetOrAdd )
				{
					oldOrNewItem = this.getOrAdd( item );

					if( oldOrNewItem )
						result.push( oldOrNewItem );
				}
			}

			return result;
		}


		/**
		 * <p>
		 * This function acts as a 'filter' for an object - if the object's primary key value
		 * is already in the repository, the local reference of that object is returned. If
		 * not, the object is added and returned.
		 * </p>
		 *
		 * <p>
		 * Useful when using ValueObjects for AMF transmissions and data of the
		 * same type keeps coming back - this function will help you ensure that
		 * you don't duplicate objects.
		 * </p>.
		 *
		 * @param val should be an object of type <code>handledClass</code>
		 *
		 * @see #getOrAdd()
		 * */
		public function getOrAdd( val : Object ) : Object
		{
			var oldOrNewItem : Object;

			if( val && val.hasOwnProperty( this.primaryKey ))
			{
				oldOrNewItem = this.findOne( val[ this.primaryKey ].toString());

				if( !oldOrNewItem )
					oldOrNewItem = this.add( val );
			}

			return oldOrNewItem;
		}



		/**
		 * <p>
		 * Attempts to retrieve an object by the input id. If none is found, a new
		 * object is created, the input id is assigned to it, it is added to the repository
		 * and then returned.
		 * </p>
		 *
		 * @param id the String representation of the id of the object to find or create.
		 * @param constructorArgs the (optional) arguments for the constructor, in case
		 * the object by the input id is not found and <code>handledClass</code> needs
		 * constructor arguments.
		 *
		 * @return the retrieved or created object.
		 *
		 * @see #create()
		 * @see #findOne()
		 * */
		public function getOrCreateById( id : String, ... constructorArgs ) : Object
		{
			var existingItem : Object = this.findOne( id );

			if( !existingItem )
				existingItem = this.create( id, constructorArgs );

			return existingItem;
		}




		/**
		 * <p>
		 * Searches for multiple objects based on a list of ids. Makes use of <code>findOne()</code>
		 * </p>
		 *
		 * @param ids the assumption is that this parameter is an
		 * array of String id values. See @see #determineIdsFromUnknownType()
		 *
		 * @return an array of search results, or an empty array if no object
		 * has been found.
		 *
		 * @see #findOne()
		 * */
		protected function performSearch( ids : Array ) : Array
		{
			var results : Array = [];
			var id : String;
			var foundObj : Object;

			for each( id in ids )
				if( id )
				{
					foundObj = this.findOne( id );

					if( foundObj )
						results.push( foundObj );
				}

			return results;
		}



		/**
		 * <p>
		 * Used to 'normalize' an id or an array of ids. Returns an array of string ids.
		 * </p>
		 *
		 * <p>
		 * This function is currently used by find().
		 * </p>
		 *
		 *
		 * @param id can be a Number, String, or Array of Numbers / Strings.
		 *
		 * @return an array of String ids.
		 *
		 * @see #find()
		 * */
		protected function determineIdsFromUnknownType( id : Object ) : Array
		{
			var ids : Array = [];
			var stringId : String = this.toStringId( id );

			if( stringId )
				ids.push( stringId );
			else if( id is Array )
				for each( var idInArray : Object in( id as Array ))
				{
					stringId = this.toStringId( idInArray );

					if( stringId )
						ids.push( stringId );
				}

			return ids;
		}


		/**
		 * <p>
		 * Used as a 'filter' for a particular array of objects. It returns a new array containing
		 * all the 'valid' objects. See <code>getObjectIfValid()</code> for the definition of 'valid'.
		 * </p>
		 *
		 * <p>
		 * This function is currently used by addMany() and getOrAddMany().
		 * </p>
		 *
		 *
		 * @param array the object instance to be validated.
		 *
		 * @return an array containing only the valid objects from the original input array.
		 *
		 * @see #getObjectIfValid()
		 * @see #addMany()
		 * @see #getOrAddMany()
		 * */
		protected function getValidObjectsFromArray( array : Array ) : Array
		{
			var result : Array = [];
			var validItem : Object;

			for each( var item : Object in array )
				if( item && ( validItem = this.getObjectIfValid( item )))
					result.push( validItem );

			return result;
		}


		/**
		 * <p>
		 * Used as a 'filter' for a particular object. It returns that object if it is 'valid',
		 * or null if it is not. An object is 'valid' if it conforms to the following conditions:<br/>
		 * - is an instance of <code>handledClass</code>
		 * <br/>
		 * More conditions could be added in an override of this function in an implementing class of
		 * <code>AbstractRepository</code>.
		 * </p>
		 *
		 * <p>
		 * This function is currently used by getValidObjectsFromArray(), add(), addMany(), getOrAddMany().
		 * </p>
		 *
		 *
		 * @param val the object instance to be validated.
		 *
		 * @see #getValidObjectsFromArray()
		 * @see #add()
		 * @see #addMany()
		 * @see #getOrAddMany()
		 * */
		protected function getObjectIfValid( val : Object ) : Object
		{
			return( val && ( val is this.handledClass )) ? val : null;
		}


		protected function toStringId( id : Object ) : String
		{
			if( id is String )
				return id as String;
			else if( id is Number )
				return id.toString();
			else
				return '';
		}

	}
}