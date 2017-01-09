/*
VAST2CreativeElement.as

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
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2CompanionElement;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2NonLinearElement;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2LinearElement;
	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */
	 
	/**
	 * Internal creative element parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	public dynamic class VAST2CreativeElement extends VAST2Element
	{
	
		private var _id:String;
		private var _sequence:String;
		private var _AdID:String;
		private var _Linear:VAST2LinearElement;
		private var _CompanionAds:Array;
		private var _NonLinearAds:Array;
		private var _companionXML:XMLList;
		
		/**
		 * @private
		 */	
		public function VAST2CreativeElement(forxData:Object, trackingData:VAST2TrackingData)	
		{
			super(forxData,"VAST2CreativeElement",trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 
			
			_Linear = new VAST2LinearElement(forxData, trackingData);
			_CompanionAds = new Array();
			_NonLinearAds = new Array();
			_companionXML = null;
			
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
				/* Use else if below because VAST 2 xsd has xs:choice. Use first element in creative */
				if(_forxRef.Linear != undefined && _forxRef.Linear[0].name() == "Linear") 
				{
					_Linear = new VAST2LinearElement(_forxRef.Linear[0], _trackingData);
					_Linear.parseXMLData();
				}
				else if(_forxRef.NonLinearAds != undefined && _forxRef.NonLinearAds[0].name() == "NonLinearAds") 
				{
					for(i = 0; i < _forxRef.NonLinearAds.NonLinear.length(); i++) 
					{
						if(_forxRef.NonLinearAds.NonLinear[i] != undefined) 
						{
							var nonlinear:VAST2NonLinearElement = new VAST2NonLinearElement(_forxRef.NonLinearAds.NonLinear[i], _trackingData);
							nonlinear.parseXMLData();

							//only collect nodes with content
							if ( (nonlinear.staticResource) ||
								 (nonlinear.IFrameResource) ||
								 (nonlinear.HTMLResource) )
							{
								_NonLinearAds.push(nonlinear);
							}
						}
						/* For now, prevent more than one nonlinear element for two reasons:
						 1) Main reason - we have not determined how to give the player the choice on which nonlinear element to use. 
						  This is more of a sequencing questions and warrants further discussion with publishers. It doesn't seem there
						  will be high demand for this based on network test samples on the IAB site
						 2) We are also sharing the same trackingData for all creatives, and this will only work for having one of linear and
						  nonlinear creatives, but not more than one because trackers will be fired for the wrong creative. */
						i = _forxRef.NonLinearAds.NonLinear.length(); 
					}
					// Less code (and faster) than doing a switch inside the for trackingEvents loop
					var eventMap:Array = new Array();
					eventMap["start"] = _trackingData.trkStartEventNonLinear;
					eventMap["midpoint"] = _trackingData.trkMidPointEventNonLinear;
					eventMap["firstQuartile"] = _trackingData.trkFirstQuartileEventNonLinear;
					eventMap["thirdQuartile"] = _trackingData.trkThirdQuartileEventNonLinear;
					eventMap["complete"] = _trackingData.trkCompleteEventNonLinear;
					eventMap["mute"] = _trackingData.trkMuteEventNonLinear;
					eventMap["pause"] = _trackingData.trkPauseEventNonLinear;
					eventMap["replay"] = _trackingData.trkReplayEventNonLinear;
					eventMap["fullscreen"] = _trackingData.trkFullScreenEventNonLinear;
					eventMap["close"] = _trackingData.trkCloseEventNonLinear;				
					eventMap["creativeView"] = _trackingData.trkCreativeViewEventNonLinear;
					eventMap["unmute"] = _trackingData.trkUnmuteEventNonLinear; 
					eventMap["rewind"] = _trackingData.trkRewindEventNonLinear;
					eventMap["resume"] = _trackingData.trkResumeEventNonLinear;
					eventMap["expand"] = _trackingData.trkExpandEventNonLinear;
					eventMap["collapse"] = _trackingData.trkCollapseEventNonLinear;
					eventMap["acceptInvitation"] = _trackingData.trkAcceptInvitationEventNonLinear;					
					eventMap["stop"] = new Array(); // Prevent breaking		
					eventMap["replay"] = new Array(); // Prevent breaking			
		
					for (i = 0; i < _forxRef.NonLinearAds.TrackingEvents.Tracking.length(); i++) 
					{
							
						if(_forxRef.NonLinearAds.TrackingEvents.Tracking[i] != undefined) 
						{
							var Tracking : Object = new Object();
							Tracking.event = _forxRef.NonLinearAds.TrackingEvents.Tracking[i].@event;
							Tracking.url = _forxRef.NonLinearAds.TrackingEvents.Tracking[i].text();
							if (eventMap[String(Tracking.event)] != undefined)
								eventMap[String(Tracking.event)].push(Tracking);
						}
					}

				}
				else if(_forxRef.CompanionAds != undefined && _forxRef.CompanionAds[0].name() == "CompanionAds" && _forxRef.CompanionAds.Companion != undefined) 
				{
					_companionXML = _forxRef.CompanionAds;
					for(i = 0; i < _forxRef.CompanionAds.Companion.length(); i++) 
					{
						if(_forxRef.CompanionAds.Companion[i] != undefined) 
						{
							var companion:VAST2CompanionElement = new VAST2CompanionElement(_forxRef.CompanionAds.Companion[i]);
							companion.parseXMLData();
							_CompanionAds.push(companion);
						}
					}
				}

					

		}
		
		/**
		 * @private
		 */	
		public function get Linear():VAST2LinearElement {return _Linear;}
		/**
		 * @private
		 */	
		public function get CompanionAds():Array {return _CompanionAds;}
		/**
		 * @private
		 */	
		public function get NonLinearAds():Array {return _NonLinearAds;}

		public function get companionXML():XMLList {return _companionXML}
	}
}
