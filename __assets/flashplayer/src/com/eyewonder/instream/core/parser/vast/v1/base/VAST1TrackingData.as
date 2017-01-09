/*
VAST1TrackingData.as

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
See VAST1Element for general high-level description of what this class does


*/

package com.eyewonder.instream.core.parser.vast.v1.base
{

	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */
	
	public dynamic class VAST1TrackingData
	{
		public var _impressionArray : Array;
		public var _surveyArray : Array;
		public var _errorArray : Array;
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
		public var _clickTrackingArray:Array;
		
		
		public function VAST1TrackingData():void
		{
			_impressionArray = new Array();
			_surveyArray = new Array();
			_errorArray = new Array();
			_trkStartEvent = new Array();
			_trkMidPointEvent = new Array();
			_trkFirstQuartileEvent = new Array();
			_trkThirdQuartileEvent = new Array();
			_trkCompleteEvent = new Array();
			_trkMuteEvent = new Array(); 
			_trkPauseEvent = new Array();
			_trkReplayEvent = new Array();
			_trkFullScreenEvent = new Array();
			_trkStopEvent = new Array();
			_clickTrackingArray = new Array();
			

		}
		
		
		public function get impressionArray() : Array { return _impressionArray;} 
		public function set impressionArray(val:Array):void { _impressionArray = val; }
		public function get surveyArray() : Array { return _surveyArray;} 
		public function set surveyArray(val:Array):void { _surveyArray = val; }	
		public function get errorArray() : Array { return _errorArray;} 
		public function set errorArray(val:Array):void { _errorArray = val; }
		public function get trkStartEvent() : Array { return _trkStartEvent;} 
		public function set trkStartEvent(val:Array):void { _trkStartEvent = val; }
		public function get trkMidPointEvent() : Array { return _trkMidPointEvent;} 
		public function set trkMidPointEvent(val:Array):void { _trkMidPointEvent = val; }
		public function get trkFirstQuartileEvent() : Array { return _trkFirstQuartileEvent;} 
		public function set trkFirstQuartileEvent(val:Array):void { _trkFirstQuartileEvent = val; }
		public function get trkThirdQuartileEvent() : Array { return _trkThirdQuartileEvent;} 
		public function set trkThirdQuartileEvent(val:Array):void { _trkThirdQuartileEvent = val; }
		public function get trkCompleteEvent() : Array { return _trkCompleteEvent;} 
		public function set trkCompleteEvent(val:Array):void { _trkCompleteEvent = val; }
		public function get trkMuteEvent() : Array { return _trkMuteEvent;} 
		public function set trkMuteEvent(val:Array):void { _trkMuteEvent = val; }
		public function get trkPauseEvent() : Array { return _trkPauseEvent;} 
		public function set trkPauseEvent(val:Array):void { _trkPauseEvent = val; }
		public function get trkReplayEvent() : Array { return _trkReplayEvent;} 
		public function set trkReplayEvent(val:Array):void { _trkReplayEvent = val; }
		public function get trkFullScreenEvent() : Array { return _trkFullScreenEvent;} 
		public function set trkFullScreenEvent(val:Array):void { _trkFullScreenEvent = val; }
		public function get trkStopEvent() : Array { return _trkStopEvent;} 
		public function set trkStopEvent(val:Array):void { _trkStopEvent = val; }
		public function get clickTrackingArray() : Array { return _clickTrackingArray;} 
		public function set clickTrackingArray(val:Array):void { _clickTrackingArray = val; }

		

	}
}