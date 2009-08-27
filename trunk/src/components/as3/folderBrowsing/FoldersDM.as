/**
 * TODO: in history, also record the selected item, not just the level
 * -when going back in history, remove the constraints as well
 * 
 * */

package components.as3.folderBrowsing
{
	import components.as3.folderBrowsing.drilldown.BrowsingLevel;
	
	import interfaces.IBrowsingItem;
	import interfaces.IBrowsingLevel;
	import interfaces.IFilterManager;
	
	public class FoldersDM
	{
		public var filter:IFilterManager;
		
		private var _currentLevel:IBrowsingLevel;
		private var _currentItem:IBrowsingItem;
		
		[Bindable]
		public var level0:IBrowsingLevel; //top browsing level
		private var _history:Array = []; //of BrowsingLevel items
		
		
		
		
		//----------------------BROWSING-----------------------
		public function select(item:IBrowsingItem):void
		{
			this.currentItem = item;
		}
		
		public function upOneLevel():void
		{
			if((this.currentLevel) && (this.currentLevel.parent) && (this.currentLevel.parent.level))
				this.currentLevel = this.currentLevel.parent.level;
		}
		
		public function upToRoot():void
		{
			if(this._currentLevel != this.level0) {
				this.currentLevel = this.level0;
				this.currentItem = null;
				this.filter.clearAllConstraints();
			}
		}
		
		public function backToPrevious():void
		{
			if(this._history.length)
				this.setCurrentItem(IBrowsingItem(this._history.pop()), false);
		}
		
		
		
		//----------------------DEFINING LEVELS AND ITEMS-----------------------
		public function addLevel(name:String, items:Array, parent:IBrowsingItem = null):IBrowsingLevel
		{
			var level:IBrowsingLevel = new BrowsingLevel(name, items, parent);
			trace('new level with items ' + items);
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
		
		
		public function addGlobalSubLevel(name:String, items:Array, parent:IBrowsingLevel):IBrowsingLevel
		{
			var level:IBrowsingLevel = new BrowsingLevel(name, items);
			trace('new level with items ' + items);
			if(parent)
				parent.globalSubLevel = level;
			
			return level;
		}
		
		
		
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
		
		
		
		
		protected function setCurrentItem(selectedItem:IBrowsingItem, recordInHistory:Boolean = true):void
		{
			this._currentItem = selectedItem;
			
			this.filter.addConstraint(this._currentLevel.name, selectedItem ? selectedItem.item : null);
			
			if(recordInHistory)
				this._history.push(selectedItem);
			
			var level:IBrowsingLevel;
			if(selectedItem)
				if(selectedItem.subLevel)
					level = selectedItem.subLevel;
				else if((selectedItem.level) && (selectedItem.level.globalSubLevel))
					level = selectedItem.level.globalSubLevel;
				
			
			if(level)
				this.currentLevel = level;
		}
		
		
		public function set currentPath(val:String):void
		{
			
		}
		
		public function get currentPath():String
		{
			return '';
		}

	}
}