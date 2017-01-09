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
package com.eyewonder.instream.publisherAPI.adControl
{
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.utility.ICacheBuster;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd.IVPAIDControl;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd.VPAIDControl;

	
	import com.eyewonder.instream.publisherAPI.adControl.IAdControl;
	import com.eyewonder.instream.publisherAPI.adControl.parser.ParserControl;
	import com.eyewonder.instream.publisherAPI.adControl.parser.IParserControl;
	import com.eyewonder.instream.publisherAPI.adControl.tracking.TrackingControl;
	import com.eyewonder.instream.publisherAPI.adControl.tracking.ITrackingControl;
	import com.eyewonder.instream.publisherAPI.adControl.companion.ICompanionAd;
	import com.eyewonder.instream.publisherAPI.adControl.companion.CompanionAd;

	import com.eyewonder.instream.publisherAPI.adControl.adFormat.AbstractAdController;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.AbstractAdFormat;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.IAbstractAdFormat;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.events.UIFEventDispatcher;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFTrackEvent;
	
	public class AdControl extends UIFEventDispatcher implements IAdControl 
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		private var _trackingControl:TrackingControl;
		private var _parserControl:ParserControl;
		private var _abstractAdController:AbstractAdController;
		private var _companionAd:CompanionAd;
		
		private var _vpaidControl:VPAIDControl;
		
		private var _remainingTime:Number = 0;
		private var _totalTime:Number = 0;
		
		public const REMINDER_TYPE_URL:String = InstreamFrameworkBase.REMINDER_TYPE_URL;
		public const REMINDER_TYPE_XML:String = InstreamFrameworkBase.REMINDER_TYPE_XML;
		public const AD_SLOT_TYPE_LINEAR:String = InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR;
		public const AD_SLOT_TYPE_NONLINEAR:String = InstreamFrameworkBase.AD_SLOT_TYPE_NONLINEAR;
		
		public function AdControl(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
			
			_instreamFramework.addEventListener(UIFEvent.CONTROL_EVENT, updateRemainingTime);
			
			_instreamFramework.addEventListener(UIFEvent.ERROR_EVENT, controlEventForwarding);
			_instreamFramework.addEventListener(UIFEvent.CONTROL_EVENT, controlEventForwarding);
			
			_trackingControl = new TrackingControl(_instreamFramework);
			_parserControl = new ParserControl(_instreamFramework);
			_companionAd = new CompanionAd(_instreamFramework);
			_abstractAdController = new AbstractAdController(_instreamFramework);
			
			_vpaidControl = new VPAIDControl(_instreamFramework);
		}
		
		public function destroy():void
		{
			_instreamFramework.removeEventListener(UIFEvent.CONTROL_EVENT, updateRemainingTime);
			
			_instreamFramework.removeEventListener(UIFEvent.ERROR_EVENT, controlEventForwarding);
			_instreamFramework.removeEventListener(UIFEvent.CONTROL_EVENT, controlEventForwarding);
			
			trackingControl.destroy();
			companionAd.destroy();
		}
		
		public function get vpaid():IVPAIDControl
		{
			return _vpaidControl;
		}
		
		public function get trackingControl():ITrackingControl
		{
			return _trackingControl;
		}

		public function get parserControl():IParserControl
		{
			return _parserControl;
		}

		public function get ad():IAbstractAdFormat
		{
			return _abstractAdController.ad;
		}
		
		public function get cachebuster():ICacheBuster
		{
			return _instreamFramework._cacheBuster;
		}
		
		public function get companionAd():ICompanionAd
		{
			return _companionAd;
		}
		
		private function controlEventForwarding(event:UIFEvent):void
		{
			var eventType:String;
			var eventInfo:Object;
			
			if (event.type == UIFEvent.ERROR_EVENT)
			{
				eventType = event.type;
			}
			else
			{
				switch(event.info.type)
				{
					case UIFControlEvent.AD_REMAINING_TIME:
					case UIFControlEvent.ON_END_AD:
					case UIFControlEvent.ON_AD_LOAD_COMPLETE:
					case UIFControlEvent.ON_START_PLAY_AD:
					case UIFControlEvent.ON_START_REQUEST_AD:
					case UIFControlEvent.ON_START_NONLINEAR:
					case UIFControlEvent.ON_START_LINEAR:
					case UIFControlEvent.ON_START_LINEAR_INTERACTIVE:
					case UIFControlEvent.ON_START_OVERLAY:
					case UIFControlEvent.AD_INFORMATION_DATA:
					case UIFControlEvent.ON_START_FIXEDROLL:
					case UIFControlEvent.ON_REMINDER_DETECTED:
					case UIFControlEvent.ON_REMINDER_OVERRIDE:
						eventType = event.type;
						eventInfo = event.info;
						break;
				}
			}
			
			if (eventType != null)
			{
				
				dispatchEvent(new UIFEvent(eventType, eventInfo));
			}
		}
		
		public function play():void
		{
			_instreamFramework.onPlayerVideoPlay();
		}
		
		public function pause():void
		{
			_instreamFramework.onPlayerVideoPause();
		}

		public function forward():void
		{
			_instreamFramework.forward();
		}

		public function next():void
		{
			_instreamFramework.next();
		}

		public function previous():void
		{
			_instreamFramework.prev();
		}
		
		public function seek(position:Number, offset:Number):void
		{
			_instreamFramework.onPlayerVideoSeek(position, offset);
		}
		
		public function rewind():void
		{
			_instreamFramework.rewind();
		}
		
		public function loadAdURL(adTagUrl:String, adSlotType:String, adFormat:String = "unknown"):void
		{
			_instreamFramework.loadAdURL(adTagUrl, adSlotType, adFormat);
		}
		
		public function loadDataObj(value:XML, adSlotType:String, adFormat:String = "unknown"):void
		{
			_instreamFramework.loadDataObj(value, adSlotType, adFormat);
		}
		
		public function resize():void
		{
			_instreamFramework.resizeNotify();
		}
		
		public function get adInformationData():Object
		{
			return _instreamFramework.adInformationData;
		}
		
		public function get volume():Number
		{
			//TODO adVolume getter only. The creative should set its own volume and should pull the volume from UIF.
			return _instreamFramework.audioVolume;
		}
		
		public function get format():String
		{
			return _instreamFramework._adFormat;
		}
		
		public function get isPlaying():Boolean
		{
			return _instreamFramework._adIsPlaying;
		}
		
		public function get slotType():String
		{
			return _instreamFramework._adSlotType;
		}
		
		private function updateRemainingTime(event:UIFEvent):void
		{
			if (event.info.type == UIFControlEvent.AD_REMAINING_TIME) {
		
				_remainingTime	= event.info.data.adRemainingTime;
				_totalTime 		= event.info.data.adTotalTime;
			}
		}
		
		public function get remainingTime():Number
		{
			if (isPlaying == false)
			{
				_remainingTime = 0;
			}
			
			return _remainingTime;
		}

		public function get duration():Number
		{
			if (isPlaying == false)
			{
				_totalTime = 0;
			}
			
			return _totalTime;
		}
		
		public function get reminder():Array
		{
			return _instreamFramework.reminderListArray;
		}
		
		public function set reminder(newReminderArray:Array):void
		{
			_instreamFramework.reminderListArray = newReminderArray;
		}
		
		public function endAd():void
		{
			_instreamFramework._adIsPlaying = true;
			_instreamFramework.endAd();
		}
	}
}
