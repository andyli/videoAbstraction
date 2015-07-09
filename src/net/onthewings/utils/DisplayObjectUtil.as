package net.onthewings.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DisplayObjectUtil
	{
		/**
		 * Find the nearest parent that is the specific class.
		 */
		public static function getParentOfChild(parentClass:Class,child:DisplayObject,countSelf:Boolean = true):DisplayObjectContainer {
			if (countSelf && child is parentClass) return child as DisplayObjectContainer;
			
			var parentObj:DisplayObject = child.parent;
			while (!(parentObj is parentClass))
				parentObj = parentObj.parent;
				
			if (parentObj is parentClass)
				return parentObj as DisplayObjectContainer;
			else 
				return null;
		}

	}
}