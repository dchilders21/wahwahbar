/*
VAST1WrapperElement.as

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

	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1Element;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1TrackingData;
	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */
		
	public dynamic class VAST1WrapperElement extends VAST1Element
	{
		/* All these variables are references or arrays of references */
		private var _AdSystem:String;
		private var _VASTAdTagURL:String;
		/* Not really sure what the following are for since the destination tag should really be where the companion ads are */
		private var _CompanionAdImpression:Array;
		private var _CompanionAdTagURL:Array;
		private var _CompanionAdTagCode:String;
		private var _NonLinearImpression:Array;
		private var _NonLinearAdTagURL:Array;
		private var _NonLinearAdTagCode:String;		
		
		
		/** VAST1WrapperElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param _trackingData:VAST1TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST1WrapperElement(forxData:Object = null, _trackingData:VAST1TrackingData = null)	
		{
			super(forxData, "VAST1WrapperElement", _trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element " + elementName + " created", "Instream", elementName); 
			
			_AdSystem= new String();
			_VASTAdTagURL = new String();
			_CompanionAdImpression = new Array();
			_CompanionAdTagURL = new Array();
			_CompanionAdTagCode = new String();
			_NonLinearImpression = new Array();
			_NonLinearAdTagURL = new Array();
			_NonLinearAdTagCode = new String();	
			
			if ( forxData == null || _trackingData == null)
			{
				UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " is just a temporary placeholder.", "Instream", elementName); 	
				return;		// Just a placeholder object to prevent null reference errors
			}
		}
		
		/** parseXMLData
		 *
		 * Parse out XML data and set variables accordingly.
		*/ 
		public function parseXMLData() : void
		{
							
		
			var i:Number;
			var j:Number;
			
			if (_forxRef == null || _trackingData == null)
				return;
				
				_AdSystem = _forxRef.AdSystem;

				if(_forxRef.VASTAdTagURL.URL != undefined) {
					_VASTAdTagURL = _forxRef.VASTAdTagURL.URL;
				}
				
				processUrlList(_forxRef.CompanionAds.CompanionImpression,_CompanionAdImpression);
				processUrlList(_forxRef.NonLinearAds.NonLinearImpression,_NonLinearImpression);

				
				if(_forxRef.CompanionAds.CompanionAdTag.URL != undefined) {
					_CompanionAdTagURL = _forxRef.CompanionAds.CompanionAdTag.URL;
				}
				

				
				if(_forxRef.CompanionAds.CompanionAdTag.Code != undefined) {
					_CompanionAdTagCode = _forxRef.CompanionAds.CompanionAdTag.Code;
				}
				
				if(_forxRef.NonLinearAds.NonLinearAdTag.URL != undefined) {
					_NonLinearAdTagURL = _forxRef.NonLinearAds.NonLinearAdTag.URL;
				}
				
				if(_forxRef.NonLinearAds.NonLinearAdTag.Code != undefined) {
					_NonLinearAdTagCode = _forxRef.NonLinearAds.NonLinearAdTag.Code;
				}

				
				processUrlList(_forxRef.Impression,_trackingData.impressionArray);
				processUrlList(_forxRef.Error,_trackingData.errorArray);
				
				// Less code (and faster) than doing a switch inside the for trackingEvents loop
				var eventMap:Array = new Array();
				eventMap["start"] = _trackingData.trkStartEvent;
				eventMap["midpoint"] = _trackingData.trkMidPointEvent;
				eventMap["firstQuartile"] = _trackingData.trkFirstQuartileEvent;
				eventMap["thirdQuartile"] = _trackingData.trkThirdQuartileEvent;
				eventMap["complete"] = _trackingData.trkCompleteEvent;
				eventMap["mute"] = _trackingData.trkMuteEvent;
				eventMap["pause"] = _trackingData.trkPauseEvent;
				eventMap["replay"] = _trackingData.trkReplayEvent;
				eventMap["fullscreen"] = _trackingData.trkFullScreenEvent;
				eventMap["stop"] = _trackingData.trkStopEvent;

				for(i = 0; i < _forxRef.TrackingEvents.Tracking.length(); i++) 
				{
					var TrackingWrapper : Object = new Object();
					
					if(_forxRef.TrackingEvents.Tracking[i] != undefined) {
						TrackingWrapper.event = _forxRef.TrackingEvents.Tracking[i].@event;
					}
					
					
					var trackWrapperURL : Array = new Array();
					
					for(j = 0; j < _forxRef.TrackingEvents.Tracking[i].URL.length(); j++)
					{
						
						if (_forxRef.TrackingEvents.Tracking[i].URL[j] != undefined) 
						{
							trackWrapperURL.push( _forxRef.TrackingEvents.Tracking[i].URL[j]);
							TrackingWrapper.url = trackWrapperURL[j];
					
							
							if (eventMap[String(TrackingWrapper.event)] != undefined)
								eventMap[String(TrackingWrapper.event)].push(TrackingWrapper);
					
						}
					}
				}
				
				//Get the clickthru tracking URLS
				processUrlList(forxRef.VideoClicks.ClickTracking,_trackingData.clickTrackingArray);
		
		
		}
		
		public function get AdSystem():String {return _AdSystem;}
		public function get VASTAdTagURL():String {return _VASTAdTagURL;}
		public function get CompanionImpression():Array {return _CompanionAdImpression;}
		public function get CompanionAdTagURL():Array {return _CompanionAdTagURL;}
		public function get CompanionAdTagCode():String {return _CompanionAdTagCode;}
		public function get NonLinearImpression():Array {return _NonLinearImpression;}
		public function get NonLinearAdTagURL():Array {return _NonLinearAdTagURL;}
		public function get NonLinearAdTagCode():String {return _NonLinearAdTagCode;}		
		
		
	}
}