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
		
		/**
		 *파일들을 패킹하기전 준비를위한 함수입니다. 
		 * 준비를위해서 이미지들이 들어있던 폴더와 같은위치로 파일의 경로를 설정합니다.
		 *  카운트도 초기화해줍니다.
		 */		
		public function setEncode():void
		{
		//	_localPath = File.desktopDirectory.resolvePath(DataLoader.libName + "_SpriteSheet");
			_localPath = File.documentsDirectory.resolvePath("SpriteSheet");
			_count = 0;
		}
		
		/*
		public function setEncodeDirectory():void
		{
			
		}
		*/
		
		/**
		 *인자로 입력받은 PackedData를 사용하여 png파일과 xml파일을 만드는 함수입니다. 
		 * @param packedData = 패킹할 이미지에대한 정보
		 * 이미지를 패킹해주고 카운트를 증가시켜줍니다(카운트는 파일명을 변경해주기위해서 사용합니다);
		 */		
		public function encodeFromData(packedData:PackedData):void
		{
			getPngEncode(packedData, "SpriteSheet_" + _count);
			getXmlEncode(packedData.packedImageQueue, "SpriteSheet_" + _count);
			_count++;
		}
		
		/**
		 *인자로 받아오는 PackedData를 사용하여  png파일을 생성하는 함수입니다.
		 * @param packedData = 패킹할 이미지에대한 정보
		 * @param fileName = 파일의 이름
		 * 
		 */		
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
		
		/**
		 *인자로 받아오는 imageQueue를 사용하여 xml파일을 생성하는 함수입니다. 
		 * @param imageQueue = 패킹될 이미지에 들어가있는 이미지들의 정보(BitmapImage의  Vector배열)
		 * @param fileName = 파일의 이름
		 * 
		 */		
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