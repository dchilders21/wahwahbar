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
package com.eyewonder.instream.publisherAPI.adControl.adFormat.VASTAd
{
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.AbstractAdFormat;
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	

	public class VASTControl extends AbstractAdFormat
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function VASTControl(instreamFramework:InstreamFrameworkBase)
		{
			super(instreamFramework);
			
			_instreamFramework = instreamFramework;
		}
				
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function get duration():Number 
		{
			return _instreamFramework._vastParser.adTagVASTDuration;
		}
		
		public function get isWrapper():Boolean 
		{
			return _instreamFramework._vastParser.isVASTXMLWRAPPER;
		}

		public function get tagID():String 
		{
			return _instreamFramework._vastParser.adTagID;
		}
		
		public function get wrapperSystem():String 
		{
			return _instreamFramework._vastParser.adTagWrapperSystem;
		}
			
		public function get tagURL():String 
		{
			return _instreamFramework._vastParser.VASTAdTagURL;
		}

		public function get wrapperError():String 
		{
			return _instreamFramework._vastParser.adTagWrapperError;
		}

		public function get wrapperImpression():String 
		{
			return _instreamFramework._vastParser.adTagWrapperImpression;
		}

		public function get wrapperTrackingEvent():Object 
		{
			return _instreamFramework._vastParser.adTagWrapperTrackingEvent;
		}

		public function get system():String 
		{
			return _instreamFramework._vastParser.adTagSystem;
		}

		public function get title():String 
		{
			return _instreamFramework._vastParser.adTagTitle;
		}

		public function get impressionURL():String 
		{
			return _instreamFramework._vastParser.adTagImpressionURL;
		}

		public function get impressionArray():Array
		{
			return _instreamFramework._vastParser.impressionArray;
		}
		
		public function get impressionWrapperArray():Array
		{
			return _instreamFramework._vastParser.impressionWrapperArray;
		}
		
		public function get clickThruArray():Array
		{
			return _instreamFramework._vastParser.clickThruArray;
		}
		
		public function get clickThruWrapperArray():Array
		{
			return _instreamFramework._vastParser.clickThruWrapperArray;
		}

		public function get errorArray():Array
		{
			return _instreamFramework._vastParser.errorArray;
		}

		public function get errorWrapperArray():Array
		{
			return _instreamFramework._vastParser.errorWrapperArray;
		}

		public function get trackingArray():Array 
		{
			return _instreamFramework._vastParser.trackingArray;
		}

		public function get adTagClickThrough():String 
		{
			return _instreamFramework._vastParser.adTagClickThrough;
		}

		public function get mediafileArray():Array 
		{
			return _instreamFramework._vastParser.mediafileArray;
		}
		
		public function get trkStartEvent():Array 
		{
			return _instreamFramework._vastParser.trkStartEvent;
		}
		
		public function get trkMidPointEvent():Array 
		{
			return _instreamFramework._vastParser.trkMidPointEvent;
		}

		public function get trkFirstQuartileEvent():Array 
		{
			return _instreamFramework._vastParser.trkFirstQuartileEvent;
		}
		
		public function get trkThirdQuartileEvent():Array 
		{
			return _instreamFramework._vastParser.trkThirdQuartileEvent;
		}
		
		public function get trkCompleteEvent():Array 
		{
			return _instreamFramework._vastParser.trkCompleteEvent;
		}
		
		public function get trkMuteEvent():Array 
		{
			return _instreamFramework._vastParser.trkMuteEvent;
		}
		
		public function get trkPauseEvent():Array 
		{
			return _instreamFramework._vastParser.trkPauseEvent;
		}
		
		public function get trkReplayEvent():Array 
		{
			return _instreamFramework._vastParser.trkReplayEvent;
		}
		
		public function get trkFullScreenEvent():Array 
		{
			return _instreamFramework._vastParser.trkFullScreenEvent;
		}
		
		public function get trkStopEvent():Array 
		{
			return _instreamFramework._vastParser.trkStopEvent;
		}

		public function get trackingStartWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingStartWrapperArray;
		}
		
		public function get trackingMidPointWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingMidPointWrapperArray;
		}
		
		public function get trackingFirstQuartileWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingFirstQuartileWrapperArray;
		}
		
		public function get trackingThirdQuartileWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingThirdQuartileWrapperArray;
		}
		
		public function get trackingCompleteWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingCompleteWrapperArray;
		}
		
		public function get trackingMuteWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingMuteWrapperArray;
		}
		
		public function get trackingPauseWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingPauseWrapperArray;
		}
		
		public function get trackingReplayWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingReplayWrapperArray;
		}
		
		public function get trackingFullScreenWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingFullScreenWrapperArray;
		}
		
		public function get trackingStopWrapperArray():Array 
		{
			return _instreamFramework._vastParser.trackingStopWrapperArray;
		}
		
		public function get companionArray():Array 
		{
			return _instreamFramework._vastParser.companionArray;
		}
		
		public function get nonlinearArray():Array 
		{
			return _instreamFramework._vast2Parser.nonlinearArray;
		}
		
		public function get trkClickThru(): Array 
		{
			return _instreamFramework._vastParser.trkClickThru;
		}
 	}
}
