// Only handle visual display here. Handle any control logic in AdManager.as
package wahwahadplayer.controls
{

    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class PlayerControls extends MovieClip implements IPlayerControls
    {
        private var playBtn : SimpleButton;
        private var pauseBtn : SimpleButton;
        private var muteBtn : SimpleButton;
        private var unMuteBtn : SimpleButton;
		private var audioVolume:Number;
		private var speakerClick:Boolean = false;
		public var adManager:Object;
		public var timeline:MovieClip;
		private var speaker:SimpleButton;
		private var audioVolumeMC:MovieClip;
		private var rpBtn:SimpleButton;
       

        public function PlayerControls()
        {
        }	

        public function initialize(displayObj: Object, adManager: Object): void
        {
			
			
            this.playBtn = displayObj.playBtn;
            this.pauseBtn = displayObj.pauseBtn;
            this.muteBtn = displayObj.muteBtn;
            this.unMuteBtn = displayObj.unMuteBtn;
			this.rpBtn = displayObj.rpBtn;
			this.adManager = adManager;
			initalSettings();
        }

        private function initalSettings() : void
        {
            playBtn.visible = false;
            pauseBtn.visible = false;
			muteBtn.visible = false;
			unMuteBtn.visible = false;
			rpBtn.visible = false;
            playBtn.addEventListener(MouseEvent.CLICK, playClick);
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN, playClick);
            pauseBtn.addEventListener(MouseEvent.CLICK, pauseClick);
            unMuteBtn.addEventListener(MouseEvent.CLICK, unMuteClick);
            muteBtn.addEventListener(MouseEvent.CLICK, muteClick);
			rpBtn.addEventListener(MouseEvent.CLICK, rpClick);
        }

        private function playClick(e : MouseEvent) : void
        {
            if(e.currentTarget.enabled == false)
            {
                return;
            }
			adManager.playClick(this);
            
			
        }

        private function pauseClick(e : MouseEvent) : void
        {
            if(e.currentTarget.enabled == false)
            {
                return;
            }

			adManager.pauseClick(this);
        }

        private function muteClick(e : MouseEvent) : void
        {
		     if(e.currentTarget.enabled == false)
            {
                return;
            }
			adManager.muteClick(this);
        }

        private function unMuteClick(e : MouseEvent) : void
        {
		    if(e.currentTarget.enabled == false)
            {
                return;
            }
			adManager.unMuteClick(this);
        }
		
		private function rpClick(e : MouseEvent) : void
		{
		    if(e.currentTarget.enabled == false)
            {
                return;
            }
			adManager.rpClick(this);
		}

		// Play/pause toggle
		public function showPlaying(play:Boolean): void
		{
			if (play)
			{
				playBtn.visible = false;
				pauseBtn.visible = true;
				
				rpBtn.visible = true; // Always allow replay
			}
			else
			{
				playBtn.visible = true;
				pauseBtn.visible = false;

				rpBtn.visible = true;	// Always allow replay			
			}
		}
		
		
		public function showMuted(mute:Boolean): void
		{
			if (mute)
			{
				muteBtn.visible = false;
				unMuteBtn.visible = true;
			}
			else
			{
				muteBtn.visible = true;
				unMuteBtn.visible = false;			
			}
		}
		
		public function adCompleted(): void
		{
				muteBtn.visible = false;
				unMuteBtn.visible = false;	
				playBtn.visible = false;
				pauseBtn.visible = false;
				rpBtn.visible = false;
		}
		
		public function adError(): void
		{
			adCompleted(); // Only do something different for HTML5 controls
		}
		
		public function updateCountdown(remaining:Number, duration:Number):void
		{
			// Do nothing. Countdown will be overlaid in Flash SWF
		}
		
    }
}