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
		
		public function Packer()
		{
			_packedDataVector = new Vector.<PackedData>();
		}

		public function get packedDataVector():Vector.<PackedData>
		{
			return _packedDataVector;
		}

		/**
		 *비트맵데이터들을 하나의 비트맵데이터로 합치기 위한 함수 
		 * @param dataStack = 비트맵데이터가 들어있는 스택
		 * 합치기전에 높이순으로 정렬한 후 시작
		 */		
		public function goPacking(dataStack:Vector.<BitmapImage>):void
		{
			_dataQueue = dataStack.sort(orderPixels);
			
			startPacking();
		}
		
		private function orderPixels(data1:BitmapImage, data2:BitmapImage):int
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
			var spaceArray:Vector.<Rectangle> = new Vector.<Rectangle>();
			var mult:uint = 0xFF;
			var bitmapWidth:int = 0;
			var bitmapHeight:int = 0;
			currentPackedData.packedBitmapWidth = _dataQueue[_dataQueue.length-1].bitmap.width;
			currentPackedData.packedBitmapHeight = _dataQueue[_dataQueue.length-1].bitmap.height;
			var first_rect:Rectangle = new Rectangle(0, 0, currentPackedData.packedBitmapData.width, currentPackedData.packedBitmapData.height);
			spaceArray.push(first_rect);
			
			while(_dataQueue.length != 0)
			{
				var bitmapImage:BitmapImage = _dataQueue.shift();
				var nonFlag:Boolean = true;
				for(var i:int = 0; i < spaceArray.length; i++)
				{
					if(spaceArray[i].containsRect(new Rectangle(spaceArray[i].x, spaceArray[i].y, bitmapImage.bitmap.width, bitmapImage.bitmap.height)))
					{
						var point:Point = new Point(spaceArray[i].x, spaceArray[i].y);
						var imageRect:Rectangle = bitmapImage.bitmap.bitmapData.rect;
						
						bitmapImage.x = imageRect.x = spaceArray[i].x;
						bitmapImage.y = imageRect.y = spaceArray[i].y;
						
						currentPackedData.packedBitmapData.merge(bitmapImage.bitmap.bitmapData, bitmapImage.bitmap.bitmapData.rect, point, mult,mult,mult,mult);
						currentPackedData.packedImageQueue.push(bitmapImage);
						if(currentPackedData.packedBitmapWidth < bitmapImage.x+bitmapImage.bitmap.width)
							currentPackedData.packedBitmapWidth = bitmapImage.x+bitmapImage.bitmap.width;
						if(currentPackedData.packedBitmapHeight < bitmapImage.y+bitmapImage.bitmap.height)
							currentPackedData.packedBitmapHeight = bitmapImage.y+bitmapImage.bitmap.height;
						
						//이미지와 겹쳐지는 공간이 있다면 해당 공간을 분할
						searchIntersects(spaceArray, imageRect);
						
						nonFlag = false;
						break;
					}
				}
				
				//추가하려는 이미지가  들어갈 수 있는 공간이 없을 경우
				if(nonFlag)
				{
					count++;
					_dataQueue.push(bitmapImage);
					if(_dataQueue.length <= count)
						startPacking.apply(this);
					continue;
				}
				
				spaceArray.sort(orderYvalue);	//여유공간을  y값으로 정렬하여 상대적으로 아래쪽에 있는 공간은 나중에 선택이 되도록 합니다
			}
		}
		
		/**
		 *공간들 중 이미지와 겹쳐지는 공간을 찾아내서 해당공간을 분할하는 함수입니다
		 * @param spaceArray = 남아있는공간
		 * @param imageRect = 추가되는 이미지가 차지하는 자리
		 * 자리를 찾아서 추가되는 이미지가 차지하는 공간과 기존의 여유공간들이 겹쳐지는지를 조사한 후 겹쳐진다면 겹쳐지는 공간을 토대로 해당 여유공간을 분할합니다
		 */		
		private function searchIntersects(spaceArray:Vector.<Rectangle>, imageRect:Rectangle):void
		{
			for(var i:int = spaceArray.length-1; i >= 0; i--)
			{
				if(spaceArray[i].intersects(imageRect))
				{
					var inter:Rectangle = spaceArray[i].intersection(imageRect);
					var rect:Rectangle = spaceArray.removeAt(i);
					
					var leftRect:Rectangle = new Rectangle(rect.x, rect.y, (inter.x-rect.x), rect.height);
					if(leftRect.width > 0 && leftRect.height > 0)
						spaceArray.push(leftRect);
					var rightRect:Rectangle = new Rectangle((inter.x+inter.width), rect.y, (rect.x+rect.width-(inter.x+inter.width)), rect.height);
					if(rightRect.width > 0 && rightRect.height > 0)
						spaceArray.push(rightRect);
					var bottomRect:Rectangle = new Rectangle(rect.x, (inter.y+inter.height), rect.width, (rect.y+rect.height-(inter.y+inter.height)));
					if(bottomRect.width > 0 && bottomRect.height > 0)
						spaceArray.push(bottomRect);
					var topRect:Rectangle = new Rectangle(rect.x, rect.y, rect.width, (inter.y-rect.y));
					if(topRect.width > 0 && topRect.height > 0)
						spaceArray.push(topRect);
				}
			}
			removeContains(spaceArray);
		}
		
		/**
		 *여유공간들 중 다른공간에 완전히 포함이되는 공간을 제거하는 함수입니다
		 * @param spaceArray = 남아있는 여유공간을 가진 배열
		 * 
		 */		
		private function removeContains(spaceArray:Vector.<Rectangle>):void
		{
			for(var i:int = spaceArray.length-1; i >= 0; i--)
			{
				for(var j:int = 0; j < spaceArray.length; j++)
				{
					if((spaceArray[j].containsRect(spaceArray[i])) && (i != j))
					{
						spaceArray.removeAt(i);
						break;
					}
				}
			}	
		}
		
		private function orderXvalue(space1:Rectangle, space2:Rectangle):int
		{
			if(space1.x < space2.x) 
			{ 
				return -1;
			} 
			else if(space1.x > space2.x)
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		
		private function orderYvalue(space1:Rectangle, space2:Rectangle):int
		{
			if(space1.y < space2.y) 
			{ 
				return -1;
			} 
			else if(space1.y > space2.y)
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
	}
}