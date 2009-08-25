package factory
{
	import org.as3commons.reflect.Type;
	
	import utils.ObjectUtils;

	public class FactoryOfAnything extends AbstractFactory
	{
		public var useDeepEquality:Boolean = true;
		
		public function FactoryOfAnything(handledClass:Class, useDeepEquality:Boolean = true)
		{
			super();
			
			if(!handledClass)
				throw new Error('Please provide a valid class for the factory of anything constructor!');
			else {
				this._class = handledClass;
					
				//TODO: take care of constructor arguments (ClassUtils.newInstance)
			}
			
			this.useDeepEquality = useDeepEquality;
		}
		
		
		public override function duplicatesExistingItem(val:Object) : Object
		{
			if(!this.useDeepEquality)
				return super.duplicatesExistingItem(val);
			
			var item:Object;
			for each(item in this._items)
				if(ObjectUtils.deepEquals(item, val))
					return item;
			
			return null;
		}
	}
}