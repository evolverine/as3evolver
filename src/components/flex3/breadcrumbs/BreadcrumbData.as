package components.flex3.breadcrumbs
{
	import flash.events.Event;
	
	import interfaces.IBreadcrumb;
	
	public class BreadcrumbData implements IBreadcrumb
	{
		private var _name:String;
		private var _event:Event;
		
		public function BreadcrumbData(name:String, event:Event = null)
		{
			this._name = name;
			this._event = event;
		}
		
		
		public function get name():String
		{
			return this._name;
		}
		
		public function get event():Event
		{
			return this._event;
		}
	}
}