package com.as3evolver.utils
{
	import mx.collections.ArrayCollection;

	public class ArrayCollectionUtils
	{
		public static function addItemsFromArray( destination : ArrayCollection, itemsToAdd : Array ) : ArrayCollection
		{
			if( !destination )
				return null;

			if( !itemsToAdd )
				return destination;

			for each( var item : Object in itemsToAdd )
				destination.addItem( item );

			return destination;
		}

	}
}