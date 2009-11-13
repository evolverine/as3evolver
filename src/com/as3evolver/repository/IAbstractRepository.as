package com.as3evolver.repository
{
	public interface IAbstractRepository
	{
		function find(id : Object):Array;
		function findOne(id : String):Object;
		function add(val : Object):Object;
		function addMany(val : Object):Array
		function remove(id : String):Boolean;
		function create(id : String, ...constructorArgs):Boolean;
		function getOrCreateById(id : String, ...constructorArgs):Object
		function getOrAdd(val : Object):Object;
		function getOrAddMany(val : Object):Array;
	}
}