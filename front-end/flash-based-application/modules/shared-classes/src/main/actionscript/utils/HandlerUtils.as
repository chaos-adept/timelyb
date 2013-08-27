/**
 * Created by WORKSATION on 5/25/13.
 */
package utils {
import flash.events.DataEvent;

public class HandlerUtils {
    public function HandlerUtils() {
    }

    public static function and(...functions):Function {
        return function (event:*):Boolean {
            for each (var fnc:Function in functions) {
                var result:Boolean = fnc.length > 0 ? fnc.apply(null, [event]) : fnc.apply();
                if (!result) {
                    return false;
                }
            }
            return true;
        }
    }

    public static function not(handler:Function):Function {
        return function ():Boolean {
            return !handler();
        }
    }

    public static function newDataEventValueIsFn(expectedValue:*):Function {
        return function (e:DataEvent):Boolean {
            return e.data == _value(expectedValue);
        }
    }

    public static function newConditionalHandlerFn(evntPropName:String, expectedValue:*, handler:Function):Function {
        return function (e:Object):void {
            if (e[evntPropName] == _value(expectedValue)) {
                handler();
            }
        }
    }

    public static function _value(valueRef:Object):Object {
        if (valueRef is Function) {
            return (valueRef as Function)();
        } else {
            return valueRef;
        }
    }

    public static function getPropFromResultFn(getter:Function, propName:String):Function {
        return function ():String {
            return getter()[propName];
        }
    }

    public static function newGenRndNumStringFn(key:String, startNum:int, endNum:int):Function {
        return function ():String {
            return key + MathUtils.randRange(startNum, endNum);
        }
    }
}
}
