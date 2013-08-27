package game.document
{
import events.EventUtils;

import flash.events.Event;
import flash.events.MouseEvent;

public class LeftMenuCtrl extends InitiableMovieClip
	{
		
		private var Lmenu:LeftMenuSmb;
		
		public function LeftMenuCtrl()
		{
			super();
			Lmenu = new LeftMenuSmb()
			addChild(Lmenu);
            /*
			Lmenu._menuM.addEventListener(MouseEvent.CLICK, newClickHandler(KalendarCnst.EVENT_TYPE_MENU))
			Lmenu._menuR.addEventListener(MouseEvent.CLICK, newClickHandler(KalendarCnst.EVENT_TYPE_REPEAT))
			Lmenu._menuH.addEventListener(MouseEvent.CLICK, newClickHandler(KalendarCnst.EVENT_TYPE_HELP))
			Lmenu._menuA.addEventListener(MouseEvent.CLICK, newClickHandler(KalendarCnst.EVENT_TYPE_ABOUT))  */

		}

        public function open():void {
            Lmenu.DOpenMenu();
        }

        public function hide():void {
            Lmenu.DCloseMenu();
            Lmenu._menuM.gotoAndStop(1);
        }
		
		private function newClickHandler(generateEventType:String):Function {
			return function (e:Event):void {
				EventUtils.newCustomEvent(Lmenu, generateEventType, null);
			}
		}
		
		private function MouseDownMenuM(event:MouseEvent):void
		{
			Lmenu._menuM.gotoAndStop(2);
		};
		// =======================================================		
		
		private function MouseUpMenuM(event:MouseEvent):void
		{
			//ShowZastavkaMain();
			Lmenu.DCloseMenu();
			Lmenu._menuM.gotoAndStop(1);
		};

    public function toGameMenuState():void {
        Lmenu.toMainSceneLayout();
    }


    public function toGameState():void {
        Lmenu.toGameLayout();
    }

}
}