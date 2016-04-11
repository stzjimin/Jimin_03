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
				var bitmapData:BitmapData = packedDataVector[i].packedBitmapData;
				var byteArray:ByteArray = new ByteArray();
				
				var binary:String = int(packedDataVector[i].packedBitmapWidth).toString(2);
				if(!binary.match(binaryReg))
					packedDataVector[i].packedBitmapWidth = Math.pow(2,binary.length);
				
				binary = int(packedDataVector[i].packedBitmapHeight).toString(2);
				if(!binary.match(binaryReg))
					packedDataVector[i].packedBitmapHeight = Math.pow(2,binary.length);

				bitmapData.encode(new Rectangle(0, 0, packedDataVector[i].packedBitmapWidth, packedDataVector[i].packedBitmapHeight), new PNGEncoderOptions(), byteArray);
				
				var localFile:File = File.documentsDirectory.resolvePath(DataLoader.libName + "_" + i + ".png");
				var fileAccess:FileStream = new FileStream();
				fileAccess.open(localFile, FileMode.WRITE);
				fileAccess.writeBytes(byteArray, 0, byteArray.length);
				fileAccess.close();
				
				
				var imageQueue:Vector.<BitmapImage> = packedDataVector[i].packedImageQueue;
				
				localFile = File.documentsDirectory.resolvePath(DataLoader.libName + "_" + i + ".xml");
				fileAccess.open(localFile, FileMode.WRITE);
				fileAccess.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
				fileAccess.writeUTFBytes("<TextureAtlas ImagePath=\"" + DataLoader.libName + "_" + i + ".png" + "\">\n");
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
}