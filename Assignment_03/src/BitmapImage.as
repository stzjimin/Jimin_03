package
{
	import flash.display.Bitmap;

	public class BitmapImage
	{
		private var _bitmap:Bitmap;
		private var _name:String;
		private var _pixels:int;
		
		public function BitmapImage(name:String, bitmap:Bitmap)
		{
			_name = name;
			_bitmap = bitmap;
			_pixels = _bitmap.width * _bitmap.height;
		}

		public function get pixels():int
		{
			return _pixels;
		}

		public function get name():String
		{
			return _name;
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

	}
}