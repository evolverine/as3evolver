package com.pearson.shingo.view.components.as3.folderBrowsing.drilldown
{
	import com.pearson.shingo.interfaces.IName;
	
	public interface IBrowsingItem extends IName
	{
		function get level():IBrowsingLevel;
		function get hasChildren():Boolean;
		function get subLevel():IBrowsingLevel;
		function set subLevel(val:IBrowsingLevel):void;
		function get item():IName;
	}
}