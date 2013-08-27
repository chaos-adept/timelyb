/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/18/13
 * Time: 6:46 AM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
public class Transition {

    public var _toEndStateName:String;
    private var changeStateHandler:Function;
    private var _conditionals:Array;
    private var fromState:State;

    public function Transition(fromState:State, changeStateHandler:Function) {
        this.fromState = fromState;
        this.changeStateHandler = changeStateHandler;
        _conditionals = [];
    }

    public function toState(state:String):Transition {
        this._toEndStateName = state;
        return this
    }

    public function transite(event:*):void {
        if (_conditionals.length > 0) {
            for (var indx:int = _conditionals.length-1; indx > -1; indx--) {
                var handler:Function = _conditionals[indx];
                var result:Boolean = handler.length > 0 ? handler.apply(null, [event]) : handler.apply();
                if (!result) {
                    return;
                }
            }
        }

        changeStateHandler(_toEndStateName);
    }

    public function addConditional(conditionalHandler:Function):Transition {
        _conditionals.push(conditionalHandler);
        return this;
    }

    public function get _from():State {
        return fromState;
    }
}
}
