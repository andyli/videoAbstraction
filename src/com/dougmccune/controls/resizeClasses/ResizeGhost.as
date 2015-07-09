package com.dougmccune.controls.resizeClasses
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.controls.ToolTip;
	import mx.core.UIComponent;
	import mx.formatters.NumberFormatter;
	
	public class ResizeGhost extends UIComponent
	{
		private var dataTip:ToolTip;
		
		private var formatter:NumberFormatter;
		
		override protected function createChildren():void {
			super.createChildren();
			
			formatter = new NumberFormatter();
			formatter.precision = 1;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var g:Graphics = graphics;
			
			g.clear();
			g.lineStyle(1, getStyle("themeColor"), .5);
		
			if(dataTip) {
				var middlePoint:Point = new Point(unscaledWidth/2 - dataTip.width/2, unscaledHeight/2 - dataTip.height/2);
				middlePoint = this.localToGlobal(middlePoint);
			
				dataTip.text = formatter.format(unscaledWidth) + " x " + formatter.format(unscaledHeight);
				dataTip.x = middlePoint.x;
				dataTip.y = middlePoint.y;
				
			}
			
			g.drawRect(0,0,unscaledWidth, unscaledHeight);
		}
		
		public function showDataTip():void {
			if(!dataTip) {
				dataTip = new ToolTip();
				systemManager.toolTipChildren.addChild(dataTip);
				invalidateDisplayList();
			}
		}
		
		public function hideDataTip():void
	    {
	        if (dataTip)
	        {
	            systemManager.toolTipChildren.removeChild(dataTip);
	            dataTip = null;
	        }
	    }
		
		
	}
}