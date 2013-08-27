/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 3/13/13
 * Time: 7:55 AM
 * To change this template use File | Settings | File Templates.
 */
package game.license {
import flash.events.DataEvent;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class LockedLicenseChecker extends EventDispatcher implements LicenseCheckHandler{

    private var _isLocked:Boolean = false;

    private var _requestCount:int = 0;

    public function LockedLicenseChecker() {
    }

    public function request():void {
        var timer:Timer = new Timer(3000, 1);
        timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
        timer.start();
    }

    private function onTimerHandler(event:TimerEvent):void {
        _requestCount++;

        _isLocked = true;// _requestCount < 5;

        if (_isLocked) {
            dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_LOCKED));
        } else {
            dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_UNLOCKED));
        }


    }

    public function isLocked():Boolean {
        return _isLocked;
    }

    public function isCheckServiceUnAvailable():Boolean {
        return _requestCount <= 4;
    }

    public function isUnLocked():Boolean {
        return !isLocked();
    }

    public function marketUrl():String {
        return "http://market.android.com";
    }
}
}
