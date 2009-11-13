package com.pearson.shingo.view.components.as3.folderBrowsing.drilldown
{
	import com.pearson.shingo.interfaces.IName;
	
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
		
		public function set name( inName : String ) : void
		{
			this.title = inName;
		}
		
	}
}