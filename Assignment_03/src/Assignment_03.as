package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;

	[SWF(width="1024", height="1024", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		private var _packer:Packer = new Packer();
		private var _encoder:Encoder = new Encoder();
		private var _file:File;
		private var _progressText:TextField = new TextField();
		private var _time:Number;
		
		/**
		 *프로그램이 시작될 때 이미지파일들을 로딩 
		 * 
		 */		
		public function Assignment_03()
		{
			_file = new File();
			_file = File.applicationDirectory;
			_file.addEventListener(Event.SELECT, selectHandler);
			_file.browseForDirectory("우측하단의 폴더선택을 눌러주세요!!");
			_progressText.x = 430;
			_progressText.y = 450;
			_progressText.width = 150;
			_progressText.height = 150;
			_progressText.text = "폴더를 선택해주세요!!\n";
			addChild(_progressText);
		}
		
		private function selectHandler(event:Event):void
		{
			_progressText.text = "로딩중!!";
			_file.removeEventListener(Event.SELECT, selectHandler);
			new DataLoader(_file.nativePath, completeDataLoad);
		}
		
		/**
		 *로딩이 완료될 경우 Packer클래스에서 해당 데이타들을 패킹을 해준 후 화면에 출력
		 * imageQueue는 화면에 출력된 순서대로 BitmapImage객체들이 저장되어있는 큐
		 * 
		 */		
		private function completeDataLoad():void
		{
			_progressText.text = "패킹중!!";
			_packer.goPacking(DataLoader.dataStack);
			this.removeChild(_progressText);
			addChild(new Bitmap(_packer.packedDataVector[0].packedBitmapData));
			_encoder.startEncode(_packer.packedDataVector);
		}
	}
}