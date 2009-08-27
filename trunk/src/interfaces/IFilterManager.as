package interfaces
{
	public interface IFilterManager
	{
		function clearAllConstraints():void;
		function addConstraint(name:String, constraintObject:Object):void
	}
}