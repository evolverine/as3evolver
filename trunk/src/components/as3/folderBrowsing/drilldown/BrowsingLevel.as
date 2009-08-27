package components.as3.folderBrowsing.drilldown
{
	import interfaces.IBrowsingItem;
	import interfaces.IBrowsingLevel;
	import interfaces.IName;
	
	public class BrowsingLevel implements IBrowsingLevel
	{
		private var _parent:IBrowsingItem;
		private var _name:String;
		private var _globalSubLevel:IBrowsingLevel; //applies for all items on the current level
		[Bindable]
		private var _items:Array = []; //of IBrowsingItem objects
		
		public function BrowsingLevel(name:String, items:Array, parent:IBrowsingItem = null)
		{
			//the 'items' in the argument list is an array of IName objects -> transform these into IBrowsingItem objects
			var folder:IName;
			for each(folder in items)
				if(folder)
					this.items.push(new BrowsingItem(this, folder));
				
			this._name = name;
			this._parent = parent;
		}
		
		
		public function getItemByName(name:String):IBrowsingItem
		{
			var item:IBrowsingItem;
			for each(item in this.items)
				if(item && (item.name == name))
					return item;
			
			return null;
		}
		
		
		public function get items():Array
		{
			return this._items;
		}
		
		public function set items(val:Array):void
		{
			if(val != this._items)
				this._items = val;
		}
		
		
		
		public function get globalSubLevel():IBrowsingLevel
		{
			return this._globalSubLevel;
		}
		
		public function set globalSubLevel(val:IBrowsingLevel):void
		{
			if(this._globalSubLevel != val)
				this._globalSubLevel = val;
		}
		
		
		
		public function get name():String
		{
			return this._name;
		}
		
		
		public function get parent():IBrowsingItem
		{
			return this._parent;
		}
	}
}