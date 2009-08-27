package components.flex3.breadcrumbs
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import interfaces.IBreadcrumb;
	import interfaces.IName;
	
	public class BreadcrumbsController extends EventDispatcher
	{
		private static var _changeEvent:Event = new Event(Event.CHANGE, false);
		private var _items:Array = [];
		
		public function BreadcrumbsController()
		{
		}
		
		
		public function addItem(val:IName):void
		{
			if(val) {
				this._items.push(val);
				this.dispatchEvent(_changeEvent);
			}
		}
		
		public function addWithProperties(displayName:String, eventToDispatch:Event = null):void
		{
			if(displayName)
				this.addItem(new BreadcrumbData(displayName, eventToDispatch)); 
		}
		
		public function clearItems():void
		{
			this._items = [];
			this.dispatchEvent(_changeEvent);
		}
		
		
		
		
		public function select(val:IBreadcrumb):void
		{
			if(this.itemExists(val)) {
				var item:IBreadcrumb;
				do {
					item = this._items[this._items.length - 1] as IBreadcrumb;
					if(item == val) {
						if(item.event)
							this.dispatchItemEvent(item.event);
						break;
					}
				}
				while(item = (this._items.pop() as IBreadcrumb));
			}		
		}
		
		
		
		
		
		
		protected function dispatchItemEvent(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		protected function itemExists(val:IBreadcrumb):Boolean
		{
			var i:Number = this._items.length;
			while(--i >= 0)
				if(this._items[i] == val)
					return true;
					
			return false;
		}
		
		
		
		
		[Bindable]
		public function get items():Array
		{
			return this._items;
		}
		
		
		public function set items(val:Array):void
		{
			if(val && (this._items != val))
				this._items = val;
		}
		
		
	}
}