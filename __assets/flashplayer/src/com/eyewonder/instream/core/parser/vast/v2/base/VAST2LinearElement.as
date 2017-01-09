/*
VAST2LinearElement.as

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
See VAST2Element for general high-level description of what this class does


*/

package com.eyewonder.instream.core.parser.vast.v2.base
{
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2Element;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2TrackingData;
	import com.eyewonder.instream.core.debugger.*;
	import com.eyewonder.instream.core.utility.StringManipulation;
	
	/**
	 * @author bbober
	 */
	 
	/**
	 * Internal linear creative parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	
	public dynamic class VAST2LinearElement extends VAST2Element
	{
		private var _videoDuration:VAST2Time;
		private var _apiFramework:String;
		private var _MediaFiles:Array;
		private var _ClickThrough:String;
		private var _CustomClick:Array;
		private var _CustomClickIds:Array;
		private var _adParameters:String;
		
		public function VAST2LinearElement(forxData:Object, trackingData:VAST2TrackingData)	
		{
			super(forxData,"VAST2LinearElement",trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 
			
			_videoDuration = new VAST2Time();
			_apiFramework = new String();
			_MediaFiles = new Array();
			_ClickThrough = new String();
			_CustomClick = new Array();
			
			if ( forxData == null || _trackingData == null)
			{
				UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " is just a temporary placeholder.", "Instream", elementName); 	
				return;		// Just a placeholder object to prevent null reference errors
			}
		}
			
		/**
		 * @private
		 */	
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
				
			// Less code (and faster) than doing a switch inside the for trackingEvents loop
			var eventMap:Array = new Array();
			eventMap["creativeView"] = _trackingData.trkCreativeViewEvent;
			eventMap["start"] = _trackingData.trkStartEvent;
			eventMap["midpoint"] = _trackingData.trkMidPointEvent;
			eventMap["firstQuartile"] = _trackingData.trkFirstQuartileEvent;
			eventMap["thirdQuartile"] = _trackingData.trkThirdQuartileEvent;
			eventMap["complete"] = _trackingData.trkCompleteEvent;
			eventMap["mute"] = _trackingData.trkMuteEvent;
			eventMap["unmute"] = _trackingData.trkUnmuteEvent; 
			eventMap["pause"] = _trackingData.trkPauseEvent;
			eventMap["rewind"] = _trackingData.trkRewindEvent;
			eventMap["resume"] = _trackingData.trkResumeEvent;
			eventMap["fullscreen"] = _trackingData.trkFullScreenEvent;
			eventMap["expand"] = _trackingData.trkExpandEvent;
			eventMap["collapse"] = _trackingData.trkCollapseEvent;
			eventMap["replay"] = _trackingData.trkReplayEvent;
			eventMap["acceptInvitation"] = _trackingData.trkAcceptInvitationEvent;					
			eventMap["close"] = _trackingData.trkCloseEvent;				
			
			eventMap["stop"] = new Array(); // Prevent breaking		
			eventMap["replay"] = new Array(); // Prevent breaking			

			for (i = 0; i < _forxRef.TrackingEvents.Tracking.length(); i++) 
			{
					
				if(_forxRef.TrackingEvents.Tracking[i] != undefined) 
				{
					var Tracking : Object = new Object();
					Tracking.event = _forxRef.TrackingEvents.Tracking[i].@event;
					Tracking.url = _forxRef.TrackingEvents.Tracking[i].text();
					if (eventMap[String(Tracking.event)] != undefined)
						eventMap[String(Tracking.event)].push(Tracking);
				}
			}

			if(_forxRef.AdParameters != undefined) 
				_adParameters = _forxRef.AdParameters.text();
			
			if(_forxRef.Duration != undefined) 
			{
				var durationArray : Array = _forxRef.Duration.text().split(":");
				_videoDuration = new VAST2Time(durationArray[0], durationArray[1], durationArray[2]);
			}
			
			if(_forxRef.VideoClicks != undefined) 
			{
				if(_forxRef.VideoClicks.ClickThrough != undefined) 
				{
						_ClickThrough = _forxRef.VideoClicks.ClickThrough.text();
				}
				//Get the clickthru tracking URLS
				processUrlList(_forxRef.VideoClicks.ClickTracking,_trackingData.clickTrackingArray);
				
				for(i = 0; i < _forxRef.VideoClicks.CustomClick.length(); i++) 
				{
					
					if (_forxRef.VideoClicks.CustomClick[i] != undefined) 
					{
						
						var customClick:Object = new Object;
						customClick.url = _forxRef.VideoClicks.CustomClick[i].text();
						customClick.id = _forxRef.VideoClicks.CustomClick[i].@id;
						_CustomClick.push(customClick);
					}
				}
			}
			
			if(_forxRef.MediaFiles != undefined) 
			{
				for(i = 0; i < _forxRef.MediaFiles.MediaFile.length(); i++) 
				{
					if ((_forxRef.MediaFiles.MediaFile[i] != undefined) && (_forxRef.MediaFiles.MediaFile[i] != ""))
					{
						var Mediafile : Object = new Object();
						Mediafile.url = _forxRef.MediaFiles.MediaFile[i].text();
						Mediafile.delivery = _forxRef.MediaFiles.MediaFile[i].@delivery;
						Mediafile.bitrate = _forxRef.MediaFiles.MediaFile[i].@bitrate;
						Mediafile.type = _forxRef.MediaFiles.MediaFile[i].@type;
						Mediafile.width = _forxRef.MediaFiles.MediaFile[i].@width;
						Mediafile.height = _forxRef.MediaFiles.MediaFile[i].@height;
						Mediafile.id = _forxRef.MediaFiles.MediaFile[i].@id;
							
						//scaleable defaults to true if not given
						Mediafile.scalable = StringManipulation.toBoolean(_forxRef.MediaFiles.MediaFile[i].@scalable, true);
						
						//maintainAspectRatio defaults to true if not given
						Mediafile.maintainAspectRatio = StringManipulation.toBoolean(_forxRef.MediaFiles.MediaFile[i].@maintainAspectRatio, true);

						Mediafile.apiFramework = _forxRef.MediaFiles.MediaFile[i].@apiFramework;
						if (Mediafile.apiFramework)
						{
							Mediafile.apiFramework = String(Mediafile.apiFramework).toUpperCase();
						}
						
					
						_MediaFiles.push(Mediafile);
					}
				}
			}
		}
	
		/**
		 * @private
		 */	
		public function get adParameters():String {return _adParameters;}
		/**
		 * @private
		 */	
		public function get videoDuration():VAST2Time {return _videoDuration;}
		/**
		 * @private
		 */	
		public function get apiFramework():String {return _apiFramework;}
		/**
		 * @private
		 */	
		public function get MediaFiles():Array {return _MediaFiles;}
		/**
		 * @private
		 */	
		public function get ClickThrough():String {return _ClickThrough;}
		/**
		 * @private
		 */	
		public function get CustomClick():Array {return _CustomClick;}
	
	}
}
