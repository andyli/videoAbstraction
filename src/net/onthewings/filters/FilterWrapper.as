package net.onthewings.filters
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class FilterWrapper extends EventDispatcher
	{
		public function get prevObj():IBitmapDrawable {
			return _prevObj;
		}
		
		public function FilterWrapper()
		{
			super();
		}
		
		public function applyTo(src:IBitmapDrawable,sourceRect:Rectangle = null, destPoint:Point = null):BitmapData {
			_prevObj = src;
			return getBitmapDataOf(src);
		}
		
		protected function getBitmapDataOf(obj:IBitmapDrawable):BitmapData {
			var tempBD:BitmapData;
			if (obj is BitmapData) {
				tempBD = (obj as BitmapData).clone();
			} else {
				var dObj:DisplayObject = obj as DisplayObject;
				tempBD = new BitmapData(dObj.width, dObj.height);
				tempBD.draw(dObj);
			}
			return tempBD;
		}
		
		protected var _prevObj:IBitmapDrawable;
	}
}