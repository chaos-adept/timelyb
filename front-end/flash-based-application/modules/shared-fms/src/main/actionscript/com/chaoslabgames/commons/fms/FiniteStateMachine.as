/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:41 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import flash.events.Event;
import flash.utils.Dictionary;

public class FiniteStateMachine {

    private var states:Dictionary;

    private var _currentState:State;

    public var initState:String;
    private var _started:Boolean = false;;
    private var _disposed:Boolean = false;

    public function FiniteStateMachine() {
        states = new Dictionary();
    }

    public function state(name:String):State {
        var state:State = states[name];
        if (!state) {
            state = new State(name, changeState);
            states[name] = state;
        }
        if (!initState) {
            initState = name;
        }
        return state;
    }

    public function changeState(name:String):void {
        checkStarted();
        currentState = state(name);
    }

    public function handleEvent(event:Object):void {
        if (_disposed) {
            return;
        }

        checkStarted();
        _currentState.handleEvent(event);
    }

    private function checkStarted():void {
        if (!_started) {
            start();
        }
    }

    public function start():void {
        _started = true;
        if (!currentState) {
            currentState = state(initState);
        }
    }

    public function get currentState():State {
        checkStarted();
        return _currentState;
    }

    public function set currentState(state:State):void {
        if (currentState != null) {
            currentState.deactivate();
        }
		trace("setState", state.name);
        _currentState = state;
        _currentState.activate();
    }
	
	public function reset():void {
		changeState(initState)
	}

    public function dispose():void {
        _disposed = true;
        for each (var state:State in states) {
            state.dispose();
        }
    }
}
}
