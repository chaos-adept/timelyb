package  
{
import events.EventUtils;

import flash.display.MovieClip;
	import flash.events.Event;

    import game.IActivity;

/**
	 * ...
	 * @author DES
	 */
	public class InitiableMovieClip extends MovieClip implements IActivity
	{
		
        public function InitiableMovieClip()
        {
            super();
            this.addEventListener(Event.ENTER_FRAME, firstFrameHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);

            this.addEventListener(Event.ADDED, addedToParentHandler);
        }

        private function firstFrameHandler(e:Event):void {
                this.removeEventListener(Event.ENTER_FRAME, firstFrameHandler);
                addedToStateHandler();
        }

        protected function addedToParentHandler(e:Event):void {
        }

        protected function addedToStateHandler():void {

        }

        protected function removeFromStageHandler(e:Event):void {

        }

        public function exit():void {
        }

        public function suspend():void {
            EventUtils.newCustomEvent(this, Cnst.EVENT_ACTIVITY_SUSPENDED, null);
        }

        public function resume():void {
            EventUtils.newCustomEvent(this, Cnst.EVENT_ACTIVITY_RESUMED, null);
        }

    public function addAddedToStageListener(handler:Function):void {
        this.addEventListener(Event.ADDED_TO_STAGE, handler);
    }

    public function removeAddedToStageListener(handler:Function):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, handler);
    }

    public function addRemovedFromStageListener(handler:Function):void {
        this.addEventListener(Event.REMOVED_FROM_STAGE, handler);
    }

    public function removeRemovedFromStageListener(handler:Function):void {
        this.removeEventListener(Event.REMOVED_FROM_STAGE, handler);
    }
}

}