/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/18/13
 * Time: 8:21 AM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms.events {
import flash.events.Event;

public class StateEvent extends Event {
    public static const EVENT_TYPE_ACTIVATE:String = "EVENT_TYPE_ACTIVATE"
    public static const EVENT_TYPE_DEACTIVATE:String = "EVENT_TYPE_DEACTIVATE"

    public function StateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
