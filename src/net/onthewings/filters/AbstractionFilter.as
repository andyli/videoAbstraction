package net.onthewings.filters
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IBitmapDrawable;
	import flash.display.Shader;
	import flash.display.ShaderPrecision;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class AbstractionFilter extends FilterWrapper
	{
		public const MAX_PROCESS_STAGE:uint = 3;
		[Bindable]
		public var processStage:int = MAX_PROCESS_STAGE;
		
		[Bindable]
		public var blendMode:String = BlendMode.MULTIPLY;
		
		public function AbstractionFilter()
		{
			super();
			
			//bilateralBlurShader.precisionHint = ShaderPrecision.FAST;
			bilateralBlurShader.data.r.value = [0.25];
			
			//doGShader.precisionHint = ShaderPrecision.FAST;
		}
		
		public override function applyTo(src:IBitmapDrawable, sourceRect:Rectangle=null, destPoint:Point=null):BitmapData {
			_prevObj = src;
			
			var resultBD:BitmapData = getBitmapDataOf(src);
			var edgeBD:BitmapData = resultBD.clone();
			
			if (!sourceRect) sourceRect = resultBD.rect;
			if (!destPoint) destPoint = _originPt;
			
			if (processStage == 2) {
				edgeBD.applyFilter(resultBD,sourceRect,destPoint,doGShaderFilter);
				resultBD.dispose();
				return edgeBD;
			}
			
			resultBD.applyFilter(resultBD,sourceRect,destPoint,bilateralBlurShaderFilter);
			if (processStage == 1) {
				edgeBD.dispose();
				return resultBD;
			}
			
			edgeBD.applyFilter(resultBD,sourceRect,destPoint,doGShaderFilter);
			
			resultBD.draw(edgeBD,null,null,blendMode);
			
			edgeBD.dispose();
			
			return resultBD;
		}
		
		[Embed("BilateralBlur.pbj", mimeType="application/octet-stream")]
		private static var bilateralBlur:Class;
		[Bindable]
		public var bilateralBlurShader:Shader = new Shader(new bilateralBlur() as ByteArray);
		private var bilateralBlurShaderFilter:ShaderFilter = new ShaderFilter(bilateralBlurShader);
		
		[Embed("DoG.pbj", mimeType="application/octet-stream")]
		private static var doG:Class;
		[Bindable]
		public var doGShader:Shader = new Shader(new doG() as ByteArray);
		private var doGShaderFilter:ShaderFilter = new ShaderFilter(doGShader);
		
		private var _originPt:Point = new Point();
	}
}