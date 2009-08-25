package factory
{
	public interface IFactory
	{
		function gimme(...constructorArgs):Object
		function park(val:Object):void;
	}
}