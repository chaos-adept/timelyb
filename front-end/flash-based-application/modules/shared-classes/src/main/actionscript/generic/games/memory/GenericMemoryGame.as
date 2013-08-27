/**
 * author: chaos-encoder
 * Date: 23.10.12 Time: 21:33
 */
package generic.games.memory {
import com.furusystems.dconsole2.DConsole;

import events.EventUtils;

import flash.display.MovieClip;
import flash.events.DataEvent;
import flash.events.Event;

import fms.FSM;

import game.core.BaseGame;

import org.as3commons.collections.Map;
import org.as3commons.lang.StringUtils;

import utils.ArrayUtils;
import utils.MathUtils;
import utils.SoundManager;

public class GenericMemoryGame extends BaseGame {
    private const STATE_START_GAME:String = "stateStartGame";

    private const STATE_SELECT_PAIR:String = "stateSelectPair";

    private const STATE_SELECT_SECOND_BALL:String = "stateSelctSecondBall";

    private const STATE_CHECK_PAIR_SELECTION:String = "stateCheckPairSelection";

    private const STATE_WAIT_BALL_OPENNIG:String = "stateWaitBallOpenning";

    private var itemsMap:Map;

    private var closedPairsMap:Map;

    private var _stateMachine:FSM;

    private var firstSelectedItemCtrl:IMemoryItemCtrl;

    private var secondItemCtrl:IMemoryItemCtrl;

    private var speaker:ISpeaker;

    private var halfBallCount:int;

    private static const EVENT_TYPE_ALL_PAIRS_FOUNDED:String = "eventTypeAllPairsFounded";

    private static const EVENT_TYPE_WRONG_PAIR:String = "wrongPair";

    private static const EVENT_TYPE_CORRECT_PAIR:String = "correctPairFounded";

    private static const STATE_GAME_FINISHED:String = "stateGameFinished";

    private static const STATE_CORRECT_PAIR:String = "stateCorrectPair";

    private static const STATE_CHECK_GAME_FINISHED:String = "stateCheckGameFinished";

    private static const EVENT_TYPE_GAME_NOT_COMPLETED:String = "stateGameNotCompleted";

    private static const STATE_WRONG_ANSWER:String = "stateWrongAnswer";

    private static var interestingEvents:Array =
            [   EVENT_TYPE_ALL_PAIRS_FOUNDED,
                EVENT_TYPE_WRONG_PAIR,
                EVENT_TYPE_CORRECT_PAIR,
                EVENT_TYPE_ALL_PAIRS_FOUNDED,
                EVENT_TYPE_GAME_NOT_COMPLETED,
                Cnst.EVENT_SOUND_COMPLETE,
                Cnst.EVENT_TYPE_ANIMCOMPLETED,
                Cnst.EVENT_TYPE_SELECT];

    private const STATE_INTRO:String = "stateIntro";

    private var _introSoundKeys:Vector.<String>;

    private var introConversationIndx:uint;

    private var _waitSecondItemSoundCompleted:Boolean;

    public function GenericMemoryGame() {
		super();
        var movie:MovieClip = new GameLayoutSmbClass();
        initScene(movie);
        this.addChild(movie);
    }

    protected function get introConversationSequence():Vector.<String> {
        throw new Error("not implemnted")
    }

    protected function get GameLayoutSmbClass():Class {
        throw new Error("not implemnted")
    }

    protected function initScene(movie:MovieClip):void {
        itemsMap = new Map();
        for (var itemIndx:int = 0; true; itemIndx++) {
            var item:IMemoryItemCtrl = extractMemoryItemCtrlByIndx(movie, itemIndx);
            if (item == null) {
                break;
            }

            itemsMap.add(item.name, item);
            item.wait();
        }
        halfBallCount = itemsMap.size / 2;
        speaker = newSpeackerCharacterController(movie);
    }

    protected function newSpeackerCharacterController(gameLayoutMovie:MovieClip):ISpeaker {
        throw new Error("not implemented")
    }

    protected function extractMemoryItemCtrlByIndx(movie:MovieClip, ballIndx:int):IMemoryItemCtrl {
        throw new Error("not implemented");
    }

    private function openPairs(count:int):void {
        var opened:int = 0;
        for each (var pair:Pair in closedPairsMap.toArray()) {
            firstSelectedItemCtrl = pair.balls[0];
            secondItemCtrl = pair.balls[1];
            firstSelectedItemCtrl.open();
            secondItemCtrl.open();
            closedPairsMap.remove(pair);
            opened++;
            if (opened == count) {
                break;
            }
        }
    }

    private function changeState(nextState:String):void {
        _stateMachine.changeState(nextState);
    }

    override protected function addedToStateHandler():void {
        super.addedToStateHandler();

        DConsole.createCommand("setState", changeState);
        DConsole.createCommand("openPairs", openPairs);

        initFMS();
        for each (var eventType:String in interestingEvents) {
            addEventListener(eventType, handleEvent);
        }
        SoundManager.instance.addAllEventListener(handleEvent);
    }

    override protected function removeFromStageHandler(e:Event):void {
        super.removeFromStageHandler(e);

        DConsole.removeCommand("setState");
        DConsole.removeCommand("openPairs");

        _stateMachine.dispose();

        for each (var eventType:String in interestingEvents) {
            removeEventListener(eventType, handleEvent);
        }
        SoundManager.instance.removeAllEventListener(handleEvent);
    }

    private function handleEvent(e:DataEvent):void {
        _stateMachine.handleEvent(e);
    }

    private function initFMS():void {
        _stateMachine = new FSM("memoryGame");
        _stateMachine.registerState(STATE_START_GAME, startGameStateHandler)
                .addTransition(Cnst.EVENT_TYPE_ENTER_STATE, STATE_INTRO);

        _stateMachine.registerState(STATE_INTRO, intro)
                .addForwardEventTransition(Cnst.EVENT_TYPE_SELECT, STATE_SELECT_PAIR)
                .addHandler(Cnst.EVENT_SOUND_COMPLETE, nextIntroSound)
                .addDlgConditTransition(Cnst.EVENT_SOUND_COMPLETE, isIntroFinished, STATE_SELECT_PAIR);

        _stateMachine.registerState(STATE_SELECT_PAIR, selectPair)
                .addDlgConditHandler(Cnst.EVENT_SOUND_STARTED, isFirstItemSoundKey, speaker.startArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_COMPLETE, isFirstItemSoundKey, speaker.stopArticulation)
                .addHandler(Cnst.EVENT_TYPE_SELECT, selectFirstBallHandler)
                .addTransition(Cnst.EVENT_TYPE_SELECT, STATE_SELECT_SECOND_BALL);

        _stateMachine.registerState(STATE_SELECT_SECOND_BALL, enterSelectSecondBallState)
                .setExitStateHandler(speaker.stopArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_STARTED, isFirstOrSecondSoundKey, speaker.startArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_COMPLETE, isFirstOrSecondSoundKey, speaker.stopArticulation)
                .addDlgConditHandler(Cnst.EVENT_TYPE_SELECT, isNotFirstSelectedBall, selectSecondBallHandler)
                .addDlgConditTransition(Cnst.EVENT_TYPE_SELECT, isNotFirstSelectedBall, STATE_WAIT_BALL_OPENNIG);

        _stateMachine.registerState(STATE_WAIT_BALL_OPENNIG, waitBallOpened)
                //.addHandler(Cnst.EVENT_SOUND_STARTED, speaker.startArticulation)
                .addHandler(Cnst.EVENT_SOUND_COMPLETE, speaker.stopArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_COMPLETE, isSecondItemSoundKey, markAsSecondBallSoundCompleted)
                .addHandler(Cnst.EVENT_TYPE_ANIMCOMPLETED, isAllBallOpened)
                .addHandler(Cnst.EVENT_SOUND_COMPLETE, isAllBallOpened);

        _stateMachine.registerState(STATE_CHECK_PAIR_SELECTION, checkPairEnterStateHandler)
                .addTransition(EVENT_TYPE_CORRECT_PAIR, STATE_CORRECT_PAIR)
                .addTransition(EVENT_TYPE_WRONG_PAIR, STATE_WRONG_ANSWER);

        _stateMachine.registerState(STATE_WRONG_ANSWER, wrongAnswer);

        _stateMachine.registerState(STATE_CORRECT_PAIR, correctPairEnterStateHandler)

        _stateMachine.registerState(STATE_CHECK_GAME_FINISHED, checkGameFinishedState)
                .addTransition(EVENT_TYPE_ALL_PAIRS_FOUNDED, STATE_GAME_FINISHED)
                .addTransition(EVENT_TYPE_GAME_NOT_COMPLETED, STATE_SELECT_PAIR);

        _stateMachine.registerState(STATE_GAME_FINISHED, gameFinishedHandler)
                .addDlgConditHandler(Cnst.EVENT_SOUND_STARTED, isGameFinishedSoundKey, speaker.startArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_COMPLETE, isGameFinishedSoundKey, speaker.stopArticulation)
                .addDlgConditHandler(Cnst.EVENT_SOUND_COMPLETE, isGameFinishedSoundKey, notifContainerGameFinished);
        _stateMachine.changeState(STATE_START_GAME);
    }


    override public function resetGame():void {
        super.resetGame();
        _stateMachine.changeState(STATE_START_GAME);
    }

    private function markAsSecondBallSoundCompleted():void {
        _waitSecondItemSoundCompleted = false;
    }

    private function waitBallOpened():void {
        _waitSecondItemSoundCompleted = hintItemNameByGameLevel(secondItemCtrl);
        isAllBallOpened();
    }

    private function enterSelectSecondBallState():void {
        _waitSecondItemSoundCompleted = false;
        hintItemNameByGameLevel(firstSelectedItemCtrl);
    }

    private function selectPair():void {
        firstSelectedItemCtrl = null;
        secondItemCtrl = null;
    }

    private function isFirstItemSoundKey(soundKey:String):Boolean {
        if (firstSelectedItemCtrl == null) {
            return false;
        }
        return getItemDataByKey(firstSelectedItemCtrl.key).gameMemorySoundKey == soundKey;
    }

    private function isSecondItemSoundKey(soundKey:String):Boolean {
        if (secondItemCtrl == null) {
            return false;
        }
        return getItemDataByKey(secondItemCtrl.key).gameMemorySoundKey == soundKey;
    }

    private function isFirstOrSecondSoundKey(soundKey:String):Boolean {
        return isFirstItemSoundKey(soundKey) || isSecondItemSoundKey(soundKey);
    }

    private function wrongAnswer():void {
        SoundManager.play("memory_no");
        changeState(STATE_CHECK_GAME_FINISHED);
    }

    private function isIntroFinished():Boolean {
        return introConversationIndx >= introConversationSequence.length;
    }

    private function intro():void {
        _introSoundKeys = (introConversationSequence);
        introConversationIndx = 0;
        speaker.startArticulation();
        nextIntroSound(null);
    }

    private function nextIntroSound(e:DataEvent):void {
        if ((e != null) && (introConversationSequence.indexOf(e.data) == -1)) {
            return;
        }
        if (e != null) {
            introConversationIndx++;
        }

        if (!isIntroFinished()) {
            SoundManager.play(_introSoundKeys[introConversationIndx]);
        } else {
            speaker.stopArticulation();
        }
    }

    private function notifContainerGameFinished():void {
        EventUtils.newGameFinishedEvent(this);
    }

    private function checkGameFinishedState():void {
        if (closedPairsMap.size == 0) {
            EventUtils.newCustomEvent(this, EVENT_TYPE_ALL_PAIRS_FOUNDED, null);
        } else {
            EventUtils.newCustomEvent(this, EVENT_TYPE_GAME_NOT_COMPLETED, null);
        }
    }

    private function isCurrentPairNameSoundKey(soundKey:String):Boolean {
        return getItemDataByKey(firstSelectedItemCtrl.key).gameMemorySoundKey == soundKey;
    }

    private function correctPairEnterStateHandler():void {
        SoundManager.play("memory_yes");
        changeState(STATE_CHECK_GAME_FINISHED);
    }

    protected function getItemDataByKey(key:String):IMemoryGameItemData {
        throw new Error("not implemented");
    }

    private function gameFinishedHandler():void {
        //_stateMachine.changeState(STATE_START_GAME);
        speaker.startArticulation();
        SoundManager.play(genGameFinishedSoundKey(), false);
    }

    protected function genGameFinishedSoundKey():String {
        return "music_01_yes_0" + MathUtils.randRange(1, 2);
    }

    protected function isGameFinishedSoundKey(soundKey:String):Boolean {
        return StringUtils.startsWith(soundKey, "music_01_yes_");
    }

    private function isNotFirstSelectedBall(movieName:String):Boolean {
        return firstSelectedItemCtrl != getItemCtrlByMovieName(movieName);
    }

    private function isAllBallOpened(...args):Boolean {
        var result:Boolean = !_waitSecondItemSoundCompleted && firstSelectedItemCtrl.isOpenned() && secondItemCtrl.isOpenned();
        if (result) {
            changeState(STATE_CHECK_PAIR_SELECTION);
        }
        return result;
    }

    private function checkPairEnterStateHandler():void {
        if (firstSelectedItemCtrl.key == secondItemCtrl.key) {
            this.closedPairsMap.removeKey(firstSelectedItemCtrl.key);

            firstSelectedItemCtrl.mouseEnabled = false;
            firstSelectedItemCtrl.mouseChildren = false;
            secondItemCtrl.mouseEnabled = false;
            secondItemCtrl.mouseChildren = false;

            EventUtils.newCustomEvent(this, EVENT_TYPE_CORRECT_PAIR, null);

        } else {
            firstSelectedItemCtrl.wait();
            secondItemCtrl.wait();
            EventUtils.newCustomEvent(this, EVENT_TYPE_WRONG_PAIR, null);
        }
    }

    private function selectSecondBallHandler(e:DataEvent):void {
        var ball:IMemoryItemCtrl = getItemCtrlByMovieName(e.data);
        secondItemCtrl = ball;
        ball.open();

    }

    private function selectFirstBallHandler(e:DataEvent):void {
        if (firstSelectedItemCtrl != null) {
            return;
        }
        var ball:IMemoryItemCtrl = getItemCtrlByMovieName(e.data);
        firstSelectedItemCtrl = ball;
        ball.open();

    }

    private function hintItemNameByGameLevel(item:IMemoryItemCtrl):Boolean {
        var itemData:IMemoryGameItemData = getItemDataByKey(item.key);
        var result:Boolean = false;
        if (isItemSoundKeyShouldByPlayed(item)) {
            speaker.startArticulation();
            SoundManager.play(itemData.gameMemorySoundKey);
            result = true;
        }

        return result;
    }

    protected function isItemSoundKeyShouldByPlayed(item:IMemoryItemCtrl) {
        return (isSimpleLevel) || (isAdvancedLevel && item.isTextMode);
    }

    protected function get isSimpleLevel():Boolean {
        return LevelManager.instance.isSimple;
    }

    protected function get isAdvancedLevel():Boolean {
        return !isSimpleLevel;
    }

    private function getItemCtrlByMovieName(movieName:String):IMemoryItemCtrl {
        return itemsMap.itemFor(movieName);
    }

    private function startGameStateHandler():void {
        closedPairsMap = new Map();

        var allItems:Array = getAllDataItems();

        allItems.sort(ArrayUtils.randomizeArrayHandler);
        allItems.splice(halfBallCount - 1, allItems.length - halfBallCount);
        allItems = allItems.concat(allItems); //make pairs
        allItems.sort(ArrayUtils.randomizeArrayHandler); // randomize

        var indx:int = 0;
        var itemCtrlArray:Array = itemsMap.toArray();
        itemCtrlArray.sort(ArrayUtils.randomizeArrayHandler);
        for each (var itemCtrl:IMemoryItemCtrl in itemCtrlArray) {
            var item:IMemoryGameItemData = allItems[indx];
            bindData(itemCtrl, item);
            indx++;
            //itemCtrl.open();
        }


    }

    protected function bindData(itemCtrl:IMemoryItemCtrl, item:IMemoryGameItemData):void {
        itemCtrl.key = item.key;
        itemCtrl.mouseEnabled = true;
        itemCtrl.isTextMode = false;

        itemCtrl.wait();

        var pair:Pair = closedPairsMap.itemFor(item.key);
        if (pair == null) {
            pair = new Pair();
            closedPairsMap.add(item.key, pair);
            pair.balls = [itemCtrl];
        } else {
            itemCtrl.isTextMode = isAdvancedLevel;
            pair.balls.push(itemCtrl);
        }

    }

    protected function getAllDataItems():Array {
        throw new Error("not implemented")
    }
}
}
