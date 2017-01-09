/*
VAST1Translator.as

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

Deserializes the parser variables for the VAST modules.

*/
package com.eyewonder.instream.core.parser.vast.v1
{
	import com.eyewonder.instream.core.debugger.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	public dynamic class VAST1Translator extends Sprite
	{
		// Static vars also need to be replicated in ../../VAST1Translator.as legacy file since static vars can't be inherited
		public static const TRANSLATOR_READY:String = "translatorReady";
		
		
		public var _adTagID:String;
		public var _adTagWrapperSystem:String;
		public var _VASTAdTagURL:String;

		public var _adTagSystem:String;
		public var _adTagTitle:String;
		public var _adTagImpressionURL:String;
		public var _adTagVASTDuration:Number;
		public var _clickThruUrl:String;
		
		public var _trackingArray:Array;
		public var _adTagTrackingEvent:Array;
		
		public var _impressionArray : Array;
		public var _errorArray : Array;
		public var _clickThruArray : Array;
		public var _mediafileArray:Array;
		public var _companionArray:Array;
		public var _nonlinearArray:Array;

		
		public var _vastObj:VAST1Parser;
		public var _vastVars:Object;
		
		public var _trkStartEvent:Array;
		public var _trkMidPointEvent:Array;
		public var _trkFirstQuartileEvent:Array;
		public var _trkThirdQuartileEvent:Array;
		public var _trkCompleteEvent:Array;
		public var _trkMuteEvent:Array;
		public var _trkPauseEvent:Array;
		public var _trkReplayEvent:Array;
		public var _trkFullScreenEvent:Array;
		public var _trkStopEvent:Array;
		public var _trkClickThruEvent:Array;
		
		
		public function VAST1Translator(parser:VAST1Parser):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "Init VAST1Translator", "Instream", "VAST1Translator");
			_vastObj = parser;
			deserializeVastVars();
			
		}
		
		public function deserializeVastVars():void
		{
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In deserializeVastVars() ", "Instream", "VAST1Translator");
			
			
			_adTagWrapperSystem = String(_vastObj.adTagWrapperSystem);
			_VASTAdTagURL = String(_vastObj.VASTAdTagURL);
			//_adTagWrapperImpression = String(_vastObj.adTagWrapperImpression );
			
			_adTagID = String(_vastObj.adTagID);
			_adTagSystem = String(_vastObj.adTagSystem);
			_adTagTitle = String(_vastObj.adTagTitle);
			_adTagVASTDuration = Number(_vastObj.adTagVASTDuration);
			
			_clickThruUrl = String(_vastObj.adTagClickThrough);
			
			_impressionArray = _vastObj.impressionArray;
			_errorArray = _vastObj.errorArray;
			_clickThruArray = _vastObj.clickThruArray;
			_trackingArray = _vastObj.trackingArray;
			_mediafileArray = _vastObj.mediafileArray;
			_companionArray = _vastObj.companionArray;
			_nonlinearArray = _vastObj.nonlinearArray;
			
			_trkStartEvent = _vastObj.trkStartEvent;
			_trkMidPointEvent = _vastObj.trkMidPointEvent;
			_trkFirstQuartileEvent = _vastObj.trkFirstQuartileEvent;
			_trkThirdQuartileEvent = _vastObj.trkThirdQuartileEvent;
			_trkCompleteEvent = _vastObj.trkCompleteEvent;
			_trkMuteEvent = _vastObj.trkMuteEvent;
			_trkPauseEvent = _vastObj.trkPauseEvent;
			_trkReplayEvent = _vastObj.trkReplayEvent;
			_trkFullScreenEvent = _vastObj.trkFullScreenEvent;
			_trkStopEvent = _vastObj.trkStopEvent;
			_trkClickThruEvent = _vastObj.trkClickThru;
			
		}
		
		//VAST Getters/Setters
		public function get adTagID() : String
		{
			return _adTagID;
		}
		
		public function get adTagWrapperSystem() : String
		{
			return _adTagWrapperSystem;
		}
		
		public function get VASTAdTagURL() : String
		{
			
			return _VASTAdTagURL;
		}

		public function get adTagSystem() : String
		{
			return _adTagSystem;
		}
	
		public function get adTagTitle() : String
		{
			return _adTagTitle;
		}
		
		public function get adTagImpressionURL() : String
		{
			return _adTagImpressionURL;
		}
			
		public function get impressionArray() : Array
		{
			return _impressionArray;
		}
			
		public function get clickThruArray() : Array
		{
			return _clickThruArray;
		}

			
		public function get errorArray() : Array
		{
			return _errorArray;
		}

		
		public function get adTagVASTDuration() : Number
		{
			return _adTagVASTDuration;
		}
		
		public function get mediafileArray() : Array
		{
			return _mediafileArray;
		}
	
		public function get companionArray() : Array
		{
			return _companionArray;
		}
	
		public function get nonlinearArray() : Array
		{
			return _nonlinearArray;
		}
		public function get trkStartEvent() : Array
		{
			return _trkStartEvent;
		}
		public function get trkMidPointEvent() : Array
		{
			return _trkMidPointEvent;
		}
		public function get trkFirstQuartileEvent() : Array
		{
			return _trkFirstQuartileEvent;
		}
		public function get trkThirdQuartileEvent() : Array
		{
			return _trkThirdQuartileEvent;
		}
		public function get trkCompleteEvent() : Array
		{
			return _trkCompleteEvent;
		}
		public function get trkMuteEvent() : Array
		{
			return _trkMuteEvent;
		}
		public function get trkPauseEvent() : Array
		{
			return _trkPauseEvent;
		}
		public function get trkReplayEvent() : Array
		{
			return _trkReplayEvent;
		}
		public function get trkFullScreenEvent() : Array
		{
			return _trkFullScreenEvent;
		}
		public function get trkStopEvent() : Array
		{
			return _trkStopEvent;
		}	
	
		public function get clickThruUrl() : String
		{
			return _clickThruUrl;
		}		
			
		public function get trkClickThruEvent() : Array
		{
			return _trkClickThruEvent;
		}
	}
}