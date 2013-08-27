/**
 * Created by WORKSATION on 5/26/13.
 */
package utils.ui {

import events.EventUtils;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

public class ButtonCtrl extends EventDispatcher {

    protected var smb:MovieClip;

    public var selectEvent:String;

    public function ButtonCtrl(smb:MovieClip, selectEvent:String = null) {
        this.smb = smb;
        if (selectEvent == null) {
            selectEvent = Cnst.EVENT_TYPE_SELECT;
        }
        this.selectEvent = selectEvent;
        smb.stop();
        smb.addEventListener(MouseEvent.CLICK, clickHandler);
        smb.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        smb.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    private function clickHandler(event:MouseEvent):void {
        var name:String = smb.name;
        EventUtils.newCustomEvent(this, selectEvent, name);
    }

    protected function mouseDownHandler(e:Event):void {
        smb.gotoAndStop(2);
    }

    protected function mouseUpHandler(e:Event):void {
        smb.gotoAndStop(1);
    }
}

}
