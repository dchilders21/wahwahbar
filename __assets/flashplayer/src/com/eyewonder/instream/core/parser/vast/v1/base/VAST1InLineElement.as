/*
VAST1InlineElement.as

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
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1CompanionElement;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1NonLinearElement;
	import com.eyewonder.instream.core.parser.vast.v1.base.VAST1Time;
	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */

	public dynamic class VAST1InLineElement extends VAST1Element
	{
		/* All these variables are references or arrays of references */
		private var _AdSystem:String;
		private var _AdTitle:String;
		private var _Description:String;
		private var _Survey:Array;
		private var _Error:Array;
		private var _Impression:Array;
		private var _videoDuration:VAST1Time;
		private var _apiFramework:String;
		private var _MediaFiles:Array;
		private var _CompanionAds:Array;
		private var _NonLinearAds:Array;
		private var _Extensions:XML;
		private var _ClickThrough:String;
	
		/** VAST1InLineElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param _trackingData:VAST1_trackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST1InLineElement(forxData:Object = null, _trackingData:VAST1TrackingData = null)	
		{
			
			super(forxData,"VAST1InLineElement", _trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element " + elementName + " created", "Instream", elementName); 	
			
			_AdSystem = new String();
			_AdTitle = new String();
			_Description = new String();
			_Survey = new Array();
			_Error = new Array();
			_Impression = new Array();
			_videoDuration = new VAST1Time();
			_apiFramework = new String();
			_MediaFiles = new Array();
			_CompanionAds = new Array();
			_NonLinearAds = new Array();
			_Extensions = new XML();
			_ClickThrough = new String();

			if ( forxData == null || _trackingData == null)
			{
				UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " is just a temporary placeholder.", "Instream", elementName); 	
				return;		// Just a placeholder object to prevent null reference errors
			}

			// Continue here

				
			
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
				_AdTitle = _forxRef.AdTitle;
				_Description = _forxRef.Description;
				UIFDebugMessage.getInstance()._debugMessage(2, "AdTitle: " + _AdTitle);
				UIFDebugMessage.getInstance()._debugMessage(3, "Description: " + _Description); 

				processUrlList(_forxRef.Impression,_trackingData.impressionArray);
				processUrlList(_forxRef.Error,_trackingData.errorArray);
				processUrlList(_forxRef.Survey,_trackingData.surveyArray);
				_Extensions = _forxRef.Extensions[0];
				
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
						
				for (i = 0; i < _forxRef.TrackingEvents.Tracking.length(); i++) 
				{
					
					var trackURL : Array = new Array();
					for(j = 0; j < _forxRef.TrackingEvents.Tracking[i].URL.length(); j++)
					{
						
						if (_forxRef.TrackingEvents.Tracking[i].URL[j] != undefined) {
							
							var Tracking : Object = new Object();
							
							if(_forxRef.TrackingEvents.Tracking[i] != undefined) {
								Tracking.event = _forxRef.TrackingEvents.Tracking[i].@event;
							}
							
							trackURL.push( _forxRef.TrackingEvents.Tracking[i].URL[j]);
							Tracking.url = trackURL[j];
							
							if (eventMap[String(Tracking.event)] != undefined)
								eventMap[String(Tracking.event)].push(Tracking);
							
						}
					}
				}

				if(_forxRef.Video.Duration != undefined) {
					var durationArray : Array = _forxRef.Video.Duration.text().split(":");
					_videoDuration = new VAST1Time(durationArray[0], durationArray[1], durationArray[2]);
				}
				
				if(_forxRef.Video.VideoClicks != undefined) {
					if(_forxRef.Video.VideoClicks.ClickThrough != undefined) 
					{
						if(_forxRef.Video.VideoClicks.ClickThrough.URL != undefined) 
						{
							_ClickThrough = _forxRef.Video.VideoClicks.ClickThrough.URL;
						}
					}
					//Get the clickthru tracking URLS
					processUrlList(_forxRef.Video.VideoClicks.ClickTracking,_trackingData.clickTrackingArray);
				}
				
				if(_forxRef.Video.MediaFiles != undefined) {
					for(i = 0; i < _forxRef.Video.MediaFiles.MediaFile.length(); i++) {
						
						if (_forxRef.Video.MediaFiles.MediaFile[i] != undefined) {
							if (_forxRef.Video.MediaFiles.MediaFile[i].URL != undefined) {
								var tempArray : Array = _forxRef.Video.MediaFiles.MediaFile[i].URL.text().split(".");
								
								var Mediafile : Object = new Object();
								Mediafile.url = _forxRef.Video.MediaFiles.MediaFile[i].URL.text();
								Mediafile.delivery = _forxRef.Video.MediaFiles.MediaFile[i].@delivery;
								Mediafile.bitrate = _forxRef.Video.MediaFiles.MediaFile[i].@bitrate;
								Mediafile.type = _forxRef.Video.MediaFiles.MediaFile[i].@type;
								Mediafile.width = _forxRef.Video.MediaFiles.MediaFile[i].@width;
								Mediafile.height = _forxRef.Video.MediaFiles.MediaFile[i].@height;
									
								_MediaFiles.push(Mediafile);
							}
						}
					}
				}
				
				if(_forxRef.CompanionAds != undefined && _forxRef.CompanionAds.Companion != undefined) 
				{
					for(i = 0; i < _forxRef.CompanionAds.Companion.length(); i++) 
					{
						if(_forxRef.CompanionAds.Companion[i] != undefined) 
						{
							var companion:VAST1CompanionElement = new VAST1CompanionElement(_forxRef.CompanionAds.Companion[i], _trackingData);
							companion.parseXMLData();
							_CompanionAds.push(companion);
						}
					}
				}
				
				if(_forxRef.NonLinearAds != undefined && _forxRef.NonLinearAds.NonLinear != undefined) 
				{
					for(i = 0; i < _forxRef.NonLinearAds.NonLinear.length(); i++) 
					{
						if(_forxRef.NonLinearAds.NonLinear[i] != undefined) 
						{
							var nonlinear:VAST1NonLinearElement = new VAST1NonLinearElement(_forxRef.NonLinearAds.NonLinear[i], _trackingData);
							nonlinear.parseXMLData();
							_NonLinearAds.push(nonlinear)
						}
					}
				}
					

		}
		
		public function get AdSystem():String {return _AdSystem;}
		public function get AdTitle():String {return _AdTitle;}
		public function get Description():String {return _Description;}
		public function get Survey():Array {return _Survey;}
		public function get Error():Array {return _Error;}
		public function get Impression():Array {return _Impression;}
		public function get videoDuration():VAST1Time {return _videoDuration;}
		public function get apiFramework():String {return _apiFramework;}
		public function get MediaFiles():Array {return _MediaFiles;}
		public function get CompanionAds():Array {return _CompanionAds;}
		public function get NonLinearAds():Array {return _NonLinearAds;}
		public function get Extensions():XML/*Array*/ {return _Extensions;}
		public function get ClickThrough():String {return _ClickThrough;}

		
	}
}