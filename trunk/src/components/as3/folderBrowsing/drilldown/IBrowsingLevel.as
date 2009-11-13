package com.pearson.shingo.view.components.as3.folderBrowsing.drilldown
{
	import com.pearson.shingo.interfaces.IName;
	[Bindable]
	public interface IBrowsingLevel extends IName
	{
		function get items():Array;
		function set items(val:Array):void
		function get globalSubLevel():IBrowsingLevel;
		function set globalSubLevel(val:IBrowsingLevel):void
		function get parent():IBrowsingItem;
		
		function getItemByName(name:String):IBrowsingItem;
	}
}