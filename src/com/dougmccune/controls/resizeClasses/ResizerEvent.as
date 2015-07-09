package com.dougmccune.controls.resizeClasses
{
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ResizerEvent extends Event
	{
		public static const RESIZER_COMPLETE:String = "resizerComplete";
		
		public var rectangle:Rectangle;
		
		public function ResizerEvent(type:String, bubbles:Boolean = false,
							    cancelable:Boolean = false, rectangle:Rectangle = null)
		{
			super(type, bubbles, cancelable);
		
			this.rectangle = rectangle;
		}
	}
}