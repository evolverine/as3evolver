package com.pearson.shingo.view.components.flex3.breadcrumbs
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class DefaultEventDispatcherDelegate extends EventDispatcher implements IEventDispatcherDelegate
	{
		public function dispatch(eventInfo : EventInfo):void
		{
			if(eventInfo && eventInfo.type)
				this.dispatchEvent( new Event( eventInfo.type ) );
		}
		
	}
}