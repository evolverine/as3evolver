package com.as3evolver.utils
{
	import org.as3commons.reflect.IMember;

	public class ObjectUtils
	{
		public static function deepEquals(a:Object, b:Object):Boolean
		{
			return new DeepEqualsBuilder().append(a, b).equals;
		}
	}
}