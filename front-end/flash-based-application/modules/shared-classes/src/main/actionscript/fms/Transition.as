package fms 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author DES
	 */
	public class Transition 
	{
		
		public var nextState:String;
		
		public var nextStateDelegate:Function;
		
		public function Transition() 
		{
			
		}
		
		public function handleEvent(event:Event):void {
            if (nextStateDelegate != null) {
                if (nextStateDelegate.length == 0) {
                    nextStateDelegate();
                } else {
                    nextStateDelegate(nextState, event);
                }

            }

		}
		
	}

}