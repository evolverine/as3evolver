package com.pearson.shingo.view.components.as3.folderBrowsing.filter
{
	import com.as3evolver.utils.ArrayUtils;
	
	
	/**
	 * <p>
	 * This class manages constraints for object filtering. Currently it is geared towards client-side
	 * filtering, but it could be adjusted to work with server-side filtering, where it would send
	 * the server an array of filters to apply to the db items.
	 * </p>
	 * 
	 * <p>
	 * It is assumed that the objects to be filtered are inside a domain model class, which uses a
	 * subclass of AbstractFilter to filter them. Eg: <code>com.pearson.prg.domain.ProductsListDM</code>.
	 * The main filtering function is <code>passes()</code>, which tests if one item passes through the
	 * constraints.
	 * </p>
	 * 
	 * <p>
	 * Individual constraints can be any type of objects, and they are indexed by name. For example,
	 * a constraint object could be a <code>SubjectVO</code> instance (representing, say, the
	 * Mathematics subject), and the name could be 'Subjects'.
	 * Based on this name, the <code>getRelevantObjectProperty</code> function returns the value of the
	 * relevant property of the object being checked (for instance, the property <code>subjects</code>
	 * of the ProductVO class). This value is then compared to the filter objects (which in our example
	 * means checking if an object with the same reference as the Mathematics <code>SubjectVO</code> is
	 * present in the <code>ProductVO</code>'s <code>subjects</code> array).
	 * </p>
	 * 
	 * 
	 * <p>
	 * <strong>TODO:</strong>
	 *  <ul>
	 *   <li>implement a function to filter an array of objects and to return another array with those
	 *       objects which pass the filter. Currently a domain model class needs to implement that function
	 *       itself, but there is no reason for that.</li>
	 *   <li>make so that this filter also checks the type of objects to filter. Currently, for instance,
	 *       the ProductFilterData implementation of passes checks if the item is a ProductVO. This can
	 *       be done generically in the abstract class.</li>
	 *  </ul>
	 * <p>
	 * 
	 * 
	 * @see com.pearson.prg.domain.ProductsListDM
	 * @see com.pearson.prg.domain.filter.ProductFilterData
	 * @see com.pearson.prg.domain.subjects.SubjectVO
	 * 
	 * @author Mihai Chira
	 * */
	public class AbstractFilter implements IFilterManager
	{
		protected var _constraints:Array; //indexed by constraint name
		
		public function AbstractFilter()
		{
			this.clearAllConstraints();
		}
		
		
		
		
		//----------------------MANAGING CONSTRAINTS--------------------------------------
		
		/**
		 * <p>
		 * Clears all constraints.
		 * </p>
		 * 
		 * @see #clearConstraint()
		 * */
		public function clearAllConstraints():void
		{
			this._constraints = [];
		}
		
		
		/**
		 * <p>
		 * Sets a constraint. The difference between <code>setConstraint</code> and
		 * <code>addConstraint</code> is that <code>setConstraint</code> replaces
		 * any previous constraint for that particular <code>categoryName</code>, whereas
		 * <code>addConstraint</code> leaves the previous constraints intact and adds the
		 * new one in addition.
		 * </p>
		 * 
		 * <p>
		 * This function also calls <code>onNewConstraints()</code>, which is intended to
		 * provide an opportunity to compute any custom constraints in subclasses.
		 * </p>
		 * 
		 * @param categoryName the name of the constraint category. For instance, if one wants
		 * to filter educational products so as to see only Mathematics products,
		 * one would set the constraint object (using an instances of <code>SubjectVO</code>
		 * representing the Mathematics subject) with 'Subjects', perhaps, as the category
		 * name. Then this category name would be used in the <code>getConstraintsByName()</code> and
		 * <code>getRelevantObjectProperty()</code> functions to match the constraint objects
		 * to the value of the relevant property of the filtered object.
		 * 
		 * @param constraintObject the object representing the constraint. Can be of any type,
		 * from basic to complex types. But it obviously should be the potential value
		 * of a property of the filtered object type. Pay particular attention to references! One
		 * potential mistake to make is to set a constraint to a SubjectVO instance with the name
		 * of 'Mathematics', say, and for an object to be filtered to have a SubjectVO instance
		 * with the same name, but to be a different instance (i.e. to have a different reference).
		 * In that case, the object would NOT pass the filter. So as a developer you need to ensure
		 * that there is only one instance of this constraint object (see the
		 * <code>AbstractRepository</code> class to help you with that).
		 * 
		 * @see #addConstraint()
		 * @see com.as3evolver.repository.AbstractRepository
		 * */
		public function setConstraint(categoryName : String, constraintObject : Object):void
		{
			if(categoryName && (constraintObject != null)) {
				this._constraints[categoryName] = (constraintObject is Array) ? (constraintObject as Array) : [constraintObject];
				this.onNewConstraints(categoryName, constraintObject);
			}
		}
		
		
		
		/**
		 * <p>
		 * Adds a constraint. The difference between <code>setConstraint</code> and
		 * <code>addConstraint</code> is that <code>setConstraint</code> replaces
		 * any previous constraint for that particular <code>categoryName</code>, whereas
		 * <code>addConstraint</code> leaves the previous constraints intact and adds the
		 * new one in addition.
		 * </p>
		 * 
		 * <p>
		 * This function also calls <code>onNewConstraints()</code>, which is intended to
		 * provide an opportunity to compute any custom constraints in subclasses.
		 * </p>
		 * 
		 * @param categoryName the name of the constraint category. For instance, if one wants
		 * to filter educational products so as to see only Mathematics and English products,
		 * one would add two constraints (using two instances of <code>SubjectVO</code> representing
		 * the Mathematics and the English subjects) with the same category name, perhaps 'Subjects'.
		 * Then this category name would be used in the <code>getConstraintsByName()</code> and
		 * <code>getRelevantObjectProperty()</code> functions to match the constraint objects
		 * to the value of the relevant property of the filtered object.
		 * 
		 * @param constraintObject the object representing the constraint. Can be of any type,
		 * from basic to complex types. However, if it is an array, it is treated as a list of
		 * constraint objects rather than as a single constraint object in itself. So calling
		 * <code>addConstraint</code> with an array as the constraintObject will in effect add
		 * as many constraints as the length of the array.<br/>
		 * This parameter should be a potential value of a property of the filtered object type.
		 * <br/>
		 * <strong>Pay particular attention to references!</strong> For example, one
		 * potential mistake to avoid is to set a constraint to a SubjectVO instance with the name
		 * of 'Mathematics', say, and for an object to be filtered to have a SubjectVO instance
		 * with the same name, but to be a <i>different instance</i> (i.e. to have a different
		 * reference). In that case, the object would NOT pass the filter. Therefore as a developer
		 * you need to ensure that there is only one instance of this constraint object (see the
		 * <code>AbstractRepository</code> class to help you with that).
		 * 
		 * @see #setConstraint()
		 * @see com.as3evolver.repository.AbstractRepository
		 * */
		public function addConstraint(categoryName:String, constraintObject:Object):void
		{
			if(categoryName && constraintObject)
				if(!this.constraintAlreadyExists(categoryName, constraintObject)) {
					if(!this._constraints[categoryName])
						this._constraints[categoryName] = [];
					
					if(constraintObject is Array)
						this._constraints[categoryName] = ArrayUtils.safeConcat(this._constraints[categoryName] as Array, constraintObject as Array);
					else
						(this._constraints[categoryName] as Array).push(constraintObject);
						
					this.onNewConstraints(categoryName, constraintObject);
				}
		}
		
		
		/**
		 * <p>
		 * Clears one constraint.
		 * </p>
		 * 
		 * @param categoryName the name of the constraint category where to look for the constraint
		 * object to be cleared.
		 * 
		 * @param constraintObject the object representing the constraint to be cleared. Similarly
		 * to the way <code>addConstraint</code> works, if this parameter is an Array, an attempt
		 * will be made to remove all its items as separate constraint objects, instead of it being
		 * treated as a single constraint object.
		 * 
		 * @see #addConstraint()
		 * @see #clearAllConstraints()
		 * */
		public function clearConstraint(name:String, constraintObject:Object):void
		{
			var relevantConstraintObjects:Array = this.getConstraintsByName(name);
			if(relevantConstraintObjects && relevantConstraintObjects.length) {
				
				var constraintsToRemove:Array = (constraintObject is Array) ? (constraintObject as Array) : [ constraintObject ];
				var objPos:Number;
				var item:Object;
				
				for each(item in constraintsToRemove) {
					objPos = relevantConstraintObjects.indexOf(item);
					if(objPos != -1)
						relevantConstraintObjects.splice(objPos, 1);
				}
				
				this.onConstraintsRemoved(name, constraintObject);
			}
		}
		
		/**
		 * <p>
		 * Checks if the constraint object(s) already exist as constraints.
		 * </p>
		 * 
		 * <p>
		 * This function is used in <code>addConstraint()</code>
		 * </p>
		 * 
		 * @param categoryName the name of the constraint category where to look for the constraint
		 * object(s).
		 * 
		 * @param constraintObject the object representing the constraint to be looked up. Similarly
		 * to the way <code>addConstraint</code> works, if this parameter is an Array, this function
		 * returns true only if all its items are already set as constraints. Conversely, it returns
		 * false even if some of the array items are constraints, but some are not.
		 * 
		 * @return true if the <code>constraintObject(s)</code> already exist as constraints, false
		 * otherwise.
		 * 
		 * @see #addConstraint()
		 * */
		public function constraintAlreadyExists(categoryName : String, constraintObject : Object) : Boolean
		{
			if(categoryName)
				if(this._constraints[categoryName] && (this._constraints[categoryName] is Array))
					if(constraintObject is Array) {
						for(var constraint:Object in (constraintObject as Array))
							if((this._constraints[categoryName] as Array).indexOf(constraint) == -1)
								return false;
								
						return true;
					}
					else
						return (this._constraints[categoryName] as Array).indexOf(constraintObject) != -1;
			
			return false;
		}
		
		
		
		
		
		
		
		
		
		
		//----------------------FILTERING OBJECTS--------------------------------------
		
		/**
		 * <p>
		 * Checks if the object passes the filter (i.e. all the constraints).
		 * </p>
		 * 
		 * <p>
		 * This function is (currently) to be called from the domain model when updating
		 * the filtered items.
		 * </p>
		 * 
		 * <p>
		 * There is no implementation in this abstract class. The developer is responsible for
		 * providing one in a subclass. Most probably it will use the <code>passesBy()</code>
		 * function multiple times. For example:
		 * 
		 *  <listing>
		 *   public override function passes( item : Object ) : Boolean
			 {
				return (item) && (item is ProductVO) &&
				   this.passesBy(Constants.BROWSING_LEVEL_SECTOR_PROP_NAME, item) &&
				   this.passesBy(Constants.BROWSING_LEVEL_KEYSTAGE_PROP_NAME, item) &&
				   this.passesBy(Constants.BROWSING_LEVEL_SUBJECT_PROP_NAME, item) &&
				   this.passesBy(Constants.BOUGHT_STATUS_CONSTRAINT, item);
			 }
		 *  </listing>
		 * </p>
		 * 
		 * @param item the item to filter.
		 * 
		 * @return true if the item passes the filter, false if not. The abstract implementation always
		 * returns true.
		 * 
		 * <p>
		 * <strong>TODO:</strong>
		 *  <ul>
		 *   <li>make so that <code>passes()</code> also checks the type of objects to filter. Currently, for instance,
		 *       the ProductFilterData implementation of passes checks if the item is a ProductVO. This can
		 *       be done generically here.</li>
		 *  </ul>
		 * <p>
		 * 
		 * @see #passesBy()
		 * */
		public function passes(item:Object):Boolean
		{
			return true;
		}
		
		
		
		/**
		 * <p>
		 * Checks if the object passes one particular set of constraints (namely, 
		 * all the constraints from the <code>constraintCategoryName</code> category).
		 * </p>
		 * 
		 * <p>
		 * This function is expected to be called from <code>passes()</code>, but other
		 * uses are not discouraged.
		 * </p>
		 * 
		 * <p>
		 * The abstract implementation calls <code>getConstraintsByName()</code> and
		 * <code>getRelevantObjectProperty()</code> and then returns the result of
		 * <code>valuePassesFilters()</code>, passing in as arguments the results of
		 * the previous two functions. It is expected that implementing classes override
		 * all the aforementioned functions, except <code>passesBy</code>.
		 * </p>
		 * 
		 * @param constraintCategoryName the name of the category of constraints to use.
		 * 
		 * @param objectToCheck the object to filter.
		 * 
		 * @return true if the item passes the constraints, false if not.
		 * 
		 * @see #passes()
		 * @see #valuePassesFilters()
		 * @see #getConstraintsByName()
		 * @see #getRelevantObjectProperty()
		 * */
		protected function passesBy(constraintCategoryName:String, objectToCheck:Object) : Boolean
		{
			var constraintObjectsForThisName:Array = this.getConstraintsByName(constraintCategoryName);
			var relevantObjectPropertyValue:Object = this.getRelevantObjectProperty(constraintCategoryName, objectToCheck);
			
			return this.valuePassesFilters(constraintCategoryName, constraintObjectsForThisName, relevantObjectPropertyValue);
		}
		
		
		/**
		 * <p>
		 * Returns all the constraints from a particular category. Used by
		 * <code>passesBy()</code>.
		 * </p>
		 * 
		 * <p>
		 * In the event that there are any custom constraints, or ones which
		 * should be built on the fly, the implementing class is expected to
		 * override this function, but still call
		 * <code>super.getConstraintsByName()</code> for the default functionality.
		 * </p>
		 * 
		 * @param categoryName the name of the category of constraints to return.
		 * 
		 * @return an array of all the constraints under the category
		 * <code>categoryName</code>, or an empty array if no such constraints
		 * exists.
		 * 
		 * @see #passesBy()
		 * */
		protected function getConstraintsByName(categoryName : String) : Array
		{
			if(categoryName)
				if(this._constraints[categoryName])
					return this._constraints[categoryName] as Array;
			
			return null;
		}
		
		
		
		/**
		 * <p>
		 * Returns all the value of the object property associated with a
		 * particular constraint category. This is the crux of the filtering
		 * association: a list of constraints grouped under a particular
		 * category name are associated with a particular property of the
		 * object to be filtered (e.g. constraints under 'Subjects' are
		 * associated with the ProductVO's property <code>subjects</code>).
		 * </p>
		 * 
		 * <p>
		 * The abstract implementation returns null regardless of the parameters.
		 * A subclass needs to override this function and implement the adequate
		 * functionality. For example:
		 *  <listing>
		 *   switch(constraintCategory) {
				case Constants.BROWSING_LEVEL_SECTOR_PROP_NAME: return ProductVO(item).keyStages;
				case Constants.BROWSING_LEVEL_KEYSTAGE_PROP_NAME: return ProductVO(item).keyStages;
				case Constants.BROWSING_LEVEL_SUBJECT_PROP_NAME: return ProductVO(item).subjects;
				case Constants.BOUGHT_STATUS_CONSTRAINT: return ProductVO(item).boughtStatus;
			}
		 *  </listing>
		 * </p>
		 * 
		 * <p>
		 * <strong>TODO:</strong>
		 *  <ul>
		 *   <li>attempt to return item[constraintCategory] if it exists</li>
		 *   <li>type checking here in the abstract class?</li>
		 *  </ul>
		 * <p>
		 * 
		 * @param constraintCategory the name of the category associated
		 * with a particular object property.
		 * 
		 * @param item the object to be filtered, and whose properties are to be
		 * returned here.
		 * 
		 * @return the value of the property of <code>item</code> associated with
		 * <code>constraintCategory</code>.
		 * 
		 * @see #passesBy()
		 * */
		protected function getRelevantObjectProperty(constraintCategory : String, item : Object) : Object
		{
			switch(constraintCategory) {
				default: return null;
			}
		}
		
		
		
		/**
		 * <p>
		 * Checks if a value passes a list of filters from a specific category.
		 * This is the function which actually does the filtering.
		 * </p>
		 * 
		 * <p>
		 * The abstract implementation returns true regardless of the parameters.
		 * A subclass needs to override this function and implement the adequate
		 * functionality. For example:
		 *  <listing>
		 *   switch(constraintCategory) {
				case Constants.BROWSING_LEVEL_SECTOR_PROP_NAME:
			    case Constants.BROWSING_LEVEL_KEYSTAGE_PROP_NAME:
			    case Constants.BROWSING_LEVEL_SUBJECT_PROP_NAME:
			    		var passes:Boolean = (!filterObjects) ||
			    			   (!filterObjects.length) ||
			    			   ((propertyValue is Array) && (ArrayUtilFunctions.atLeastOneItemInCommon(propertyValue as Array, filterObjects)));
			    		return passes;
			    case Constants.BOUGHT_STATUS_CONSTRAINT:
			    		return (propertyValue is int) && ((this.boughtStatus == Constants.BOUGHT_STATUS_ALL) || (this.boughtStatus == propertyValue));
			}
			
			return true;
		 *  </listing>
		 * </p>
		 * 
		 * @param constraintCategory the name of the category which the
		 * <code>filterObjects</code> belong to.
		 * 
		 * @param filterObjects a list of constraints under the
		 * <code>constraintCategory</code> category name.
		 * 
		 * @param propertyValue the value of the relevant object property to check
		 * against the constraints.
		 * 
		 * @return true if the <code>propertyValue</code> passes the constraints,
		 * false otherwise.
		 * 
		 * @see #passesBy()
		 * */
		protected function valuePassesFilters(constraintCategory : String, filterObjects : Array, propertyValue : Object) : Boolean
		{
			return true;
		}
		
		
		/**
		 * <p>
		 * Called after constraints are added or set. The abstract implementation
		 * is void, but subclasses can override and use this function to compute
		 * custom constraints. For example:
		 *  <listing>
		 *   switch(constraintCategory) {
				case Constants.BROWSING_LEVEL_SECTOR_PROP_NAME:
						this._sectors.push(constraints);
						this.refreshIsPrimary();
						this.refreshSectorKeyStages();
						break;
				case Constants.BOUGHT_STATUS_CONSTRAINT:
						this.refreshBoughtStatus(constraints);
						break;
			}
		 *  </listing>
		 * </p>
		 * 
		 * @param constraintCategory the name of the category which the
		 * <code>constraints</code> belong to.
		 * 
		 * @param constraints the newly added constraint(s) under the
		 * <code>constraintCategory</code> category name.
		 * 
		 * @see #setConstraint()
		 * @see #addConstraint()
		 * */
		protected function onNewConstraints(constraintCategory : String, constraints : Object) : void
		{
			
		}
		
		
		
		
		
		/**
		 * <p>
		 * Called after constraints are removed. The abstract implementation
		 * is void, but subclasses can override and use this function to compute
		 * custom constraints. For example:
		 *  <listing>
		 *   switch(constraintCategory) {
				case Constants.BROWSING_LEVEL_SECTOR_PROP_NAME:
						this._sectors.push(constraints);
						this.refreshIsPrimary();
						this.refreshSectorKeyStages();
						break;
				case Constants.BOUGHT_STATUS_CONSTRAINT:
						this.refreshBoughtStatus(constraints);
						break;
			}
		 *  </listing>
		 * </p>
		 * 
		 * @param constraintCategory the name of the category which the
		 * <code>constraints</code> belong to.
		 * 
		 * @param constraints the freshly removed constraint(s) under the
		 * <code>constraintCategory</code> category name.
		 * 
		 * @see #setConstraint()
		 * @see #addConstraint()
		 * */
		protected function onConstraintsRemoved(constraintCategory : String, constraints : Object) : void
		{
			
		}

	}
}