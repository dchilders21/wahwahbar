package {
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.events.*;
	import flash.net.*;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	public class FakeAd extends Sprite
	{
     
		public var nc:NetConnection;
		public var ns:NetStream;
		private var video:Video;
		 private var adSoundTransform:SoundTransform;
		private var globalSoundValue: Number = 1.0;
		public var timer:Timer;
		private var vpaid: ExampleVPAID;


		public function FakeAd(_vpaid: ExampleVPAID)
		{
			vpaid = _vpaid;
			vpaid._log("WW globalsound test");

			function asyncErrorHandler(event:AsyncErrorEvent):void
			{

			}
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			//ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
			ns.play("http://test.wahwahnetworks.com/brian/hackmyaudio073015/ads/cats.mp4"); 
			ns.addEventListener(NetStatusEvent.NET_STATUS, statusChanged);

function statusChanged(stats:NetStatusEvent) {
    if (stats.info.code == 'NetStream.Play.Stop') {
         trace('the video has ended');
    }
}
			video = new Video(400,225);
			video.attachNetStream(ns);
			video.smoothing = true;
			addChild(video);


			adSoundTransform = new SoundTransform();
			adSoundTransform.volume = 1;
			ns.soundTransform = adSoundTransform;

			ns.resume();


            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.start();   

		}
		
		
        protected function onTimer(pEvent:TimerEvent):void {
			vpaid._log("Muwahaha! Set sound to Globla sound to " + globalSoundValue + ">:)");
		SoundMixer.soundTransform = new SoundTransform(globalSoundValue);
        }


		private function asyncErrorHandler(event:AsyncErrorEvent) : void
		{
			return;
		}

		public function iPause() : void
		{
			this.ns.pause();
			return;
		}

		public function iResume() : void
		{
			ns.resume();
			return;
		}

		public function  adVolume(value:Number) : void
		{
			adSoundTransform.volume = value;
			ns.soundTransform = adSoundTransform;
			return;
		}// end function



	}
}