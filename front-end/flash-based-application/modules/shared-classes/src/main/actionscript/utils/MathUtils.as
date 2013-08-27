package utils 
{
	/**
	 * ...
	 * @author DES
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		public static function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}	
		
		public static function randBoolean():Boolean {
			return (Math.random() > .5) ? true : false;
		}

        public static function oneValueOf(...args):* {
            return oneValueFromArray(args);
        }

        public static function oneValueFromArray(arr:Array):* {
            return arr[MathUtils.randRange(0, arr.length-1)]
        }
    }

}