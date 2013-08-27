package events 
{
	import flash.events.DataEvent;
	/**
	 * ...
	 * @author DES
	 */
	public class EventFactory 
	{
		
		public function EventFactory() 
		{
			
		}
		
		
		public static function newDataEvent(type:String, data:String):DataEvent {
			return new DataEvent(type, true, true, data);
		}
		
		static public function newSelectEvent(name:String):DataEvent 
		{
			return newDataEvent(EventTypes.EVENT_TYPE_SELECT, name);
		}
		
	}

}