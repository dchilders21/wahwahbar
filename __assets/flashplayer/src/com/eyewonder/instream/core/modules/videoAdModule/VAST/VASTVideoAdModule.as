/*
VASTVideoAdModule.as

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

Sub class of VideoAdModule

*/
package com.eyewonder.instream.core.modules.videoAdModule.VAST
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.debugger.*;
	import com.eyewonder.instream.core.modules.videoAdModule.base.IVideoAdModule;
	import com.eyewonder.instream.core.modules.videoAdModule.base.VideoAdModule;
	import com.eyewonder.instream.core.modules.videoAdScreenModule.base.IVideoAdScreenModule;
	import com.eyewonder.instream.core.parser.events.*;
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Parser;
	import com.eyewonder.instream.core.parser.vast.v1.VAST1Translator;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Parser;
	import com.eyewonder.instream.core.parser.vast.v2.VAST2Translator;
	
	import flash.display.MovieClip;
	import flash.events.*;

	public dynamic class VASTVideoAdModule extends VideoAdModule implements IVideoAdModule
	{
		public function VASTVideoAdModule(ewad:InstreamFrameworkBase, videoScreen:IVideoAdScreenModule)
		{	
			super(ewad, videoScreen); 
			
			UIFDebugMessage.getInstance()._debugMessage(2, "========================================", "VAST", "VASTModule");
			UIFDebugMessage.getInstance()._debugMessage(2, "Vast FLV Module v1.0", "VAST", "VASTModule");
			UIFDebugMessage.getInstance()._debugMessage(2, "Created on: April 21, 2009", "VAST", "VASTModule");
			UIFDebugMessage.getInstance()._debugMessage(2, "Ad Type: Fixedroll AS3", "VAST", "VASTModule");
			UIFDebugMessage.getInstance()._debugMessage(2, "========================================", "VAST", "VASTModule");
			
			
			//creates instance of VastTranslator inside vastHolder
			if (ewad._adFormat == "VAST")
				translator = new VAST1Translator(vastParser as VAST1Parser);
			else if (ewad._adFormat == "VAST2")
				translator = new VAST2Translator(vastParser as VAST2Parser);
			else
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Not VAST!", "VAST", "VASTModule"); // Shouldn't happen
				return;
			}
			
			translator.addEventListener(ParserErrorEvent.XML_ERROR, onXMLError);
			
			_preferredDeliveryMethod = ewad.config.preferredDeliveryMethod;
			_bwDetectProgressiveURL = ewad.config.bwDetectProgressiveURL;
			_bwDetectStreamingServer = ewad.config.bwDetectStreamingServer;
			_qualityFirst = ewad.config.qualityFirst;
				
			vastTranslatorReady();
		}
		
		
		public function vastTranslatorReady():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2,"Timer and load notification", "VAST", "VASTModule"  );
			
			// Ad is ready to begin. Notify player that the ad is loaded.
			pausePlayerVideo();
			
			//passes the preferred deliveryMethod to VideoPlayer
			if (_preferredDeliveryMethod != String(null))		
					videoAdScreenModule.setPreferredDeliveryMethod( String(_preferredDeliveryMethod));
			
			// Whether to prefer quality or preferred delivery mode if the highest bandwidth is non-preferred delivery mode
			if (_qualityFirst != "undefined")
					videoAdScreenModule.setQualityFirst(_qualityFirst);
			
			//setting properties inside video screen
			videoAdScreenModule.setMediaFile(translator.mediafileArray);
			videoAdScreenModule.setVolume(getAudioVolume());
			
			videoAdScreenModule.setDuration(translator.adTagVASTDuration);
			
			videoAdScreenModule.setBwDetectStreamingServer(_bwDetectStreamingServer);
			videoAdScreenModule.setBwDetectProgressiveURL( _bwDetectProgressiveURL);
			videoAdScreenModule.setScaleVideo(ewad.config.scaleVAST);
			videoAdScreenModule.setPositionVideo(ewad.config.positionVAST);
			
			//ewVideoScreen.errorID = ;
			//ewVideoScreen.errorDescription = ;
			
			//initializes VideoPlayer
			videoAdScreenModule.initialize();

			//initializes impression and tracking events movieClips
			impressionHolder = new MovieClip();
			vastWrapperImpression = new MovieClip();

			//trackImpression();
			
			//pass clickThru url and cachebuster to clickThru class
			vastClickThru = new VASTClickThru(cacheBuster, translator.clickThruUrl, translator.clickThruArray);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, vastClickThru.onClickThru);
			this.addEventListener(MouseEvent.CLICK, trackClickThru);
		}
		
		
		
	
	}
}