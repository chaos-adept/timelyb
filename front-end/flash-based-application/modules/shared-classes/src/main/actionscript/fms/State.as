package fms 
{
import events.EventFactory;
import events.EventUtils;

import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

	/**
	 * ...
	 * @author DES
	 */
	public class State
	{
		
		private var stateMachine:FSM;
		
		private var staticTransitionDict:Dictionary;
		
		public var enterStateHandler:Function;			
		public var exitStateHandler:Function;
		public var disposeStateHandler:Function;
        public var name:String;

        private var eventDict:Dictionary;

		public function State(stateMachine:FSM) 
		{
			this.stateMachine = stateMachine;
			staticTransitionDict = new Dictionary();
            eventDict = new Dictionary();
		}
		
		public function handle(e:Event):void {
			this.dispatchEvent(e);
		}	
		
		public function setExitStateHandler(handler:Function):State {
			exitStateHandler = handler;
			return this;
		}
		
		public function addHandler(eventType:String, litener:Function):State {
			this.addEventListener(eventType, litener);
			return this;
		}
		
		public function addTransition(eventType:String, nextState:String, changeStateDelegate:Function = null):State 
		{
			var transition:Transition = new Transition();
			transition.nextStateDelegate = changeStateDelegate == null ? changeStateHandler : changeStateDelegate;
			transition.nextState = nextState;
			
			addHandler(eventType, transition.handleEvent);
			
			staticTransitionDict[eventType] = transition;
			
			return this;
		}
		
		public function addForwardEventTransition(eventType:String, nextState:String):State 
		{
			return addTransition(eventType, nextState, changeStateAndForwardEventHandler);
		}
		
		private function changeStateHandler(nextState:String, e:Event):void {
			stateMachine.changeState(nextState);
		}
		
		private function changeStateAndForwardEventHandler(nextState:String, e:Event):void 
		{
			changeStateHandler(nextState, e);
			stateMachine.handleEvent(e);
		}
		
		public function addConditHandler(eventType:String, condition:String, listener:Function):State 
		{
			return addDlgConditHandler(eventType, function (data:String):Boolean {
				return (data == condition);
			}, listener);
		}
		
		public function addDlgConditHandler(eventType:String, conditionDelegate:Function, listener:Function):State {
			return addHandler(eventType, function (e:DataEvent):void {
                var conditionPassed:Boolean = conditionDelegate.length == 1 ? conditionDelegate(e.data) : conditionDelegate();
                if (conditionPassed) {
                    if (listener.length == 0) {
                        listener();
                    } else {
                        listener(e);
                    }
                }
			});			
		}
		
		public function addConditTransition(eventType:String, condition:String, nextState:String):State 
		{
			return addDlgConditTransition(eventType, isData, nextState);

            function isData(data:String):Boolean {
                return (data == condition);
            }
		}		

        public function addDlgConditTransition(eventType:String, conditDlgHandler:Function, nextState:String):State {
            return addDlgConditHandler(eventType, conditDlgHandler, moveToNextState);

            function moveToNextState(e:DataEvent):void {
                changeStateHandler(nextState, e);
            }
        }

		public function setDisposeHandler(disposeStateHandler:Function):State 
		{
			this.disposeStateHandler = disposeStateHandler;
			return this;
		}

		public function dispose():void {
			staticTransitionDict = new Dictionary(); //todo remove all transitions;
			
			if (disposeStateHandler != null) {
				disposeStateHandler();
			}
		}


        public function enter():void {
            if (enterStateHandler != null) {
                enterStateHandler();
            }
            this.dispatchEvent(EventFactory.newDataEvent(Cnst.EVENT_TYPE_ENTER_STATE, name));
        }

        public function addEnterStateHandler(listener:Function):State {
            addHandler(Cnst.EVENT_TYPE_ENTER_STATE, listener);
            return this;
        }

        public function addEventListener(type:String, listener:Function):void {
            var eventListeners:Array = eventDict[type]; //todo getornew fuct
            if (!eventListeners) {
                eventListeners = [];
                eventDict[type] = eventListeners;
            }
            eventListeners.push(listener);
        }

        public function removeEventListener(type:String, listener:Function):void {
            var eventListeners:Array = eventDict[type]; //todo getter
            var indx:int = eventListeners.indexOf(listener);
            eventListeners.splice(indx, 1);
        }

        public function dispatchEvent(event:Event):void { //todo optimize performance
            var eventListeners:Array = eventDict[event.type]; //todo getter
            if (eventListeners) {
                for each (var handler:Function in eventListeners) {
                    if (handler.length > 0) {
                        handler(event);
                    } else {
                        handler();
                    }
                }
            }
        }
    }

}