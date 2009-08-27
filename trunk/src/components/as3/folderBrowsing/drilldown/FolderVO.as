package components.as3.folderBrowsing.drilldown
{
	import interfaces.IName;
	
	[RemoteClass(alias="FolderVO")]
	public class FolderVO implements IName
	{
		public var id:String;
		public var title:String;
		public var children:Array; //of FolderVO items
		public var resources:Array; //of ResourceVO items
		
		[Transient]
		public function get name():String
		{
			return this.title;
		}
	}
}