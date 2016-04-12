package
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.utils.Timer;

	[SWF(width="1064", height="1064", frameRate="60", backgroundColor="#FFFFFF")]
	public class Assignment_03 extends Sprite
	{
		private var _packer:Packer;
		private var _encoder:Encoder = new Encoder();
		private var _dataLoader:DataLoader;
		private var _file:File;
		private var _progressText:TextField = new TextField();
		private var _time:Number;
		
		private var _imageAddButton:SimpleButton;
		private var _encodeButton:SimpleButton;
		private var _autoPackButton:SimpleButton;
		private var _packedImageUpButton:SimpleButton;
		private var _packedImageDownButton:SimpleButton;
		
		private var _backGround:Sprite;
		private var _currentBitmapImage:BitmapImage
		private var _currentCanvas:Sprite;
		private var _currentCanvasCount:int = 0;
		private var _maxCanvasCount:int = 0;
		
		private var _packFlag:Boolean = false;
		private var _dataNumText:TextField = new TextField();
		
		/**
		 *프로그램이 시작될 때 이미지파일들을 로딩 
		 * 
		 */		
		public function Assignment_03()
		{
			_file = new File();
			_file = File.applicationDirectory;
			_file.addEventListener(Event.SELECT, onClickSelectButton);
			_file.browseForDirectory("우측하단의 폴더선택을 눌러주세요!!");
			_progressText.x = 430;
			_progressText.y = 450;
			_progressText.width = 150;
			_progressText.height = 150;
			_progressText.text = "폴더를 선택해주세요!!\n";
			addChild(_progressText);
			_backGround = new Sprite();
			_backGround.y = 30;
			_dataLoader = new DataLoader(completeDataLoad);
		}
		
		private function onClickSelectButton(event:Event):void
		{
			_progressText.text = "로딩중!!";
			_file.removeEventListener(Event.SELECT, onClickSelectButton);
			_dataLoader.loadData(_file.nativePath);
		}
		
		/**
		 *로딩이 완료될 경우 Packer클래스에서 해당 데이타들을 패킹을 해준 후 화면에 출력
		 * imageQueue는 화면에 출력된 순서대로 BitmapImage객체들이 저장되어있는 큐
		 * 
		 */		
		private function completeDataLoad():void
		{
			this.removeChild(_progressText);
			
			//이미지 추가 버튼---------------------------------
			var addButtonUpState:TextField = new TextField();
			addButtonUpState.text = "이미지 추가";
			addButtonUpState.border = true;
			addButtonUpState.height = 20;
			addButtonUpState.width = 100;
			addButtonUpState.background = true;
			addButtonUpState.backgroundColor = 0xFFFFF0;
			
			var addButtonDownState:TextField = new TextField();
			addButtonDownState.text = "Go!!";
			addButtonDownState.border = true;
			addButtonDownState.height = 20;
			addButtonDownState.width = 100;
			
			_imageAddButton = new SimpleButton(addButtonUpState, addButtonUpState, addButtonDownState, addButtonDownState);
			_imageAddButton.addEventListener(MouseEvent.CLICK, onClickAddButton);
			//-------------------------------------------
			
			//현재상태로 패킹하는 버튼---------------------------
			var encodeButtonUpState:TextField = new TextField();
			encodeButtonUpState.text = "패킹할 이미지가 없어요!!";
			encodeButtonUpState.border = true;
			encodeButtonUpState.height = 20;
			encodeButtonUpState.width = 150;
			encodeButtonUpState.background = true;
			encodeButtonUpState.backgroundColor = 0xFFFFF0;
			
			var encodeButtonDownState:TextField = new TextField();
			encodeButtonDownState.text = "패킹할 이미지가 없어요!!";
			encodeButtonDownState.border = true;
			encodeButtonDownState.height = 20;
			encodeButtonDownState.width = 150;
			
			_encodeButton = new SimpleButton(encodeButtonUpState, encodeButtonUpState, encodeButtonDownState, encodeButtonDownState);
			_encodeButton.x = 300;
			//----------------------------------------
			
			//자동 패킹 버튼-------------------------------
			var autoPackButtonUpState:TextField = new TextField();
			autoPackButtonUpState.text = "자동패킹";
			autoPackButtonUpState.border = true;
			autoPackButtonUpState.height = 20;
			autoPackButtonUpState.width = 100;
			autoPackButtonUpState.background = true;
			autoPackButtonUpState.backgroundColor = 0xFFFFF0;
			
			var autoPackButtonDownState:TextField = new TextField();
			autoPackButtonDownState.text = "Go!!";
			autoPackButtonDownState.border = true;
			autoPackButtonDownState.height = 20;
			autoPackButtonDownState.width = 100;
			
			_autoPackButton = new SimpleButton(autoPackButtonUpState, autoPackButtonUpState, autoPackButtonDownState, autoPackButtonDownState);
			_autoPackButton.addEventListener(MouseEvent.CLICK, onClickAutoButton);
			_autoPackButton.x = 800;
			//---------------------------------------
			
			//CanvasUp 버튼-------------------------------
			var upButtonUpState:TextField = new TextField();
			upButtonUpState.text = "\n \nU\nP";
			upButtonUpState.border = true;
			upButtonUpState.height = 100;
			upButtonUpState.width = 20;
			upButtonUpState.background = true;
			upButtonUpState.backgroundColor = 0xFFFFF0;
			
			var upButtonDownState:TextField = new TextField();
			upButtonDownState.text = "\n*\nU\nP\n*";
			upButtonDownState.border = true;
			upButtonDownState.height = 100;
			upButtonDownState.width = 20;
			
			_packedImageUpButton = new SimpleButton(upButtonUpState, upButtonUpState, upButtonDownState, upButtonDownState);
			_packedImageUpButton.addEventListener(MouseEvent.CLICK, onClickUpButton);
			_packedImageUpButton.x = 1034;
			_packedImageUpButton.y = 200;
			//---------------------------------------
			
			//CanvasDown 버튼-------------------------------
			var downButtonUpState:TextField = new TextField();
			downButtonUpState.text = " \nD\nO\nW\nN";
			downButtonUpState.border = true;
			downButtonUpState.height = 100;
			downButtonUpState.width = 20;
			downButtonUpState.background = true;
			downButtonUpState.backgroundColor = 0xFFFFF0;
			
			var downButtonDownState:TextField = new TextField();
			downButtonDownState.text = "*\nD\nO\nW\nN\n*";
			downButtonDownState.border = true;
			downButtonDownState.height = 100;
			downButtonDownState.width = 20;
			
			_packedImageDownButton = new SimpleButton(downButtonUpState, downButtonUpState, downButtonDownState, downButtonDownState);
			_packedImageDownButton.addEventListener(MouseEvent.CLICK, onClickDownButton);
			_packedImageDownButton.x = 1034;
			_packedImageDownButton.y = 500;
			//---------------------------------------
			
			_dataNumText.text = "남은 이미지 개수 : " + DataLoader.dataStack.length.toString();
			_dataNumText.x = 600;
			_dataNumText.width = 150;
			_dataNumText.height = 20;
			
			addChild(_imageAddButton);
			addChild(_encodeButton);
			addChild(_autoPackButton);
			addChild(_packedImageUpButton);
			addChild(_packedImageDownButton);
			addChild(_dataNumText);
			addChild(_backGround);
			
			_packer = new Packer(setCanvas);
			_packer.setPacker(DataLoader.dataStack);
			_encoder.setEncode();
			
			var canvas:Sprite = new Sprite();
			_backGround.addChild(canvas);
			_currentCanvas = canvas;
		}
		
		/**
		 *_packedImageUpButton을 클릭했을 때 호출되는 함수입니다. 
		 * @param event
		 * 호출될 경우 _currentCanvasCount가 _maxCanvasCount보다 작다면 화면을 위의 화면으로 전환시켜줍니다.
		 */		
		private function onClickUpButton(event:MouseEvent):void
		{
			if(_maxCanvasCount > _currentCanvasCount)
			{
				_currentCanvas.visible = false;
				_currentCanvas = _backGround.getChildAt(++_currentCanvasCount) as Sprite;
				_currentCanvas.visible = true;
			}
		}
		
		/**
		 * _packedImageDownButton을 클릭했을 때 호출되는 함수입니다.
		 * @param event
		 * 호출될 경우 _currentCanvasCount가 0보다 크다면 한단계 아래의 화면으로 전환시켜줍니다.
		 */		
		private function onClickDownButton(event:MouseEvent):void
		{
			if(_currentCanvasCount > 0)
			{
				_currentCanvas.visible = false;
				_currentCanvas = _backGround.getChildAt(--_currentCanvasCount) as Sprite;
				_currentCanvas.visible = true;
			}
		}
		
		/**
		 *From jihwan 
		 * @param event
		 * 자동패킹버튼을 눌렀을 경우 타이머를 이용하여 addImageButton을 클릭합니다.
		 * 타이머가 끝난경우 마지막화면도 패킹해주고 자동패킹버튼의 리스너들을 제거합니다.
		 */		
		private function onClickAutoButton(event:MouseEvent):void
		{
			if(_maxCanvasCount != _currentCanvasCount)
			{
				_currentCanvas.visible = false;
				_currentCanvas = _backGround.getChildAt(_maxCanvasCount) as Sprite;
				_currentCanvas.visible = true;
				_currentCanvasCount = _maxCanvasCount;
			}
			
			var timer:Timer = new Timer(100, DataLoader.dataStack.length);
			timer.addEventListener(TimerEvent.TIMER, timerActive);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			timer.start();
			
			function timerActive():void
			{
				onClickAddButton(event);
			}
			
			function timerComplete():void
			{
				onClickEncodeButton(event);
				timer.removeEventListener(TimerEvent.TIMER, timerActive);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			}
		}
		
		/**
		 *_imageAddButton의 클릭시 호출되는 함수 
		 * @param event
		 * 이미지 클릭 시 현제 화면을 이미지가 추가되어야하는 화면으로 전환시켜 줍니다.
		 * _imageAddButton이 클릭되면 dataStack에 남아있는 데이터가 있다면 Packer클래스의 addImage함수를 호출합니다.
		 * 호출된 Image정보를 받아와 화면에도 뿌려줍니다.
		 * 더이상 출력할 이미지가 없다면 _autoPackButton과 _addImageButton을 잠금을 시켜줍니다.
		 */		
		private function onClickAddButton(event:MouseEvent):void
		{
			if(_maxCanvasCount != _currentCanvasCount)
			{
				_currentCanvas.visible = false;
				_currentCanvas = _backGround.getChildAt(_maxCanvasCount) as Sprite;
				_currentCanvas.visible = true;
				_currentCanvasCount = _maxCanvasCount;
			}
			
			if(DataLoader.dataStack.length != 0)
			{
				_currentBitmapImage = _packer.addImage();
				if(_currentBitmapImage != null)
				{
					var currentImage:Bitmap = _currentBitmapImage.bitmap;
					currentImage.x = _currentBitmapImage.x;
					currentImage.y = _currentBitmapImage.y;
					_currentCanvas.addChild(currentImage);
					_dataNumText.text = "남은 이미지 개수 : " + DataLoader.dataStack.length.toString();
				}
				else
				{
					onClickAddButton(event);
				}
			}
			
			if(DataLoader.dataStack.length == 0)
			{
				TextField(_imageAddButton.upState).text = "No Image!!";
				TextField(_imageAddButton.downState).text = "No Image!!";
				_imageAddButton.removeEventListener(MouseEvent.CLICK, onClickAddButton);
				TextField(_imageAddButton.upState).background = false;
				
				TextField(_autoPackButton.upState).text = "No Image!!";
				TextField(_autoPackButton.downState).text = "No Image!!";
				_autoPackButton.removeEventListener(MouseEvent.CLICK, onClickAutoButton);
				TextField(_autoPackButton.upState).background = false;
			}
			
			if(!_packFlag)
			{
				TextField(_encodeButton.upState).text = "현제상태로 패킹!!";
				TextField(_encodeButton.downState).text = "Go!!";
				_encodeButton.addEventListener(MouseEvent.CLICK, onClickEncodeButton);
				TextField(_encodeButton.upState).background = true;
				_packFlag = true;
			}
		}
		
		/**
		 *_encodeButton이 클릭되었을 때 호출되는 함수입니다. 
		 * @param event
		 * _currentCanvas를 인코딩되어야할 화면으로 옮겨준 후 setCanvas를 호출합니다.
		 */		
		private function onClickEncodeButton(event:MouseEvent):void
		{
			if(_maxCanvasCount != _currentCanvasCount)
			{
				_currentCanvas.visible = false;
				_currentCanvas = _backGround.getChildAt(_maxCanvasCount) as Sprite;
				_currentCanvas.visible = true;
				_currentCanvasCount = _maxCanvasCount;
			}
			
			setCanvas(_packer.currentPackedData);
		}
		
		/**
		 *setCanvas함수는 합쳐지는 비트맵데이터를 초기화하고 새로운 비트맵에 합치기 시작할때 호출됩니다. 
		 * 기존에 화면을 보여주고있던 Sprite는 제거하고 새로운 sprite로 교체해주며 해당 sprite를 _currentCanvas에 넘겨줍니다.
		 * 새로운 비트맵에 합친다는것은 기존에 합쳐지던 비트맵데이터는 필요가 없다는 얘기이므로 해당 비트맵데이터는 encode함수를 호출에 png와 xml파일로 인코딩해줍니다.
		 */		
		private function setCanvas(packedData:PackedData):void
		{
			var canvas:Sprite = new Sprite();
			_currentCanvas.visible = false;
			_backGround.addChild(canvas);
			packedData.packedBitmapWidth = _currentCanvas.width;
			packedData.packedBitmapHeight = _currentCanvas.height;
			
			_currentCanvas = canvas;
			_currentCanvasCount++;
			_maxCanvasCount = _currentCanvasCount;
			encode(packedData);
		}
		
		/**
		 *실질적으로 Encoder클래스와 연결되는 함수입니다.
		 * Encoder클래스의 encodeFromData를 호출하게됩니다. 
		 * encodeFromData함수는 PackedData를 인자로 받아서 해당 객체가 가지고있는 비트맵데이터를 png로 변환하며 _imageQueue를 xml로 변환해줍니다.
		 * 변환이되면 빈화면을 패킹하는것을 배제하기위해 패킹버튼은 잠금시켜줍니다.
		 */		
		private function encode(packedData:PackedData):void
		{
			_encoder.encodeFromData(packedData);

			if(DataLoader.dataStack.length != 0)
			{
				_packer = new Packer(setCanvas);
				_packer.setPacker(DataLoader.dataStack);
			}
			
			TextField(_encodeButton.upState).text = "패킹할 이미지가 없어요!!";
			TextField(_encodeButton.downState).text = "패킹할 이미지가 없어요!!";
			_encodeButton.removeEventListener(MouseEvent.CLICK, onClickEncodeButton);
			TextField(_encodeButton.upState).background = false;
			_packFlag = false;
		}
	}
}