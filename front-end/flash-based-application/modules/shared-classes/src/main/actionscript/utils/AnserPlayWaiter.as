package utils 
{
	import events.EventUtils;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author DES
	 */
	public class AnserPlayWaiter extends EventDispatcher {
	
		public var animCompleted:Boolean;
		public var soundCompleted:Boolean;
		public var isStarted:Boolean;
		
		public function start():void {
			animCompleted = false;
			soundCompleted = false;
			isStarted = true;
		}
		
		public function complete():void {
			animCompleted = true;
			soundCompleted = true;
			isStarted = false;
		}
		
		public function onAnimationCompleted(...args):void {
			animCompleted = true;
			checkCompleted();
		}
		
		public function onSoundCompleted(...args):void 
		{
			soundCompleted = true;
			checkCompleted();
		}
		
		public function checkCompleted():void 
		{
			if (isCompleted) {
				//dispatchEvent(ZagadkiConstants.EVENT_TYPE_ANSER_PLAY_COMPLETED);
				EventUtils.newCustomEvent(this, ZagadkiConstants.EVENT_TYPE_ANSER_PLAY_COMPLETED, null); 
			}
		}
		
		
		
		public function get isCompleted():Boolean {
			return animCompleted && soundCompleted;
		}
	
	}

}