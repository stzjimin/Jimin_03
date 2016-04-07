package
{
	import flash.display.Sprite;

	public class Assignment_03 extends Sprite
	{
		private var dataQueueTemp:Vector.<BitmapImage>;
		public function Assignment_03()
		{
			new DataLoader("GUI_resources", complete);
		}
		
		private function complete(dataQueue:Vector.<BitmapImage>):void
		{
			dataQueueTemp = dataQueue;
			dataQueueTemp = dataQueueTemp.sort(comparleFunc);
			trace(dataQueueTemp.length);
			
			for(var i:int = 0; i < dataQueueTemp.length; i++)
			{
				var data:BitmapImage = dataQueueTemp[i];
				trace(data.name + " = " + data.pixels);
			}
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
	}
}