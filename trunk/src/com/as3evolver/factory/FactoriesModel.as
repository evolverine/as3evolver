package com.as3evolver.factory
{
	import flash.utils.Dictionary;

	public class FactoriesModel
	{
		private static var _factoriesCreator:PoolOfPools = new PoolOfPools();
		private static var _factories:Dictionary = new Dictionary(false);
		
		public static function gimme(byClass:Class):GenericObjectPool
		{
			if(byClass) {
				if(!_factories[byClass]) _factories[byClass] = _factoriesCreator.gimme(byClass) as GenericObjectPool;
				return _factories[byClass] as GenericObjectPool;
			}
			
			return null;
		}
	}
}