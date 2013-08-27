package utils 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author DES
	 */
	public class CheckBtn extends MovieClip 
	{
		
		private var _checked:Boolean;
		
		public function CheckBtn() 
		{
			trace("new check btn");
		}
		
		public function get checked():Boolean 
		{
			return _checked;
		}
		
		public function set checked(value:Boolean):void 
		{
			trace("checked " + checked);
			_checked = value;
			this.gotoAndStop(value ? 2 : 1);
		}
		
		
		
	}

}