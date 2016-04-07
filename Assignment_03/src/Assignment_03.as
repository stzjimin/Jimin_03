package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;

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
		
		private function completeDataLoad():void
		{
			_packer.goPacking(DataLoader.dataStack);
			addChild(new Bitmap(_packer.packedBitmapData));
		}
	}
}