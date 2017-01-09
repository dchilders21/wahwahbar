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



Description
-----------

Instantiates a VPAID Translator and Controller to begin playing a VPAID ad.

*/

package com.eyewonder.instream.core.modules.videoAdModule.VPAID
{
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.v_1_1.VPAID_1_1;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.v_1_0.VPAID_1_0;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDTranslator;
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;

	/*
		Class: VPAID

		This class loads the ad SWF via VPAIDController, after that it's checked whether the
		loaded ad responds to one of the handshake functions.
		If it responds with the right handshake version then the communication between the ad and
		the framework will be done in the coresponding class.
	*/
	public class VPAID extends MovieClip
	{
		private var _instreamFramework:InstreamFrameworkBase;
		private var _translator:VPAIDTranslator;
		private var _controller:VPAIDController;
		
		private var _supportedVersion:Array = ["1.0", "1.1"];
		
		private var _vpaid:*;
		
		/*
			Constructor: VPAID
			
			This is called when a external VPAID module is being used,
			it set class names that will be instantiated.
		
			Parameters:
				VPAIDTranslator - The VPAID translator that will be used for this
				VPAIDVersion - The VPAID version String that has been found by the VAST parser
		*/
		public function VPAID(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
			// WW disable. Wait for AdStarted event (see VPAID_1_*.as and translator)
			//_instreamFramework.dispatchUIFEvent( UIFControlEvent.ON_START_PLAY_AD );
			
			_translator = new VPAIDTranslator(_instreamFramework);
			_controller = new VPAIDController(_translator);
			
			_instreamFramework._adContainer_mc = new MovieClip();
			
			
			_controller.addEventListener("VPAID_LOADED", VPAIDHandshakeTest);
			_controller.addEventListener("VPAID_END_AD", VPAIDEndAd);
		}

		private function VPAIDHandshakeTest(event:Event):void
		{
			_instreamFramework.dispatchUIFEvent( UIFControlEvent.ON_AD_LOAD_COMPLETE );
			if (_instreamFramework._adSlotType == _instreamFramework.AD_SLOT_TYPE_NONLINEAR)
			{
				_instreamFramework.dispatchUIFEvent( UIFControlEvent.HIDE_CONTROLS );
			}
			
			_instreamFramework._debugMessage(3, "In VPAIDHandshakeTest() - VPAID SWF loaded - ok", "[::VPAID::]");
			
			if (!_instreamFramework.config.scaleVAST){
			/* START SCALING DISABLED */
				_instreamFramework._debugMessage(2, "In VPAIDHandshakeTest(): Scaling disabled.", "[::VPAID::]");
				/* Do not display if too large */
				if ( ( (_translator.vpaidWidth > _instreamFramework.config.width ) || (_translator.vpaidHeight > _instreamFramework.config.height) )){
					_instreamFramework._debugMessage(1,"In VPAIDHandshakeTest(): Ad width or height is larger than video width or height. Killing ad. Ad width=" + _translator.vpaidWidth + " Ad height=" + _translator.vpaidHeight + " Player video dimensions=Rectangle[x="+_instreamFramework.config.x+",y=" + _instreamFramework.config.y+",width="+_instreamFramework.config.width+",height="+_instreamFramework.config.height+"]", "[::VPAID::]");
					_translator.trackError();
					_translator.error();
					return;
				}
			/* END SCALING DISABLED */
			}
			
			var _testResult:Boolean = false;
			
			for each (var version:String in _supportedVersion)
			{
				_instreamFramework._debugMessage(2, "In VPAIDHandshakeTest() - Testing HandshakeVersion: "+ version, "[::VPAID::]");
				
				if (_testResult == false)
				{
					_testResult = probeVersion(version);
				}
				else
				{
					break;
				}
			}
			
			if (_testResult)
			{
				//found a handshake
				_instreamFramework._debugMessage(2, "In VPAIDHandshakeTest() - Matching HandshakeVersion, ad responded: "+ _vpaid.adVersion +" - ok", "[::VPAID::]");
				
				initVPAID();
			}
			else
			{
				_translator.trackError();
				
				//none found
				_instreamFramework._debugMessage(2, "In VPAIDHandshakeTest() - No Matching HandshakeVersion found, ad responded: "+ _vpaid.adVersion +" - error", "[::VPAID::]");
				
				_controller._endAd();
			}
		}
		
		private function probeVersion(versionToTest:String):Boolean
		{
			var _result:Boolean = false;
			
			switch(versionToTest)
			{
				case "1.0":
					_vpaid = new VPAID_1_0(_controller);
					_result = _vpaid.probeVersion();
					break;
				
				case "1.1":
					_vpaid = new VPAID_1_1(_controller);
					_result = _vpaid.probeVersion();
					break;	
			}
			
			return _result;
		}
		
		private function initVPAID():void
		{
			_instreamFramework.VPAIDVersion = _vpaid.adVersion;
			
			_translator.dispatchUIFEvent(UIFControlEvent.ON_AD_LOAD_COMPLETE, { } );
			
			_instreamFramework._adContainer_mc.addChild(_translator);
			_translator.addChild(_controller._contentSwfLoader);
			
			_vpaid.init();
			
			if (_instreamFramework._adSlotType == InstreamFrameworkBase.AD_SLOT_TYPE_LINEAR)
			{
				_instreamFramework.dispatchUIFEvent( UIFControlEvent.ON_START_LINEAR );
			}
			
			if ((_translator.config.enforceVPAIDScaling) || (_translator.config.scaleVAST))
				{
					_vpaid.initVPAID(_translator.config.width, _translator.config.height, "viewMode", 300, _translator.creativeData, "frameRate=24");
				}
				else 
				{
					_vpaid.initVPAID(_translator.vpaidWidth, _translator.vpaidHeight, "viewMode", 300, _translator.creativeData, "frameRate=24");
				}
			
			_controller.ad.adVolume = _instreamFramework.audioVolume / 100;
			addFrameworkListener();
		}
		
		private function addFrameworkListener():void
		{
			_instreamFramework.addEventListener(UIFControlEvent.AD_VOLUME_CHANGED, handleUIFEvent);
			_instreamFramework.addEventListener(UIFControlEvent.AD_VID_PLAY, handleUIFEvent);
			_instreamFramework.addEventListener(UIFControlEvent.AD_VID_PAUSE, handleUIFEvent);
			_instreamFramework.addEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, handleUIFEvent);
		}
		
		private function removeFrameworkListener():void
		{
			_instreamFramework.removeEventListener(UIFControlEvent.AD_VOLUME_CHANGED, handleUIFEvent);
			_instreamFramework.removeEventListener(UIFControlEvent.AD_VID_PLAY, handleUIFEvent);
			_instreamFramework.removeEventListener(UIFControlEvent.AD_VID_PAUSE, handleUIFEvent);
			_instreamFramework.removeEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, handleUIFEvent);
		}

		private function handleUIFEvent(e:UIFEvent):void
		{
			switch(e.type)
			{
				case UIFControlEvent.AD_VOLUME_CHANGED:
					setAdVolume();
					break;
				case UIFControlEvent.AD_VID_PLAY:
					_vpaid.resumeVPAID();
					break;
				case UIFControlEvent.AD_VID_PAUSE:
					_vpaid.pauseVPAID();
					break;
				case UIFControlEvent.ON_RESIZE_NOTIFY:
						_vpaid.resizeVPAID(_translator.config.width, _translator.config.height, "normal");
					break;
			}
		}
		
		private function setAdVolume():void
		{
			var newVolume:Number = _instreamFramework.audioVolume;
			
			//make sure we only set a valid volume
			if (newVolume < 0)
			{
				newVolume = 0;
			}
			
			if (newVolume > 100)
			{
				newVolume = 100;
			}
			
			//volume in VPAID ad can be set from 0 to 1
			_vpaid.volumeVPAID = newVolume / 100;
		}
		
		private function VPAIDEndAd(e:Event):void
		{
			_controller.removeEventListener("VPAID_LOADED", VPAIDHandshakeTest);
			_controller.removeEventListener("VPAID_END_AD", VPAIDEndAd);
			
			removeFrameworkListener();
		}
		
		public function get translator():VPAIDTranslator
		{
			return _translator;	
		}	
		
	}
}
