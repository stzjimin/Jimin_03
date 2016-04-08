package
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class Encoder
	{
		public function Encoder()
		{
			
		}
		
		/*
		public function startEncode():void
		{
			var bitmapData:BitmapData = _packer.packedBitmapVector[0];
			var byteArray:ByteArray = new ByteArray();
			//	bitmapData.encode(new Rectangle(0, 0, _packer.packedBitmapDataWidth, _packer.packedBitmapDataHeight), new PNGEncoderOptions(), byteArray);
			bitmapData.encode(new Rectangle(0, 0, 1024, 1024), new PNGEncoderOptions(), byteArray);
			
			var localFile:File = File.documentsDirectory.resolvePath("bild.png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
			
			/*
			var imageQueue:Vector.<BitmapImage> = _packer.imageQueue;
			trace("test.length = " + imageQueue.length);
			
			localFile = File.documentsDirectory.resolvePath("bild.xml");
			fileAccess.open(localFile, FileMode.WRITE);
			fileAccess.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			fileAccess.writeUTFBytes("<TextureAtlas ImagePath=\"" + "bild.png" + "\">\n");
			while(imageQueue.length != 0)
			{
			var image:BitmapImage = imageQueue.shift();
			fileAccess.writeUTFBytes("<SubTexture name=\"" + image.name + "\" x=\"" + image.x + "\" y=\"" + image.y + "\" width=\"" + image.bitmap.width + "\" height=\"" + image.bitmap.height + "\"/>\n");
			}
			fileAccess.writeUTFBytes("</TextureAtlas>");
			fileAccess.close();
			
		}
		*/
	}
}