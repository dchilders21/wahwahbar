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
	import flash.media.SoundTransform;

	public class FakeAd extends Sprite
	{
     
		public var nc:NetConnection;
		public var ns:NetStream;
		private var video:Video;
		 private var adSoundTransform:SoundTransform;
		private var vpaid: ExampleVPAID;


		public function FakeAd(_vpaid: ExampleVPAID)
		{
			vpaid = _vpaid;
			vpaid._log("WW Template");
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
			ns.resume();


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