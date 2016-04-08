package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
			startPacking_2();
		//	startPacking();
		}
		
		private function comparleFunc(data1:BitmapImage, data2:BitmapImage):int
		{
			if(data1.pixels < data2.pixels) 
			{ 
				return -1;
			} 
			else if(data1.pixels > data2.pixels) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		
		/**
		 *Maxrect알고리즘을 이용한 패킹함수
		 * 각 이미지들이 여유공간을 찾아간 후 해당 이미지와 겹쳐지는 여유공간은 다시 겹쳐지는 부분을 기준으로 분할하는 방법
		 * NOTE @구현방식에 문제가 있는지 속도가 생각만큼 나오지는 않습니다
		 */		
		private function startPacking_2():void
		{
			var rectArray:Vector.<Rectangle> = new Vector.<Rectangle>();
			var mult:uint = 0xFF;
			var bitmapWidth:int = 0;
			var bitmapHeight:int = 0;
			var maxLinHeight:int = _imageStack[_imageStack.length-1].bitmap.height;
			var first_rect:Rectangle = new Rectangle(0, 0, _packedBitmapData.width, _packedBitmapData.height);
			rectArray.push(first_rect);
			trace(first_rect.width + ", " + first_rect.height);
			
			while(_imageStack.length != 0)
			{
				trace("aa");
				var bitmapImage:BitmapImage = _imageStack.pop();
				var vecArrayTemp:Vector.<Rectangle> = new Vector.<Rectangle>();
				for(var i:int = 0; i < rectArray.length; i++)
				{
					trace("ii");
					trace("rectArray[i] = " + rectArray[i].x + ", " + rectArray[i].y);
					if(rectArray[i].containsRect(new Rectangle(rectArray[i].x, rectArray[i].y, bitmapImage.bitmap.width, bitmapImage.bitmap.height)))
					{
						trace(bitmapImage.name + " = " + bitmapImage.bitmap.bitmapData.rect.width + ", " + bitmapImage.bitmap.bitmapData.rect.height);
						var point:Point = new Point(rectArray[i].x, rectArray[i].y);
						var imageRect:Rectangle = bitmapImage.bitmap.bitmapData.rect;
						
						bitmapImage.x = imageRect.x = rectArray[i].x;
						bitmapImage.y = imageRect.y = rectArray[i].y;
						
						_packedBitmapData.merge(bitmapImage.bitmap.bitmapData, bitmapImage.bitmap.bitmapData.rect, point, mult,mult,mult,mult);
						_imageQueue.push(bitmapImage);
						if(maxLinHeight < bitmapImage.y+bitmapImage.bitmap.width)
							maxLinHeight = bitmapImage.y+bitmapImage.bitmap.width;
						
						//이미지와 겹쳐지는 공간이 있다면 해당 공간을 분할
						for(var j:int = rectArray.length-1; j >= 0; j--)
						{
							trace("jj");
						//	var intersection:Rectangle = getIntersection(imageRect, rectArray[j]);
							if(rectArray[j].intersects(imageRect))
							{
								var inter:Rectangle = rectArray[j].intersection(imageRect);
								trace("inter = " + inter.width + ", " + inter.height);
								trace("rectArray[j] = " + rectArray[j].x + ", " + rectArray[j].y + ", " + rectArray[j].width + ", " + rectArray[j].height);
								var rect:Rectangle = rectArray.removeAt(j);
								
								var rightRect:Rectangle = new Rectangle((inter.x+inter.width), rect.y, (rect.x+rect.width-(inter.x+inter.width)), rect.height);
								if(rightRect.width > 0 && rightRect.height > 0)
								{
									vecArrayTemp.push(rightRect);
									trace("rr");
								}
								var leftRect:Rectangle = new Rectangle(rect.x, rect.y, (inter.x-rect.x), rect.height);
								if(leftRect.width > 0 && leftRect.height > 0)
								{
									vecArrayTemp.push(leftRect);
									trace("ll");
								}
								var bottomRect:Rectangle = new Rectangle(rect.x, (inter.y+inter.height), rect.width, (rect.y+rect.height-(inter.y+inter.height)));
								if(bottomRect.width > 0 && bottomRect.height > 0)
								{
									trace("bb");
									vecArrayTemp.push(bottomRect);
								}
								var topRect:Rectangle = new Rectangle(rect.x, rect.y, rect.width, (inter.y-rect.y));
								if(topRect.width > 0 && topRect.height > 0)
								{
									vecArrayTemp.push(topRect);
									trace("tt");
								}
							}
						}
						break;
					}
				}
				
				//분할된 공간들 중 다른 공간에 포함이되는 공간이 있다면 해당 공간은 삭제 시켜준다
				rectArray =	rectArray.concat(vecArrayTemp);
				trace("rectArray.length = " + rectArray.length);
				
				var outAt:Vector.<int> = new Vector.<int>();
				for(var j:int = rectArray.length-1; j >= 0; j--)
				{
					for(var k:int = 0; k < rectArray.length; k++)
					{
						if((rectArray[k].containsRect(rectArray[j])) && (j != k))
						{
							rectArray.removeAt(j);
							break;
						}
					}
				}
			}
		}
		
		/**
		 *높이순으로 정렬된 스택을 pop을 하며 차례로 하나의 비트맵으로 병합 하는 함수
		 * 최대길이에 도달하면 남은 길이에 들어갈 이미지를 찾은 후 해당 이미지를 스택의 마지막부분으로 옮긴 후 다시 함수를 실행
		 */		
		private function startPacking():void
		{
			var mult:uint = 0xFF;
			var bitmapWidth:int = 0;
			var bitmapHeight:int = 0;
			var maxLinHeight:int = _imageStack[_imageStack.length-1].bitmap.height;
			while(_imageStack.length != 0)
			{
				var bitmapImage:BitmapImage = _imageStack.pop();
			//	trace(bitmapImage.name + " = " + bitmapImage.bitmap.width);
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
			
			var testNum:int = 1000;
			trace();
			
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
				trace("서치함");
				for(var i:int = _imageStack.length-1; i >= 0; i--)
				{
					if(_imageStack[i].bitmap.width < fitWidth)
					{
						var bitmapTemp:BitmapImage = _imageStack.removeAt(i);
						_imageStack.push(bitmapTemp);
						return true;
					}
				}
			//	trace("false");
				return false;
			}
		}
	}
}