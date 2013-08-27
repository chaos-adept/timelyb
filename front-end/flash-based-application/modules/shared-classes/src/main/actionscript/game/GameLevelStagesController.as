/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 06.12.12
 * Time: 9:28
 * To change this template use File | Settings | File Templates.
 */
package game {
import events.EventUtils;

import flash.display.MovieClip;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.MouseEvent;

import org.as3commons.collections.Map;

import utils.MathUtils;
import utils.SoundManager;

public class GameLevelStagesController implements IEnveromentSpeaker {

    private var trainNavigator:TrainNavigator;
    private var vagonIcons:Vector.<VagonIconController>;
    public static var instance:GameLevelStagesController;

    public var levelSequence:Vector.<String>;

    private var passedGamesInfo:GamePassedInformationStore;

	private var _envSpeaker:IEnveromentSpeaker;
	
    public function GameLevelStagesController(trainNavigator:TrainNavigator, levelSequence:Vector.<String>, envSpeaker:IEnveromentSpeaker) {
        this.trainNavigator = trainNavigator;
        vagonIcons = new <VagonIconController>[];
        this.trainNavigator.addEventListener(Event.ADDED_TO_STAGE, addedTrainToStageHandler);
        this.levelSequence = levelSequence;

        instance = this;
        LevelManager.instance.addEventListener(Cnst.EVENT_TYPE_MODE_UPDATED, modeUpdatedHandler);
        passedGamesInfo = new GamePassedInformationStore();
		_envSpeaker = envSpeaker; 
    }

    private function modeUpdatedHandler(...args):void {
        var lastCompletedSeqKey:String = null;
        var indx:int = 0;
        for each (var vagonIconCtrl:VagonIconController in vagonIcons) {
            vagonIconCtrl.enable = passedGamesInfo.isCompleted(vagonIconCtrl.key, LevelManager.instance.isAdvanced);//vagonIconCtrl.index < 1;
            if (vagonIconCtrl.enable) {
                indx++;
            }
        }
        if ((indx > 0)&&(indx < vagonIcons.length)) {
            trainNavigator.trainControl.moveToPosition(Cnst.TRAIN_POSITION_SEQUENCE[indx], true);
        } else {
            trainNavigator.trainControl.moveToPosition(Cnst.TRAIN_POSITION_0, true);
        }

    }

    private function addedTrainToStageHandler(event:Event):void {
        this.trainNavigator.nextGameBtn.addEventListener(MouseEvent.CLICK, nextGameRequestHandler);

        var lokomotiv:MovieClip = this.trainNavigator.trainControl.train["pos_0"];
        lokomotiv.addEventListener(MouseEvent.CLICK, lokomotivClickHandler);

        //init vagons
        vagonIcons = new <VagonIconController>[];
        for (var indx:int = 0; indx < wagonCount; indx++) {
            var ctrl:VagonIconController = new VagonIconController(extractVagonIconByIndx(indx));
            ctrl.requestChangePosition = requestChangePosition;
            var hitAreaNum:int = indx+1;
            var hitArea:MovieClip = this.trainNavigator.trainControl.train["pos_"+hitAreaNum];
            ctrl.key = this.levelSequence[indx+1];
            hitArea.addEventListener(MouseEvent.CLICK, ctrl.clickHandler); //TODO move to vagon icon ctrl

            vagonIcons.push(ctrl);
        }

        for each (var vagonIconCtrl:VagonIconController in vagonIcons) {
            vagonIconCtrl.loadIcons();
            vagonIconCtrl.enable = false;//vagonIconCtrl.index < 1;
        }
    }

    private function get wagonCount():int {
        return trainNavigator.trainControl.train.wagonCount;
    }

    private function nextGameRequestHandler(event:MouseEvent):void {
        EventUtils.newCustomEvent(trainNavigator, Cnst.EVENT_TYPE_NEXT_GAME, null);
    }

    private function lokomotivClickHandler(event:MouseEvent):void {
        requestChangePosition(levelSequence[0]);
    }

    protected function extractVagonIconByIndx(indx:int):MovieClip {
        var icon:MovieClip = this.trainNavigator.trainControl.train["ic"+indx];
        return icon;
    }

    protected function requestChangePosition(positionKey:String):void {
        this.trainNavigator.dispatchEvent(new DataEvent(
                ZagadkiConstants.EVENT_TYPE_CHANGE_NAV_POSITION, true, true, positionKey));
    }

    public function enableLayer(key:String):void {
        var indx:int = this.levelSequence.indexOf(key);
        if (indx > 0) {
            vagonIcons[levelIndxToVagonIndx(indx)].enable = true;
            passedGamesInfo.markAsPassed(key, LevelManager.instance.isAdvanced);
        }
    }

    private function levelIndxToVagonIndx(indx:int):int {
        return indx-1;
    }

    public function enableCurrentLevel(currentGameLevel:String):void {
        //var indx:int = getNextLevelIndx(currentGameLevel);
        //enableLayer(levelSequence[indx]);
        enableLayer(currentGameLevel);
    }

    private function getNextLevelIndx(currentGameLevel:String):int {
        var indx:int = this.levelSequence.indexOf(currentGameLevel);
        if (indx == -1) {
            throw new Error("Game layer is not found by " + currentGameLevel);
        }

        if (indx == levelSequence.length-1) {
            return 0; //do nothing because 0 level is enabled by convention
        } else {
            return indx+1;
        }
    }

    public function updateCurrentLevel(currentLevelKey:String):void {
        var indx:int = levelSequence.indexOf(currentLevelKey);
        this.trainNavigator.trainControl.moveToPosition(Cnst.TRAIN_POSITION_SEQUENCE[indx]);
    }

    public function nextLevel(currentLevelKey:String):void {
        var indx:int = getNextLevelIndx(currentLevelKey);
        vagonIcons[levelIndxToVagonIndx(indx)].activationRequest();
    }

    public function enableLayerTo(levelKey:String):void {
        var levelIndx:int = levelSequence.indexOf(levelKey);
        for (var enableIndx:int = 0; enableIndx <= levelIndx; enableIndx++) {
            enableLayer(levelSequence[enableIndx]);
        }
    }

    public function showNextGameBtn():void {
        trainNavigator.nextGameBtn.visible = true;
    }

    public function hideNextGameBtn():void {
        trainNavigator.nextGameBtn.visible = false;
    }

    //todo extract to another class
    public function lastGameExitHandler():void {
        showNextGameBtn();
    }

    //todo extract to another class
    public function lastGameEnterHandler():void {
        hideNextGameBtn();
    }

    public function newGameFinishedHandler():Function {
        return function ():void {
            SoundManager.play("all_final_3a_varya");
        }
    }

    public function newSilentEnableCurrentLevelHandler(gameState:String):Function {
        return newEnableCurrentLevelHandler(gameState, false);
    }

    public function newNextGameHandler(currentGameKey:String):Function {
        return function ():void {
            nextLevel(currentGameKey);
        }
    }

    public function newEnableCurrentLevelHandler(gameState:String, playSound:Boolean = true):Function {
        return function ():void {
            if (playSound) {
				congratulations();                
            }
            enableCurrentLevel(gameState);
        }
		
	}

    public function listGameLevels():String {
        return levelSequence.join();
    }

    public function menuStageEnterHandler():void {
        hideNextGameBtn();
    }

    public function menuStageExitHandler():void {
        showNextGameBtn();
    }
	
	
	public function congratulations():void {
		_envSpeaker.congratulations();		
	}

	public function newSetBukaSpeakerStereotypeFn():Function { return _envSpeaker.newSetBukaSpeakerStereotypeFn() }
	public function newSetWaryaSpeakerStereotypeFn():Function { return _envSpeaker.newSetWaryaSpeakerStereotypeFn() }		
	public function isNextGameSound(soundKey:String):Boolean { return _envSpeaker.isNextGameSound(soundKey) }
	
}
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.utils.Dictionary;


class VagonIconController {

    public var icon:MovieClip;

    private var enableIcon:Bitmap;
    private var disableIcon:Bitmap;
    private var _enable:Boolean;
    public var key:String;
    public var requestChangePosition:Function;

    public function VagonIconController(icon:MovieClip) {
        this.icon = icon;
    }

    public function clickHandler(event:MouseEvent = null):void {
        trace("clickHandler", event);
        //if (this.enable) {
            this.requestChangePosition(this.key);
        //}
    }

    public function loadIcons():void {

        loadIcon(false);
        loadIcon(true);

        function loadIcon(forEnable:Boolean):void {
            var i:Loader = new Loader();
            i.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
            i.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errHandler);
            var indx:String = index.toString();
            var urlPath:String = forEnable ? "/icons/train/train_icon_" + indx + ".png" :
                             "/icons/train/train_icon_" + indx + "_mn.png";
            var url:URLRequest = new URLRequest(urlPath);
            i.load(url);

            function loadComplete( event:Event = null ):void
            {
                var image:Bitmap = Bitmap(event.target.content);
                //image.alpha = 0;
                image.smoothing = true;
                if (forEnable) {
                    enableIcon = image;
                } else {
                    disableIcon = image;
                }

                icon.addChild(image);

                updateEnableState();
            }
        }

    }

    public function get index():Number {
        return parseInt(icon.name.substr(2));
    }



    private function updateEnableState():void {
        if (enableIcon) {
            enableIcon.visible = _enable;
        }

        if (disableIcon) {
            disableIcon.visible = !_enable;
        }
    }

    private function errHandler(ioError:IOErrorEvent):void {
        trace("loading error: ", ioError);
    }

    public function get enable():Boolean {
        return _enable;
    }

    public function set enable(value:Boolean):void {
        _enable = value;
        updateEnableState();
    }

    public function activationRequest():void {
        clickHandler();
    }
}


class GamePassedInformationStore {

    private var dictAdvanced:Dictionary = new Dictionary();
    private var dictSimple:Dictionary = new Dictionary();

    public function isCompleted(gameStageName:String, isAdvance:Boolean):Boolean {
        if (isAdvance) {
            return dictAdvanced[gameStageName];
        } else {
            return dictSimple[gameStageName];
        }
    }

    public function markAsPassed(gameStageName:String, isAdvance:Boolean):void {
        if (isAdvance) {
            dictAdvanced[gameStageName] = true;
        } else {
            dictSimple[gameStageName] = true;
        }
    }
}
