/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 3/13/13
 * Time: 9:17 AM
 * To change this template use File | Settings | File Templates.
 */
package game.license {

import com.adobe.air.sampleextensions.android.licensing.LicenseChecker;
import com.adobe.air.sampleextensions.android.licensing.LicensePolicyType;
import com.adobe.air.sampleextensions.android.licensing.LicenseStatus;
import com.adobe.air.sampleextensions.android.licensing.LicenseStatusEvent;

import flash.events.DataEvent;
import flash.events.ErrorEvent;

import flash.events.EventDispatcher;

public class PlayMarketLicense extends EventDispatcher implements LicenseCheckHandler {

    private var appKey:String;
    private var appId:String;

    private var licChecker:LicenseChecker;

    private var _isLocked:Boolean;

    private var _serviceAvailable:Boolean;

    public function PlayMarketLicense(appKey:String,  appId:String) {
        this.appKey = appKey;
        this.appId = appId;
        licChecker = new LicenseChecker();
        licChecker.addEventListener(ErrorEvent.ERROR, errorHandler);
        licChecker.addEventListener(LicenseStatusEvent.STATUS, licStatusHandler);
        _isLocked = true;
        _serviceAvailable = true;
    }

    private function errorHandler(e:ErrorEvent):void {
        trace("error: " + e.toString())
        _isLocked = true;
        if (_isLocked) {
            dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_LOCKED))
        }
    }

    private function licStatusHandler(event:LicenseStatusEvent):void {
        trace(" licStatusHandler status:" +  event.status + " reason: " + event.statusReason );

        _isLocked = (event.status != LicenseStatus.LICENSED);
        if (_isLocked) {
            _serviceAvailable = event.status != LicenseStatus.RETRY;
            dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_LOCKED))
        } else {
            dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_UNLOCKED))
        }

    }

    public function request():void {
        licChecker.checkLicense(appKey, LicensePolicyType.MANAGED);
    }

    public function isLocked():Boolean {
        return _isLocked;
    }

    public function isUnLocked():Boolean {
        return !isLocked();
    }

    public function marketUrl():String {
        return "http://market.android.com/details?id=" + appId;
    }

    public function isCheckServiceUnAvailable():Boolean {
        return !_serviceAvailable;
    }
}
}
