/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 6/14/13
 * Time: 8:15 AM
 * To change this template use File | Settings | File Templates.
 */
package utils.content {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import insfrastructure.content.IByteArrayDataLoader;

public class UrlByteArrayDataLoader implements IByteArrayDataLoader {

    public function UrlByteArrayDataLoader() {
    }

    public function requestData(url:String, acceptResultHandler:Function):void {
        var loader:URLLoader = new URLLoader()
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
        loader.addEventListener(IOErrorEvent.IO_ERROR, loadError, false, 0, true);
        loader.load(new URLRequest(url))

        function loadComplete(event:Event):void {

            var bytes:ByteArray = ByteArray(event.target.data);
            acceptResultHandler(bytes);
        }
    }

    private function loadError(event:IOErrorEvent):void {
        trace("error", event);
    }

}
}
