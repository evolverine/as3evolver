package com.as3evolver.factory
{
	
	/**
	 * <p>
	 * Represents a pool of object pools. Is implemented as singleton. Its main purpose is to aid
	 * in the creation of dynamic object pools:
	 * 
	 *  <listing>
	 *   _itemFactory = PoolOfPools.getInstance().gimme(_breadcrumbRenderer, false) as GenericObjectPool;
	 * 	 //_breadcrumbRenderer is of type Class
	 * 	</listing>
	 * 
	 * , instead of having to write a separate class for every object pool used in the application.
	 * This makes it easier to improve memory management in an application.
	 * </p>
	 * 
	 * <p>
	 * <strong>TODO:</strong>
	 *  <ul>
	 *   <li>move this class in a 'pool' package, not factory</li>
	 *   <li>it actually makes more sense to use a Pool repository for this task, because when
	 *       two different classes want to use pools which handle the same type of object,
	 *       it makes more sense for them to have a reference to the same pool, instead of
	 *       two different ones being created. This way, objects will be pooled between those
	 *       two classes, with a greater potential for saving memory. Implement this.</li>
	 *  </ul>
	 * <p>
	 * 
	 * @see com.as3evolver.factory.GenericObjectPool
	 * 
	 * @author Mihai Chira
	 * */
	public class PoolOfPools extends GenericObjectPool
	{
		
		//SINGLETON STUFF
		private static var _instance:PoolOfPools = new PoolOfPools();
		public static function getInstance():PoolOfPools {return _instance};
		
		
		public function PoolOfPools()
		{
			super( GenericObjectPool );
		}
	}
}