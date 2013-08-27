package fms 
{
	import flash.utils.Dictionary;
	import flash.events.Event;

	/**
	 * ...
	 * @author DES
	 */
	public class FSM 
	{
		
		public var context:Object;
		
		public var states:Dictionary;
		
		private var currentState:State;
		
		public var name:String;
		
		public function FSM(name:String) 
		{
			this.name = name;
			this.states = new Dictionary();
		}
		
		public function registerState(stateKey:String, enterStateHandler:Function = null):State {
			var state:State = new State(this);
            state.name = stateKey;
			state.enterStateHandler = enterStateHandler;
			trace(name, "registerState", stateKey);
			states[stateKey] = state;
			return state;
		}
		
		
		public function changeState(stateKey:String):void {
			trace(name, "changeState", currentState != null ? currentState.name : null, "->", stateKey);
			
			if ((currentState != null) && (currentState.exitStateHandler != null)) {
				currentState.exitStateHandler();
			}
			
			currentState = states[stateKey];
			
			if (currentState == null) {
				throw new Error("State not found for " + stateKey);
				return;
			}

            currentState.enter();

		}
		
		public function handleEvent(event:Event):void {
			trace(name, "currentState:", currentState.name, " handleEvent type", event.type);
			currentState.handle(event);
		}
		
		public function registerSleepState(stateKey:String, delay:Number, nextStateKey:String):void 
		{
			StateFactory.newSleepState(stateKey, delay, nextStateKey, this);
		}
		
		public function dispose():void { 
			for (var key:String in states) {
				var state:State = states[key] as State;
				if (state != null) {
					state.dispose();
				}
			}
			
			for (var remKey:String in states) {
				delete states[remKey];
			}
		}

        public function getAllStates():Array {
            var result:Array = [];

            for each (var item:State in states) {
                result.push(item);
            }

            return result;
        }
    }

}