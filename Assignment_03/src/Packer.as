package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class Packer
	{
		private static const MaxHeight:int = 1024;
		private static const MaxWidth:int = 1024;
		
		private var _packedBitmapData:BitmapData;
		private var _imageStack:Vector.<BitmapImage>;
		private var _imageQueue:Vector.<BitmapImage>;
		private var _packedBitmapDataWidth:int;
		private var _packedBitmapDataHeight:int;
		
		public function Packer()
		{
			_packedBitmapData = new BitmapData(MaxWidth, MaxHeight);
			_imageStack = new Vector.<BitmapImage>;
			_imageQueue = new Vector.<BitmapImage>;
			var bit:Bitmap = new Bitmap();
		}
		
		public function get packedBitmapDataHeight():int
		{
			return _packedBitmapDataHeight;
		}

		public function get packedBitmapDataWidth():int
		{
			return _packedBitmapDataWidth;
		}

		public function get imageQueue():Vector.<BitmapImage>
		{
			return _imageQueue;
		}

		public function get packedBitmapData():BitmapData
		{
			return _packedBitmapData;
		}

		/**
		 *비트맵데이터들을 하나의 비트맵데이터로 합치기 위한 함수 
		 * @param dataStack = 비트맵데이터가 들어있는 스택
		 * 합치기전에 높이순으로 정렬한 후 시작
		 */		
		public function goPacking(dataStack:Vector.<BitmapImage>):void
		{
			_imageStack = dataStack.sort(comparleFunc);
			trace(_imageStack.length);
			
			for(var i:int = 0; i < _imageStack.length; i++)
			{
				var data:BitmapImage = _imageStack[i];
			//	trace(data.name + " = " + data.bitmap.height);
			}
			
			startPacking();
		}
		
		private function comparleFunc(data1:BitmapImage, data2:BitmapImage):int
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
		
		/**
		 *높이순으로 정렬된 스택을 pop을 하며 차례로 하나의 비트맵으로 병합 하는 함수
		 * 최대길이에 도달하면 남은 길이에 들어갈 이미지를 찾은 후 해당 이미지를 스택의 마지막부분으로 옮긴 후 다시 함수를 실행
		 */		
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
				bitmapImage.x = bitmapWidth;
				bitmapImage.y = bitmapHeight;
				_imageQueue.push(bitmapImage);
				bitmapWidth += bitmapImage.bitmap.width;
				if(_packedBitmapDataWidth < bitmapWidth)
					_packedBitmapDataWidth = bitmapWidth;
				_packedBitmapDataHeight = bitmapImage.y + maxLinHeight;
			}
			trace("전w = " + _packedBitmapDataWidth);
			trace("전h = " + _packedBitmapDataHeight);
			
			var count:int = 2;
			while(true)
			{
				if(count < _packedBitmapDataWidth)
					count *= 2;
				else
				{
					_packedBitmapDataWidth = count;
					break;
				}
			}
			
			count = 2;
			while(true)
			{
				if(count < _packedBitmapDataHeight)
					count *= 2;
				else
				{
					_packedBitmapDataHeight = count;
					break;
				}
			}
			
			trace("후w = " + _packedBitmapDataWidth);
			trace("후h = " + _packedBitmapDataHeight);
			
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