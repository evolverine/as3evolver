package components.as3.folderBrowsing.drilldown
{
	import interfaces.IBrowsingItem;
	import interfaces.IBrowsingLevel;
	import interfaces.IName;
	
	public class BrowsingItem implements IName, IBrowsingItem
	{
		private var _item:IName;
		public var info:String; //can be a tooltip text
		private var _subLevel:IBrowsingLevel;
		private var _level:IBrowsingLevel;
		
		public function BrowsingItem(level:IBrowsingLevel, item:IName, info:String = '')
		{
			this._level = level;
			this._item = item;
			this.info = info;
		}
		
		
		public function get hasChildren():Boolean
		{
			return (this._subLevel && this._subLevel.items && this._subLevel.items.length) || (this.level && this.level.globalSubLevel && this.level.globalSubLevel.items && this.level.globalSubLevel.items.length);
		}
		
		public function get numChildren():Number
		{
			var numChildren:Number = 0;
			if(this.hasChildren)
				if(this._subLevel)
					numChildren = this._subLevel.items.length;
				else
					numChildren = this.level.globalSubLevel.items.length;
			
			return numChildren;
		}
		
		public function get name():String
		{
			return (_item) ? _item.name : '<noname>';
		}
		
		public function get item():IName
		{
			return this._item;
		}
		
		public function get level():IBrowsingLevel
		{
			return this._level;
		}
		
		public function set subLevel(val:IBrowsingLevel):void
		{
			if(this._subLevel != val)
				this._subLevel = val;
		}
		
		public function get subLevel():IBrowsingLevel
		{
			return this._subLevel;
		}

	}
}