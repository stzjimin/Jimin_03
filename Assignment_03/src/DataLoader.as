package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;

	public class DataLoader
	{
		private var _dataQueue:Vector.<Bitmap>;
		private var _completeFunc:Function;
		private var _libName:String;
		/*
		private var _url:String;
		private var _id:String;
		private var _loader:Loader;
		private var _completeFunc:Function;
		private var _loadedBitmap:Bitmap;
		*/
		
		public function DataLoader(libName:String, func:Function)
		{
			_dataQueue = new Vector.<Bitmap>();
			_completeFunc = func;
			_libName = libName;
			/*
			_loader = new Loader();
			_id = id;
			_url = url;
			_completeFunc = func;
			*/
		}
		
		public function enqueue(...rawAssets):void
		{
			for each(var rawAsset:Object in rawAssets)
			{
				trace(rawAsset);
			}
		}
		
		
		
		/*
		public function start():void
		{
			_loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtError);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
			
			_loader.load(new URLRequest(_url));
		}
		
		private function uncaughtError(event:UncaughtErrorEvent):void
		{
			trace("error!!!");
		}
		
		private function onCompleteLoad(event:Event):void
		{
			_loadedBitmap = event.currentTarget.Loader.content as Bitmap;
			_completeFunc(_id, _loadedBitmap);
		}
		*/
	}
}