/*
VAST1Parser.as

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

Parser VAST formatted XML ad tags.

*/
package com.eyewonder.instream.core.parser.vast.v1 {
	
	/**
	 * @author mthomas
	 */
	import com.eyewonder.instream.core.parser.Parser;
	import com.eyewonder.instream.core.parser.events.ParserEvent;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1Time;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1TrackingData;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1InLineElement;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1WrapperElement;
	import com.eyewonder.instream.core.debugger.*;
	
	import flash.events.Event;

	public dynamic class VAST1Parser extends Parser {
		
		// Static vars also need to be replicated in ../../VAST1Parser.as legacy file since static vars can't be inherited
		public static const TOGGLE_VAST_WRAPPER_CALLED:String = "toggleVastWrapperCalled";
		
		public var _adTagID : String;
		

		public var _trackingData : VAST1TrackingData;
		public var _InLine : VAST1InLineElement;
		public var _Wrapper : VAST1WrapperElement;

		/*public var _vastVars : Object;*/
		public var _isVASTXML : Boolean = false;
		public var _isVASTXMLWrapper : Boolean = false;
		private var VASTVersion:Number = 1.1; // TODO this has to be set by one of the VAST parsers
		
		public function VAST1Parser(trackingData:VAST1TrackingData = null) {

			UIFDebugMessage.getInstance()._debugMessage(3, "Init VAST1Parser", "Instream", "VAST1Parser (v1)");
			super();
			tagType = "VAST1";
		
			_adTagID = "";
			
			if (trackingData != null)
				_trackingData = trackingData;
			else
				_trackingData = new VAST1TrackingData();
				
			_Wrapper = new VAST1WrapperElement();
			_InLine = new VAST1InLineElement();
		
			/*_vastVars = new Object();*/
		}
		
		//performs a check to see if the xml passed to it is VAST
		public override function checkFormat(data:XML):Boolean
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In checkFormat() ", "Instream", "VAST1Parser (v1)");
			
			if(String(data.name()) == "VideoAdServingTemplate")
			{
				
				return true;
			}
			else
			{ 
				return false;
			}
		}
		
		//stores vast tags in the _vastVars object
		protected function createVASTvars() : void {
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In createVASTvars() ", "Instream", "VAST1Parser (v1)");
			
			if(!_isVASTXML && !_isVASTXMLWrapper) {
				dispatchError(4);
				return;
			}

			//check For VAST 1.1 restrictions
			if ( VASTv1RestrictionFound() )
			{
				dispatchError(4);
			}
			else
			{
			dispatchEvent(new ParserEvent(ParserEvent.XML_PARSED, this));
			}
		}

		/*
			Data is only tested if all wrappers have been parsed already, so we don't throw a false alarm here.
			
			Checks three cases,
			a) NonLinear is filled and Linear is not
			b) If NonLinear and Linear are given, ignore the NonLinear
			c) Linear is of type SWF
		*/
		private function VASTv1RestrictionFound():Boolean
		{
			var error:Boolean = false;
			
			//TODO - we need a VAST version string here, so we know whether to test the XML or not - it's HARDCODED at the moment!
			if ( (VASTVersion < 2) && (_isVASTXMLWrapper == false) )
			{
				if ( ( nonlinearArray.length > 0 ) && ( mediafileArray.length < 1 ) )
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "NonLinears are only supported with VAST version 2 and up.", "VAST1", "VAST1Parser");
					error = true;
				}
				
				if ( ( nonlinearArray.length > 0 ) && ( mediafileArray.length > 0 ) )
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "NonLinears and Linear found, ignoring NonLinear.", "VAST1", "VAST1Parser");
				}
				
				for (var i:uint; i < mediafileArray.length; i++)
				{
					var fileType:String = mediafileArray[i].type;
					if (fileType.search(/swf/i) >= 0 || fileType.search(/x-shockwave-flash/i) >= 0)
					{
						UIFDebugMessage.getInstance()._debugMessage(2, "Linear may not be of file type SWF.", "VAST1", "VAST1Parser");
						
						error = true;
					}
				}
			}
			
			return error;
		}

		protected override function parseXMLData() : void {
			//Parse Data Here: _adTagXML:XMLDocument is the XML Data
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In parseXMLData() ", "Instream", "VAST1Parser (v1)");
			
			var i:Number = 0;
			var j:Number = 0;
			var Impression:Object;
			
										
					
			if(mainXML.Ad != undefined) {
				_adTagID = mainXML.Ad.@id;
			}
				
			if(mainXML.Ad.Wrapper.AdSystem != undefined) {
				_isVASTXMLWrapper = true;
				dispatchEvent(new Event(VAST1Parser.TOGGLE_VAST_WRAPPER_CALLED));
				_Wrapper = new VAST1WrapperElement( mainXML.Ad.Wrapper, _trackingData);
				_Wrapper.parseXMLData();

			} else {
				_isVASTXML = true;
				_isVASTXMLWrapper = false;
				_InLine = new VAST1InLineElement(mainXML.Ad.InLine, _trackingData);
				_InLine.parseXMLData();
			}
			
			createVASTvars();
		}

		//VAST Getters/Setters

		public function get isVASTXML() : Boolean {
			return _isVASTXML;
		}

		public function get isVASTXMLWRAPPER() : Boolean {
			return _isVASTXMLWrapper;
		}

		public function get adTagID() : String {
			return _adTagID;
		}

		public function get adTagWrapperSystem() : String {
			return _Wrapper.AdSystem;
		}

		public function get VASTAdTagURL() : String {
			return _Wrapper.VASTAdTagURL;
		}

/* Commenting because this isn't done right. Will probably need to change core code.
		public function get adTagWrapperError() : String {
			return _trackingData.errorWrapperArray[0];
		}


		public function get adTagWrapperImpression() : String {
			return _trackingData.impressionWrapperArray[0];
		}


		public function get adTagWrapperTrackingEvent() : Object {
			return _trackingData.trackingArray[0];
		}


*/
		public function get adTagSystem() : String {
			if (_isVASTXMLWrapper)
				return _Wrapper.AdSystem;
			else
				return _InLine.AdSystem;
		}

		public function get adTagTitle() : String {
			return _InLine.AdTitle;
		}

		public function get adTagImpressionURL() : Array {
			return _trackingData.impressionArray;
		}

		public function get impressionArray() : Array
		{
			return _trackingData.impressionArray;
		}

		public function get impressionWrapperArray() : Array
		{
			return _trackingData.impressionWrapperArray;
		}
		
		public function get clickThruArray() : Array
		{
			return _trackingData.clickTrackingArray;
		}
			
		public function get clickTrackingWrapperArray() : Array
		{
			return _trackingData.clickTrackingWrapperArray;
		}

		public function get errorArray() : Array
		{
			return _trackingData.errorArray;
		}

		public function get errorWrapperArray() : Array
		{
			return _trackingData.errorWrapperArray;
		}

		public function get trackingArray() : Array {
			return _trackingData.trackingArray;
		}

		public function get adTagVASTDuration() : VAST1Time {
			return _InLine.videoDuration;
		}

		public function get adTagClickThrough() : String {
			return _InLine.ClickThrough;
		}

		public function get mediafileArray() : Array {
			return _InLine.MediaFiles;
		}
		
		public function get trkStartEvent() : Array {
			return _trackingData.trkStartEvent;
		}
		
		public function get trkMidPointEvent() : Array {
			return _trackingData.trkMidPointEvent;
		}

		public function get trkFirstQuartileEvent() : Array {
			return _trackingData.trkFirstQuartileEvent;
		}
		
		public function get trkThirdQuartileEvent() : Array {
			return _trackingData.trkThirdQuartileEvent;
		}
		
		public function get trkCompleteEvent() : Array {
			return _trackingData.trkCompleteEvent;
		}
		
		public function get trkMuteEvent() : Array {
			return _trackingData.trkMuteEvent;
		}
		
		public function get trkPauseEvent() : Array {
			return _trackingData.trkPauseEvent;
		}
		
		public function get trkReplayEvent() : Array {
			return _trackingData.trkReplayEvent;
		}
		
		public function get trkFullScreenEvent() : Array {
			return _trackingData.trkFullScreenEvent;
		}
		
		public function get trkStopEvent() : Array {
			return _trackingData.trkStopEvent;
		}

		public function get trackingStartWrapperArray() : Array {
			return _trackingData.trackingStartWrapperArray;
		}
		
		public function get trackingMidPointWrapperArray() : Array {
			return _trackingData.trackingMidPointWrapperArray;
		}
		
		public function get trackingFirstQuartileWrapperArray() : Array {
			return _trackingData.trackingFirstQuartileWrapperArray;
		}
		
		public function get trackingThirdQuartileWrapperArray() : Array {
			return _trackingData.trackingThirdQuartileWrapperArray;
		}
		
		public function get trackingCompleteWrapperArray() : Array {
			return _trackingData.trackingCompleteWrapperArray;
		}
		
		public function get trackingMuteWrapperArray() : Array {
			return _trackingData.trackingMuteWrapperArray;
		}
		
		public function get trackingPauseWrapperArray() : Array {
			return _trackingData.trackingPauseWrapperArray;
		}
		
		public function get trackingReplayWrapperArray() : Array {
			return _trackingData.trackingReplayWrapperArray;
		}
		
		public function get trackingFullScreenWrapperArray() : Array {return _trackingData.trackingFullScreenWrapperArray;}
			
		public function get trackingStopWrapperArray() : Array {return _trackingData.trackingStopWrapperArray;}
		
		public function get companionArray() : Array {return _InLine.CompanionAds;}
			
		public function get nonlinearArray() : Array {return _InLine.NonLinearAds;}
		
		public function get trkClickThru(): Array {return _trackingData._clickTrackingArray;}
			
		
	}

/* End package */
}