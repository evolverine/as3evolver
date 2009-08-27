package factory
{
	import org.as3commons.lang.ClassUtils;

	public class AbstractFactory implements IFactory
	{
		public var allowDuplicates:Boolean = false;
		protected var _class:Class;
		protected var _items:Array = [];
		
		public function AbstractFactory()
		{
			this._class = Object;
		}
		
		
		public function gimme(...constructorArgs):Object
		{
			var item:Object = this._items.pop(); 
			if((!item) || !(item is _class))
				//item = new _class();
				item = ClassUtils.newInstance(_class, constructorArgs);
			return (item as _class);
		}
		
		
		public function park(val:Object):void
		{
			if(val && val is _class)
				if(!this.isParked(val))
					if(allowDuplicates || !this.duplicatesExistingItem(val))
						this._items.push(val);
		}
		
		
		public function isParked(val:Object):Boolean
		{
			var item:Object;
			for each(item in this._items)
				if(item == val)
					return true;
			
			return false;
		}
		
		public function duplicatesExistingItem(val:Object) : Object
		{
			var item:Object;
			for each(item in this._items)
				if(item == val)
					return item;
			
			return null;
		}
		
		
		public function get handledClass():Class
		{
			return this._class;
		}
	}
}