/**
 * Created by WORKSATION on 5/26/13.
 */
package utils.ui {
import events.EventUtils;

import flash.display.MovieClip;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

public class CheckBtnCtrl extends EventDispatcher{

    protected var smb:MovieClip;
    private var _checked:Boolean;

    private var frameResolver:FrameResolver;

    public function CheckBtnCtrl(smb:MovieClip) {
        this.smb = smb;
        this.smb.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
        this.smb.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler)
        this.smb.stop();
        if (smb.totalFrames == 4) {
            frameResolver = new FourStateResolver();
        } else {
            frameResolver = new SingleStateResolver();
        }

    }

    private function mouseDownHandler(e:Event):void {
        smb.gotoAndStop(frameResolver.getFrameForDownState(checked));
    }

    private function mouseUpHandler(e:Event):void {

        var checkEvent:DataEvent = new DataEvent(Cnst.EVENT_TYPE_SELECTING, false, true, (!checked).toString());
        dispatchEvent(checkEvent);
        if (checkEvent.isDefaultPrevented()) {
            updateView();
            return;
        }

        checked = !checked;

        dispatchEvent(new DataEvent(Cnst.EVENT_TYPE_SELECTING_COMPLETED, false, false, checked.toString()))
    }

    public function get checked():Boolean
    {
        return _checked;
    }

    public function set checked(value:Boolean):void {
        if (_checked == value) {
            return;
        }

        _checked = value;
        updateView();
        EventUtils.newCustomEvent(this, Cnst.EVENT_TYPE_SELECT, this.smb.name);
    }

    private function updateView():void {
        smb.gotoAndStop(frameResolver.getFrameForWaitState(checked));
    }

}
}

interface FrameResolver {
    function getFrameForDownState(checked:Boolean):int;
    function getFrameForWaitState(checked:Boolean):int;
}

class FourStateResolver implements FrameResolver {

    public function getFrameForDownState(checked:Boolean):int {
        return checked ? 4 : 2;
    }

    public function getFrameForWaitState(checked:Boolean):int {
        return checked ? 3 : 1;
    }
}

class SingleStateResolver implements FrameResolver {

    public function getFrameForDownState(checked:Boolean):int {
        return 0;
    }

    public function getFrameForWaitState(checked:Boolean):int {
        return 0;
    }
}
