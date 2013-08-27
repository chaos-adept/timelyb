/**
 * Created by WORKSATION on 10.08.13.
 */
package game.document {
import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.furusystems.dconsole2.DConsole;

import controls.GameHolder;

import flash.display.StageAlign;

import flash.display.StageScaleMode;

import flash.events.Event;
import flash.geom.Rectangle;

import game.IEnveromentSpeaker;
import game.core.BaseGame;

import infrastructure.impl.NullEnvSpeaker;

import utils.LayoutUtils;
import utils.ui.AlertCtrl;

public class MenuBasedGameEnvDocument extends InitiableMovieClip {
    protected var gameHolder:GameHolder;

    protected var leftMenu:LeftMenuCtrl;

    private var stateMachine:FiniteStateMachine;

    public var _firstGameStateName:String;

    protected static const REQUEST_GAME_PLAY:String = "request_game_play";

    public function MenuBasedGameEnvDocument() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        gameHolder = new GameHolder;
        leftMenu = new LeftMenuCtrl;

        leftMenu.addEventListener(Cnst.EVENT_TYPE_MENU, handleEvent);
        leftMenu.addEventListener(Cnst.EVENT_TYPE_HELP, showHelpHandler);
        leftMenu.addEventListener(Cnst.EVENT_TYPE_REPEAT, repeatHandler);
        leftMenu.addEventListener(Cnst.EVENT_TYPE_ABOUT, aboutHandler);
        this.addEventListener(Cnst.EVENT_TYPE_GAME_FINISHED, gameFinishedHandler);
        this.addEventListener(Cnst.EVENT_TYPE_GAME_OVER, gameOverHandler);

        leftMenu.toGameMenuState();

        addEventListener(REQUEST_GAME_PLAY, handleEvent);

        addChild(gameHolder);
        addChild(leftMenu);
        addChild(DConsole.view);
    }

    protected function aboutHandler(event:Event):void {
        AlertCtrl.ShowDefaultSmb(stage, getAboutMessage());
    }

    protected function gameOverHandler(event:Event):void {
        openMenu();
    }

    protected function gameFinishedHandler(event:Event):void {
        openMenu();
    }

    private function openMenu():void {
        leftMenu.open();
    }

    protected function repeatHandler(event:Event):void {
        var gameScene:BaseGame = gameHolder.getCurrentGame() as BaseGame;
        gameScene.resetGame();
    }

    protected function showHelpHandler(event:Event):void {
        var gameScene:BaseGame = gameHolder.getCurrentGame() as BaseGame;
        AlertCtrl.ShowDefaultSmb(stage, gameScene.getHelpMessage())
    }

    protected function newEnvSpeaker():IEnveromentSpeaker {
        return new NullEnvSpeaker();
    }

    override protected function addedToStateHandler():void {
        super.addedToStateHandler();
        this.stage.addEventListener(Event.RESIZE, stageResizeHandler);
        doLayout();

        initFSM();
    }

    protected function handleEvent(e:*):void {
        stateMachine.handleEvent(e)
    }

    protected function initFSM():void {
        stateMachine = new FiniteStateMachine();
        bindStatesToScenes();
        buildSceneSequence();
        stateMachine.start();
    }

    private function buildSceneSequence():void {
        stateMachine.state("menu")
                .addTransition(REQUEST_GAME_PLAY).toState(_firstGameStateName);
        stateMachine.state("menu")
                .addActivateHandler(newSetSceneFn(menuSceneClassRef))
                .addTransition(Cnst.EVENT_TYPE_MENU).toState("menu");
        stateMachine.state("menu")
                .addActivateHandler(leftMenu.toGameMenuState)
                .addDeactivateHandler(leftMenu.toGameState);

        leftMenu.toGameMenuState();
        stateMachine.initState = "menu";
    }

    protected function get menuSceneClassRef():Class {
        throw new Error("abstract method");
    }

    protected function bindStatesToScenes():void {
    }

    protected function bindStateToGame(stateName:String, sceneClassRef:Class):void {
        if (!_firstGameStateName) {
            _firstGameStateName = stateName;
        }

        var requestGameEvent:String = "request_game_" + stateName;
        stateMachine.state("menu").addTransition(requestGameEvent).toState(stateName);

        addEventListener(requestGameEvent, handleEvent);
        stateMachine.state(stateName).addActivateHandler(leftMenu.hide)
        stateMachine.state(stateName).addActivateHandler(newSetSceneFn(sceneClassRef))
                .addTransition(Cnst.EVENT_TYPE_MENU).toState("menu");
    }

    protected function newSetSceneFn(classRef:Class):Function {
        return function ():void {
            gameHolder.setGame(classRef);
        }
    }

    protected function stageResizeHandler(e:Event):void {
        doLayout();
    }

    protected function doLayout():void {
        leftMenu.x = 0;
        LayoutUtils.doStretch(stage, gameHolder, null, new Rectangle(204, 23, 1024, 754));
    }

    protected function getAboutMessage():* {
    }
}
}
