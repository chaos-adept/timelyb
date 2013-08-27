/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 05.01.13
 * Time: 12:54
 * To change this template use File | Settings | File Templates.
 */
package game {
import flash.desktop.NativeApplication;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;

import org.as3commons.lang.Assert;

public class ApplicationHelper {
    public function ApplicationHelper() {
    }

    public static function exit():void {
        var exitingEvent:Event = new Event(Event.EXITING, false, true);
        NativeApplication.nativeApplication.dispatchEvent(exitingEvent);
        if (!exitingEvent.isDefaultPrevented()) {
            NativeApplication.nativeApplication.exit();
        }
    }

    public static function newExitFunction():Function {
        return function (...arg):void {
            exit();
        }
    }

    public static function registerDocumentActivity(activity:IActivity):ActivityController {
        Assert.notNull(activity.stage);
        return new DocumentActivityController(activity);
    }

    public static function registerActivity(activity:IActivity):void {
        Assert.notNull(activity.stage);
        new ActivityController(activity);
    }
}
}
