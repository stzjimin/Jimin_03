package
{
	import flash.display.Bitmap;

	public class BitmapImage
	{
		private var _bitmap:Bitmap;
		private var _name:String;
		private var _pixels:int;
		private var _x:int;
		private var _y:int;
		
		/**
		 *비트맵이미지는 비트맵과 해당이미지의 이름으로 저장 
		 * @param name = 이미지의 이름
		 * @param bitmap = 해당이미지의 비트맵
		 * 
		 */		
		public function BitmapImage(name:String, bitmap:Bitmap)
		{
			_name = name;
			_bitmap = bitmap;
			_pixels = (_bitmap.width * _bitmap.height);
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
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