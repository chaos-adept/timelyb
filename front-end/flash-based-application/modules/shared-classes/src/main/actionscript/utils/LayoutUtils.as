package utils 
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author DES
	 */
	public class LayoutUtils 
	{
		
		public static const WIDTH:int = 1280;
		public static const HEIGHT:int = 800;
		
		private static const origin_rect:Rectangle = new Rectangle(0, 0, WIDTH, HEIGHT);
		
		public function LayoutUtils() 
		{
			
		}
		
		public static function fitSize(viewAreaRect:Rectangle, targetAreaRect:Rectangle, target:DisplayObject):void {
				var newScaleX:Number =  (viewAreaRect.width) / targetAreaRect.width;
				var newScaleY:Number = viewAreaRect.height / targetAreaRect.height;
				var newScale:Number = newScaleX > newScaleY ? newScaleY : newScaleX;	
				target.scaleX = newScale; 
				target.scaleY = newScale; 
				target.x = viewAreaRect.x - targetAreaRect.x*newScale + (viewAreaRect.width - targetAreaRect.width*newScale)/2;
				target.y = viewAreaRect.y - targetAreaRect.y*newScale + (viewAreaRect.height - targetAreaRect.height*newScale)/2;	
		}

        public static function center(targetRect:Rectangle, image:DisplayObject):void {
            image.x = (targetRect.width - image.width)/2;
            image.y = (targetRect.height - image.height)/2;
        }

        public static function fitRectWithoutSpace(stageRect:Rectangle, docRect:Rectangle):Rectangle {
            var factor = stageRect.height / docRect.height
            var newDocWidth:Number = docRect.width * factor;
            var newDocHeight:Number = docRect.height * factor;
            var newDocX:int = (stageRect.width - newDocWidth) / 2;
            var newDocY:int = (stageRect.height - newDocHeight) / 2;
            return new Rectangle(newDocX, newDocY, newDocWidth, newDocHeight);
        }

        public static function doLayout(stage:Stage, viewArea:MovieClip, viewAreaMask:MovieClip, initRect:Rectangle = null):void {

			if (initRect == null) {
				initRect = origin_rect;
			}
			
            var initX:Number = initRect.x;
            var initY:Number = initRect.y;

            var initWidht:Number = initRect.width - initX;
            var initHeight:Number = initRect.height - initY;

            var viewAreaRect:Rectangle = new Rectangle(stage.x, stage.y, stage.stageWidth, stage.stageHeight);
            var targetAreaRect:Rectangle = new Rectangle(initX, initY, initWidht, initHeight);
            //when
            //var newDocRect:Rectangle = LayoutUtils.fitRectWithoutSpace(viewAreaRect, targetAreaRect);
            viewArea.scaleY = viewAreaRect.height / targetAreaRect.height;
            viewArea.scaleX = viewArea.scaleY;
            viewArea.x = viewAreaRect.width / 2 - ((initWidht)/2) * viewArea.scaleX - initX* viewArea.scaleX //- 24 * viewArea.scaleX;
            viewArea.y = viewAreaRect.height / 2 - ((initHeight)/2) * viewArea.scaleY - initY* viewArea.scaleY;


            targetAreaRect.inflate(viewArea.scaleX, viewArea.scaleY)

			if (viewAreaMask) {
				viewAreaMask.graphics.clear();
				viewAreaMask.graphics.lineStyle(1, 0x000000);
				viewAreaMask.graphics.beginFill(0x0000ff, 0.5);
				viewAreaMask.graphics.drawRect(viewArea.x, 0, initWidht* viewArea.scaleX, initHeight* viewArea.scaleX);
				viewAreaMask.graphics.endFill();				
			}
        }

        public static function doStretch(stage:Stage, viewArea:DisplayObject, viewAreaMask:MovieClip, initRect:Rectangle = null):void {

            if (initRect == null) {
                initRect = origin_rect;
            }

            var initX:Number = initRect.x;
            var initY:Number = initRect.y;

            var initWidht:Number = initRect.width ;
            var initHeight:Number = initRect.height;

            var stageArea:Rectangle = new Rectangle(stage.x, stage.y, stage.stageWidth, stage.stageHeight);
            var targetAreaRect:Rectangle = new Rectangle(initX, initY, initWidht, initHeight);
            //when
            //var newDocRect:Rectangle = LayoutUtils.fitRectWithoutSpace(stageArea, targetAreaRect);

                viewArea.scaleY = stageArea.height / targetAreaRect.height;
                viewArea.scaleX = viewArea.scaleY;

                targetAreaRect.x *= viewArea.scaleX;
                targetAreaRect.y *= viewArea.scaleY;
                targetAreaRect.width *= viewArea.scaleX;
                targetAreaRect.height *= viewArea.scaleY;


            viewArea.x =  - targetAreaRect.x + stageArea.width/2 - targetAreaRect.width/2;//(stageArea.width/2 - (targetAreaRect.width/2 + targetAreaRect.x));//stageArea.width / 2 - (targetAreaRect.width ) /2 - targetAreaRect.x;//((initWidht)/2) * viewArea.scaleX - initX* viewArea.scaleX //- 24 * viewArea.scaleX;
            viewArea.y =  - targetAreaRect.y + stageArea.height/2 - targetAreaRect.height/2;

            if (viewAreaMask) {
                viewAreaMask.graphics.clear();
                viewAreaMask.graphics.lineStyle(1, 0x000000);
                viewAreaMask.graphics.beginFill(0x0000ff, 0.5);
                viewAreaMask.graphics.drawRect(viewArea.x, 0, initWidht* viewArea.scaleX, initHeight* viewArea.scaleX);
                viewAreaMask.graphics.endFill();
            }
        }

    }

}