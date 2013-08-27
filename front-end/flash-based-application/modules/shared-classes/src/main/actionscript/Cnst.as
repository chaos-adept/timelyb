/**
 * author: chaos-encoder
 * Date: 23.09.12 Time: 10:36
 */
package {
public class Cnst {
    public static const SCREEN_WIDTH:int = 1280;
    public static const SCREEN_HEIGHT:int = 800;

    public static const EVENT_SOUND_STARTED:String = "звукНачался";
    public static const EVENT_SOUND_COMPLETE:String = "звукЗавершен";
    public static const FOLDER_SOUNDS:String = "sounds/";
    public static const EVENT_TYPE_SELECT:String = "выбран";
    public static const EVENT_TYPE_SELECTING:String = "выбирается";
    public static const EVENT_TYPE_REQUECT_CHECK_TASK:String = "EVENT_TYPE_REQUECT_CHECK_TASK";

    public static const EVENT_TYPE_ANIMCOMPLETED:String = "анимацияЗавершена";
    static public const EVENT_TYPE_ANIM_STARTED:String = "анимацияНачалась";
    static public const EVENT_TYPE_BEGIN_GAMES:String = "beginGames";
    static public const EVENT_TYPE_NEXT_GAME:String = "nextGame";
	static public const EVENT_TYPE_PREV_GAME:String = "prevGame"
    public static const EVENT_TYPE_GAME_FINISHED:String = "eventTypeGameFinished";
    public static const EVENT_TYPE_GAME_OVER:String = "eventTypeGameOver";
    public static const EVENT_TYPE_PLAY_AGAIN:String = "eventTypePlayAgain";

    public static const TRAIN_POSITION_0:String = "pos_0";
    public static const TRAIN_POSITION_1:String = "pos_1";
    public static const TRAIN_POSITION_2:String = "pos_2";
    public static const TRAIN_POSITION_3:String = "pos_3";
    public static const TRAIN_POSITION_4:String = "pos_4";
    public static const TRAIN_POSITION_5:String = "pos_5";
    public static const TRAIN_POSITION_6:String = "pos_6";

    public static const TRAIN_POSITION_SEQUENCE:Vector.<String> = new <String>[
        TRAIN_POSITION_0,
        TRAIN_POSITION_1,
        TRAIN_POSITION_2,
        TRAIN_POSITION_3,
        TRAIN_POSITION_4,
        TRAIN_POSITION_5,
        TRAIN_POSITION_6
    ];

    public static const SOUND_KEY_NO:String = "BadRes";
    public static const SOUND_KEY_YES:String = "yes01";

    public static const EVENT_TYPE_REPEAT_TASK:String = "повторитьЗадание";
    public static const EVENT_TYPE_SKIP_REQUEST:String = "пропустить";
    public static const EVENT_TYPE_ENTER_STATE:String = "enterState";
    public static const EVENT_TYPE_MODE_UPDATED:String = "modeUpdated";
    public static const STATE_NEXT_GAME_REQUEST:String = "stateNextGame";
    public static const EVENT_ACTIVITY_RESUMED:String = "activityResumed";
    public static const EVENT_ACTIVITY_SUSPENDED:String = "activySuspended";
    public static const EVENT_TYPE_SHOW_ABOUT:String = "showAbout";
    public static const EVENT_APP_IS_LOCKED:String = "appLocked";
    public static const EVENT_APP_IS_UNLOCKED:String = "appUnLocked";
    public static const EVENT_ACTIVITY_EXIT_REQUEST:String = "activityExitRequest";


    public static var EVENT_TYPE_REPEAT:String = "EVENT_TYPE_REPEAT";
    public static var EVENT_TYPE_MENU:String = "EVENT_MENU";
    public static var EVENT_TYPE_HELP:String = "EVENT_TYPE_HELP";
    public static var EVENT_TYPE_ABOUT:String = "EVENT_TYPE_ABOUT";
    public static const EVENT_TYPE_SELECTING_COMPLETED:String = "EVENT_TYPE_SELECTING_COMPLETED";


}
}
