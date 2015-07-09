package
{
	import com.symantec.premiumServices.asyncThreading.abstract.AbstractAsyncThread;
	import com.symantec.premiumServices.asyncThreading.interfaces.IAsyncThreadScalableResponder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.controls.VideoDisplay;
	import mx.events.ResizeEvent;
	
	import net.onthewings.filters.FilterWrapper;

	public class ProcessVideoThread extends AbstractAsyncThread implements IAsyncThreadScalableResponder
	{
		public var videoDisplay:DisplayObject;
		public var filters:Array;
		
		[Bindable]
		public var outputTarget:BitmapData;
		
		[Bindable]
		public var effectApplyRect:Rectangle;
		[Bindable]
		public var effectApplyPoint:Point = new Point();
		
		public function get processTime():uint{
			return _processTime;
		}
		
		/**
		 * The process will auto sleep after countFrame reaches zero. -1 means this is disabled.
		 */
		[Bindable]
		public var countFrame:int = -1;
		
		/**
		 * Constructor.
		 * @param	videoDisplay		DisplayObject that contain the video or animation.
		 * @param	filters				Array of filters apply on the video.
		 * @param	outputTarget		BitmapData the result will be drawn on.
		 */
		public function ProcessVideoThread(videoDisplay:VideoDisplay, filters:Array, outputTarget:BitmapData) {	
			super();
			super.priority = RUN_LEVEL_REAL_TIME;
			
			this.videoDisplay = videoDisplay;
			this.filters = filters;
			this.outputTarget = outputTarget;
			
			inputResizeHandler();
			
			videoDisplay.addEventListener(ResizeEvent.RESIZE,inputResizeHandler,false,0,true);
		}
		
		public function execute():void
		{
			if (countFrame == -1 || countFrame-- > 0){
				_time = getTimer();
				outputTarget.draw(videoDisplay,transformMatrix);
				
				if (!effectApplyRect) effectApplyRect = outputTarget.rect;
				
				for (var i:uint = 0 ; i < filters.length ; ++i){
					var filter:FilterWrapper = filters[i];
					var result:BitmapData = filter.applyTo(outputTarget)//,effectApplyRect,effectApplyPoint);
					outputTarget.copyPixels(result,effectApplyRect,effectApplyPoint);
					result.dispose();
				}
				_processTime = getTimer() - _time;
			} else {
				this.sleep();
			}
		}
		
		public function increaseWorkLoad():void
		{
			if (priority < 1) {
				priority--; trace ("priority",priority);
			}
		}
		
		public function decreaseWorkLoad():void
		{
			if (priority > 12){
				priority++; trace ("priority",priority);
			}
		}
		
		private var transformMatrix:Matrix = new Matrix();
		private var _time:uint;
		private var _processTime:uint;
		
		private function inputResizeHandler(evt:ResizeEvent = null):void{
			transformMatrix.createBox(outputTarget.width/videoDisplay.width,outputTarget.height/videoDisplay.height);
		}
	}
}