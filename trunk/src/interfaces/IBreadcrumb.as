package interfaces
{
	import flash.events.Event;
	
	public interface IBreadcrumb extends IName
	{
		function get event():Event;
	}
}