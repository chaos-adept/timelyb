package events 
{
import flash.events.IEventDispatcher;

/**
	 * ...
	 * @author DES
	 */
	public class EventUtils 
	{
		
		public function EventUtils() 
		{
			
		}
		
		public static function newSelectEvent(dispatcher:IEventDispatcher, data:String):void {
			
			newCustomEvent(dispatcher, ZagadkiConstants.EVENT_TYPE_SELECT, data);
		}
		
		public static function newRepeatEvent(dispatcher:IEventDispatcher):void {
			newCustomEvent(dispatcher, ZagadkiConstants.EVENT_TYPR_REPEAT_TASK, null);
		}
		
		public static function newRepeatGameEvent(dispatcher:IEventDispatcher):void {
			newCustomEvent(dispatcher, Cnst.EVENT_TYPE_PLAY_AGAIN, null);
		}
		
		static public function newAnimCompletedEvent(dispatcher:IEventDispatcher, animName:String):void 
		{
			newCustomEvent(dispatcher, ZagadkiConstants.EVENT_TYPE_ANIMCOMPLETED, animName);
		}
		
		static public function newAnimStartedEvent(dispatcher:IEventDispatcher, animName:String):void 
		{
			newCustomEvent(dispatcher, ZagadkiConstants.EVENT_TYPE_ANIM_STARTED, animName);
		}		
		
		static public function newCustomEvent(dispatcher:IEventDispatcher, eventType:String, data:String = null):void
		{
			trace(" event: ", eventType, data);
			dispatcher.dispatchEvent(EventFactory.newDataEvent(eventType, data));
		}
		
		static public function newGameFinishedEvent(dispatcher:IEventDispatcher):void 
		{
			newCustomEvent(dispatcher, Cnst.EVENT_TYPE_GAME_FINISHED, null);
		}

        static public function addToEvents(dispatcher:IEventDispatcher, handler:Function, eventTypes:Array):void {
            for each (var eventType:String in eventTypes) {
                dispatcher.addEventListener(eventType, handler);
            }
        }

        static public function removeFromEvents(dispatcher:IEventDispatcher, handler:Function, eventTypes:Array):void {
            for each (var eventType:String in eventTypes) {
                dispatcher.removeEventListener(eventType, handler);
            }
        }

        public static function newGameOverEvent(dispatcher:IEventDispatcher):void {
            EventUtils.newCustomEvent(dispatcher, Cnst.EVENT_TYPE_GAME_OVER, null)
        }

        public static function newGameFinishedFn(dispatcher:IEventDispatcher):Function {
            return function ():void {
                newGameFinishedEvent(dispatcher);
            }
        }

        public static function newGameOverFn(dispatcher:IEventDispatcher):Function {
            return function ():void {
                newGameOverEvent(dispatcher);
            }
        }
    }

}