package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;

	[SWF(width="1024", height="1024", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		public function Assignment_03()
		{
			var packer:Packer = new Packer();
			addChild(new Bitmap(packer.packedBitmapData));
		}
	}
}