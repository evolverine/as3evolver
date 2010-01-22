package com.as3evolver.utils
{
	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;


	public class StringValidatorWIllegalChars extends StringValidator
	{

		public static function validateString( validator : StringValidatorWIllegalChars, value : Object, baseField : String = null ) : Array
		{
			var results : Array = StringValidator.validateString( validator, value, baseField );

			if( !results.length )
			{
				if( !validator.illegalCharacters )
					return results;

				var val : String = value != null ? String( value ) : "";

				if( StringUtils.containsAtLeastACharacterOf( val, validator.illegalCharacters ))
				{
					results.push( new ValidationResult( true, baseField, "containsIllegalChar", StringUtil.substitute( validator.illegalCharactersError, validator.illegalCharacters )));
					return results;
				}
			}
			return results;
		}

		/**
		 * A string containing the characters which are not allowed
		 * in the string. If this is empty, it means everything is allowed.
		 * */
		public var illegalCharacters : String = '';

		/**
		 *  Error message when the String contains
		 *  at least one of the <code>illegalCharacters</code>.
		 *
		 *  @default "Sorry, but your input cannot contain the following characters: {0}"
		 */
		public var illegalCharactersError : String = 'Sorry, but your input cannot contain the following characters: {0}';


		override protected function doValidation( value : Object ) : Array
		{
			var results : Array = super.doValidation( value );

			// Return if there are errors
			// or if the required property is set to false and length is 0.
			var val : String = value ? String( value ) : "";

			if( results.length > 0 || (( val.length == 0 ) && !required ))
				return results;
			else
				return StringValidatorWIllegalChars.validateString( this, value, null );
		}

	}
}