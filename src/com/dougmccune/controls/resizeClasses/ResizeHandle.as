package com.dougmccune.controls.resizeClasses
{
	import flash.display.Sprite;
	import mx.core.UIComponent;

	/**
	 * A simple rectangle, about as easy as it gets.
	 */
	public class ResizeHandle extends UIComponent
	{
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			graphics.clear();
			graphics.lineStyle(1, getStyle("themeColor"), .5);
			graphics.beginFill(0xffffff, .5);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
		}
		
	}
}