/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:46 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import com.chaoslabgames.commons.fms.events.StateEvent;

import flash.utils.Dictionary;

public class State {

    private var _eventHandlers:Dictionary;
    private var _transitions:Dictionary;
    private var _changeStateHandler:Function;

    public var name:String;

    public function State(name:String, changeStateHandler:Function) {
        this.name = name;
        _eventHandlers = new Dictionary()
        _transitions = new Dictionary()
        this._changeStateHandler = changeStateHandler;
    }

    public function addTransition(eventType:String, key:String = null):Transition {
        var complexKey:String = key ? eventType + "_" + key : eventType;
        var transition:Transition = _transitions[complexKey];
        if (transition != null) {
            throw new Error("There is another transition for '" + complexKey + "'")
        }
        transition = new Transition(this, _changeStateHandler);
        _transitions[complexKey] = transition;
        addHandler(eventType, transition.transite)

        return transition;
    }

    public function addTrasitionOnActivate(key:String = null):Transition {
        return addTransition(StateEvent.EVENT_TYPE_ACTIVATE, key);
    }

    public function addHandler(eventType:String, handler:Function):State {
        eventHandlersByType(eventType).push(handler);
        return this;
    }

    public function handleEvent(event:Object):void {
        var handlers:Array = eventHandlersByType(event.type);
        for (var indx:int = 0; indx < handlers.length; indx++) {
            var targetHandler:Function = handlers[indx];
            if (targetHandler != null) {
                if (targetHandler.length == 1) {
                    targetHandler(event);
                } else {
                    targetHandler();
                }
            }
        }
    }

    private function eventHandlersByType(eventType:String):Array {
        var handlers:Array = _eventHandlers[eventType];
        if (!handlers) {
            handlers = [];
            _eventHandlers[eventType] = handlers;
        }
        return handlers;
    }

    public function addActivateHandler(handler:Function):State {
        this.addHandler(StateEvent.EVENT_TYPE_ACTIVATE, handler)
        return this;
    }

    public function addDeactivateHandler(handler:Function):State {
        this.addHandler(StateEvent.EVENT_TYPE_DEACTIVATE, handler)
        return this;
    }

    public function activate():void {
        handleEvent(new StateEvent(StateEvent.EVENT_TYPE_ACTIVATE))
    }

    public function deactivate():void {
        handleEvent(new StateEvent(StateEvent.EVENT_TYPE_DEACTIVATE))
    }

    public function toString():String {
        return "[" + name + "]";
    }

    public function dispose():void {
        _eventHandlers = new Dictionary();
        _transitions = new Dictionary();
    }
}
}
