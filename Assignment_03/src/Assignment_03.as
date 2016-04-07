package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	public class Assignment_03 extends Sprite
	{	
		public function Assignment_03()
		{
			new DataLoader("GUI_resources", complete);
		}
		
		private function complete(dataQueue:Vector.<BitmapImage>):void
		{
			while(dataQueue.length != 0)
				trace(dataQueue.pop().pixels);
		}
	}
}