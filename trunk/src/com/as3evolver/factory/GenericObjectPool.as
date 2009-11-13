package com.as3evolver.factory
{
	import com.as3evolver.utils.ObjectUtils;
	import org.as3commons.lang.ClassUtils;

	/**
	 * <p>
	 * Simple implementation of an object pool. See http://en.wikipedia.org/wiki/Object_pool .
	 * The strength of this implementation is that it can handle objects of any type. Also,
	 * in conjunction with the <code>PoolOfPools</code> class, there arises the
	 * possibility that object pools can be created on the fly as such:
	 * 
	 *  <listing>
	 *   _itemFactory = PoolOfPools.getInstance().gimme(_breadcrumbRenderer, false) as GenericObjectPool;
	 * 	 //_breadcrumbRenderer is of type Class
	 * 	</listing>
	 * 
	 * , instead of having to write a separate class for every object pool used in the application.
	 * </p>
	 * 
	 * <p>
	 * Moreover, the object pool can optionally ensure that there are no duplicates among the objects,
	 * and can do this either superficially (by reference) or in depth (the so-called deep equality),
	 * which goes through the entire object structure and checks for equality of values.
	 * </p>
	 * 
	 * <p>
	 * <strong>TODO:</strong>
	 *  <ul>
	 *   <li>move this class in a 'pool' package, not factory</li>
	 *   <li>create new objects in batches (of 10, for example), instead of individually, on request</li>
	 *  </ul>
	 * <p>
	 * 
	 * @see com.as3evolver.factory.IPool
	 * 
	 * @author Mihai Chira
	 * */
	
	public class GenericObjectPool implements IPool
	{
		protected var _allowDuplicates:Boolean;
		protected var _class:Class;
		protected var _pendingItems:Array = [];
		protected var _useDeepEquality : Boolean;
		
		public function GenericObjectPool( inClass : Class, inAllowDuplicates : Boolean = false, inUseDeepEquality : Boolean = false )
		{
			this._class = inClass ? inClass : Object;
			_allowDuplicates = inAllowDuplicates;
			_useDeepEquality = inUseDeepEquality;
		}
		
		
		/**
		 * Returns a parked object, or a newly created object of the
		 * type <code>_class</code>.
		 * */
		public function gimme(...constructorArgs) : Object
		{
			var item:Object = this._pendingItems.pop();
			if((!item) || !(item is _class))
				item = ClassUtils.newInstance(_class, constructorArgs);
			return (item as _class);
		}
		
		/**
		 * <p>
		 * 'Parks' an object. The assumption is that the application
		 * ceases to use this object, and releases all references to it.
		 * </p>
		 * 
		 * <p>
		 * Parking will not occur if the object is not of type <code>_class</code>,
		 * if it is already parked, or if the <code>_allowDuplicates</code> flag is
		 * true and the object duplicates another parked object.
		 * </p>
		 * 
		 * @param val the Object to park.
		 * */
		public function park(val : Object) : void
		{
			if(val && val is _class)
				if(!this.isParked(val))
					if(_allowDuplicates || !this.duplicatesWhichItem(val))
						this._pendingItems.push(val);
		}
		
		
		/**
		 * Checks for parked status of an object.
		 * 
		 * @param val the object to locate within the parked objects.
		 * 
		 * @return true if the object is parked, false otherwise.
		 * */
		public function isParked(val:Object):Boolean
		{
			return this._pendingItems.indexOf(val) == -1;
		}
		
		
		/**
		 * The class of objects in the pool.
		 * */
		public function get handledClass():Class
		{
			return this._class;
		}
		
		
		/**
		 * Returns the object in the pool which the input parameter duplicates,
		 * if any. If the <code>_useDeepEquality</code> flag is set to true,
		 * the duplication check is done with deep equality, else with superficial
		 * equality (by reference).
		 * 
		 * @param val the object whose duplicate to return
		 * 
		 * @return the object which duplicates the input parameter, by either method
		 * (deep or superficial equality check).
		 * */
		public function duplicatesWhichItem(val:Object) : Object
		{
			var item:Object;
			if(!this._useDeepEquality) {
				for each(item in this._pendingItems)
					if(item == val)
						return item;
			}
			else {
				for each(item in this._pendingItems)
					if(ObjectUtils.deepEquals(item, val))
						return item;
			}
			
			return null;
		}

	}
}