package com.dougmccune.controls
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	public class DragBar extends UIComponent
	{
		private var regX:Number;
		private var regY:Number;
		
		private var nameField:Label;
		
		private var _target:UIComponent;
		
		public function set target(value:UIComponent):void {
			_target = value;
		}
		
		public function get target():UIComponent {
			return _target;
		}
		
		public function DragBar():void {
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			
			this.useHandCursor = this.buttonMode = true;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			nameField = new Label();
			nameField.setStyle("fontSize", 9);	
			nameField.setStyle("fontWeight", "normal");
			nameField.setStyle("color", 0x666666);
			nameField.setStyle("textAlign", "left");
			
			addChild(nameField);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if(isNaN(unscaledWidth) || isNaN(unscaledHeight)) {
				return;
			}
			
			nameField.move(0,-2);
			nameField.setActualSize( unscaledWidth, nameField.getExplicitOrMeasuredHeight());
			nameField.text = target ? target.name : "";
			
			var g:Graphics = this.graphics;
			
			g.clear();
			
			g.beginFill(0xcccccc, .5);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			
			var themeCol:Number = getStyle("themeColor");
			
			g.beginFill(themeCol, .4);
			g.drawRect(0,0, unscaledWidth, unscaledHeight);  
			
			g.lineStyle(1, themeCol);
			g.moveTo(0, 0);
			g.lineTo(unscaledWidth, 0);
			
			g.moveTo(0,0);
			g.lineTo(0, unscaledHeight);
			
			g.moveTo(unscaledWidth,0);
			g.lineTo(unscaledWidth, unscaledHeight);
		}
		
		protected function startDragging(event:MouseEvent):void
	    {
	    	if(_target) {
		    	regX = event.stageX - _target.x;
		       	regY = event.stageY - _target.y;
		    }
		    else {
		    	regX = event.stageX - this.x;
		       	regY = event.stageY - this.y;
		    } 
	        systemManager.addEventListener(
	            MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
	
	        systemManager.addEventListener(
	            MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
	
	        systemManager.stage.addEventListener(
	            Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
	    }
	    
	    protected function stopDragging():void
	    {
	        systemManager.removeEventListener(
	            MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
	
	        systemManager.removeEventListener(
	            MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
	
	        systemManager.stage.removeEventListener(
	            Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
	
	        regX = NaN;
	        regY = NaN;
	        
	        if(_target) {
	        	//wtf? we gotta change width back and forth to trigger a real redraw. Hmmm... lame
	        	_target.width++;
	        	_target.width--;
	        	_target.invalidateDisplayList();
	        }
	    }
	    
	    private function systemManager_mouseMoveHandler(event:MouseEvent):void
	    {
	    	event.stopImmediatePropagation();
	    	
	        if(_target) {
	        	_target.move(event.stageX - regX, event.stageY - regY);
	        }
	    }
	    
	    private function systemManager_mouseUpHandler(event:MouseEvent):void
	    {
	        if (!isNaN(regX))
	            stopDragging();
	    }
	    
	    private function stage_mouseLeaveHandler(event:Event):void
	    {
	        if (!isNaN(regX))
	            stopDragging();
	    }
	}
}