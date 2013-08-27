/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 3/13/13
 * Time: 6:58 AM
 * To change this template use File | Settings | File Templates.
 */
package game.license {

import flash.events.DataEvent;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class LicenseManager extends EventDispatcher{

    private static var _instance:LicenseManager;

    private var _licenseCheckHandler:LicenseCheckHandler;

    public function LicenseManager() {
        licenseCheckHandler = new NullLicenseChecker();
    }

    public static function get instance():LicenseManager {
        if (!_instance) {
            _instance = new LicenseManager();
        }

        return _instance;
    }

    public static function isUnLocked():Boolean {
        return instance.licenseCheckHandler.isUnLocked();
    }

    public static function isLocked():Boolean {
        return instance.licenseCheckHandler.isLocked();
    }

    public static function isCheckServiceUnAvailable():Boolean {
        return instance.licenseCheckHandler.isCheckServiceUnAvailable();
    }

    public static function navigateToMarket():void {
        var url:String = instance.licenseCheckHandler.marketUrl(); //"http://market.android.com/details?id="; //todo fixme
        var request:URLRequest = new URLRequest(url);
        try {
            navigateToURL(request, '_blank');
        } catch (e:Error) {
            trace(e.toString());
        }
    }

    public function get licenseCheckHandler():LicenseCheckHandler {
        return _licenseCheckHandler;
    }

    public function set licenseCheckHandler(value:LicenseCheckHandler):void {
        if (_licenseCheckHandler) {
            //todo remove event
            _licenseCheckHandler.removeEventListener(Cnst.EVENT_APP_IS_LOCKED, statusHandler);
            _licenseCheckHandler.removeEventListener(Cnst.EVENT_APP_IS_UNLOCKED, statusHandler);
        }

        _licenseCheckHandler = value;
        _licenseCheckHandler.addEventListener(Cnst.EVENT_APP_IS_LOCKED, statusHandler);
        _licenseCheckHandler.addEventListener(Cnst.EVENT_APP_IS_UNLOCKED, statusHandler);
        licenseCheckHandler.request();
    }

    private function statusHandler(event:DataEvent):void {
        this.dispatchEvent(event);
    }


    public static function request():void {
        instance.licenseCheckHandler.request();
    }

    public static function isCheckServiceAvailable():Boolean {
        return !isCheckServiceUnAvailable();
    }
}
}
