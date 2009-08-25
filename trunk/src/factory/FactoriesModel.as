package factory
{
	import flash.utils.Dictionary;

	public class FactoriesModel
	{
		private static var _factoriesCreator:FactoryOfFactories = new FactoryOfFactories();
		private static var _factories:Dictionary = new Dictionary(false);
		
		public static function gimme(byClass:Class):FactoryOfAnything
		{
			if(byClass) {
				if(!_factories[byClass]) _factories[byClass] = _factoriesCreator.gimme(byClass) as FactoryOfAnything;
				return _factories[byClass] as FactoryOfAnything;
			}
			
			return null;
		}
	}
}