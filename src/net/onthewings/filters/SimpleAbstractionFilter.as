package net.onthewings.filters
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IBitmapDrawable;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class SimpleAbstractionFilter extends FilterWrapper
	{
		public const MAX_PROCESS_STAGE:uint = 3;
		[Bindable]
		public var processStage:int = MAX_PROCESS_STAGE;
		
		[Bindable]
		public var numOfBlur:uint = 5;
		[Bindable]
		public var blendMode:String = BlendMode.DARKEN;
		
		public function SimpleAbstractionFilter()
		{
			super();
		}
		
		public override function applyTo(src:IBitmapDrawable, sourceRect:Rectangle=null, destPoint:Point=null):BitmapData {
			_prevObj = src;
			
			var resultBD:BitmapData = getBitmapDataOf(src);
			var edgeBD:BitmapData = resultBD.clone();
			
			if (!sourceRect) sourceRect = resultBD.rect;
			if (!destPoint) destPoint = _originPt;
			
			if (processStage == 2) {
				edgeBD.applyFilter(edgeBD,sourceRect,destPoint,GrayScaleShaderFilter);
				edgeBD.applyFilter(edgeBD,sourceRect,destPoint,SobelShaderFilter);
				edgeBD.applyFilter(edgeBD,sourceRect,destPoint,invertRGBShaderFilter);
				resultBD.dispose();
				return edgeBD;
			}
			
			for (var i:uint = 0 ; i < numOfBlur ; ++i){
				resultBD.applyFilter(resultBD,sourceRect,destPoint,MedianSimpleShaderFilter);
			}
			if (processStage == 1) {
				edgeBD.dispose();
				return resultBD;
			}
			
			edgeBD.applyFilter(edgeBD,sourceRect,destPoint,GrayScaleShaderFilter);
			edgeBD.applyFilter(edgeBD,sourceRect,destPoint,SobelShaderFilter);
			edgeBD.applyFilter(edgeBD,sourceRect,destPoint,invertRGBShaderFilter);
			
			
			resultBD.draw(edgeBD,null,null,blendMode);
			
			edgeBD.dispose();
			return resultBD;
		}
		
		[Embed("Sobel.pbj", mimeType="application/octet-stream")]
		private static var Sobel:Class;
		private var SobelShader:Shader = new Shader(new Sobel() as ByteArray);
		private var SobelShaderFilter:ShaderFilter = new ShaderFilter(SobelShader);
		
		[Embed("../../../../pb/MedianSimple.pbj", mimeType="application/octet-stream")]
		private static var MedianSimple:Class;
		private static var MedianSimpleShader:Shader = new Shader(new MedianSimple() as ByteArray);
		private static var MedianSimpleShaderFilter:ShaderFilter = new ShaderFilter(MedianSimpleShader);
		
		[Embed("../../../../pb/GrayScale.pbj", mimeType="application/octet-stream")]
		private static var GrayScale:Class;
		private static var GrayScaleShader:Shader = new Shader(new GrayScale() as ByteArray);
		private static var GrayScaleShaderFilter:ShaderFilter = new ShaderFilter(GrayScaleShader);
		
		[Embed("../../../../pb/invertRGB.pbj", mimeType="application/octet-stream")]
		private static var invertRGB:Class;
		private static var invertRGBShader:Shader = new Shader(new invertRGB() as ByteArray);
		private static var invertRGBShaderFilter:ShaderFilter = new ShaderFilter(invertRGBShader);
		
		private var _originPt:Point = new Point();
	}
}