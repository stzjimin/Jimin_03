package
{
	import flash.display.BitmapData;

	public class PackedData
	{	
		private var _packedBitmapData:BitmapData;
		private var _packedImageQueue:Vector.<BitmapImage>;
		private var _packedBitmapWidth:int;
		private var _packedBitmapHeight:int;
		
		public function PackedData(maxWidth:int, maxHeight:int)
		{
			_packedBitmapData = new BitmapData(maxWidth, maxHeight);
			_packedImageQueue = new Vector.<BitmapImage>();
		}

		public function get packedBitmapHeight():int
		{
			return _packedBitmapHeight;
		}

		public function set packedBitmapHeight(value:int):void
		{
			_packedBitmapHeight = value;
		}

		public function get packedBitmapWidth():int
		{
			return _packedBitmapWidth;
		}

		public function set packedBitmapWidth(value:int):void
		{
			_packedBitmapWidth = value;
		}

		public function get packedImageQueue():Vector.<BitmapImage>
		{
			return _packedImageQueue;
		}

		public function set packedImageQueue(value:Vector.<BitmapImage>):void
		{
			_packedImageQueue = value;
		}

		public function get packedBitmapData():BitmapData
		{
			return _packedBitmapData;
		}

		public function set packedBitmapData(value:BitmapData):void
		{
			_packedBitmapData = value;
		}

	}
}