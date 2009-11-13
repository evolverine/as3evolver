package com.pearson.shingo.view.components.as3.folderBrowsing.filter
{
	public interface IFilterManager
	{
		function clearAllConstraints():void;
		function clearConstraint(name:String, constraintObject:Object):void;
		function addConstraint(name:String, constraintObject:Object):void
		function setConstraint(name:String, constraintObject:Object):void
	}
}