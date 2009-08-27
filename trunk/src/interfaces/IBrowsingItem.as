package interfaces
{
	public interface IBrowsingItem extends IName
	{
		function get level():IBrowsingLevel;
		function get hasChildren():Boolean;
		function get subLevel():IBrowsingLevel;
		function set subLevel(val:IBrowsingLevel):void;
		function get item():IName;
	}
}