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
		private const binaryReg:RegExp = new RegExp("^10*$", "m");
		private const fileReg:RegExp = new RegExp("(.png|.jpg|.jpeg)$", "m");
		
		public function Encoder()
		{
			
		}
		
		public function startEncode(packedDataVector:Vector.<PackedData>):void
		{	
			for(var i:int = 0; i < packedDataVector.length; i++)
			{
				getPngEncode(packedDataVector[i], DataLoader.libName + "_" + i);
				getXmlEncode(packedDataVector[i].packedImageQueue, DataLoader.libName + "_" + i);
			}
		}
		
		private function getPngEncode(packedData:PackedData, fileName:String):void
		{
			var bitmapData:BitmapData = packedData.packedBitmapData;
			var byteArray:ByteArray = new ByteArray();
			
			var binary:String = packedData.packedBitmapWidth.toString(2);
			if(!binary.match(binaryReg))
				packedData.packedBitmapWidth = Math.pow(2,binary.length);
			
			binary = packedData.packedBitmapHeight.toString(2);
			if(!binary.match(binaryReg))
				packedData.packedBitmapHeight = Math.pow(2,binary.length);
			
			bitmapData.encode(new Rectangle(0, 0, packedData.packedBitmapWidth, packedData.packedBitmapHeight), new PNGEncoderOptions(), byteArray);
			
			var localPngFile:File = File.documentsDirectory.resolvePath(fileName + ".png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localPngFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
		}
		
		private function getXmlEncode(imageQueue:Vector.<BitmapImage>, fileName:String):void
		{
			var localXmlFile:File = File.documentsDirectory.resolvePath(fileName + ".xml");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localXmlFile, FileMode.WRITE);
			fileAccess.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			fileAccess.writeUTFBytes("<TextureAtlas ImagePath=\"" + fileName + ".png" + "\">\n");
			while(imageQueue.length != 0)
			{
				var image:BitmapImage = imageQueue.shift();
				fileAccess.writeUTFBytes("<SubTexture name=\"" + image.name.replace(fileReg,"") + "\" x=\"" + image.x + "\" y=\"" + image.y + "\" width=\"" + image.bitmap.width + "\" height=\"" + image.bitmap.height + "\"/>\n");
			}
			fileAccess.writeUTFBytes("</TextureAtlas>");
			fileAccess.close();
		}
	}
}