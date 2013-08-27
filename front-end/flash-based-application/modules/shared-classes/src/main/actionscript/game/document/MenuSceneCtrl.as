/**
 * Created by WORKSATION on 11.08.13.
 */
package game.document {
import flash.display.MovieClip;
import flash.events.DataEvent;
import flash.events.Event;

import utils.ui.ButtonCtrl;

import utils.ui.CheckBtnCtrl;

public class MenuSceneCtrl {

    private var container:MovieClip;

    private var easyCtrl:CheckBtnCtrl;
    private var hardCtrl:CheckBtnCtrl;

    private var zastavkaAnimationSmb:MovieClip;

    public static var isOneGameMode:Boolean = false;

    public function MenuSceneCtrl(container:MovieClip, zastavkaClass:Class)
    {
        super();

        this.container = container;

        zastavkaAnimationSmb = new zastavkaClass();
        easyCtrl = new CheckBtnCtrl(zastavkaAnimationSmb.easyLevelBtn);
        hardCtrl = new CheckBtnCtrl(zastavkaAnimationSmb.hardLevelBtn);

        easyCtrl.checked = !LevelManager.instance.isAdvanced;
        hardCtrl.checked = LevelManager.instance.isAdvanced;

        easyCtrl.addEventListener(Cnst.EVENT_TYPE_SELECT, updateLevelValueHandler);
        hardCtrl.addEventListener(Cnst.EVENT_TYPE_SELECT, updateLevelValueHandler);

        easyCtrl.addEventListener(Cnst.EVENT_TYPE_SELECTING, selectingLevelValueHandler);
        hardCtrl.addEventListener(Cnst.EVENT_TYPE_SELECTING, selectingLevelValueHandler);

        var playScene:ButtonCtrl = new ButtonCtrl(zastavkaAnimationSmb.playSceneBtn);
        playScene.addEventListener(Cnst.EVENT_TYPE_SELECT, playSceneHandler);

        if (isOneGameMode)
            zastavkaAnimationSmb.navigationPanel.gotoAndStop(2);

        container.addChild(zastavkaAnimationSmb)
    }

    private function playSceneHandler(...args):void {
        zastavkaAnimationSmb.gotoAndPlay(2);
    }
    /*
     public static function enableMenuBtn(name:String):void {
     var indx:int = gameBtns.indexOf(name);
     gameBtns.splice(indx);
     }*/

    private function selectingLevelValueHandler(event:DataEvent):void {
        var target:CheckBtnCtrl = event.target as CheckBtnCtrl;
        var newValue:Boolean = event.data == "true";
        if ((target.checked)&&(target.checked != newValue)) {
            event.preventDefault();
        }
    }

    private function updateLevelValueHandler(event:Event):void {
        if (event.target == easyCtrl ) {
            hardCtrl.checked = !easyCtrl.checked
        } else {
            easyCtrl.checked = !hardCtrl.checked
        }
        LevelManager.instance.isAdvanced = hardCtrl.checked;
    }
}
}
