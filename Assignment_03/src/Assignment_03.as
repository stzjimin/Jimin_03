package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	public class Assignment_03 extends Sprite
	{
		public function Assignment_03()
		{
			enqueue(File.applicationDirectory.resolvePath("GUI_resources"));
		}
		
		public function enqueue(...rawAssets):void
		{
			trace(rawAssets.length);
			for each(var rawAsset:Object in rawAssets)
			{
				if(rawAsset["isDirectory"])
					enqueue.apply(this, rawAsset["getDirectoryListing"]());
				trace(rawAsset);
			}
		}
	}
}