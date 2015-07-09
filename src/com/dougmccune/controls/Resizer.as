package com.dougmccune.controls
{
	import com.dougmccune.controls.resizeClasses.ResizeGhost;
	import com.dougmccune.controls.resizeClasses.ResizeHandle;
	import com.dougmccune.controls.resizeClasses.ResizerEvent;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	
	public class Resizer extends UIComponent
	{
		private static var TL_CORNER:int = 0;
	    private static var TR_CORNER:int = 1;
	    private static var BL_CORNER:int = 2;
	    private static var BR_CORNER:int = 3;
	    private static var L_SIDE:int = 4;
	    private static var R_SIDE:int = 5;
	    private static var T_SIDE:int = 6;
	    private static var B_SIDE:int = 7;
	    
	    
	    public static var DEFAULT_RESIZE_HANDLE_WIDTH:Number = 5;
	    public static var DEFAULT_RESIZE_HANDLE_HEIGHT:Number = 5;
	    
	    
		private var ghost:ResizeGhost;
    	
    	/**
    	 * All our resize handles. We got 8 (all corners and middle of each side)
    	 */
		private var tl:ResizeHandle;
		private var bl:ResizeHandle;
		private var tr:ResizeHandle;
		private var br:ResizeHandle;
		private var t:ResizeHandle;
		private var b:ResizeHandle;
		private var l:ResizeHandle;
		private var r:ResizeHandle;
		
		private var lastTopLeftPoint:Point;
		private var lastBottomRightPoint:Point;
			
		private var resizeHandleSelected:int;
		private var rotationHandleSelected:int;
		
		private var _target:UIComponent;
		
		public function set target(value:UIComponent):void {
			_target = value;
		}
		
		public function get target():UIComponent {
			return _target;
		}
		
		
		override protected function createChildren():void {
			
			
			ghost = new ResizeGhost();
			ghost.visible = false;
				
			tl = new ResizeHandle();
			tr = new ResizeHandle();
			bl = new ResizeHandle();
			br = new ResizeHandle();
			t = new ResizeHandle();
			b = new ResizeHandle();
			l = new ResizeHandle();
			r = new ResizeHandle();
			
			tl.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			tr.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			bl.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			br.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			t.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			b.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			l.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			r.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			
			tl.buttonMode = tl.useHandCursor = true;
			tr.buttonMode = tr.useHandCursor = true;
			bl.buttonMode = bl.useHandCursor = true;
			br.buttonMode = br.useHandCursor = true;
			t.buttonMode = t.useHandCursor = true;
			b.buttonMode = b.useHandCursor = true;
			l.buttonMode = l.useHandCursor = true;
			r.buttonMode = r.useHandCursor = true;
			
			addChild(ghost);
			
			addChild(tl);
			addChild(tr);
			addChild(bl);
			addChild(br);
			addChild(t);
			addChild(b);
			addChild(l);
			addChild(r);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(isNaN(unscaledWidth) || isNaN(unscaledHeight)) {
				return;
			}
			
			var w:Number = _resizeHandleWidth ? _resizeHandleWidth : Resizer.DEFAULT_RESIZE_HANDLE_WIDTH;
			var h:Number = _resizeHandleHeight ? _resizeHandleHeight : Resizer.DEFAULT_RESIZE_HANDLE_HEIGHT;
			
			tl.setActualSize(w, h);
			tr.setActualSize(w, h);
			bl.setActualSize(w, h);
			br.setActualSize(w, h);
			
			t.setActualSize(w, h);
			b.setActualSize(w, h);
			l.setActualSize(w, h);
			r.setActualSize(w, h);
			
			placeHandles( new Rectangle(0,0, unscaledWidth, unscaledHeight) );
		}
		
		private var _resizeHandleWidth:Number;
		
		public function set resizeHandleWidth(value:Number):void {
			_resizeHandleHeight = value;
			invalidateDisplayList();
		}
		
		public function get resizeHandleWidth():Number {
			return _resizeHandleWidth ? _resizeHandleWidth : DEFAULT_RESIZE_HANDLE_WIDTH;
		}
		
		private var _resizeHandleHeight:Number;
		
		public function set resizeHandleHeight(value:Number):void {
			_resizeHandleHeight = value;
			invalidateDisplayList();
		}
		
		public function get resizeHandleHeight():Number {
			return _resizeHandleHeight ? _resizeHandleHeight : DEFAULT_RESIZE_HANDLE_HEIGHT;
		}
	
		
		private function handlePress(event:MouseEvent):void {
			systemManager.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			ghost.visible = true;
			ghost.showDataTip();
		
			var globalTopLeft:Point = localToGlobal( new Point(0,0) );
			var globalBottomRight:Point = localToGlobal( new Point(width,height) );
			
			lastTopLeftPoint = this.globalToLocal( globalTopLeft );
			lastBottomRightPoint = this.globalToLocal( globalBottomRight );
			
				
			switch(event.target) {
				case tl:
					resizeHandleSelected = TL_CORNER;
					break;
				case tr:
					resizeHandleSelected = TR_CORNER;
					break;
				case bl:
					resizeHandleSelected = BL_CORNER;
					break;
				case br:
					resizeHandleSelected = BR_CORNER;
					break;	
				case t:
					resizeHandleSelected = T_SIDE;
					break;
				case b:
					resizeHandleSelected = B_SIDE;
					break;
				case l:
					resizeHandleSelected = L_SIDE;
					break;
				case r:
					resizeHandleSelected = R_SIDE;
					break;	
			}
			
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, doResize);
		}
		
		
		private function doResize(event:MouseEvent):void {
			var x:Number = event.stageX;
			var y:Number = event.stageY;
			
			var localPoint:Point = this.globalToLocal(new Point(x, y));
			
			x = localPoint.x;
			y = localPoint.y;
			
			var newX:Number;
			var newY:Number;
			var newWidth:Number;
			var newHeight:Number;
			
			switch(resizeHandleSelected) {
				case TL_CORNER:
					newWidth = lastBottomRightPoint.x - x;
					newHeight = lastBottomRightPoint.y - y;
					
					newX = x;
					newY = y;
					break;
					
				case TR_CORNER:
					newWidth = x - lastTopLeftPoint.x;
					newHeight = lastBottomRightPoint.y - y;
					
					newX = lastTopLeftPoint.x;
					newY = y;		
					break;
				
				case BL_CORNER:
					newWidth = lastBottomRightPoint.x - x;
					newHeight = y - lastTopLeftPoint.y;
					
					newX = x;
					newY = lastTopLeftPoint.y;		
					break;
				
				case BR_CORNER:
					newWidth = x - lastTopLeftPoint.x;
					newHeight = y - lastTopLeftPoint.y;
					
					newX = lastTopLeftPoint.x;
					newY = lastTopLeftPoint.y;		
					break;
				
				case T_SIDE:
					newHeight = lastBottomRightPoint.y - y;
					newWidth = this.width;
					
					newX = 0;
					newY = y;	
					break;
				
				case B_SIDE:
					newWidth = this.width;
					newHeight = y - lastTopLeftPoint.y;
					
					newX = 0;
					newY = lastTopLeftPoint.y;	
					break;
				
				case L_SIDE:
					newWidth = lastBottomRightPoint.x - x;
					newHeight = this.height;
					
					newX = x;	
					newY = 0;
					break;
				
				case R_SIDE:
					newWidth = x - lastTopLeftPoint.x;
					newHeight = this.height;
					
					newX = lastTopLeftPoint.x;	
					newY = 0;
					break;
			}
			
			if(newWidth < 0) {
				newX = newX + newWidth;
				newWidth *= -1;
			}
			
			if(newHeight < 0) {
				newY = newY + newHeight;
				newHeight *= -1;
			}
			
			placeHandles(new Rectangle(newX, newY, newWidth, newHeight));
		}
		
		private function placeHandles(rect:Rectangle):void {
			tl.move(rect.x - tl.width/2, rect.y - tl.height/2);
			tr.move(rect.x + rect.width - tr.width/2, rect.y - tl.height/2);
			bl.move(rect.x - bl.width/2, rect.y + rect.height - tl.height/2);
			br.move(rect.x + rect.width - bl.width/2, rect.y + rect.height - tl.height/2);
			
			t.move(rect.x + rect.width/2 - t.width/2, rect.y - t.height/2);
			b.move(rect.x + rect.width/2 - b.width/2, rect.y + rect.height - b.height/2);
			l.move(rect.x - l.width/2, rect.y + rect.height/2 - l.height/2);
			r.move(rect.x + rect.width - r.width/2, rect.y + rect.height/2 - r.height/2);
			
			ghost.move(rect.x, rect.y);
			ghost.setActualSize(rect.width, rect.height);
		}
		
		private function handleRelease(event:MouseEvent):void {
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, handleRelease);
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, doResize);
			
			var point:Point = this.localToGlobal( new Point(ghost.x,ghost.y) );
			
			ghost.visible = false;
			ghost.hideDataTip();
			
			var rectangle:Rectangle = new Rectangle(point.x, point.y, ghost.width, ghost.height);
			
			this.setActualSize(ghost.width, ghost.height);
			this.move(this.x + ghost.x, this.y + ghost.y);
			
			
			dispatchEvent(new ResizerEvent(ResizerEvent.RESIZER_COMPLETE, false, false, rectangle));
		
			if(_target) {
				resizeUIComponent(_target, rectangle);
			}
		}
		
		
		private function resizeUIComponent(component:*, rectangle:Rectangle):void {
			var point:Point = new Point(rectangle.x, rectangle.y);
			point = component.parent.globalToLocal(point);
			
			/* The following code would just move the target directly, instead of
			 * using a Tween. I dunno, I kinda like the tween, but it might look silly
			 */
			/*
			component.width = rectangle.width;
			component.height = rectangle.height;
			
			component.x = point.x;
			component.y = point.y;
			
			component.invalidateDisplayList();
			*/
			
			var tween:Resize = new Resize(component);
			tween.heightFrom = component.height;
			tween.heightTo = rectangle.height;
			tween.widthFrom = component.width;
			tween.widthTo = rectangle.width;
			
			var moveTween:Move = new Move(component);
			moveTween.xFrom = component.x;
			moveTween.xTo = point.x;
			moveTween.yFrom = component.y;
			moveTween.yTo = point.y;
			
			var para:Parallel = new Parallel(component);
			para.addChild(tween);
			para.addChild(moveTween);
			
			para.duration = 400;
			
			para.addEventListener(EffectEvent.EFFECT_END, resizeEffectEnd);
			para.play();
			
			this.visible = false;
		}
		
		private function resizeEffectEnd(event:EffectEvent):void {
			this.visible = true;
		}
	}
}