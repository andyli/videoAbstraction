package com.dougmccune.controls
{
	import mx.core.UIComponent;
	
	public class ResizerAndDragBar extends UIComponent
	{
		private var resizer:Resizer;
		public var dragBar:DragBar;
		
		override protected function createChildren():void {
			super.createChildren();
		
			resizer = new Resizer();
			dragBar = new DragBar();
			
			dragBar.mouseEnabled = dragBar.buttonMode = dragBar.useHandCursor = true;
			dragBar.visible = _showDragBar;
			resizer.visible = _showResizeHandles;
			
			addChild(dragBar);
			addChild(resizer);
			
			if(!_target) {
				resizer.target = this;
				dragBar.target = this;
			}
			else {
				resizer.target = dragBar.target = _target;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			resizer.move(0,0);
			resizer.setActualSize(unscaledWidth, unscaledHeight);
			dragBar.move(0, -10);
			dragBar.setActualSize(unscaledWidth, 10);
			
		}
		
		private var _target:UIComponent;
		
		public function set target(value:UIComponent):void {
			_target = value;
			
			if(resizer && dragBar) 
				resizer.target = dragBar.target = _target;
		}
		
		public function get target():UIComponent {
			return _target;
		}
		
		private var _showDragBar:Boolean = true;
		
		public function get dragBarVisible():Boolean {
			return _showDragBar;
		}
		
		public function set dragBarVisible(value:Boolean):void {
			_showDragBar = value;
			
			if(dragBar) dragBar.visible = value;
		}
		
		private var _showResizeHandles:Boolean = true;
		
		public function get resizeHandlesVisible():Boolean {
			return _showResizeHandles;
		}
		
		public function set resizeHandlesVisible(value:Boolean):void {
			_showResizeHandles = value;
			
			if(resizer) resizer.visible = value;
		}
		
	}
}