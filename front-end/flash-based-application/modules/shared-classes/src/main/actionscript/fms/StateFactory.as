package fms 
{
	/**
	 * ...
	 * @author DES
	 */
	public class StateFactory 
	{
		
		public function StateFactory() 
		{
			
		}
		
		public static function newSleepState(stateKey:String, delay:int, nextStateKey:String, stateMachine:FSM):State {
			var sleepStateController:SleepStateHelper = new SleepStateHelper(stateMachine, delay, nextStateKey);
			var newState:State = stateMachine.registerState(stateKey, sleepStateController.enterStateHandler)
				.setDisposeHandler(sleepStateController.disposeStateHandler);
			return newState;
			
		}
		
	}

}
import flash.events.TimerEvent;
import flash.utils.Timer;

class SleepStateHelper {
	
	public var stateMachine:fms.FSM;
	
	private var timer:Timer;
	
	private var nextStateKey:String;
	
	public function SleepStateHelper(stateMachine:fms.FSM, delay:Number, nextStateKey:String) {
		this.stateMachine = stateMachine;
		timer = new Timer(delay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		this.nextStateKey = nextStateKey;
	}
	
	private function timerCompleteHandler(e:TimerEvent):void 
	{
		stateMachine.changeState(nextStateKey);
	}
	
	public function disposeStateHandler():void {
		timer.stop();
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
	}
	
	public function enterStateHandler():void {
		timer.reset();
		timer.start();
	}
}