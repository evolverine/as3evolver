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


		public static function getItemIndexByProperty( list : ArrayCollection, property : String, value : Object ) : Number
		{
			if( !list )
				return-1;

			if( !list.length )
				return-1;

			if( !property )
				return-1;

			var item : Object;

			for( var ctr : Number = 0; ctr < list.length; ctr++ )
			{
				item = list.getItemAt( ctr );

				if( item && item.hasOwnProperty( property ))
					if( item[ property ] == value )
						return ctr;
			}

			return( -1 );
		}

	}
}