/**
 * Created by WORKSATION on 01.09.13.
 */
package {
import com.chaoslabgames.commons.fms.FiniteStateMachine;

import controls.GameHolder;

import flash.display.MovieClip;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import game.IEnveromentSpeaker;

import infrastructure.impl.EmbedByteArrayLoader;

import infrastructure.impl.EmbedImageContentResolver;

import infrastructure.impl.EmbedSoundContentReolver;
import infrastructure.impl.GameSettingsImpl;
import infrastructure.impl.NullEnvSpeaker;

import insfrastructure.Context;
import insfrastructure.IGameSettings;
import insfrastructure.content.IByteArrayDataLoader;
import insfrastructure.content.IImageContentResolver;
import insfrastructure.content.ISoundContentResolver;

import scenes.SplashScene;

import utils.DictonaryUtils;

import utils.LayoutUtils;

public class TimeLybDocument extends InitiableMovieClip {

    private var stateMachine:FiniteStateMachine;

    private var gameHolder:GameHolder;

    public function TimeLybDocument() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        var keys:Dictionary = TimeLybEmbedRefs.keys;
        Context.instance.register(IEnveromentSpeaker, newEnvSpeaker());
        Context.instance.register(ISoundContentResolver, new EmbedSoundContentReolver(keys));
        Context.instance.register(IImageContentResolver, new EmbedImageContentResolver(keys));
        Context.instance.register(IByteArrayDataLoader, new EmbedByteArrayLoader(keys));
        Context.instance.register(IGameSettings, GameSettingsImpl.newMarketSettings());

        gameHolder = new GameHolder();
        addChild(gameHolder);
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

    private function initFSM():void {
        stateMachine = new FiniteStateMachine();
        stateMachine.state("menu")
                .addActivateHandler(newSetSceneFn(SplashScene))
        stateMachine.start();
    }

    protected function handleEvent(e:*):void {
        stateMachine.handleEvent(e)
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
        LayoutUtils.doStretch(stage, gameHolder, null, new Rectangle(0, 0, 768, 1280));
    }

}

}
