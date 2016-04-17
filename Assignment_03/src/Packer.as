package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{	
		private const MaxWidth:int = 1024;
		private const MaxHeight:int = 1024;
		
		private var _dataQueue:Vector.<BitmapImage>;
		private var _currentPackedData:PackedData;
		
		private var _changeFunc:Function;
		
		private var _count:int;
		private var _spaceArray:Vector.<Rectangle>;
		
		public function Packer(changeFunc:Function)
		{
			_changeFunc = changeFunc;
		}
		
		public function get currentPackedData():PackedData
		{
			return _currentPackedData;
		}
		
		/**
		 *Packer클래스에서 초기화를 위한 함수입니다. 
		 * @param dataStack
		 * 
		 */		
		public function initPacker(dataStack:Vector.<BitmapImage>):void
		{
			_dataQueue = dataStack;
			initPackedData();
		}
		
		/**
		 *_dataQueue에 있는 이미지중 가장 앞에있는 이미지 하나를 가져와 패킹하는 함수입니다. 
		 * @return = 리턴값으로 추가되는 이미지에 대한 정보를가진 BitmapImage객체를 반환해줍니다.
		 * 호출은 Assignment_03클래스에서 하게되며 호출되면 반환값으로 추가되는 이미지의 정보를가진 BitmapImage객체를 반환해줍니다.
		 */		
		public function addImage():BitmapImage
		{
			var bitmapImage:BitmapImage = _dataQueue.shift();
			var nonFlag:Boolean = true;
			for(var i:int = 0; i < _spaceArray.length; i++)
			{
				if(_spaceArray[i].containsRect(new Rectangle(_spaceArray[i].x, _spaceArray[i].y, bitmapImage.bitmap.width, bitmapImage.bitmap.height)))
				{
					var point:Point = new Point(_spaceArray[i].x, _spaceArray[i].y);
					var imageRect:Rectangle = bitmapImage.bitmap.bitmapData.rect;
					
					bitmapImage.x = imageRect.x = _spaceArray[i].x;
					bitmapImage.y = imageRect.y = _spaceArray[i].y;
					
					_currentPackedData.packedBitmapData.merge(bitmapImage.bitmap.bitmapData, bitmapImage.bitmap.bitmapData.rect, point, 0xFF,0xFF,0xFF,0xFF);
					_currentPackedData.packedImageQueue.push(bitmapImage);
					
					//이미지와 겹쳐지는 공간이 있다면 해당 공간을 분할
					searchIntersects(_spaceArray, imageRect);
					
					nonFlag = false;
					break;
				}
			}
			
			//추가하려는 이미지가  들어갈 수 있는 공간이 없을 경우
			if(nonFlag)
			{
				_count++;
				_dataQueue.push(bitmapImage);
				if(_dataQueue.length <= _count)
					_changeFunc(_currentPackedData);
				return null;
			}
			
			_spaceArray.sort(orderYvalue);	//여유공간을  y값으로 정렬하여 상대적으로 아래쪽에 있는 공간은 나중에 선택이 되도록 합니다
			return bitmapImage;
		}
		
		private function orderName(data1:BitmapImage, data2:BitmapImage):int
		{
			if(data1.name < data2.name) 
			{ 
				return -1;
			} 
			else if(data1.name > data2.name) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
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
		 *Pacer가 패킹을 하기전 준비를 위한 함수입니다. 
		 * 준비를 위한 연산들(새로운 밑바탕이 되는 비트맵데이터의 생성, 카운트를 초기화, 여유공간을 초기화)을 모아놓았습니다.
		 */		
		private function initPackedData():void
		{
			_dataQueue = _dataQueue.sort(orderPixels);
			_currentPackedData = new PackedData(MaxWidth, MaxHeight);
			
			_count = 0;
			_spaceArray = new Vector.<Rectangle>();
			var firstRect:Rectangle = new Rectangle(0, 0, _currentPackedData.packedBitmapData.width, _currentPackedData.packedBitmapData.height);
			
			_spaceArray.push(firstRect);
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