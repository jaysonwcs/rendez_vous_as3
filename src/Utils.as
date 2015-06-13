package  
{
	import flash.globalization.NumberFormatter;
	/**
	 * ...
	 * @author Jayson
	 */
	public class Utils 
	{
		static public function formatWithZerosString(number: String, numberOfZeros: uint, format: NumberFormatter):String {
			return formatWithZeros(format.parseNumber(number), numberOfZeros, format);
		}
		
		static public function formatWithZeros(number: Number, numberOfZeros: uint, format: NumberFormatter):String {
			var intNumber: int = Math.floor(number);
			var decimalNumber: Number = number - intNumber;
			var stringNumber: String = intNumber.toString();
			var length: int = stringNumber.length;
			var result: String = new String();
			var i: int;
			
			if (numberOfZeros > length) {
				for (i = 0; i < (numberOfZeros - length); i++) {
					result = result + 0;
				}
				
				result = result + format.formatNumber(intNumber + decimalNumber);
			} else {
				var maxNum: Number = new Number();
				
				for (i = -format.fractionalDigits; i < numberOfZeros; i++) {
					maxNum = maxNum + (9 * Math.pow(10, i));
				}
				
				result = format.formatNumber(Math.min(number, maxNum));
			}
			
			return result;
		}
		
	}

}