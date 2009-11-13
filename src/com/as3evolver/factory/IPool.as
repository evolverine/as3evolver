package com.as3evolver.factory
{
	public interface IPool
	{
		function gimme(...constructorArgs):Object
		function park(val:Object):void;
	}
}