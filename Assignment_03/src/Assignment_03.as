package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;

	[SWF(width="1024", height="1024", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		private var _packer:Packer = new Packer();
		
		/**
		 *프로그램이 시작될 때 이미지파일들을 로딩 
		 * 
		 */		
		public function Assignment_03()
		{
			new DataLoader("GUI_resources", completeDataLoad);
		//	addChild(new Bitmap(packer.packedBitmapData));
		}
		
		/**
		 *로딩이 완료될 경우 Packer클래스에서 해당 데이타들을 패킹을 해준 후 화면에 출력
		 * imageQueue는 화면에 출력된 순서대로 BitmapImage객체들이 저장되어있는 큐
		 * 
		 */		
		private function completeDataLoad():void
		{
			_packer.goPacking(DataLoader.dataStack);
			addChild(new Bitmap(_packer.packedBitmapData));
			
			var bitmapData:BitmapData = _packer.packedBitmapData;
			var byteArray:ByteArray = new ByteArray();
		//	bitmapData.encode(new Rectangle(0, 0, _packer.packedBitmapDataWidth, _packer.packedBitmapDataHeight), new PNGEncoderOptions(), byteArray);
			bitmapData.encode(new Rectangle(0, 0, 1024, 1024), new PNGEncoderOptions(), byteArray);
			
			var localFile:File = File.documentsDirectory.resolvePath("bild.png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
			
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
	}
}