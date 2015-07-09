package net.onthewings.utils
{
	import flash.display.BlendMode;
	
	public class BlendModeUtil
	{
		public static const constArray:Array = [
			BlendMode.ADD,
			BlendMode.ALPHA,
			BlendMode.DARKEN,
			BlendMode.DIFFERENCE,
			BlendMode.ERASE,
			BlendMode.HARDLIGHT,
			BlendMode.INVERT,
			BlendMode.LAYER,
			BlendMode.LIGHTEN,
			BlendMode.MULTIPLY,
			BlendMode.NORMAL,
			BlendMode.OVERLAY,
			BlendMode.SCREEN,
			BlendMode.SHADER,
			BlendMode.SUBTRACT
		];
		
		public static const constNameArray:Array = [
			"ADD",
			"ALPHA",
			"DARKEN",
			"DIFFERENCE",
			"ERASE",
			"HARDLIGHT",
			"INVERT",
			"LAYER",
			"LIGHTEN",
			"MULTIPLY",
			"NORMAL",
			"OVERLAY",
			"SCREEN",
			"SHADER",
			"SUBTRACT"
		];
		
		public static function getIndexOfConstArray(blendMode:String):int {
			blendMode = blendMode.toLowerCase();
			
			for (var i:int = 0 ; i < constArray.length ; ++i) {
				if (constArray[i] == blendMode || constNameArray[i] == blendMode){
					return i;
				}
			}
			
			return -1;
		}
	}
}