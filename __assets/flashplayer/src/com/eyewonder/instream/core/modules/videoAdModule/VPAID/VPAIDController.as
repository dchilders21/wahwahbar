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
	//FLASH EVENTS
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.utility.Debug;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	//FLASH UTILS
	import flash.utils.Timer;
	//FLASH DISPLAY
	import flash.display.MovieClip;
	import flash.display.Loader;
	//FLASH NET
	import flash.net.URLRequest;
	//OTHER
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDTranslator;
	
	/*
		Class: VPAIDController

		This class has functionality that observes the VPAID ad.
		It starts timers to check whether the ad responded within a given 
		time frame, or whether the ad is being loaded within a configurable time frame.
	*/
	public class VPAIDController extends MovieClip
	{
		public var _VPAIDTranslator:VPAIDTranslator;
		public var _contentSwfLoader:Loader;
		public var _loadingGuardTimer:Timer;
		public var _loadingGuard_MaxWaitingTime:Number = 30;		//Time frame within the ad has to be loaded, or it'll be destroyed (given in seconds)
																	
		public var _eventGuardTimer:Timer;							//Timer to observe whether the ad has responded with a return within a given time frame
		public var _eventGuard_MaxActionReturnTime:Number = 30; 	//The time frame given in seconds
		
		public var _remainingTimer:Timer;
		private var _ad:*;
		

		
		
		public var _debug:Debug;
		
		/*
			Constructor: VPAIDController
			
			Parameters:
				VPAIDTranslator - see <VPAIDTranslator>
		 */
		public function VPAIDController(__VPAIDTranslator:VPAIDTranslator):void
		{
			_VPAIDTranslator = __VPAIDTranslator;

			addEventListener("loadSWF_Complete", _loadSWF_Complete);
			addEventListener("loadSWF_Error", _loadSWF_Error);
			
			_loadContentSwf(_VPAIDTranslator.vpaidURL);
			
			_debug = new Debug(_VPAIDTranslator.config);
		}

		public function _addVPAIDListener():void {}
		
		public function _removeVPAIDListener():void {}
		
		
		public function get ad():*
		{
			return _ad;
		}
		
		/*
			Function: _endAd
			
			Removes an ad and requests the content video to resume playback
		*/
		public function _endAd():void 
		{
			dispatchEvent(new Event("VPAID_END_AD"));
			
			destroy();
			_VPAIDTranslator.endAd();
			_VPAIDTranslator.setVideoState(2);			//play ContentVideo
		}
		
		/*
			Destructor: destroy
			
			Clears remaining timer, removes the loaded VPAID ad and clears all listeners.
		*/
		private function destroy():void
		{
			_VPAIDTranslator._debugMessage("In _destroy()");
			
			if (_remainingTimer != null)
			{
				_remainingTimer.removeEventListener("timer", _remainingTimerHandler);
				_remainingTimer.reset();
			}
			
			_removeVPAIDListener();
			
			try
			{
				_VPAIDTranslator.removeChild(_contentSwfLoader);
			}
			catch (e:Error)
			{
				_VPAIDTranslator._debugMessage("In _destroy() - could not remove adSWF from translator, this usually happens when handshake failed");
			}
		}

		private function _loadContentSwf(adContentURL:String):void 
		{
			trace("[::VPAID::] In _loadContentSWF()");
			_startLoadingGuardTimer();
			var urlReq:URLRequest = new URLRequest(adContentURL);
			_contentSwfLoader = new Loader();
			_contentSwfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loadSWF_Complete);
			_contentSwfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _loadSWF_Error);
			_contentSwfLoader.load(urlReq);
		}
		
		private function _startLoadingGuardTimer():void 
		{
			_loadingGuardTimer = new Timer(1000);
			_loadingGuardTimer.addEventListener("timer", _loadingGuardTimerHandler);
			_loadingGuardTimer.start();
		}
		
		/*
			function: _loadingGuardTimerHandler
			
			Observes VPAID loading.
			If it takes longer than the given <_loadingGuard_MaxWaitingTime>
			then an error will be dispatched - and the ad will be removed
		*/
		public function _loadingGuardTimerHandler(event:TimerEvent):void 
		{
			if (_loadingGuardTimer.currentCount >= _loadingGuard_MaxWaitingTime)
			{
				_stopLoadingGuardTimer();
				removeEventListener("loadSWF_Complete", _loadSWF_Complete);
				removeEventListener("loadSWF_Error", _loadSWF_Error);
				_VPAIDTranslator.error();
			}
		}
		
		private function _stopLoadingGuardTimer():void
		{
			_loadingGuardTimer.removeEventListener("timer", _loadingGuardTimerHandler);
			_loadingGuardTimer.reset();
		}
		
		public function _loadSWF_Complete(evt:Event):void 
		{
			removeEventListener("loadSWF_Complete", _loadSWF_Complete);
			removeEventListener("loadSWF_Error", _loadSWF_Error);
			
			_stopLoadingGuardTimer();
		
			//Check for ActionScript version compatibility - only AS3 ads allowed here
			try
			{
				var adSWF:* = _contentSwfLoader.content;
				_ad = adSWF.getVPAID();
			}
			catch (e:Error)
			{
				// It's a AS2 SWF
				_VPAIDTranslator._debugMessage("In _loadSWF_Complete() - AS2 in AS3 - Error");
				_VPAIDTranslator.error();
				return;
			}
			
			dispatchEvent(new Event("VPAID_LOADED"));
		}
		
		private function _loadSWF_Error(evt:Event):void 
		{
			dispatchEvent(new Event("VPAID_ERROR"));
			
			_VPAIDTranslator._debugMessage("In _loadSWF_Error() - Could not load VPAID ad SWF, check the ad URLs please - error");
			
			removeEventListener("loadSWF_Complete", _loadSWF_Complete);
			removeEventListener("loadSWF_Error", _loadSWF_Error);
			
			_stopLoadingGuardTimer();
			_VPAIDTranslator.error();
		}
		
		public function _startEventGuardTimer():void 
		{
			if (_eventGuardTimer == null)
			{
				_eventGuardTimer = new Timer(1000);
			}
			else
			{
				_eventGuardTimer.reset();
			}
			_eventGuardTimer.addEventListener("timer", _eventGuardTimerHandler);
			_eventGuardTimer.start();
		}
		
		public function _stopEventGuardTimer():void
		{
			if (_eventGuardTimer != null)
			{
				_eventGuardTimer.removeEventListener("timer", _eventGuardTimerHandler);
				_eventGuardTimer.reset();
			} 
		}
		
		private function _eventGuardTimerHandler(event:TimerEvent):void 
		{
			if (_eventGuardTimer.currentCount >= _eventGuard_MaxActionReturnTime)
			{
				_eventGuardTimer.removeEventListener("timer", _eventGuardTimerHandler);
				_eventGuardTimer.reset();
				_endAd();
			}
		}
		
		public function _remainingTimerHandler(event:TimerEvent):void {}
	}
}
