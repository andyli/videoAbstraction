package net.onthewings.utils
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.core.UIComponent;
	
	public class PanelUtil
	{
		/**
		 * Make a Panel draggable. Press on the title bar of Panel to start dragging.
		 * Work with Flex SDK 3.3, other versions are not tested.
		 */
		public static function makePanelDraggable(panel:Panel):void {
			var titleBar:InteractiveObject;
			for (var i:int = 0 ; i < panel.rawChildren.numChildren ; i ++){
				var child:DisplayObject = panel.rawChildren.getChildAt(i);
				if(child is UIComponent){
					titleBar = child as InteractiveObject;
				}
			}
			titleBar.addEventListener(MouseEvent.MOUSE_DOWN,draggablePanelStartDrag,false,0,true);
			titleBar.addEventListener(MouseEvent.MOUSE_UP,draggablePanelStopDrag,false,0,true);
		}
		
		private static function draggablePanelStartDrag(evt:MouseEvent):void {
			var panel:Panel = DisplayObjectUtil.getParentOfChild(Panel,evt.target as DisplayObject) as Panel;
			panel.startDrag();
		}
		
		private static function draggablePanelStopDrag(evt:MouseEvent):void {
			var panel:Panel = DisplayObjectUtil.getParentOfChild(Panel,evt.target as DisplayObject) as Panel;
			panel.stopDrag();
		}
	}
}