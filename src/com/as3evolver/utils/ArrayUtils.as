package com.as3evolver.utils
{

	public class ArrayUtils
	{
		public static function cloneArray( val : Array ) : Array
		{
			if( !val )
				return null;

			if( !val.length )
				return[];

			var clonedArray : Array = [];
			var arrayIndex : String;

			for( arrayIndex in val )
				clonedArray[ arrayIndex ] = val[ arrayIndex ];


			return clonedArray;
		}


		public static function safeConcat( array1 : Array, ... otherArrays ) : Array
		{
			if( array1 && otherArrays )
			{
				var resultArray : Array = [];
				var index : String;
				var indexAsNumber : Number;
				var sources : Array = [ array1 ].concat( otherArrays );
				var array : Array;

				for each( array in sources )
				{
					for( index in array )
						if( index is String )
						{
							resultArray[ index ] = array[ index ];
						}
						else if( index is Number )
							resultArray.push( array[ index ]);
				}

				return resultArray;
			}

			return array1;
		}


		public static function joinBy( items : Array, separator : String, propertyName : String ) : String
		{
			var joined : String = '';

			if( items && items.length && propertyName )
			{
				var item : Object;

				for each( item in items )
					if( item && item.hasOwnProperty( propertyName ) && ( item[ propertyName ]))
					{
						if( joined )
							joined += separator;
						joined += item[ propertyName ];
					}
			}

			return joined;
		}


		public static function arrayFromObjectsProperty( array : Array, propertyName : String ) : Array
		{
			var result : Array = [];

			if( array && propertyName )
			{
				var item : Object;

				for( var i : String in array )
				{

					item = array[ i ];

					if( item && item.hasOwnProperty( propertyName ) && item[ propertyName ])
						result.push( item[ propertyName ]);

				}

			}

			return result;
		}


		/**
		 * assumption is that array1 and array2 have consequent integers as indexes
		 *
		 * */
		public static function uniqueConcat( array1 : Array, array2 : Array ) : Array
		{
			var result : Array = [];

			if( !array1 && !array2 )
				return result;

			var array1Length : Number = array1 ? array1.length : 0;
			var array2Length : Number = array2 ? array2.length : 0;
			var i : Number = array1Length;
			var item : Object;

			while( --i >= 0 )
				if( result.indexOf( item = array1[ i ]) == -1 )
					result.push( item );

			i = array2Length;

			while( --i >= 0 )
				if( result.indexOf( item = array2[ i ]) == -1 )
					result.push( item );


			return result;
		}


		public static function indexOfPropertyValue( array : Array, propertyName : String, value : Object ) : String
		{
			var indexOf : String = '-1';

			if( array )
			{
				var item : Object;

				for( var index : String in array )
				{
					item = array[ index ];

					if( item && item.hasOwnProperty( propertyName ))
						if( item[ propertyName ] == value )
							return index;
				}
			}

			return indexOf;
		}


		public static function findByPropertyValue( array : Array, propertyName : String, value : Object ) : Object
		{
			var index : String = indexOfPropertyValue( array, propertyName, value );

			if( index != '-1' )
				return array[ index ];

			return null;
		}
	}
}