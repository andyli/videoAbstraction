package com.dougmccune.containers
{
	import mx.core.Container;
	import com.dougmccune.controls.ResizerAndDragBar;
	import com.dougmccune.controls.Resizer;
	import mx.containers.Canvas;
	import flash.display.DisplayObject;
	import mx.core.UIComponent;

	[DefaultProperty("content")]

	public class ResizableWrapper extends UIComponent
	{
		private var resizer:ResizerAndDragBar;
		
		
		
		private var _content:UIComponent;
		public function set content(value:UIComponent):void {
			if(_content) {
				removeChild(_content);
			}
			_content = value;
			addChild(_content);
			
			invalidateSize();
		}
		
		public function get content():UIComponent {
			return _content;
		}
		
		override protected function measure():void {
			super.measure();
			
			if(_content) {
				measuredHeight = _content.getExplicitOrMeasuredHeight();
				measuredWidth = _content.getExplicitOrMeasuredWidth();
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			resizer = new ResizerAndDragBar();
			resizer.target = this;
			addChild(resizer);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_content) {
				_content.move(0,0);
				_content.setActualSize(unscaledWidth, unscaledHeight);
			}
			
			resizer.move(0,0);
			resizer.setActualSize( unscaledWidth,  unscaledHeight);
		}
		
		
	}
}