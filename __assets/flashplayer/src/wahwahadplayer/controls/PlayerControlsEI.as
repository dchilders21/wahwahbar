// Only handle visual display here. Handle any control logic in AdManager.as
package wahwahadplayer.controls
{

    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
	import flash.external.*

    public class PlayerControlsEI extends MovieClip implements IPlayerControls
    {
		public var adManager:Object;
       

        public function PlayerControlsEI()
        {
        }	

        public function initialize(displayObj: Object, adManager: Object): void
        {
			this.adManager = adManager;
			try{
			ExternalInterface.addCallback("eiPlayClick", playClick);
			ExternalInterface.addCallback("eiPauseClick", pauseClick);
			ExternalInterface.addCallback("eiMuteClick", muteClick);
			ExternalInterface.addCallback("eiUnMuteClick", unMuteClick);
			ExternalInterface.addCallback("eiReplayClick", rpClick);
			}
			catch(e:Error)
			{
				trace(e.message);
			}
        }

        private function playClick() : void
        {
			adManager.playClick(this);
        }

        private function pauseClick() : void
        {
			adManager.pauseClick(this);
        }

        private function muteClick() : void
        {
			adManager.muteClick(this);
        }

        private function unMuteClick() : void
        {
			adManager.unMuteClick(this);
        }
		
		private function rpClick() : void
		{
			adManager.rpClick(this);
		}

		// Play/pause toggle
		public function showPlaying(play:Boolean): void
		{
			adManager.debugMessage("EI showPlaying " + play);
			ExternalInterface.call("eiShowPlaying", play);
		}
		
		
		public function showMuted(mute:Boolean): void
		{
			adManager.debugMessage("EI showMuted " + mute);
			ExternalInterface.call("eiShowMuted", mute);

		}
		
		public function adCompleted(): void
		{
			adManager.debugMessage("EI adCompleted");
			ExternalInterface.call("eiAdCompleted");
			adManager.globalSound(0);
			adManager._clearSoundPollingInterval();
		}
		
		public function adError(): void
		{
			adManager.debugMessage("EI adError");
			ExternalInterface.call("eiAdError");
			adManager.globalSound(0);
			adManager._clearSoundPollingInterval();
		}
		
		public var countdownDebugMessageRemaining:Number = 3; // Prevent excessive output
		
		public function updateCountdown(remaining:Number, duration:Number):void
		{
			if (countdownDebugMessageRemaining > 0)
			{
				adManager.debugMessage("EI updateCountdown " + play);			
				countdownDebugMessageRemaining--;
				if (countdownDebugMessageRemaining == 0)
					adManager.debugMessage("EI updateCountdown message will only be shown 3 times. This is expected behavior");
			}
			ExternalInterface.call("eiCountdown", remaining, duration);
		}
		
		
    }
}