package com.pearson.shingo.view.components.flex3.breadcrumbs
{
	import flash.events.Event;
	
	public class BreadcrumbData implements IBreadcrumb
	{
		private var _name:String;
		private var _eventInfo:EventInfo;
		
		public function BreadcrumbData(name:String, event : EventInfo = null)
		{
			this._name = name;
			this._eventInfo = event;
		}
		
		
		public function get name():String
		{
			return this._name;
		}

		public function set name( inName : String ) : void
		{
			//TODO: Review: do we need to set name?
		}
		
		public function get eventInfo():EventInfo
		{
			return this._eventInfo;
		}
	}
}