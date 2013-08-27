/**
 * Created by WORKSATION on 5/26/13.
 */
package utils.ui {
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.engine.FontLookup;

import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;

public class AlertCtrl {
    protected var smb:MovieClip;
    public function AlertCtrl(stage:Stage, smb:MovieClip, text:String) {
        this.smb = smb;
        //smb.mesageTxt.text = TextConverter.importToFlow text;
        if (text.indexOf("TextFlow") != -1) {
            var flow:TextFlow = TextConverter.importToFlow(new XML(text), TextConverter.TEXT_LAYOUT_FORMAT);
            var tf:Object = smb.mesageTxt;
//            tf.embedFonts = true;
            //tf.fontLookup = FontLookup.EMBEDDED_CFF;
            tf.textFlow = flow;
        } else {
            smb.mesageTxt.text = text;
        }

        smb.x = stage.stageWidth / 2 - smb.width / 2;
        smb.y = stage.stageHeight / 2 - smb.height / 2;
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        stage.addChild(smb);
    }

    private function mouseUpHandler(event:MouseEvent):void {
        smb.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        smb.stage.removeChild(smb);
    }

    public static function Show(stage:Stage, alertSmbClass:Class, text:String):AlertCtrl {
        //var smb:KalendarAlert = new KalendarAlert();

        var ctrl:AlertCtrl = new AlertCtrl(stage, new alertSmbClass, text);

        return ctrl;
    }

    public static function ShowDefaultSmb(stage:Stage, text:String):AlertCtrl {
        return Show(stage, KinderGardenAlert, text);
    }
}
}
