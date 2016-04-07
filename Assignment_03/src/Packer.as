package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class Packer
	{
		private var _packedBitmapData:BitmapData;
		private var _imageQueue:Vector.<BitmapImage>;
		private static const MaxHeight:int = 1024;
		private static const MaxWidth:int = 1024;
		
		public function Packer()
		{
			_packedBitmapData = new BitmapData(MaxWidth, MaxHeight);
			_imageQueue = new Vector.<BitmapImage>;
			new DataLoader("GUI_resources", completeDataLoad);
		}
		
		public function get packedBitmapData():BitmapData
		{
			return _packedBitmapData;
		}

		private function completeDataLoad(dataQueue:Vector.<BitmapImage>):void
		{
			_imageQueue = dataQueue;
			_imageQueue = _imageQueue.sort(comparleFunc);
			trace(_imageQueue.length);
			
			for(var i:int = 0; i < _imageQueue.length; i++)
			{
				var data:BitmapImage = _imageQueue[i];
			//	trace(data.name + " = " + data.bitmap.height);
			}
			
			startPacking();
			
			function comparleFunc(data1:BitmapImage, data2:BitmapImage):int
			{
				if(data1.bitmap.height < data2.bitmap.height) 
				{ 
					return -1;
				} 
				else if(data1.bitmap.height > data2.bitmap.height) 
				{ 
					return 1; 
				} 
				else 
				{ 
					return 0; 
				} 
			}
		}
		
		private function startPacking():void
		{
			var mult:uint = 0xFF; // 50% 
			var bitmapWidth:int = 0;
			var bitmapHeight:int = 0;
			var maxLinHeight:int = _imageQueue[_imageQueue.length-1].bitmap.height;
			while(_imageQueue.length != 0)
			{
				var bitmapImage:BitmapImage = _imageQueue.pop();
				trace(bitmapImage.name + " = " + bitmapImage.bitmap.width);
				if(bitmapWidth + bitmapImage.bitmap.width >= MaxWidth)
				{
					_imageQueue.push(bitmapImage)
					if(searchFit(MaxWidth - bitmapWidth))
						continue;
					bitmapImage = _imageQueue.pop();
					bitmapHeight += maxLinHeight;
					bitmapWidth = 0;
					maxLinHeight = bitmapImage.bitmap.height;
				}
				if(bitmapHeight + bitmapImage.bitmap.height > MaxHeight)
				{
					trace("너무 큼");
					break;
				}
				_packedBitmapData.merge(bitmapImage.bitmap.bitmapData, bitmapImage.bitmap.bitmapData.rect, new Point(bitmapWidth, bitmapHeight),mult,mult,mult,mult);
				bitmapWidth += bitmapImage.bitmap.width;
			//	_packedBitmapData = _packedBitmapData
			}
			
			function searchFit(fitWidth:int):Boolean
			{
				for(var i:int = _imageQueue.length-1; i >= 0; i--)
				{
					if(_imageQueue[i].bitmap.width < fitWidth)
					{
						var bitmapTemp:BitmapImage = _imageQueue[i];
						trace(bitmapTemp.name);
						_imageQueue.removeAt(i);
						_imageQueue.push(bitmapTemp);
						trace("true");
						return true;
					}
				}
				trace("false");
				return false;
			}
		}
	}
}