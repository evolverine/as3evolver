package factory
{
	public class FactoryOfFactories extends AbstractFactory
	{
		
		//SINGLETON STUFF
		private static var _instance:FactoryOfFactories = new FactoryOfFactories();
		public static function getInstance():FactoryOfFactories {return _instance};
		
		
		public function FactoryOfFactories()
		{
			super();
			this._class = FactoryOfAnything;
		}
	}
}