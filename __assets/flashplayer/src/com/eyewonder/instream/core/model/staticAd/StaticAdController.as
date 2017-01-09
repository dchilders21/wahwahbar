/*
StaticAdController.as

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

Controller for non-linear (static) VAST ads.

*/

package com.eyewonder.instream.core.model.staticAd 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.debugger.UIFDebugMessage;
	import com.eyewonder.instream.core.utility.CacheBuster;
	import com.eyewonder.instream.core.utility.RequestQueue;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.net.URLRequest;
	
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Translator;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Translator;
	
	import com.eyewonder.instream.core.events.UIFEvent;
	
	public class StaticAdController
	{
		private var _adTimer:Timer;
		
		private var _adModel:Object;
		
		private var _staticAdModel:StaticAdModel;
		
		private const IAB_NONLINEAR_MAXLENGTH:Number = 15;
		private var _duration:Number;
		
		private var _instreamFramework:InstreamFrameworkBase;
		private var _vastTranslator:*;
		
		public function StaticAdController(instreamFramework:InstreamFrameworkBase, staticAdModel:StaticAdModel) 
		{
			_instreamFramework = instreamFramework;
			
			_staticAdModel = staticAdModel;
			
			_staticAdModel.addEventListener(Event.CHANGE, init);
		}
		
		//ad model data has been set right now
		private function init(event:Event):void
		{
			_staticAdModel.removeEventListener(Event.CHANGE, init);
			
			_adModel = _staticAdModel.staticResource[0];
			
			setMaxDuration();
			
			//select the correct VASTTranslator
			switch(_instreamFramework._adFormat)
			{
				case "VAST":
					_vastTranslator = new VAST1Translator(_instreamFramework._vast1Parser);
					break;
				case "VAST2":
					_vastTranslator = new VAST2Translator(_instreamFramework._vast2Parser);
					break;
			}
			
			//so we get the correct tracking array
			_vastTranslator.adPlacement = VAST2Translator.PLACEMENT_NONLINEAR;
		}
		
		private function setMaxDuration():void
		{
			if ((_adModel.minSuggestedDuration == undefined) ||
				(_adModel.minSuggestedDuration.totalSeconds > IAB_NONLINEAR_MAXLENGTH) ||
				(_adModel.minSuggestedDuration.totalSeconds <= 0))
			{
				_duration = IAB_NONLINEAR_MAXLENGTH;
			}
			else
			{
				_duration = _adModel.minSuggestedDuration.totalSeconds;
			}
		}
		
		public function startAdTimer():void
		{
			//construct timer
			_adTimer = new Timer(1000, _duration);
			_adTimer.addEventListener(TimerEvent.TIMER, adGuard);
			
			//start timer
			_adTimer.start();
		}
		
		private function adGuard(evt:TimerEvent):void
		{
			//start
			if (evt.currentTarget.currentCount == 1)
			{
				track(_vastTranslator.impressionArray, "Impression");
				track(_vastTranslator.trkCreativeViewEvent, "CreativeView");
				track(_vastTranslator.trkStartEvent, "Start");
			}
			
			//firstQuartile
			if (evt.currentTarget.currentCount == Math.floor(_duration / 4))
			{
				track(_vastTranslator.trkFirstQuartileEvent, "FirstQuartile");
			}
			
			//midpoint
			if (evt.currentTarget.currentCount == Math.floor(_duration / 2))
			{
				track(_vastTranslator.trkMidPointEvent, "MidPoint");
			}
			
			//thirdQuartile
			if (evt.currentTarget.currentCount == Math.floor(_duration / 1.333))
			{
				track(_vastTranslator.trkThirdQuartileEvent, "ThirdQuartile");
			}
			
			//complete
			if (evt.currentTarget.currentCount >= _duration)
			{
				track(_vastTranslator.trkCompleteEvent, "Complete");
				
				closeAd();
			}
		}
		
		public function errorClose():void
		{
			closeAd(true);
		}
		
		/*
		 * This function is called either on normal close, or when an error
		 * happened. The given flag decides which tracker is being called.
		*/
		public function closeAd(error:Boolean = false):void
		{
			if(_adTimer)
		{
			//stop timers
			_adTimer.removeEventListener(TimerEvent.TIMER, adGuard);
			_adTimer.stop();
			}
			
			//tracking
			if (error)
			{
				trackError();
			}
			
			//if this remains to be set to true, AdContainerParent.as throws an error..
			_instreamFramework._adContainerParent_mc._isLoaded = false;
			
			if (error)
			{
				_instreamFramework.dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			}
			else
			{
			//close it
			_instreamFramework.endAd();
		}
		}
		
		public function trackClickThru():void
		{
			track(_vastTranslator.trkClickThruEvent, "ClickThru");
			_instreamFramework.trackClickthru();
		}
		
		public function trackError():void
		{
			track(_vastTranslator.errorArray, "Error");
		}
		
		public function trackUserClose():void
		{
			//user close, need to be moved
			track(_vastTranslator.trkCloseEvent, "UserClose");
			_instreamFramework.trackClose();
		}
		
		private function track(urlArray:Array, description:String):void
		{
			if (urlArray == null) return;
			
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			var trackingHolder:MovieClip = new MovieClip();
			
			for(var i:uint = 0; i < urlArray.length; i++)
			{
				
				cacheBustURL = _instreamFramework._cacheBuster.cacheBustURL(urlArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);

				trackingHolder.tracker = new MovieClip();
				trackingHolder.tracker.requestQueue = new RequestQueue();
				trackingHolder.tracker.requestQueue.addRequest(trkRequest);
				
				UIFDebugMessage.getInstance()._debugMessage(2, "Tracking:"+ description +" - "+ cacheBustURL, "VPAID", "VPAIDTranslator");
			}
		}
	}
}