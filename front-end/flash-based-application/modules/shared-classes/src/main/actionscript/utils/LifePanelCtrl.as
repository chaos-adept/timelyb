/**
 * Created by WORKSATION on 5/25/13.
 */
package utils {
import flash.display.MovieClip;

public class LifePanelCtrl {

    private var maxLifeCount:int;
    private var _lifeCount:int;

    public var avalibaleLifeSlots:int;
    public var lifeWidht:int = 47.45;

    public var isHorizontalMode:Boolean = false;

    private var smb:MovieClip

    public function LifePanelCtrl(smb:MovieClip) {
        this.smb = smb;
        var indx:Number = 1;
        avalibaleLifeSlots = 0;
        while (smb["life_"+indx]) {
            avalibaleLifeSlots++;
            indx++;
        }
        doLayOut();
    }

    public function setLifeCount(num:int):void {
        trace("setLifeCount", num);
        maxLifeCount = num;
        resetLifes();
    }

    public function removeLife():void {
        var life:MovieClip = smb["life_"+(maxLifeCount - lifeCount + 1)];
        if (!life) {
            trace("error life is not defined");
            return;
        }
        life.play();
        _lifeCount--;
        doLayOut();
    }

    public function resetLifes():void {
        _lifeCount = maxLifeCount;
        for (var indx:Number = 1; indx <= avalibaleLifeSlots; indx++) {
            var lifeMovie:MovieClip = smb["life_" + indx];
            lifeMovie.gotoAndStop(1);
            lifeMovie.visible = indx <= maxLifeCount;
        }
        doLayOut();
    }

    public function doLayOut():void {
        if (isHorizontalMode) {
            var space:int = 5;
            var panelWidth:Number = 257.05;
            var maxWidht:Number = (lifeWidht) * maxLifeCount ;
            var firstPosX:Number = (panelWidth - maxWidht) / 2;

            for (var indx:Number = 1; indx <= avalibaleLifeSlots; indx++) {
                var lifeMovie:MovieClip = smb["life_" + indx];
                lifeMovie.x = firstPosX + lifeWidht / 2;
                firstPosX += lifeWidht;
            }
        }
    }

    public function get lifeCount():int
    {
        return _lifeCount;
    }

    public function get hasLifes():Boolean {
        return _lifeCount > 0;
    }

    public function getHasLifes():Boolean {
        return hasLifes;
    }

}




}
