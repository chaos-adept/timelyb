package utils 
{
	/**
	 * ...
	 * @author DES
	 */
	public class ArrayUtils 
	{
		
		public function ArrayUtils() 
		{
			
		}
		
		
		public static function randomizeArrayHandler(...args):Number {
			return Math.round(Math.random() * 2) - 1;
		}

        public static function randomize(target:*):void {
            var result:Array = new Array();

            for(var len:int = target.length;len;len--) {
                result.push(target.splice(Math.random() * target.length, 1)[0]);
            }

            for (var indx:int = 0; indx < result.length;indx++) {
                target.push(result[indx]);
            }



        }
    }

}