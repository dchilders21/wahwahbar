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
package com.eyewonder.instream.publisherAPI.adControl.adFormat 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.EWAd.EWControl;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.VASTAd.VASTControl;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd.VPAIDControl;
	
	/*
		Class: AbstractAdController
		
		Based upon the currently completely parsed XML,
		this layer will return the ad model.
	*/
	public class AbstractAdController
	{
		private var _instreamFramework:InstreamFrameworkBase;
		private var _abstractAd:IAbstractAdFormat;
		
		public function AbstractAdController(instreamFramework:InstreamFrameworkBase) 
		{
			_instreamFramework = instreamFramework;
			
			_instreamFramework.addEventListener(UIFControlEvent.ON_AD_FORMAT_DETECTED, createAbstractAd);
		}
		
		public function destroy():void
		{
			_instreamFramework.removeEventListener(UIFControlEvent.ON_AD_FORMAT_DETECTED, createAbstractAd);
			_abstractAd.destroy();
		}
		
		private function createAbstractAd(event:UIFEvent):void
		{
			switch(_instreamFramework._adFormat)
			{
				case "EW":
					_abstractAd = new EWControl(_instreamFramework);
					break;
				case "VAST2":
					_abstractAd = new VASTControl(_instreamFramework);
					break;
				case "VPAID":
					_abstractAd = new VPAIDControl(_instreamFramework);
					break;
			}
		}
		
		public function get ad():IAbstractAdFormat
		{
			return _abstractAd;
		}
	}

}