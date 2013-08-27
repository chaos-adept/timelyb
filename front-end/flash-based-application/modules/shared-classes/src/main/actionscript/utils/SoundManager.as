package utils 
{
import events.EventFactory;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import insfrastructure.Context;
import insfrastructure.content.ISoundContentResolver;

import org.as3commons.lang.StringUtils;

	/**
	 * ...
	 * @author DES
	 */
	public class SoundManager extends EventDispatcher
	{

		private static var _instance:SoundManager;

        private var soundChannelCount:int = 0;

		private var _playedSoundChannels:Dictionary = new Dictionary();

        private static const EVENT_TYPES:Vector.<String> = Vector.<String>
                                ([Cnst.EVENT_SOUND_STARTED, Cnst.EVENT_SOUND_COMPLETE]);

        private var suspendState:Boolean = false;

		private var contentResolver:ISoundContentResolver;
		
		public function SoundManager(){
			contentResolver = Context.instance.locate(ISoundContentResolver) as ISoundContentResolver;
		}
		
		public static function get instance():SoundManager {
			if (!_instance) {
				_instance = new SoundManager();
			}
			return _instance;
		}

        public function getSoundChannel(key:String):SoundChannel {
            var soundItem:SoundItem = getSoundItem(key);
            return soundItem ? soundItem.channel : null;
        }

        private function getSoundItem(key:String):SoundItem {
            return SoundItem(_playedSoundChannels[key]);
        }

		public function playSound(key:String, exclusive:Boolean = true, position:int = 0):void {
			trace("play is " + key);
			if (exclusive) {
				stopAllSounds();
			}			
			var sound:Sound = contentResolver.newSound(key); 

            sound.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
                trace("load sound error: " + e);
                clearSoundByKey(key);
            });

            try {

                soundChannelCount++;
                var item:SoundItem = new SoundItem();
				_playedSoundChannels[key] = item;
                item.sound = sound;
                item.soundCompleteHandler = newInternalSoundCompleteHandler(key);
                item.play(position);
				dispatchEvent(EventFactory.newDataEvent(Cnst.EVENT_SOUND_STARTED, key));

            } catch (e:Error) {
                clearSoundByKey(key);
                throw e;
            }
		}

        private function newInternalSoundCompleteHandler(key:String):Function {
            return function (e:Event):void {
                trace("sound complete ", key);
                clearSoundByKey(key);
            }
        }

        public function clearSoundByKey(key:String, silent:Boolean = false):void {
            var soundItem:SoundItem = _playedSoundChannels[key];
            if (soundItem) {
                soundItem.channel.stop();
                soundItem.channel = null;
                soundItem.sound = null;
                delete _playedSoundChannels[key];
                soundChannelCount--;
                trace("clr sound channel count: ", soundChannelCount);
            }
            if (!silent && !suspendState) {
                dispatchEvent(new DataEvent(Cnst.EVENT_SOUND_COMPLETE, true, true, key));
            }
        }


        public function getSound(key:String):Sound {
            return getSoundItem(key).sound;
        }

		
		public function stopAllSounds(...args):void
		{
			for (var itemKey:String in _playedSoundChannels) {
                clearSoundByKey(itemKey, true);
			}				
		}
		
		static public function play(soundKey:String, exclusive:Boolean = true):void 
		{
			SoundManager.instance.playSound(soundKey, exclusive);
		}
		
				
		public static function newPlaySoundFunction(soundKey:*):Function 
		{
			return function (...args):void {
				if (soundKey is Function) {
					SoundManager.play(soundKey());
				} else {
					SoundManager.play(soundKey.toString());				
				}
				
			}
		}

        public static function newPlaySndFn(soundKey:*):Function {
            return newPlaySoundFunction(soundKey);
        }

        public function addAllEventListener(handler:Function):void {
            for each (var eventType:String in EVENT_TYPES) {
                addEventListener(eventType, handler);
            }
        }

        public function removeAllEventListener(handler:Function):void {
            for each (var eventType:String in EVENT_TYPES) {
                removeEventListener(eventType, handler);
            }
        }

        public function resumeAll():void {

            suspendState = false;
            for (var itemKey:String in _playedSoundChannels) {
                var soundItem:SoundItem = _playedSoundChannels[itemKey];
                if (soundItem) {
                    soundItem.resume();
                }
            }


        }

        public function suspendAll():void {

            suspendState = true;
            for (var itemKey:String in _playedSoundChannels) {
                var soundItem:SoundItem = _playedSoundChannels[itemKey];
                if (soundItem) {
                    soundItem.pause();
                }
            }

        }

        public function removeSoundChannel(soundKey:String):void {
            clearSoundByKey(soundKey);
        }
    }

}

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;

class SoundItem {
    public var channel:SoundChannel;
    public var sound:Sound;

    private var pausePos:int = 0;

    public var soundCompleteHandler:Function;

    public function pause():void {
        pausePos = channel.position;
        channel.stop();
    }

    public function resume():void {
        channel = sound.play(pausePos);
        channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
    }

    public function play(position:int):void {
        pausePos = position;
        resume();
    }
}