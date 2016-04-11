package
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;

	[SWF(width="1024", height="1044", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		private var _packer:Packer;
		private var _encoder:Encoder = new Encoder();
		private var _file:File;
		private var _progressText:TextField = new TextField();
		private var _time:Number;
		private var _imageAddButton:SimpleButton;
		private var _encodeButton:SimpleButton;
		private var _backGround:Sprite;
		private var _currentBitmapImage:BitmapImage
		private var _currentCanvas:Sprite;
		private var _endFlag:Boolean = false;
		
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
			_backGround = new Sprite();
			_backGround.y = 20;
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
			this.removeChild(_progressText);
			
			var addButtonUpState:TextField = new TextField();
			addButtonUpState.text = "이미지 추가";
			var addButtonDownState:TextField = new TextField();
			addButtonDownState.text = "Go!!";
			_imageAddButton = new SimpleButton(addButtonUpState, addButtonDownState, addButtonDownState, addButtonDownState);
			_imageAddButton.addEventListener(MouseEvent.CLICK, onClickAddButton);
			
			var encodeButtonUpState:TextField = new TextField();
			encodeButtonUpState.text = "현제상태로 패킹!!";
			var encodeButtonDownState:TextField = new TextField();
			encodeButtonDownState.text = "Go!!";
			_imageAddButton = new SimpleButton(addButtonUpState, addButtonDownState, addButtonDownState, addButtonDownState);
			_imageAddButton.addEventListener(MouseEvent.CLICK, onClickAddButton);
			
			addChild(_imageAddButton);
			addChild(_backGround);
			setCavas();
			
			_packer = new Packer(setCavas, _endFlag);
			_packer.setPacking(DataLoader.dataStack);
		}
		
		private function onClickAddButton(event:MouseEvent):void
		{
			if(!_endFlag)
			{
			//	trace(_endFlag);
				_currentBitmapImage = _packer.addImage();
				if(_currentBitmapImage != null)
				{
					var currentImage:Bitmap = _currentBitmapImage.bitmap;
					currentImage.x = _currentBitmapImage.x;
					currentImage.y = _currentBitmapImage.y;
					_currentCanvas.addChild(currentImage);
				}
				else
				{
					onClickAddButton(event);
				}
			}
			trace(_endFlag);
		//	_progressText.text = "패킹중!!";
		//	addChild(new Bitmap(_packer.packedDataVector[0].packedBitmapData));
		//	_encoder.startEncode(_packer.packedDataVector);
		}
		
		private function setCavas():void
		{
			var canvas:Sprite = new Sprite();
			if(_backGround.numChildren != 0)
				_backGround.removeChildAt(0);
			_backGround.addChild(canvas);
			_currentCanvas = canvas;
		}
		
		private function onClickEncodeButton(event:MouseEvent):void
		{
			
		}
	}
}