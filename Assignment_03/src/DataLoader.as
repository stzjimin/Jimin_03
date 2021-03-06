package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	public class DataLoader
	{	
		private const appReg:RegExp = new RegExp(/app:\//);
		
		private var _dataStack:Vector.<BitmapImage>;	//반환될 BitmapImage의 백터배열
		private var _libName:String;
		
		private var _completeFunc:Function;
		private var _assetLength:int = 1;			//폴더내의 파일 개수
		private var _assetCounter:int = 0;		//로드된 비트맵의 개수
		private var _fileURL:String;
		
		/**
		 *데이타 로더는 폴더내부의 이미지들을 모두 받아옴(starling에 있는 AssetManager를 참고)
		 * @param libName = 폴더이름
		 * @param func = 반환하기위한 함수
		 * 
		 */		
		public function DataLoader(libName:String, completeFunc:Function)
		{
			_dataStack = new Vector.<BitmapImage>();
			_completeFunc = completeFunc;
			
			_libName = libName;
			_fileURL = "file:///" + _libName.replace(new RegExp(/\\/g),"/");
			pushStack(File.applicationDirectory.resolvePath(_libName));
		}
		
		public function get libName():String
		{
			return _libName;
		}
		
		public function get dataStack():Vector.<BitmapImage>
		{
			return _dataStack;
		}
		
		/**
		 * 폴더의 경로로 들어간 뒤 해당 폴더내의 이미지들을 로드하기위한 함수
		 * @param rawAssets
		 * 
		 */		
		private function pushStack(...rawAssets):void
		{
			if(!rawAssets["isDirectory"])
				_assetLength = _assetLength + rawAssets.length - 1;
			trace(_assetLength);
			for each(var rawAsset:Object in rawAssets)
			{
				if(rawAsset["isDirectory"])
					pushStack.apply(this, rawAsset["getDirectoryListing"]());
				else if(getQualifiedClassName(rawAsset) == "flash.filesystem::File")
				{
					var urlRequest:URLRequest = new URLRequest(decodeURI(rawAsset["url"]).replace(appReg,""));
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
					loader.load(urlRequest);
				}
			}
		}
		
		/**
		 *이미지파일의 URL주소로 해당 이미지파일의 이름을 구하는 함수 
		 * @param rawAssetURL
		 * @return 
		 * 
		 */		
		private function getName(rawAssetURL:String):String
		{
			var fileName:String;
			
			fileName = rawAssetURL.replace(_fileURL + "/","");
			
			return fileName;
		}
		
		/**
		 *로더의 IO애러시 호출될 함수 
		 * @param event
		 * 
		 */		
		private function uncaughtError(event:IOErrorEvent):void
		{
			trace("Please Check Directory's File!!");
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_assetCounter++;
		}
		
		/**
		 *로더가 개별 이미지의 로드를 했을 경우 호출될 함수 
		 * @param event
		 * 호출된 로더를 추적한 뒤 해당 로더가 가지고 있는 url과 content를 이용하여 BitmapImage객체 생성
		 */		
		private function onCompleteLoad(event:Event):void
		{
			var bitmapImage:BitmapImage = new BitmapImage(getName(event.currentTarget.url) ,event.currentTarget.loader.content as Bitmap);
			_dataStack.push(bitmapImage);
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_assetCounter++;
			
			if(_assetCounter >= _assetLength)
				_completeFunc();
		}
	}
}