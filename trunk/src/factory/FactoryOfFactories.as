package factory
{
	public class FactoryOfFactories extends AbstractFactory
	{
		
		public function FactoryOfFactories()
		{
			super();
			this._class = FactoryOfAnything;
		}
	}
}