package com.as3evolver.utils
{

	public class StringUtils
	{
		public static function containsAtLeastACharacterOf( originalString : String, charactersToCheck : String, charactersAlreadyFormattedForRegExp : Boolean = false ) : Boolean
		{
			if( !originalString )
				return false;

			if( !charactersToCheck )
				return false;

			if( !charactersAlreadyFormattedForRegExp )
				charactersToCheck = escapeStringForRegExp( charactersToCheck );

			return( originalString.search( new RegExp( charactersToCheck, 'im' )) != -1 );
		}


		public static const REG_EXP_SPECIAL_CHARACTERS : String = ".[]^+*?$|{}/'#\\";


		public static function escapeStringForRegExp( val : String ) : String
		{
			if( !val )
				return val;

			var positionsOfSpecialChars : Array = [];
			var ctr : Number;

			for( ctr = 0; ctr < val.length; ctr++ )
				if( REG_EXP_SPECIAL_CHARACTERS.indexOf( val.charAt( ctr )) != -1 )
					positionsOfSpecialChars.push( ctr );

			if( !positionsOfSpecialChars.length )
				return '[' + val + ']';
			else
			{
				var escapedString : String = '';

				var backslash : String = String.fromCharCode( 92 );
				ctr = 0;
				var previousSpecialCharPosition : Number = 0;

				while( ctr < positionsOfSpecialChars.length )
				{
					escapedString += val.substr( previousSpecialCharPosition, positionsOfSpecialChars[ ctr ] - previousSpecialCharPosition ) + backslash;
					previousSpecialCharPosition = positionsOfSpecialChars[ ctr ];
					ctr++;
				}
				escapedString += val.substr( previousSpecialCharPosition );

				return '[' + escapedString + ']';
			}
		}

	}
}