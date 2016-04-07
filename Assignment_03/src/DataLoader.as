package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class DataLoader
	{
		private static const NAME_REGEX:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
		
		private var _dataQueue:Vector.<BitmapImage>;

		public function get dataQueue():Vector.<BitmapImage>
		{
			return _dataQueue;
		}

		private var _completeFunc:Function;
		private var _libName:String;
	//	private var _bitmapVector:Vector.<BitmapImage>;
		/*
		private var _url:String;
		private var _id:String;
		private var _loader:Loader;
		private var _completeFunc:Function;
		private var _loadedBitmap:Bitmap;
		*/
		
		public function DataLoader(libName:String, func:Function)
		{
			_dataQueue = new Vector.<BitmapImage>();
			_completeFunc = func;
			_libName = libName;
			/*
			_loader = new Loader();
			_id = id;
			_url = url;
			_completeFunc = func;
			*/
			
			enqueue(File.applicationDirectory.resolvePath(_libName));
		}
		
		public function enqueue(...rawAssets):void
		{
			var urlRequest:URLRequest = null;
			trace(rawAssets.length);
			for each(var rawAsset:Object in rawAssets)
			{
				if(rawAsset["isDirectory"])
					enqueue.apply(this, rawAsset["getDirectoryListing"]());
				else if(getQualifiedClassName(rawAsset) == "flash.filesystem::File")
				{
				//	trace(decodeURI(rawAsset["url"]).substring(5,decodeURI(rawAsset["url"]).length));
					urlRequest = new URLRequest(decodeURI(rawAsset["url"]).substring(5,decodeURI(rawAsset["url"]).length));
				//	trace(getName(rawAsset));
				//	trace(decodeURI(rawAsset["url"]));
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
				//	loader.contentLoaderInfo.url
				//	loader.load(new URLRequest(decodeURI(rawAsset["url"])));
					loader.load(urlRequest);
				//	trace(urlRequest.url);
				}
			}
		}
		
		public function getName(rawAssetURL:String):String
		{
			var fileName:String;
			
			fileName = rawAssetURL.replace(_libName+"/","");
			
			return fileName;
		}
		
		/*
		public function getName(rawAsset:Object):String
		{
			var name:String;
			
			if      (rawAsset is String)        name =  rawAsset as String;
			else if (rawAsset is URLRequest)    name = (rawAsset as URLRequest).url;
			else if (rawAsset is FileReference) name = (rawAsset as FileReference).name;
			
			if (name)
			{
				name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
				name = getBasenameFromUrl(name);
				
				if (name) return name;
				else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
			}
			else
			{
				name = getQualifiedClassName(rawAsset);
				throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
			}
		}
		*/
		
		public function getBasenameFromUrl(url:String):String
		{
			var matches:Array = NAME_REGEX.exec(url);
			if (matches && matches.length > 0) return matches[1];
			else return null;
		}
		
		/*
		public function start():void
		{
			_loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
			
			_loader.load(new URLRequest(_url));
		}
		*/
		
		private function uncaughtError(event:UncaughtErrorEvent):void
		{
			trace("error!!!");
		}
		
		private function onCompleteLoad(event:Object):void
		{
		//	trace(event.currentTarget.url.substring(5,event.currentTarget.url.length));
		//	trace(event.currentTarget.loader.content);
			var bitmapImage:BitmapImage = new BitmapImage(getName(event.currentTarget.url.substring(5,event.currentTarget.url.length)) ,event.currentTarget.loader.content as Bitmap);
			_dataQueue.push(bitmapImage);
		//	trace(getName(event.currentTarget.Loader.content));
		//	_loadedBitmap = event.currentTarget.Loader.content as Bitmap;
			_completeFunc(_dataQueue);
		}
	}
}