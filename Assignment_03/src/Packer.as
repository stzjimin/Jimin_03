package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class Packer
	{
		private var _packedBitmapData:BitmapData;
		private var _imageStack:Vector.<BitmapImage>;
		private static const MaxHeight:int = 1024;
		private static const MaxWidth:int = 1024;
		
		public function Packer()
		{
			_packedBitmapData = new BitmapData(MaxWidth, MaxHeight);
			_imageStack = new Vector.<BitmapImage>;
			new DataLoader("GUI_resources", completeDataLoad);
		}
		
		public function get packedBitmapData():BitmapData
		{
			return _packedBitmapData;
		}

		private function completeDataLoad(dataStack:Vector.<BitmapImage>):void
		{
			_imageStack = dataStack;
			_imageStack = _imageStack.sort(comparleFunc);
			trace(_imageStack.length);
			
			for(var i:int = 0; i < _imageStack.length; i++)
			{
				var data:BitmapImage = _imageStack[i];
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
			var maxLinHeight:int = _imageStack[_imageStack.length-1].bitmap.height;
			while(_imageStack.length != 0)
			{
				var bitmapImage:BitmapImage = _imageStack.pop();
				trace(bitmapImage.name + " = " + bitmapImage.bitmap.width);
				if(bitmapWidth + bitmapImage.bitmap.width >= MaxWidth)
				{
					_imageStack.push(bitmapImage)
					if(searchFit(MaxWidth - bitmapWidth))
						continue;
					bitmapImage = _imageStack.pop();
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
			}
			
			function searchFit(fitWidth:int):Boolean
			{
				for(var i:int = _imageStack.length-1; i >= 0; i--)
				{
					if(_imageStack[i].bitmap.width < fitWidth)
					{
						var bitmapTemp:BitmapImage = _imageStack[i];
						trace(bitmapTemp.name);
						_imageStack.removeAt(i);
						_imageStack.push(bitmapTemp);
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