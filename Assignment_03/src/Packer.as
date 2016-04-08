package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{	
		private const MaxWidth:int = 1024;
		private const MaxHeight:int = 1024;
		
		private var _packedDataVector:Vector.<PackedData>;
		
		private var _dataQueue:Vector.<BitmapImage>;
		private var _packedBitmapDataWidth:int;
		private var _packedBitmapDataHeight:int;
		
		public function Packer()
		{
			_packedDataVector = new Vector.<PackedData>();
			_dataQueue = new Vector.<BitmapImage>;
		}

		public function get packedDataVector():Vector.<PackedData>
		{
			return _packedDataVector;
		}

		public function get packedBitmapDataHeight():int
		{
			return _packedBitmapDataHeight;
		}

		public function get packedBitmapDataWidth():int
		{
			return _packedBitmapDataWidth;
		}

		/**
		 *비트맵데이터들을 하나의 비트맵데이터로 합치기 위한 함수 
		 * @param dataStack = 비트맵데이터가 들어있는 스택
		 * 합치기전에 높이순으로 정렬한 후 시작
		 */		
		public function goPacking(dataStack:Vector.<BitmapImage>):void
		{
			_dataQueue = dataStack.sort(comparleFunc);
		//	_packedDataVector = packedDataVector;
			
			startPacking();
		}
		
		private function comparleFunc(data1:BitmapImage, data2:BitmapImage):int
		{
			if(data1.pixels > data2.pixels) 
			{ 
				return -1;
			} 
			else if(data1.pixels < data2.pixels) 
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
		private function startPacking():void
		{
			var currentPackedData:PackedData = new PackedData(MaxWidth, MaxHeight);
			_packedDataVector.push(currentPackedData);
			
			var count:int = 0;
			var rectArray:Vector.<Rectangle> = new Vector.<Rectangle>();
			var mult:uint = 0xFF;
			var bitmapWidth:int = 0;
			var bitmapHeight:int = 0;
			currentPackedData.packedBitmapWidth = _dataQueue[_dataQueue.length-1].bitmap.width;
			currentPackedData.packedBitmapHeight = _dataQueue[_dataQueue.length-1].bitmap.height;
			var first_rect:Rectangle = new Rectangle(0, 0, currentPackedData.packedBitmapData.width, currentPackedData.packedBitmapData.height);
			rectArray.push(first_rect);
			
			while(_dataQueue.length != 0)
			{
				var bitmapImage:BitmapImage = _dataQueue.shift();
				var vecArrayTemp:Vector.<Rectangle> = new Vector.<Rectangle>();
				var nonFlag:Boolean = true;
				trace(bitmapImage.name);
				for(var i:int = 0; i < rectArray.length; i++)
				{
					if(rectArray[i].containsRect(new Rectangle(rectArray[i].x, rectArray[i].y, bitmapImage.bitmap.width, bitmapImage.bitmap.height)))
					{
						var point:Point = new Point(rectArray[i].x, rectArray[i].y);
						var imageRect:Rectangle = bitmapImage.bitmap.bitmapData.rect;
						
						bitmapImage.x = imageRect.x = rectArray[i].x;
						bitmapImage.y = imageRect.y = rectArray[i].y;
						
						currentPackedData.packedBitmapData.merge(bitmapImage.bitmap.bitmapData, bitmapImage.bitmap.bitmapData.rect, point, mult,mult,mult,mult);
						currentPackedData.packedImageQueue.push(bitmapImage);
						if(currentPackedData.packedBitmapWidth < bitmapImage.x+bitmapImage.bitmap.width)
							currentPackedData.packedBitmapWidth = bitmapImage.x+bitmapImage.bitmap.width;
						if(currentPackedData.packedBitmapHeight < bitmapImage.y+bitmapImage.bitmap.height)
							currentPackedData.packedBitmapHeight = bitmapImage.y+bitmapImage.bitmap.height;
						
						//이미지와 겹쳐지는 공간이 있다면 해당 공간을 분할
						for(var l:int = rectArray.length-1; l >= 0; l--)
						{
							if(rectArray[l].intersects(imageRect))
							{
								var inter:Rectangle = rectArray[l].intersection(imageRect);
								var rect:Rectangle = rectArray.removeAt(l);
								
								var rightRect:Rectangle = new Rectangle((inter.x+inter.width), rect.y, (rect.x+rect.width-(inter.x+inter.width)), rect.height);
								if(rightRect.width > 0 && rightRect.height > 0)
									vecArrayTemp.push(rightRect);
								var leftRect:Rectangle = new Rectangle(rect.x, rect.y, (inter.x-rect.x), rect.height);
								if(leftRect.width > 0 && leftRect.height > 0)
									vecArrayTemp.push(leftRect);
								var bottomRect:Rectangle = new Rectangle(rect.x, (inter.y+inter.height), rect.width, (rect.y+rect.height-(inter.y+inter.height)));
								if(bottomRect.width > 0 && bottomRect.height > 0)
									vecArrayTemp.push(bottomRect);
								var topRect:Rectangle = new Rectangle(rect.x, rect.y, rect.width, (inter.y-rect.y));
								if(topRect.width > 0 && topRect.height > 0)
									vecArrayTemp.push(topRect);
							}
						}
						nonFlag = false;
						break;
					}
				}
				
				if(nonFlag)
				{
					count++;
					_dataQueue.push(bitmapImage);
					if(_dataQueue.length <= count)
						startPacking.apply(this);
				}
				
				//분할된 공간들 중 다른 공간에 포함이되는 공간이 있다면 해당 공간은 삭제 시켜준다
				rectArray =	rectArray.concat(vecArrayTemp);

				for(var h:int = rectArray.length-1; h >= 0; h--)
				{
					for(var k:int = 0; k < rectArray.length; k++)
					{
						if((rectArray[k].containsRect(rectArray[h])) && (h != k))
						{
							rectArray.removeAt(h);
							break;
						}
					}
				}
			}
		}
	}
}