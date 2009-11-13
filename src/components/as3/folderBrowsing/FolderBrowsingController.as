package com.pearson.shingo.view.components.as3.folderBrowsing
{
	import com.as3evolver.factory.GenericObjectPool;
	import com.as3evolver.factory.PoolOfPools;
	import com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel;
	import com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingItem;
	import com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingLevel;
	import com.pearson.shingo.view.components.as3.folderBrowsing.event.FolderBrowsingEvent;
	import com.pearson.shingo.view.components.as3.folderBrowsing.filter.IFilterManager;
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * <p>
	 * Controller for 'folder browsing'. Functionality similar to Windows Explorer. Contains
	 * functions for constructing the folder structure, and for navigating between folders.
	 * Developers are expected to implement their own views for displaying the folder structure.
	 * The class uses IBrowsingItem (which represents a folder) and IBrowsingLevel (which represents
	 * an entire folder level) to build the folder tree.
	 * </p>
	 * 
	 * <p>
	 * Any view which uses this controller is expected to use the <code>currentLevel</code> (and its
	 * <code>items</code> property) and <code>currentItem</code> bindable properties to display
	 * the current folder. Also, one can use the <code>history</code>, which contains the previously
	 * selected items (including the current one), perhaps to show the current path.
	 * </p>
	 * 
	 * <p>
	 * The folder browsing controller is also designed to work in conjunction with a 'filter controller',
	 * if one is supplied via the <code>filter</code> property. The filter controller is any class
	 * which implements the IFilterManager interface. Every time a folder is selected it is added as
	 * a new constraint to the filter manager. The idea is that the user keeps selecting folders,
	 * which keep restricting the results (products, images, etc) he or she will receive. The filter
	 * controller is useful for filtering a larger list of such items on the client side, or for
	 * setting a filter VO's properties, to be sent to the server to retrieve the desired items.
	 * </p> 
	 * 
	 * <p>
	 * <strong>TODO:</strong>
	 *  <ul>
	 *   <li>make it possible that folders also contain items</li>
	 *   <li>record items in history raher than levels, so that the view can display</li>
	 *  </ul>
	 * <p>
	 * 
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.filter.IFilterManager
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.filter.AbstractFilter
	 * @see com.pearson.prg.domain.filter.ProductFilterData
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingItem
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingLevel
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel
	 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingItem
	 * 
	 * @author Mihai Chira
	 * */
	
	public class FolderBrowsingController extends EventDispatcher
	{
		protected static var _levelFactory:GenericObjectPool = PoolOfPools.getInstance().gimme(BrowsingLevel, false) as GenericObjectPool;
		protected static const _historyBackEvent : FolderBrowsingEvent = new FolderBrowsingEvent(FolderBrowsingEvent.BACK);
		protected static const _folderSelectEvent : FolderBrowsingEvent = new FolderBrowsingEvent(FolderBrowsingEvent.SELECT);
		protected var _currentLevel:IBrowsingLevel;
		protected var _currentItem:IBrowsingItem;
		protected var _autoDetectHistoryBrowsing:Boolean;
		
		public var filter:IFilterManager;
		public var history:Array = []; //of IBrowsingItem items
		
		[Bindable]
		public var level0:IBrowsingLevel; //top browsing level
		
		
		
		public function FolderBrowsingController(autoDetectHistoryBrowsing:Boolean = false)
		{
			this._autoDetectHistoryBrowsing = autoDetectHistoryBrowsing;
		}
		
		
		//---------------------- BROWSING AND HISTORY NAVIGATION --------------------------------
		
		
		/**
		 * <p>
		 * Selects a folder. This is usually called by the view, when the user
		 * clicks on the visual representation of the folder. It causes the
		 * <code>currentLevel</code> and <code>currentItem</code> properties to
		 * change accordingly. Also, <code>item</code> is added to the history
		 * array.
		 * </p>
		 * 
		 * <p>
		 * If the <code>autoDetectHistoryBrowsing</code> flag is set to true, this
		 * function attempts to locate <code>item</code> in history, and if it does
		 * find it, regards this navigation as a history navigation. It thus clears
		 * all other history items which were added after <code>item</code>, and clears
		 * all the constraints added by those items.
		 * </p>
		 * 
		 * @param item the folder to select.
		 * 
		 * @see #rollBackToItem()
		 * */
		public function select(item:IBrowsingItem):void
		{
			if(this._autoDetectHistoryBrowsing && this.itemIsInHistory(item))
				this.rollBackToItem(item);
			else
				this.currentItem = item;
		}
		
		
		/**
		 * <p>
		 * Similar functionality to Internet Explorer's 'Up' button. Basically
		 * selects the current item's parent level.
		 * </p>
		 * 
		 * <p>
		 * <b>TODO:</b>
		 *  <ul>
		 *   <li>manage history and <code>currentItem</code>. Currently, the only thing which
		 *       changes is the <code>currentLevel</code>.
		 *   </li>
		 *  </ul>
		 * </p>
		 * */
		public function upOneLevel():void
		{
			if((this.currentLevel) && (this.currentLevel.parent) && (this.currentLevel.parent.level))
				this.currentLevel = this.currentLevel.parent.level;
		}
		
		/**
		 * <p>
		 * Selects the root level of the folder hierarchy, clears the <code>currentItem</code>,
		 * the history, and all the constraints associated with the previously selected folders.
		 * </p>
		 * 
		 * <p>
		 * <b>TODO:</b>
		 *  <ul>
		 *   <li>currently all the constraints are cleared, regardless of their association with folders.
		 *       Instead, call rollBackToItem(null), and make sure it works :)
		 *   </li>
		 *  </ul>
		 * </p>
		 * */
		public function upToRoot():void
		{
			this.rollBackToItem(null);
		}
		
		/**
		 * <p>
		 * Similar to Windows Explorer's functionality for the 'back' button. Goes back to
		 * the previous location (<code>currentItem</code> and <code>currentLevel</code>)
		 * </p>
		 * */
		public function backToPrevious():void
		{
			if(this.history.length)
				this.setCurrentItem(IBrowsingItem(this.history.pop()), false);
		}
		
		/**
		 * <p>
		 * Similar to selecting a history item from Firefox's history list (the little
		 * arrow next to the big green back button). Rolls back to that item, also clearing
		 * the constraints associated with the cleared items.
		 * </p>
		 * 
		 * @see #rollBackToItem()
		 * */
		public function backToItem(val:IBrowsingItem):void
		{
			if(this.itemIsInHistory(val))
				this.rollBackToItem(val);
		}
		
		
		/**
		 * <p>
		 * 'Rolls back' to an folder in the navigation history. This means that all the
		 * folders the user has navigated to after <code>selectedItem</code> are removed
		 * from history and also that the constraints associated with them are removed from
		 * the filter. 
		 * </p>
		 * 
		 * @param selectedItem the item to roll back to. This function does not check if
		 * <code>selectedItem</code> is in the history (while <code>backToItem</code> does).
		 * Therefore, if this argument is null or an IBrowsingItem which is not in the
		 * navigation history, the effect is that the whole history will be cleared
		 * and all added constraints will be removed.
		 * 
		 * @see #backToItem()
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingItem
		 * */
		protected function rollBackToItem(selectedItem:IBrowsingItem):void
		{
			var browseItem:IBrowsingItem;
			if(this.history.length)
				while(browseItem = this.history[this.history.length - 1])
					if(browseItem != selectedItem) {
						this.removeLastHistoryItem();
					}
					else {
						this.setCurrentItem(browseItem, false, false);
						break;
					}
				
				if(!browseItem) {
					this.setCurrentItem(null, false, false);
				}
		}
		
		
		/**
		 * <p>
		 * Returns true if the argument (representing a folder in our taxonomy) exists in
		 * the navigational history array.
		 * </p>
		 * 
		 * @param val the 
		 * 
		 * @return true if the item has been previously selected (i.e. if it can be found
		 * in the navigational history array).
		 * 
		 * @see #findItem()
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel
		 * */
		protected function itemIsInHistory(val:IBrowsingItem):Boolean
		{
			var browseItem:IBrowsingItem;
			var i:Number = this.history.length;
			while(browseItem = this.history[--i] as IBrowsingItem)
				if(browseItem == val)
					return true;
			
			return false;
		}
		
		
		
		
		/**
		 * <p>
		 * True if <code>currentLevel == level0</code>, false otherwise.
		 * </p>
		 * */
		public function get isAtRoot():Boolean
		{
			return this.currentLevel == this.level0;
		}
		
		
		
		
		public function removeLastHistoryItem():void
		{
			var browseItem:IBrowsingItem = this.history.length ? this.history[this.history.length - 1] : null;
			if(browseItem) {
				if(browseItem.level)
					this.filter.clearConstraint(browseItem.level.name, browseItem.item);
				this.history.pop();
				
				//trigger the 'back' event
				_historyBackEvent.item = browseItem;
				_historyBackEvent.level = browseItem.level;
				this.dispatchEvent(_historyBackEvent);
			}
		}
		
		
		//----------------------DEFINING LEVELS AND ITEMS--------------------------------------
		
		/**
		 * <p>
		 * Used to add a new browsing level as a child of a particular IBrowsingItem. This
		 * is the main function used to construct the folders tree. Initially one needs
		 * to create a root level, which means calling this function with null for the
		 * <code>parent</code> parameter. Next, one would use the <code>findItem</code>
		 * function to locate a particular <code>IBrowsingItem</code> instances as parents of
		 * subsequent levels.
		 * </p>
		 * 
		 * @param name the name of the browsing level. This can be displayed in the view,
		 * and is used as the name of the constraint for the filter. E.g.: "Key Stages",
		 * "Subjects", etc.
		 * 
		 * @param items an array of <code>IName</code> instances which represent all the folders
		 * on this level. Internally, these are wrapped inside <code>IBrowsingItem</code> instances.
		 * 
		 * @param parent the instance of <code>IBrowsingLevel</code> which will serve as the
		 * parent of the newly created global sub-level.
		 * 
		 * @param parent the instance of <code>IBrowsingItem</code> which will serve as the
		 * parent of the newly created level. If this is null, the level is the 'root level'.
		 * Be careful, there can only be one root level. This parameter defaults to null.
		 * 
		 * @return a reference to the newly created <code>IBrowsingLevel</code> instance.
		 * The exact type of the instance is <code>BrowsingLevel</code>.
		 * 
		 * @see #findItem()
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel
		 * @see com.pearson.shingo.interfaces.IName
		 * */
		public function addLevel(name:String, items:Array, parent:IBrowsingItem = null) : IBrowsingLevel
		{
			var level:IBrowsingLevel = new BrowsingLevel(name, items, parent);
			
			if(parent)
				parent.subLevel = level;
			else
				if(!this.level0) {
					this.level0 = level;
					this.currentLevel = level;
				}
				else
					trace('ERROR: multiple root browsing levels are not allowed! Level ' + name + ' has no parent, just as ' + this.level0.name);
			
			return level;
		}
		
		
		
		/**
		 * <p>
		 * Adds a 'global sub-level'. These are useful in situations where all folders
		 * (i.e. instances of IBrowsingItem in a particular level) need to have a child
		 * level with exactly the same folders. An example could be when clicking on any
		 * key stage takes the user to exactly the same list of Subjects - in this case
		 * the subjects level can be a global sublevel for the key stage level.
		 * </p>
		 * 
		 * @param name the name of the browsing level. This can be displayed in the view,
		 * and is used as the name of the constraint for the filter. E.g.: "Key Stages",
		 * "Subjects", etc.
		 * 
		 * @param items an array of IBrowsingItem instances which represent all the folders
		 * on this level.
		 * 
		 * @param parent the instance of <code>IBrowsingLevel</code> which will serve as the
		 * parent of the newly created global sub-level.
		 * 
		 * @return a reference to the newly created <code>IBrowsingLevel</code> instance.
		 * The exact type of the instance is <code>BrowsingLevel</code>.
		 * 
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingLevel
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel
		 * */
		public function addGlobalSubLevel(name:String, items:Array, parent:IBrowsingLevel):IBrowsingLevel
		{
			var level:IBrowsingLevel = new BrowsingLevel(name, items);
			trace('new level with items ' + items);
			if(parent)
				parent.globalSubLevel = level;
			
			return level;
		}
		
		
		
		
		
		//---------------------- MANIPULATING CURRENTLEVEL AND CURRENTITEM -----------------------------------
		
		[Bindable]
		public function set currentLevel(val:IBrowsingLevel):void
		{
			if(val && (val != this._currentLevel)) {
				this._currentLevel = val;
			}
		}
		
		public function get currentLevel():IBrowsingLevel
		{
			return this._currentLevel;
		}
		
		
		
		[Bindable]
		public function set currentItem(val:IBrowsingItem):void
		{
			this.setCurrentItem(val);
		}
		
		public function get currentItem():IBrowsingItem
		{
			return this._currentItem;
		}
		
		
		
		
		protected function setCurrentItem(selectedItem:IBrowsingItem, recordInHistory:Boolean = true, addConstraint:Boolean = true):void
		{
			this._currentItem = selectedItem;
			
			if(addConstraint)
				if(this.filter && selectedItem && selectedItem.level)
					this.filter.addConstraint(selectedItem.level.name, selectedItem ? selectedItem.item : null);
			
			if(recordInHistory)
				this.history.push(selectedItem);
			
			this.currentLevel = selectedItem ? selectedItem.subLevel : this.level0;
			
			//trigger the 'back' event
			_folderSelectEvent.item = selectedItem;
			_folderSelectEvent.level = selectedItem ? selectedItem.subLevel : null;
			this.dispatchEvent(_folderSelectEvent);
		}
		
		
		
		
		
		//----------------------SEARCHING FOR ITEMS--------------------------------------
		
		/**
		 * <p>
		 * Searches for a "folder" (i.e. instance of IBrowsingItem) through the entire
		 * folders tree by name and optionally by type. To optimize the search, one can
		 * specify the minimum depth, if known (eg. we know that the item called
		 * 'Mathematics', of type SubjectVO is somewhere from level 2 onwards).
		 * </p>
		 * 
		 * <p>
		 * 
		 * </p>
		 * 
		 * @param name the name of the browsing level. This can be displayed in the view,
		 * and is used as the name of the constraint for the filter. E.g.: "Key Stages",
		 * "Subjects", etc.
		 * 
		 * @param items an array of IBrowsingItem instances which represent all the folders
		 * on this level.
		 * 
		 * @param parent the instance of <code>IBrowsingLevel</code> which will serve as the
		 * parent of the newly created global sub-level.
		 * 
		 * @return a reference to the newly created <code>IBrowsingLevel</code> instance.
		 * The exact type of the instance is <code>BrowsingLevel</code>.
		 * 
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingLevel
		 * @see com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.BrowsingLevel
		 * */
		public function findItem(name : String, type : Class = null, fromDepth : Number = 0) : IBrowsingItem
		{
			return this.findItemRecursivelyStartingFrom(this.level0, name, type, fromDepth);
		}
		
		protected function findItemRecursivelyStartingFrom(browsingLevel :IBrowsingLevel, name : String, type : Class = null, minDepth : Number = 0, currentDepth :  Number = 0) : IBrowsingItem
		{
			if(browsingLevel) {
				var item:IBrowsingItem;
				
				if(currentDepth >= minDepth) {
					item = browsingLevel.getItemByName(name);
					if(item && ((!type) || (item.item is type)))
						return item;
				}
				
				if(browsingLevel.globalSubLevel)
					return this.findItemRecursivelyStartingFrom(browsingLevel.globalSubLevel, name, type, minDepth, currentDepth + 1);
				else {
					var itemToBeFound:IBrowsingItem;
					for each(item in browsingLevel.items)
						if(item && item.subLevel) {
							itemToBeFound = this.findItemRecursivelyStartingFrom(item.subLevel, name, type, minDepth, currentDepth + 1);
							if(itemToBeFound)
								return itemToBeFound;
						}
						
					return null;
				}
					
			}
			
			return null;
		}
	}
}