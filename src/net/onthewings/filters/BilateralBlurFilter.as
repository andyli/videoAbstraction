package net.onthewings.filters
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BilateralBlurFilter extends FilterWrapper
	{
		public var sampleRectHalfLength:uint = 2;
		public var d:Number;
		public var r:Number;
		
		public function BilateralBlurFilter(d:Number = 2, r:Number = 0.425)
		{
			super();
			
			this.d = d;
			this.r = r;
		}
		
		public override function applyTo(src:IBitmapDrawable, sourceRect:Rectangle = null, destPoint:Point = null):BitmapData {
			_prevObj = src;
			var tempBD:BitmapData = getBitmapDataOf(src);
			var resultBD:BitmapData = new BitmapData(tempBD.width,tempBD.height);
			var rect:Rectangle = new Rectangle();
			var ix:uint,iy:uint,jx:uint,jy:uint;
			var w:Number, totalW:Number;
			var total:Vector.<Number> = new Vector.<Number>(4);
			var pt1:Point = new Point();
			var pt2:Point = new Point();
			var color:uint, color2:uint;
			var a:uint, r:uint, g:uint, b:uint;
			
			for (ix = 0 ; ix < tempBD.width ; ++ix){
				for (iy = 0 ; iy < tempBD.height ; ++iy){
					rect.width = rect.height = sampleRectHalfLength*2+1;
					rect.x = ix-sampleRectHalfLength;
					rect.y = iy-sampleRectHalfLength;
					rect = rect.intersection(tempBD.rect);
					total[0] = total[1] = total[2] = total[3] = totalW = 0;
					pt1.x = ix;
					pt1.y = iy;
					color2 = tempBD.getPixel32(ix,iy);
					for(jx = rect.left ; jx < rect.right ; ++jx) {
						for(jy = rect.top ; jy < rect.bottom ; ++jy) {
							pt2.x = jx;
							pt2.y = jy;
							
							w = Math.exp(-0.5*Math.pow(Point.distance(pt1,pt2)/d,2.0));
							
							color = tempBD.getPixel32(jx,jy);
							a = color >>> 24;
							r = color >>> 16 & 0xFF;
							g = color >>> 8 & 0xFF;
							b = color & 0xFF;
							
							w *= Math.exp(-0.5*Math.pow((Math.abs(a - (color2 >>> 24)) + Math.abs(r - (color2 >>> 16 & 0xFF)) + Math.abs(g - (color2 >>> 8 & 0xFF)) + Math.abs(b - (color2 & 0xFF)))/r,2.0));
							
							total[0] += w * a;
							total[1] += w * r;
							total[2] += w * g;
							total[3] += w * b;
							totalW += w;
						}
					}
					color = (total[0]/totalW) << 24 | (total[1]/totalW) << 16 | (total[2]/totalW) << 8 | (total[3]/totalW);
					resultBD.setPixel32(ix,iy,color);
				}
			}
			return resultBD;
		}
	}
}