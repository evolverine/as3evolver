package com.pearson.shingo.view.components.as3.folderBrowsing.event
{
	import com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingItem;
	import com.pearson.shingo.view.components.as3.folderBrowsing.drilldown.IBrowsingLevel;
	
	import flash.events.Event;

	public class FolderBrowsingEvent extends Event
	{
		public static const SELECT : String = 'folderSelected';
		public static const BACK : String = 'historyBackNavigation';
		
		public var item : IBrowsingItem;
		public var level : IBrowsingLevel;
		
		public function FolderBrowsingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		public override function clone():Event
		{
			var newEvent : FolderBrowsingEvent = new FolderBrowsingEvent(this.type, this.bubbles, this.cancelable);
			newEvent.item = this.item;
			newEvent.level = this.level;
			
			return newEvent;
		}
		
	}
}