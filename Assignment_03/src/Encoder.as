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
		
		private var _localPath:File;
		private var _time:Number;
		private var _count:int;
		
		public function Encoder()
		{
			
		}
		
		public function setEncode():void
		{
			_localPath = File.desktopDirectory.resolvePath(DataLoader.libName + "_SpriteSheet");
			_count = 0;
		}
		
		public function encodeFromVector(packedDataVector:Vector.<PackedData>):void
		{
			for(var i:int = _count; i < packedDataVector.length; i++)
				encodeFromData(packedDataVector[i]);
		}
		
		public function encodeFromDisplay(packedDataVector:Vector.<PackedData>):Boolean
		{
			if(packedDataVector.length > _count)
			{
				encodeFromData(packedDataVector[packedDataVector.length - 1]);
				return true;
			}
			return false;
		}
		
		private function encodeFromData(packedData:PackedData):void
		{
			getPngEncode(packedData, "SpriteSheet_" + _count);
			getXmlEncode(packedData.packedImageQueue, "SpriteSheet_" + _count);
			_count++;
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
			
			var localPngFile:File = _localPath.resolvePath(fileName + ".png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localPngFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
		}
		
		private function getXmlEncode(imageQueue:Vector.<BitmapImage>, fileName:String):void
		{
			var localXmlFile:File = _localPath.resolvePath(fileName + ".xml");
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