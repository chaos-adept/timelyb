package utils 
{
	import flash.display.MovieClip;
	import flash.display.MovieClip;
	import ZagadkiConstants;	
	
	/**
	 * ...
	 * @author DES
	 */
	public class LifePanel extends MovieClip 
	{

		private static var lifeWidht:int = 47.45;

        private var ctrl:LifePanelCtrl;

		public function LifePanel() 
		{
            ctrl = new LifePanelCtrl(this)
            ctrl.lifeWidht = lifeWidht
		}
		
		public function setLifeCount(num:int):void {
			ctrl.setLifeCount(num);
		}
		
		public function removeLife():void {
            ctrl.removeLife();
		}

		public function resetLifes():void {
            ctrl.resetLifes();
		}		
		
		private function doLayOut():void {
            ctrl.doLayOut();
		}
		
		public function get lifeCount():int 
		{
			return ctrl.lifeCount;
		}
		
		public function get hasLifes():Boolean {
			return ctrl.hasLifes;
		}


        public function get isHorizontalMode():Boolean {
            return ctrl.isHorizontalMode;
        }

        public function set isHorizontalMode(value:Boolean):void {
            ctrl.isHorizontalMode = value;
        }
    }

}