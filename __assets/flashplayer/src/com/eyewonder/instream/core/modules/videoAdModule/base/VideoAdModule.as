/*
VideoAdModule.as

Universal Instream Framework
Copyright (c) 2006-2010, Eyewonder, LLC
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of Eyewonder, LLC nor the
names of contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, LLC''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, LLC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, LLC (http://www.eyewonder.com)



Description
-----------

Instantiates a VAST Translator to begin playing a VAST ad.

*/
package com.eyewonder.instream.core.modules.videoAdModule.base
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.debugger.*;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFVastEvent;
	import com.eyewonder.instream.core.modules.videoAdModule.VAST.VASTClickThru;
	import com.eyewonder.instream.core.utility.*;
	import com.eyewonder.instream.core.modules.videoAdScreenModule.base.IVideoAdScreenModule;
	import com.eyewonder.instream.core.modules.videoAdScreenModule.events.ChosenMediaFileEvent;
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Parser;
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Translator;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Parser;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Translator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	public dynamic class VideoAdModule extends MovieClip implements IVideoAdModule 
	{
		public var _ewad:InstreamFrameworkBase; //instance of uif passed in through constructor
		public var _videoAdScreenModule:IVideoAdScreenModule;		
		
		public var vastParser:Object; //instance of VAST parser passed in through constructor
		public var requestQueue:RequestQueue;//tracks impressions and other tracking events
		
		public var vastClickThru:VASTClickThru; //stores clickThru URL & CacheBuster
		
		public var cacheBuster:CacheBuster;//passed in through constructor and used for impression and tracking events
		
		public var translator:Object; //vast parser data object
		
		public var checkInitialVolume:Boolean = true;//Change to use player volume settings on creative load.
		public var _qualityFirst:Boolean;
		
		public var _preferredDeliveryMethod:String;//preferred method passed in from uif streaming or progressive 
		
		public var _bwDetectProgressiveURL:String; //url used for detecting progressive bandwidth
		public var _bwDetectStreamingServer:String; //url used for detecting streaming bandwidth
		
		public var trkRequest:URLRequest; //used for tracking 
		
		public var vastWrapperImpression:MovieClip;//created when tracking an impression inside a VAST wrapper tag						
		public var impressionHolder:MovieClip;//created when tracking an impression inside a VAST tag	
		public var vastHolder:MovieClip;
		
		public var pausedNS:Number = -1;
		public var remaining:Number = -1;
		public var total:Number = -1;
		public var TimerInitial:Number = -1;
		public var _audioVolume:Number = -1;// -1 means player didn't set volume
		
		public var _adContainerParentWidth:Number; //stores a reference to uif's adContainerParent_mc width 
		public var _adContainerParentHeight:Number; //stores a reference to uif's adContainerParent_mc height
		public var _adContainerParentX:Number; //stores a reference to uif's adContainerParent_mc x 
		public var _adContainerParentY:Number; //stores a reference to uif's adContainerParent_mc y
		
		public function VideoAdModule(ewad:InstreamFrameworkBase, videoAdScreenModule:IVideoAdScreenModule):void
		{
			_ewad = ewad;
			_videoAdScreenModule = videoAdScreenModule;
			
			if (ewad._adFormat == "VAST")
				vastParser = ewad._vast1Parser;
			else if (ewad._adFormat == "VAST2")
				vastParser = ewad._vast2Parser;
			else
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Not VAST!", "VAST", "VideoAdModule"); // Shouldn't happen
				return;
			}
			
			cacheBuster = ewad._cacheBuster;			
			
			vastHolder = new MovieClip();
			
			ewad.timerStop();// Stop initial timer since this isn't a preroll format
			
			ewad._adIsPlaying = true;
			
			if(ewad._bandwidth)
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Using provided UIF bandwidth: " + ewad._bandwidth, "VAST", "VideoAdModule");
				_videoAdScreenModule.setBandWidth(ewad._bandwidth);
			}
						
			_adContainerParentWidth = ewad._videoRect.width;
			_adContainerParentHeight = ewad._videoRect.height;
			_adContainerParentX = ewad._videoRect.x;
			_adContainerParentY = ewad._videoRect.y;
			
			setupUIFListeners();	
			setupAudioListeners();		
			setupVideoScreenListeners();		
			
			//adds the VideoPlayer to the stage
			addChild(videoAdScreenModule.getVideoPlayer());
		}
		
		/*
			MetaData are received after the ad video is set to play.
			
			On odd cases, where width and height have been omitted in the ad tag
			the dimension from the video MetaData are being used.
			
			Therefore we do a resize, as the dimensions are now set
		*/
		public function onMetaDataReceived(e:Event):void
		{
			_ewad.resizeNotify();
		}
		
		//public methods
		public function remainingTime(remaining:Number, total:Number):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In remainingTime()", "VAST", "VideoAdModule");
			ewad.remainingTime(remaining,total);	
		}
		
		//make avaiable to subclasses
		public function playPlayerVideo():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In playPlayerVideo()", "VAST", "VideoAdModule");
			ewad.setVideoState(2);
		}
		
		//make avaiable to subclasses
		public function pausePlayerVideo():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In pausePlayerVideo()", "VAST", "VideoAdModule");
			ewad.setVideoState(3);
		}
		
		public function trackImpression(e:Event = null):void
		{
			videoAdScreenModule.removeEventListener("start", trackImpression );
			ewad.trackLoad();

			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			
			for(i = 0; i < translator.impressionArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.impressionArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);

			impressionHolder.trkImpression = new MovieClip();
			impressionHolder.trkImpression.requestQueue = new RequestQueue();
			impressionHolder.trkImpression.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Impression tracker: " + cacheBustURL, "VAST", "VideoAdModule");
			}
			if(translator.trkCreativeViewEvent)
			{
				for(i = 0; i < translator.trkCreativeViewEvent.length; i++)
				{
					//cache busts vast urls
					cacheBustURL = cacheBuster.cacheBustURL(translator.trkCreativeViewEvent[i].url, CacheBuster.AD);
					trkRequest = new URLRequest(cacheBustURL);
			
					impressionHolder.trkImpression = new MovieClip();
					impressionHolder.trkImpression.requestQueue = new RequestQueue();
					impressionHolder.trkImpression.requestQueue.addRequest(trkRequest);
					UIFDebugMessage.getInstance()._debugMessage(2, "Creative View tracker: " + cacheBustURL, "VAST", "VideoAdModule");
				}
			}			
		}
		
		public function trackError():void
		{
			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;

			
			for(i = 0; i < translator.errorArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.errorArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkError = new MovieClip();
				impressionHolder.trkError.requestQueue = new RequestQueue();
				impressionHolder.trkError.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Error tracker: " + cacheBustURL, "VAST", "VideoAdModule");
			}
			
		}
		
		public function trackClickThru(event:Event = null):void
		{
			ewad.trackClickthru();

			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;

			if(translator.trkClickThruEvent)
			{
			for(i = 0; i < translator.trkClickThruEvent.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.trkClickThruEvent[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
				
				impressionHolder.trkClickThru = new MovieClip();
				impressionHolder.trkClickThru.requestQueue = new RequestQueue();
				impressionHolder.trkClickThru.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "ClickThru tracker: " + cacheBustURL, "VAST", "VideoAdModule");
			}
			}
		}
		
		//set up VAST trackers
		public function trackingEvents(trackingArray:Array):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In trackingEvents()", "VAST", "VideoAdModule");
			
			var i:Number = 0;
			
			if (trackingArray == null)
				return;
			for(i = 0; i < trackingArray.length; i++)
			{
				//cache busts vast urls
				var cacheBustURL:String = cacheBuster.cacheBustURL(String(trackingArray[i].url), CacheBuster.AD);
				var trkRequest:URLRequest = new URLRequest(cacheBustURL);
	
				impressionHolder = new MovieClip();
				impressionHolder.requestQueue = new RequestQueue();
				impressionHolder.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Event tracker: " + cacheBustURL, "VAST", "VideoAdModule");
			}
		}
		
		//returns current audio volume value from uif
		public function getAudioVolume():Number
		{
			var av:Number = 0;
			av = ewad.audioVolume;
			
			UIFDebugMessage.getInstance()._debugMessage(2, "Player audio volume is: " + av, "VAST", "VideoAdModule");
			
			if (isNaN(av))
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Player volume is NaN. Ignoring.", "VAST", "VideoAdModule");
				av = -1;
			}
			return av;
		}
		
		//make avaiable to subclasses
		public function onXMLError(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onXMLError()", "VAST", "VideoAdModule");
			//end_IS(); //unloads the VAST Module
			cleanUp();
			ewad.dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
		}

		//private methods and event handlers
		public function setupUIFListeners():void
		{
			ewad.addEventListener(UIFControlEvent.AD_VOLUME_CHANGED, audioVolumeChanged);
		}
		
		public function setupAudioListeners():void
		{
			//set adVideo listeners
			UIFDebugMessage.getInstance()._debugMessage(2, "Set up adVidPlay listener on ", "VAST", "VideoAdModule");
			ewad.addEventListener(UIFControlEvent.AD_VID_PLAY, adVidPlay);
			UIFDebugMessage.getInstance()._debugMessage(2, "Set up adVidPause listener on ", "VAST", "VideoAdModule");
			ewad.addEventListener(UIFControlEvent.AD_VID_PAUSE, adVidPause);
			UIFDebugMessage.getInstance()._debugMessage(2, "Set up adVidSeek listener on ", "VAST", "VideoAdModule");
			ewad.addEventListener(UIFControlEvent.AD_VID_SEEK, adVidSeek);
		}
		
		public function setupVideoScreenListeners():void
		{
			videoAdScreenModule.addEventListener("start", trackImpression );
			videoAdScreenModule.addEventListener("start", onPlayBackStart);
			videoAdScreenModule.addEventListener("stop", onVideoStopped);
			videoAdScreenModule.addEventListener("complete", onEndOfVideo);
			videoAdScreenModule.addEventListener("error", onVideoFailed);
			videoAdScreenModule.addEventListener("mute", onMuteChange);
			videoAdScreenModule.addEventListener("unmute", onMuteChange);
			videoAdScreenModule.addEventListener("pause", onPauseChange);
			videoAdScreenModule.addEventListener("resume", onPauseChange);
			videoAdScreenModule.addEventListener("midPoint", onMidOfVideo);
			videoAdScreenModule.addEventListener("firstQuartile", onFirstQuartile);
			videoAdScreenModule.addEventListener("thirdQuartile", onThirdQuartile);
			videoAdScreenModule.addEventListener("mediaFileChosen", onMediaFileChosen);
			videoAdScreenModule.addEventListener("fullscreen", onEnterFullscreen );
			videoAdScreenModule.addEventListener(UIFEvent.ERROR_EVENT, sOnError );
			
			videoAdScreenModule.getVideoPlayer().addEventListener(UIFVastEvent.ON_META_DATA, onMetaDataReceived);
		}
		
		public function removeEventListeners():void {
			UIFDebugMessage.getInstance()._debugMessage(2, "Removing video ad module listeners", "VAST", "VideoAdModule");
			
			videoAdScreenModule.removeEventListener("start", trackImpression );
			videoAdScreenModule.removeEventListener("start", onPlayBackStart);
			videoAdScreenModule.removeEventListener("stop", onVideoStopped);
			videoAdScreenModule.removeEventListener("complete", onEndOfVideo);
			videoAdScreenModule.removeEventListener("error", onVideoFailed);
			videoAdScreenModule.removeEventListener("mute", onMuteChange);
			videoAdScreenModule.removeEventListener("unmute", onMuteChange);
			videoAdScreenModule.removeEventListener("pause", onPauseChange);
			videoAdScreenModule.removeEventListener("resume", onPauseChange);
			videoAdScreenModule.removeEventListener("midPoint", onMidOfVideo);
			videoAdScreenModule.removeEventListener("firstQuartile", onFirstQuartile);
			videoAdScreenModule.removeEventListener("thirdQuartile", onThirdQuartile);
			videoAdScreenModule.removeEventListener("mediaFileChosen", onMediaFileChosen);
			videoAdScreenModule.removeEventListener("fullscreen", onEnterFullscreen );
			videoAdScreenModule.removeEventListener(UIFEvent.ERROR_EVENT, sOnError );
			
			ewad.removeEventListener(UIFControlEvent.AD_VID_PLAY,adVidPlay);
			ewad.removeEventListener(UIFControlEvent.AD_VID_PAUSE,adVidPause);
			ewad.removeEventListener(UIFControlEvent.AD_VID_SEEK,adVidSeek);
			ewad.removeEventListener(UIFControlEvent.AD_VOLUME_CHANGED, audioVolumeChanged);
			
			videoAdScreenModule.getVideoPlayer().removeEventListener(UIFVastEvent.ON_META_DATA, onMetaDataReceived);
		}
		
		/* Audio volume ================================================ */
		//listening for audio volume change event from uif framework
		public function audioVolumeChanged(e:Event = null):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "audioVolumeChanged received from player", "VAST", "VideoAdModule");
			_audioVolume = getAudioVolume();
			setAudioVolume(_audioVolume);
		}

		//updates the video screen with current audio
		public function setAudioVolume(num:Number):void
		{
			if (num == -1)
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Player didn't set audio volume. Ignoring.", "VAST", "VideoAdModule");
				return;
			}
			else if (num == -2)
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Creative didn't check audio volume. Ignoring.", "VAST", "VideoAdModule");
				return;
			}
			
			UIFDebugMessage.getInstance()._debugMessage(2, "Setting audio volume to: " + num, "VAST", "VideoAdModule");
			videoAdScreenModule.setVolume(num);	
			
			if (num == 0)
			{
				dispatchEvent(new Event("mute"));
			}
		}
		
		public function getInitialVolume():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Getting initial player audio volume", "VAST", "VideoAdModule");
			_audioVolume = getAudioVolume();// This is used later by the child SWF after it loads
			setAudioVolume(_audioVolume);
		}
		
		public function checkInitialVolumeFunction():void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In checkInitialVolumeFunction()", "VAST", "VideoAdModule");
			
			if (checkInitialVolume == true)
			{
				getInitialVolume();// Do this before loading holder
			}
		}

		// end_IS is a wrapper for the instream close method is used to completely clear out the ad, including the "Brand exposure time" tracker.
		// Note: Do NOT call this method directly but instead use gotoAndPlay("done") or all pending interaction trackers won't get serviced.
		public function end_IS():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Function end_IS called. Sending endAd to player.", "VAST");
			cleanUp(); // Clear out all active listeners before going to ewad.endAd()
			ewad.endAd();// Clear out anything actively running. This should be the last thing called and only after events clear out
		}
		
		public function TimerUpdate():void
		{
			if (typeof(ewad.remainingTime) != "undefined")
			{
				remaining =  videoAdScreenModule.getVideoLength()-videoAdScreenModule.getVideoTime();
				total = videoAdScreenModule.getVideoLength();
				remainingTime(remaining, total);
			}
		}
		
		public function TimerCleanup():void
		{
			clearInterval(TimerInitial);
		}
		
		//listening to the videoScreen and setting uif's adTagWidth, adTagHeight, adTagAlignHorizontal, and adTagAlignVertical properties
		public function onMediaFileChosen(e:ChosenMediaFileEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onMediaFileChosen() " , "VAST", "VideoAdModule" );
			ewad._adTagWidth = e.width;
			ewad._adTagHeight = e.height;
			
			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_LINEAR );
			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_FIXEDROLL );
		}
		
		public function onPlayBackStart(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "0% of Video Reached " , "VAST", "VideoAdModule" );
			checkInitialVolumeFunction();

			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_PLAY_AD );			
			
			ewad.trackStartOfVideo(); //notifying uif to track start of video
			
			//this sets the ad dimension to 0 if width/height have been omitted in the adTag <see: onMetaDataReceived>
			ewad.resizeNotify();

			//startOfVideo
			if (TimerInitial == -1)
			{
				TimerInitial = setInterval(TimerUpdate,100);
			}
			//tracks start of video events
			trackingEvents(translator.trkStartEvent);
		}
		
		public function onFirstQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "25% of Video Reached ", "VAST", "VideoAdModule");	
			ewad.trackFirstQuartileOfVideo();
			//tracks first quartile video events
			trackingEvents(translator.trkFirstQuartileEvent);
		}
		
		public function onMidOfVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "50% of Video Reached", "VAST", "VideoAdModule");		
			ewad.trackMidOfVideo(); //notifying uif to track mid of video			
			//tracks mid of video events
			trackingEvents(translator.trkMidPointEvent);
		}
		
		public function onThirdQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "75% of Video Reached", "VAST", "VideoAdModule");
			ewad.trackThirdQuartileOfVideo();
			//tracks third quartile video events
			trackingEvents(translator.trkThirdQuartileEvent);
		}
		
		public function onEndOfVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "100% of Video Reached", "VAST", "VideoAdModule");
			
			ewad.trackEndOfVideo(); //notifying uif to track end of video	
						
			//endOfVideo
			TimerCleanup();
			
			//tracks end of video events
			trackingEvents(translator.trkCompleteEvent);
			
			end_IS(); //unloads the VAST Module
			//playPlayerVideo(); //restarts the player's video
		}
		
		public function onReplayVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onReplayVideo()", "VAST", "VideoAdModule");
			//tracks replay video events
			trackingEvents(translator.trkReplayEvent);
		}
		
		public function onEnterFullscreen(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onEnterFullscreen()", "VAST", "VideoAdModule");
			ewad.trackEnterFullscreen(); //notifying uif to track change to fullscreen
			//tracks fullscreen events, enter fullscreen only
			trackingEvents(translator.trkFullScreenEvent);	
		}
		
		public function onVideoStopped(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onVideoStopped()", "VAST", "VideoAdModule");
			//tracks video stopped video events
			trackingEvents(translator.trkStopEvent);
			videoAdScreenModule.removeEventListener("stop", onVideoStopped);
		}
		
		public function onPauseChange(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onPauseChange()", "VAST", "VideoAdModule");
			if(e.type == "pause"){
			//tracks pause video events
			trackingEvents(translator.trkPauseEvent);
			}else if(e.type == "resume"){
				//tracks pause video events
				trackingEvents(translator.trkResumeEvent);				
			}
		}
		
		public function onMuteChange(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onMuteChange()", "VAST", "VideoAdModule");
			if(e.type == "mute"){
			//tracks mute video events
			trackingEvents(translator.trkMuteEvent);
			}else if(e.type == "unmute"){
				//tracks mute video events
				trackingEvents(translator.trkUnmuteEvent);			
			}

		}
		
		public function onVideoFailed(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onVideoFailed()", "VAST", "VideoAdModule");	
			trackError();
			//end_IS(); //unloads the VAST Module
			//playPlayerVideo(); //restarts the player's video
			cleanUp();
			ewad.dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
		}
		
		public function sOnError( e:Event ):void {
			UIFDebugMessage.getInstance()._debugMessage(2, "In sOnError()", "VAST", "VideoAdModule");	
			trackError();
			//end_IS(); //unloads the VAST Module
			cleanUp();
			ewad.dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
		}
		
		//AD VIDEO CONTROL
		// Pauses the player video
		public function adVidPause(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Pausing Ad video", "VAST", "VideoAdModule");
			videoAdScreenModule.pause();
			pausedNS = videoAdScreenModule.getVideoTime();
		}

		// Plays the player video
		public function adVidPlay(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Playing Ad video", "VAST", "VideoAdModule");
			videoAdScreenModule.play();
		}

		// Seeks the player video in mlliseconds
		public function adVidSeek(e:Event):void
		{
			if (remaining != -1 && total != -1)
			{
				var adVidSeekPosition:Number;
				var adVidSeekOffset:Number;
				if (ewad.eventData.adVidSeekPosition != undefined)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "adVidSeekPosition: " +ewad.eventData.adVidSeekPosition, "VAST", "VideoAdModule");
					adVidSeekPosition = ewad.eventData.adVidSeekPosition;
					switch (adVidSeekPosition)
					{
						case -2 :
							adVidSeekPosition = videoAdScreenModule.getVideoTime()*1000;//current position of the playhead
							break;
						case -1 :
							adVidSeekPosition = videoAdScreenModule.getVideoLength()*1000;
							break;
						case 0 :
							adVidSeekPosition = 0;//beginning of video
							break;
						default :
							//use defined value
							break;
					}
				}
				if (ewad.eventData.adVidSeekOffset != undefined)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "adVidSeekOffset: " +ewad.eventData.adVidSeekOffset);
					adVidSeekOffset = ewad.eventData.adVidSeekOffset;
				}
				//Sanity checking values passed.
				var seekValue:Number = adVidSeekPosition + adVidSeekOffset;
				if ((seekValue/1000) > videoAdScreenModule.getVideoLength())
				{
					seekValue = videoAdScreenModule.getVideoLength()*1000;
				}
				if ((seekValue/1000) < 0)
				{
					seekValue = 0;
				}
				//Tell video object to seek to value defined
				var pos:Number = seekValue/1000;
				UIFDebugMessage.getInstance()._debugMessage(2, "Seeking Ad video to: " +pos);
				videoAdScreenModule.seek(pos);
			}
		}
		
		public function cleanUp():void
		{
			  UIFDebugMessage.getInstance()._debugMessage(2,"In VideoAdModule:cleanUp() - removing all listeners, resume video.", "VAST");
			  TimerCleanup();
			  
			  removeEventListeners();
			  playPlayerVideo();
		}
			
		//EventHandler Cleanup
		//add any and all event handlers here to cleanup and remove on ad shutdown
		public function handlerCleanup(e:Event):void
		{
			if (ewad.hasEventListener("audioVolumeChanged"))
				ewad.removeEventListener("audioVolumeChanged", audioVolumeChanged);
		}

		//getters and setters
		public function get ewad():InstreamFrameworkBase
		{
			return _ewad;
		}
		
		public function get videoAdScreenModule():IVideoAdScreenModule
		{
			return _videoAdScreenModule;
		}	
	}
}
