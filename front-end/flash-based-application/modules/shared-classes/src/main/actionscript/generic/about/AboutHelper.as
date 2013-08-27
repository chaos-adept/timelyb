/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 02.03.13
 * Time: 20:42
 * To change this template use File | Settings | File Templates.
 */
package generic.about {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.Event;

public class AboutHelper {

    public static var targetAlertClass:Class;

    public function AboutHelper() {
    }

    public static function initFor(target:DisplayObject, targetAlertClass:Class) {
        AboutHelper.targetAlertClass = targetAlertClass;
        target.addEventListener(Cnst.EVENT_TYPE_SHOW_ABOUT, showAboutHandler, false, 0, true);
    }

    private static function showAboutHandler(event:Event):void {
        show(targetAlertClass, event.target as DisplayObject);
    }

    private static function show(targetClass:Class, target:DisplayObject):void {
        var container:DisplayObjectContainer = target.parent;
        var about:MovieClip = new targetClass();
        about.show(container);
    }
}
}
