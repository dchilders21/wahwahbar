/*
About: License

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
*/

package com.eyewonder.instream.core.modules.videoAdModule.VPAID
{
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.debugger.UIFDebugMessage;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.modules.EWVPAIDExtensions;
	import com.eyewonder.instream.core.parser.Parser;
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Translator;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Translator;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2Element;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2LinearElement;
	import com.eyewonder.instream.core.utility.CacheBuster;
	import com.eyewonder.instream.core.utility.RequestQueue;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	
	/*
		Class: VPAIDTranslator

		This class is being used to call functions within the Framework.
	*/
	public class VPAIDTranslator extends Sprite
	{
		private var _IFB:InstreamFrameworkBase;
		
		private var _vastTranslator:*;
		
		private var _previousVolume:Number;
		
		/*
			Constructor: VPAIDTranslator
			
			Initializes the VPAIDTranslator
			
			Parameters:
				IFB - the InstreamFrameworkBase class object
		*/
		public function VPAIDTranslator(IFB:InstreamFrameworkBase):void {
			_IFB = IFB;
			
			switch(_IFB._adFormat)
			{
				case "VAST":
					_vastTranslator = new VAST1Translator(_IFB._vast1Parser);
					break;
				case "VAST2":
					_vastTranslator = new VAST2Translator(_IFB._vast2Parser);
					break;
			}
			
			switch(_IFB._adSlotType)
			{
				case InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR:
					_vastTranslator.adPlacement = VAST2Translator.PLACEMENT_LINEAR;
					break;
				case InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR:
					_vastTranslator.adPlacement = VAST2Translator.PLACEMENT_NONLINEAR;
					break;
			}
			
			_IFB._root_mc.stage.addEventListener( FullScreenEvent.FULL_SCREEN, trackFullscreen );
		}
		
		private function trackFullscreen(evt:FullScreenEvent):void
		{
			if ( evt.fullScreen )
			{
				track(_vastTranslator.trkFullScreenEvent, "Fullscreen");
			}
		}
		
		public function trackClose():void
		{
			track(_vastTranslator.trkCloseEvent, "Video closed");
			_IFB.trackClose();
		}
		
		public function trackClickthru():void 
		{
			track(_vastTranslator.trkClickThruEvent, "ClickThru");
			_IFB.trackClickthru();
		}
		
		public function trackStartOfVideo():void
		{
			track(_vastTranslator.trkStartEvent, "Start of video");
			
			_IFB.trackStartOfVideo();
		}
		
		public function trackFirstQuartileOfVideo():void
		{
			track(_vastTranslator.trkFirstQuartileEvent, "First quartile of video");
			_IFB.trackFirstQuartileOfVideo();
		}
		
		public function trackMidOfVideo():void
		{
			track(_vastTranslator.trkMidPointEvent, "Mid of video");
			_IFB.trackMidOfVideo();
		}
		
		public function trackThirdQuartileOfVideo():void
		{
			track(_vastTranslator.trkThirdQuartileEvent, "Third quartile of video");
			_IFB.trackThirdQuartileOfVideo();
		}
		
		public function trackEndOfVideo():void
		{
			track(_vastTranslator.trkCompleteEvent, "End of video");
			_IFB.trackEndOfVideo();
		}
		
		public function audioVolume(_value:Number):void
		{
			if (_value == 0)
			{
				//track mute
				track(_vastTranslator.trkMuteEvent, "Video muted");
			}
			
			if (_previousVolume == 0 && _value > 0)
			{
				//track unmute
				track(_vastTranslator.trkUnmuteEvent, "Video Unmuted");
			}
				
			_previousVolume = _value;
			
			//update volume in the ifb
			_IFB.audioVolume = _value;
		}
		
		public function resize():void
		{
			if (config.enforceVPAIDScaling)
			{
				_IFB.resizeNotify();
			}
		}
		
		public function trackContract():void
		{
			track(_vastTranslator.trkCollapseEvent, "Contracted");
			
			_IFB.trackContract();
		}
		
		public function trackExpand():void
		{
			track(_vastTranslator.trkExpandEvent, "Expanded");
			
			_IFB.trackExpand();
		}
		
		public function trackStop():void
		{
			track(_vastTranslator.trkStopEvent, "Video stopped");
		}
		
		public function trackPause():void
		{
			if (_IFB._adSlotType != InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR)
			{
			track(_vastTranslator.trkPauseEvent, "Video paused");
		}
		}
		
		//this is only fired when as has been in pause before, so we assume this one as resume
		public function trackPlaying():void
		{
			if (_IFB._adSlotType != InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR)
			{
				track(_vastTranslator.trkResumeEvent, "Video resumed");
			}
		}
		
		public function trackUserAcceptInvitation():void
		{
			track(_vastTranslator.trkAcceptInvitationEvent, "User Accept Invitation");
		}
		
		public function trackImpression():void
		{
			track(_vastTranslator.impressionArray, "Impression");
			track(_vastTranslator.trkCreativeViewEvent, "CreativeView");
		}
		
		public function setVideoState(_state:Number):void
		{
			_IFB.setVideoState(_state);
		}
		
		public function trackLoad():void
		{
			_IFB.trackLoad();
		}
		
		public function trackError():void
		{
			track(_vastTranslator.errorArray, "Error");
		}
		
		public function _debugMessage(_Msg:String):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, _Msg, "VPAID", "VPAIDTranslator");
		}
		
		public function error(trackThisError:Boolean = true):void
		{
			if (trackThisError)
			{
				trackError();
			}
			
			_IFB.dispatchUIFEvent(UIFEvent.ERROR_EVENT,{});
		}
		
		public function endAd():void
		{
			_IFB.endAd();
			_IFB._root_mc.stage.removeEventListener( FullScreenEvent.FULL_SCREEN, trackFullscreen );
		}
		
		public function remainingTime(remaining:Number):void
		{
			_IFB.remainingTime(remaining, _vastTranslator.adTagVASTDuration / 1000);
		}
		
		public function updateVPAIDExtensions(value:EWVPAIDExtensions):void
		{
			_IFB.adInformationData = value.adInformationData as Object;
		}
		
		public function getAdInformationData():Object
		{
			return _IFB.adInformationData;
		}
		
		public function hideControls():void
		{
			_IFB.dispatchUIFEvent( UIFControlEvent.HIDE_CONTROLS );
		}
		
		public function get config():Object
		{
			return _IFB._config;
		}
		
		public function get vpaidURL():String {
			
			var adURL:String;
			
			switch(_IFB._adSlotType)
			{
				case InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR:
					adURL = String(_vastTranslator.mediafileArray[0].url.toString());
					break;
				case InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR:
					adURL = String(_vastTranslator.nonlinearArray[0].URL.toString());
					break;
			}
			
			return adURL;
		}
		
		public function get vpaidHeight():Number {
			var _height:Number;
			switch(_IFB._adSlotType)
			{
				case InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR:
					_height = Number(_vastTranslator.mediafileArray[0].height);
					break;
				case InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR:
					if (isNaN(_vastTranslator.nonlinearArray[0].expandedHeight) || (_vastTranslator.nonlinearArray[0].expandedHeight == 0))
					{
						//no expanded height given, so we take normal height
						_height = Number(_vastTranslator.nonlinearArray[0].height);
					}
					else
					{
						//expanded height is given
						_height = Number(_vastTranslator.nonlinearArray[0].expandedHeight);
					}
					break;
			}
			return _height;
		}
		public function get vpaidWidth():Number {
			var _width:Number;
			switch(_IFB._adSlotType)
			{
				case InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR:
					_width = Number(_vastTranslator.mediafileArray[0].width);
					break;
				case InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR:
					_width = Number(_vastTranslator.nonlinearArray[0].width);
					break;
			}
			return _width;
		}
		
		public function get creativeData():String 
		{	
			switch(_IFB._adFormat)
			{
				case "VAST":
					return "";
					break;
				case "VAST2":
					if(_IFB._adSlotType == InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR)
						return String(_vastTranslator.linearArray[0].adParameters);
					else if(_IFB._adSlotType == InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR)
						return String(_vastTranslator.nonlinearArray[0].adParameters);
					break;
			}
			return "";
		}
		
		public function dispatchUIFEvent(evt:String, data:Object):void
		{
			_IFB.dispatchUIFEvent(evt, data);
		}
		
		private function track(urlArray:Array, description:String):void
		{
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			var trackingHolder:MovieClip = new MovieClip();
			
			if (urlArray == null) return;

			for(var i:uint = 0; i < urlArray.length; i++)
			{
				cacheBustURL = _IFB._cacheBuster.cacheBustURL(urlArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);

				trackingHolder.trkImpression = new MovieClip();
				trackingHolder.trkImpression.requestQueue = new RequestQueue();
				trackingHolder.trkImpression.requestQueue.addRequest(trkRequest);
				
				_debugMessage("Tracking:"+ description +" - "+ cacheBustURL);
			}
		}
		
		public function wwAdStarted()
		{
			_IFB.dispatchUIFEvent( UIFControlEvent.ON_START_PLAY_AD );
		}
	}
}
