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
			_imageAddButton = new SimpleButton(addButtonUpState, addButtonUpState, addButtonDownState, addButtonDownState);
			_imageAddButton.addEventListener(MouseEvent.CLICK, onClickAddButton);
			
			var encodeButtonUpState:TextField = new TextField();
			encodeButtonUpState.text = "현제상태로 패킹!!";
			var encodeButtonDownState:TextField = new TextField();
			encodeButtonDownState.text = "Go!!";
			_encodeButton = new SimpleButton(encodeButtonUpState, encodeButtonUpState, encodeButtonDownState, encodeButtonDownState);
			_encodeButton.addEventListener(MouseEvent.CLICK, onClickEncodeButton);
			_encodeButton.x = 100;
			
			addChild(_imageAddButton);
			addChild(_encodeButton);
			addChild(_backGround);
			
			_packer = new Packer(setCavas);
			_packer.setPacking(DataLoader.dataStack);
			_packer.setPackedData();
			_encoder.setEncode();
			
			var canvas:Sprite = new Sprite();
			_backGround.addChild(canvas);
			_currentCanvas = canvas;
		}
		
		/**
		 *_imageAddButton의 클릭시 호출되는 함수 
		 * @param event
		 * _imageAddButton이 클릭되면 dataStack에 남아있는 데이터가 있다면 Packer클래스의 addImage함수를 호출합니다.
		 * 호출된 Image정보를 받아와 화면에도 뿌려줍니다.
		 */		
		private function onClickAddButton(event:MouseEvent):void
		{
			if(DataLoader.dataStack.length != 0)
			{
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
			else
			{
				TextField(_imageAddButton.upState).text = "No Image!!";
				TextField(_imageAddButton.downState).text = "No Image!!";
				_imageAddButton.removeEventListener(MouseEvent.CLICK, onClickAddButton);
			}
		}
		
		/**
		 *setCanvas함수는 합쳐지는 비트맵데이터를 초기화하고 새로운 비트맵에 합치기 시작할때 호출됩니다. 
		 * 기존에 화면을 보여주고있던 Sprite는 제거하고 새로운 sprite로 교체해주며 해당 sprite를 _currentCanvas에 넘겨줍니다.
		 * 새로운 비트맵에 합친다는것은 기존에 합쳐지던 비트맵데이터는 필요가 없다는 얘기이므로 해당 비트맵데이터는 encode함수를 호출에 png와 xml파일로 인코딩해줍니다.
		 */		
		private function setCavas():void
		{
			var canvas:Sprite = new Sprite();
			_backGround.removeChildAt(0);
			_backGround.addChild(canvas);
			_currentCanvas = canvas;
			encode();
		}
		
		/**
		 *_encodeButton이 클릭되었을 때 호출되는 함수입니다. 
		 * @param event
		 * setCanvas함수를 호출하여 현제 비트맵이미지를 encode해주면서 현제 dataStack과 packedData를 다시 정리해줍니다.
		 */		
		private function onClickEncodeButton(event:MouseEvent):void
		{
			setCavas();
			if(DataLoader.dataStack.length != 0)
			{
				_packer.setPacking(DataLoader.dataStack);
				_packer.setPackedData();
			}
		}
		
		/**
		 *실질적으로 Encoder클래스와 연결되는 함수입니다.
		 * Encoder클래스의 encodeFromDisplay를 호출하게됩니다. 
		 * encodeFromDisplay함수는 더이상 패킹할 데이터가 없다면 false를 반환하게 되고 그럴경우 버튼의 이미지도 변경해줍니다.
		 */		
		private function encode():void
		{
			var flag:Boolean;
			if(_packer.packedDataVector.length != 0)
				flag = _encoder.encodeFromDisplay(_packer.packedDataVector);
			if(!flag)
			{
				TextField(_encodeButton.upState).text = "No PackedData";
				TextField(_encodeButton.downState).text = "No PackedData";
				_encodeButton.removeEventListener(MouseEvent.CLICK, onClickEncodeButton);
			}
		}
	}
}