package net.onthewings.filters
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class NativeFilter extends FilterWrapper
	{
		/**
		 * @param filter Can be string from NativeFilterFactory, filter instant or class.
		 */
		public function NativeFilter(filter:*)
		{
			super();
			
			if (filter is BitmapFilter){
				_filter = filter;
			} else if (filter is String) {
				_filter = NativeFilterFactory.createFilter(filter);
			} else if (filter is Class) {
				_filter = new filter();
			}
		}
		
		public override function applyTo(src:IBitmapDrawable, sourceRect:Rectangle = null, destPoint:Point = null):BitmapData {
			_prevObj = src;
			var tempBD:BitmapData = getBitmapDataOf(src);
			if (!sourceRect) sourceRect = tempBD.rect;
			if (!destPoint) destPoint = new Point();
			tempBD.applyFilter(tempBD, sourceRect, destPoint, _filter);
			return tempBD;
		}
		
		private var _filter:BitmapFilter;
	}
}