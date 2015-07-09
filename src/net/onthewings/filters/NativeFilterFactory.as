package net.onthewings.filters
{
	import flash.filters.*;
	public class NativeFilterFactory {
	    public static var BEVEL_FILTER:String = "BevelFilter";
	    public static var BevelFilterConstructor:Class = BevelFilter;
	
	    public static var BLUR_FILTER:String = "BlurFilter";
	    public static var BlurFilterConstructor:Class = BlurFilter;
	
	    public static var COLOR_MATRIX_FILTER:String = "ColorMatrixFilter";
	    public static var ColorMatrixFilterConstructor:Class = ColorMatrixFilter;
	
	    public static var CONVOLUTION_FILTER:String = "ConvolutionFilter";
	    public static var ConvolutionFilterConstructor:Class = ConvolutionFilter;
	
	    public static var DISPLACEMENT_MAP_FILTER:String = "DisplacementMapFilter";
	    public static var DisplacementMapFilterConstructor:Class = DisplacementMapFilter;
	
	    public static var DROP_SHADOW_FILTER:String = "DropShadowFilter";
	    public static var DropShadowFilterConstructor:Class = DropShadowFilter;
	
	    public static var GLOW_FILTER:String = "GlowFilter";
	    public static var GlowFilterConstructor:Class = GlowFilter;
	
	    public static var GRADIENT_BEVEL_FILTER:String = "GradientBevelFilter";
	    public static var GradientBevelFilterConstructor:Class = GradientBevelFilter;
	
	    public static var GRADIENT_GLOW_FILTER:String = "GradientGlowFilter";
	    public static var GradientGlowFilterConstructor:Class = GradientGlowFilter;
	
	    public static function createFilter(type:String):BitmapFilter {
	        return new NativeFilterFactory[type + "Constructor"]();   
	    }
	}
}