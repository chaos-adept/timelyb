package  
{
	/**
	 * ...
	 * @author DES
	 */
	public class ZagadkiConstants 
	{
		public static const EVENT_TYPE_SELECT:String = Cnst.EVENT_TYPE_SELECT;
		public static const EVENT_TYPE_TIMEOUT:String = "времяВышло";
		public static const EVENT_TYPE_ANIMCOMPLETED:String = Cnst.EVENT_TYPE_ANIMCOMPLETED;
		static public const EVENT_TYPE_ANIM_STARTED:String = Cnst.EVENT_TYPE_ANIM_STARTED;;
		public static const EVENT_SOUND_STARTED:String = Cnst.EVENT_SOUND_STARTED;
		public static const EVENT_SOUND_COMPLETE:String = Cnst.EVENT_SOUND_COMPLETE;
		public static const EVENT_TYPE_GAMEOVER:String = "играПроиграна";
		public static const EVENT_TYPE_WRONG_ANSWER:String = "wrongAnswer";
		public static const EVENT_TYPE_CHANGE_NAV_POSITION:String = "запросНавигации";
		static public const EVENT_TYPR_REPEAT_TASK:String = Cnst.EVENT_TYPE_REPEAT_TASK;
		static public const EVENT_TYPE_PRODUCT_LIST_LOADED:String = "prodListLoaded";;

		static public const FOLDER_IMAGE_PRODUCTS:String = "images/gorshochek/prod_png/";		
		static public const FOLDER_IMAGE_BLUDA:String = "images/gorshochek/bluda_png/";
		static public const FOLDER_IMAGE_UGADAI_PREDMET:String = "images/ugadai_predmet/";	
		
		static public const EVENT_TYPE_SELECT_COLOR:String = "eventTypeSelectColor";
		static public const EVENT_TYPE_SELECT_IMAGE_HIT_AREA:String = "eventTypeSelectImageHitArea";
		static public const EVENT_TYPE_PLAY_AGAIN:String = Cnst.EVENT_TYPE_PLAY_AGAIN;
		
		public static const THINKING_TIMEOUT:int = 2000;
		
		public static const COUNT_LIFE:int = 3;
		
		static public const COUNT_ZAGADKI_BUKI_MAX_PASSED_QUESTIONS_FOR_GROUP:int = 3;
		static public const COUNT_ZAGADKI_BUKI_MAX_PASSED_QUESTIONS_FOR_GAME:int = 12;		
		
		public static const TRAIN_POSITION_INTRO:String = Cnst.TRAIN_POSITION_0;
		public static const TRAIN_POSITION_1:String = Cnst.TRAIN_POSITION_1;
		public static const TRAIN_POSITION_2:String = Cnst.TRAIN_POSITION_2;
		public static const TRAIN_POSITION_3:String = Cnst.TRAIN_POSITION_3;
		public static const TRAIN_POSITION_4:String = Cnst.TRAIN_POSITION_4;
		public static const TRAIN_POSITION_5:String = Cnst.TRAIN_POSITION_5;
		public static const TRAIN_POSITION_6:String = Cnst.TRAIN_POSITION_6;

		public static const TRAIN_POSITION_SEQUENCE:Array = 
			[TRAIN_POSITION_INTRO, TRAIN_POSITION_1, TRAIN_POSITION_2, TRAIN_POSITION_3, TRAIN_POSITION_4, TRAIN_POSITION_5]; //, TRAIN_POSITION_3 , TRAIN_POSITION_4, TRAIN_POSITION_5
		
		static public const TRAIN_POSITION_GAME_ZAGADKI:String = TRAIN_POSITION_1;
		static public const TRAIN_POSITION_GAME_STISHKI:String = TRAIN_POSITION_2;
		static public const TRAIN_POSITION_GAME_RASKRASKI:String = TRAIN_POSITION_3;
		static public const TRAIN_POSITION_GAME_GORSHOCHEK:String = TRAIN_POSITION_4;
		static public const TRAIN_POSITION_GAME_UGADAI_PREDMET:String = TRAIN_POSITION_5;
		
		static public const ANIM_KEY_IMAGE_PART_COLOR_FILLED:String = "animKeyImagePartColorFilled";
		
		static public const ANIM_KEY_GORSHOCHEK_VARI:String = "горшочекВари";
		static public const ANIM_KEY_POPUGAY_UDIVLENIE:String = "удивлениеПопугая";
		static public const ANIM_KEY_BLUDO_HIDED:String = "ANIM_KEY_BLUDO_HIDED";
		

		static public const SOUND_KEY_YES_01:String = "yes01";
		static public const EVENT_TYPE_TRY_DROP_PRODUCT:String = "eventTypeTryDropProduct";
		static public const SOUND_KEY_NO:String = Cnst.SOUND_KEY_NO;
		static public const SOUND_KEY_GAME_OVER:String = "game_over";
		static public const EVENT_TYPE_ANSER_PLAY_COMPLETED:String = "eventTypeAnserPlayCompleted";
		static public const EVENT_TYPE_GAME_FINISHED:String = Cnst.EVENT_TYPE_GAME_FINISHED;
		
	}

}