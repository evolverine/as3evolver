package utils
{
	public class ArrayUtils
	{
		public static function safeConcat(array1:Array, ...otherArrays):Array
		{
			if(array1 && otherArrays) {
				var resultArray:Array = [];
				var index:String;
				var indexAsNumber:Number;
				var sources:Array = [array1].concat(otherArrays);
				var array:Array;
				
				for each(array in sources) {
					for(index in array)
						if(index is String) {
							resultArray[index] = array[index];
						}
						else if(index is Number)
							resultArray.push(array[index]);
				}
				
				return resultArray;
			}
			
			return array1;
		}
		
		
		public static function joinBy(items:Array, separator:String, propertyName:String):String
		{
			var joined:String = '';
			
			if(items && items.length && propertyName) {
				var item:Object;
				for each(item in items)
					if(item && item.hasOwnProperty(propertyName) && (item[propertyName])) {
						if(joined) joined += separator;
						joined += item[propertyName];
					}
			}
			
			return joined;
		}
	}
}