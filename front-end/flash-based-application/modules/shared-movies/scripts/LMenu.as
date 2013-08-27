package scripts
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip
	import flash.display.Sprite;
	
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class LMenu extends Sprite
	{
		public var _winW : int;
		public var _winH : int;
	
		public var deltaX : int;
		public var deltaY : int;
		private var _MenuOpn : Boolean = false;
		private var _MenuProc : Boolean = false;
		private var _SoundIsPlay : Boolean;
		//private var _Fone:MovieClip; 
		public var _Lmenu:LeftMenu; 
		public function get _menuM():MovieClip { return _Lmenu._menuM; };
		public function get _menuR():MovieClip { return _Lmenu._menuR; }; 
		public function get _menuH():MovieClip { return _Lmenu._menuH; }; 
		public function get _menuA():MovieClip { return _Lmenu._menuA; }; 
		public function get _menuCl():MovieClip { return _Lmenu._menuCl; }; 
		public function get _menuOp():MovieClip { return _Lmenu._menuOp; }; 
			
		// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		public function LMenu() 
		{
			super();
			//_Fone = new Fone00();
			_Lmenu = new LeftMenu();

			addChild(_Lmenu);

			toMainSceneLayout();
			
			_menuOp.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownOp);		
			_menuCl.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownCl);	
			

		
		}
		
		public function toGameLayout():void {

			/*
			_menuM.x = -92;
			_menuM.y = 132;
			
			_menuR.x = -92;
			_menuR.y = 248;
			
			_menuH.x = -92;
			_menuH.y = 378;
			
			_menuA.x = -92;
			_menuA.y = 503;
			
			_menuCl.x = 2;
			_menuCl.y = 34;
			
			_menuOp.x = 5;
			_menuOp.y = 35;			
			*/
			
			this._Lmenu.gotoAndStop(2);
		}
		
		public function toMainSceneLayout():void {
			/*
			_menuM.x = -92;
			_menuM.y = 132;
			
			_menuR.x = -92;
			_menuR.y = 248;
			
			_menuH.x = -92;
			_menuH.y = 378;
			
			_menuA.x = -92;
			_menuA.y = 503;
			
			_menuCl.x = 2;
			_menuCl.y = 34;
			
			_menuOp.x = 5;
			_menuOp.y = 35;			
			*/
			this._Lmenu.gotoAndStop(1);

		}		
		
		
	// ####################################################################################
	public function DOpenMenu():void
		{
			if (_MenuOpn == false && _MenuProc == false) {
				_MenuProc = true;
			addEventListener(Event.ENTER_FRAME, OpenMenu);
			};
		};
	
	
		function MouseDownOp(event:MouseEvent):void
		{
			if (_MenuOpn == false && _MenuProc == false) {
				_MenuProc = true;
			addEventListener(Event.ENTER_FRAME, OpenMenu);
			};
		};
	// =====================================================================================
		function MouseDownCl(event:MouseEvent):void
		{
			if (_MenuOpn == true && _MenuProc == false) {
				_MenuProc = true;
			addEventListener(Event.ENTER_FRAME, CloseMenu);
			};
		};
	
	
	// =====================================================================================
	function OpenMenu(e:Event):void {
			if (_Lmenu.x<120) {
				_Lmenu.x += (Math.abs(_Lmenu.x-120))/5+1;
				_menuOp.alpha = Math.abs(_Lmenu.x-120)/120;
				_menuCl.alpha = 1-Math.abs(_Lmenu.x-120)/120;
			} else {
				_Lmenu.x = 120;
				_menuOp.alpha = 0;
				_menuCl.alpha = 1;
				_MenuOpn = true;
				_MenuProc = false;
				removeEventListener(Event.ENTER_FRAME, OpenMenu);
			};
		};
	// =====================================================================================
	function CloseMenu(e:Event):void {
			if (_Lmenu.x>0) {
				_Lmenu.x -= (Math.abs(_Lmenu.x))/5+1;
				//_menuOp.alpha = Math.floor((_Lmenu.x)/12)/10;
				//_menuCl.alpha = 1-Math.floor((_Lmenu.x)/12)/10;
				_menuOp.alpha = Math.abs(_Lmenu.x-120)/120;
				_menuCl.alpha = 1-Math.abs(_Lmenu.x-120)/120;
			} else {
				_Lmenu.x = 0;
				_menuOp.alpha = 1;
				_menuCl.alpha = 0;
				_MenuOpn = false;
				_MenuProc = false;
				removeEventListener(Event.ENTER_FRAME, CloseMenu);
			};
		};
		
	// #####################################################################################	
	public function DCloseMenu():void
		{
			_MenuProc = true;
			addEventListener(Event.ENTER_FRAME, CloseMenu);
			
		};
	// #####################################################################################	
	public function destroyM():void
		{
		SoundMixer.stopAll();	
			
		}

	};
};