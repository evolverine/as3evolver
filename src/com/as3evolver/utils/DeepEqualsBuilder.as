package com.as3evolver.utils
{
	import org.as3commons.lang.builder.EqualsBuilder;
	import org.as3commons.reflect.IMember;
	import org.as3commons.reflect.Type;

	public class DeepEqualsBuilder extends EqualsBuilder
	{
		protected override function appendObjectProperties(a:Object, b:Object):void
		{
			var typeInfo:Type = Type.forInstance(a);
			var fieldsA:Array = typeInfo.variables.concat(typeInfo.accessors);
			var field:IMember;
			for each(field in fieldsA)
				if(field.name != 'prototype')
					this.append(a[field.name], b[field.name]);
		}
	}
}