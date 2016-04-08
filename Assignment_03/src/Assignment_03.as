package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	[SWF(width="1024", height="1024", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		private var _packer:Packer = new Packer();
		private var _encoder:Encoder = new Encoder();
		
		/**
		 *프로그램이 시작될 때 이미지파일들을 로딩 
		 * 
		 */		
		public function Assignment_03()
		{
			new DataLoader("GUI_resources", completeDataLoad);
		}
		
		/**
		 *로딩이 완료될 경우 Packer클래스에서 해당 데이타들을 패킹을 해준 후 화면에 출력
		 * imageQueue는 화면에 출력된 순서대로 BitmapImage객체들이 저장되어있는 큐
		 * 
		 */		
		private function completeDataLoad():void
		{
			_packer.goPacking(DataLoader.dataStack);
			addChild(new Bitmap(_packer.packedDataVector[0].packedBitmapData));
			_encoder.startEncode(_packer.packedDataVector);
		}
	}
}