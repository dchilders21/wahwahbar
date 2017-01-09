/*
VAST2InlineElement.as

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
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2CreativeElement;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2Time;
	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */

	/**
	 * Internal InLine element parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	public dynamic class VAST2InLineElement extends VAST2Element
	{
		/* All these variables are references or arrays of references */
		private var _AdSystem:String;
		private var _AdTitle:String;
		private var _Description:String;
		private var _Survey:Array;
		private var _Error:Array;
		private var _Impression:Array;
		private var _Extensions:XML;
		private var _Creatives:VAST2CreativeElement;
	
		/**
		 * @private
		 */	
		/** VAST2InLineElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param _trackingData:VAST2TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST2InLineElement(forxData:Object = null, _trackingData:VAST2TrackingData = null)	
		{
			
			super(forxData,"VAST2InLineElement", _trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 	
			
			_AdSystem = new String();
			_AdTitle = new String();
			_Description = new String();
			_Survey = new Array();
			_Error = new Array();
			_Impression = new Array();
			_Extensions = new XML();
			_Creatives = new VAST2CreativeElement(forxData, _trackingData);

			if ( forxData == null || _trackingData == null)
			{
				UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " is just a temporary placeholder.", "Instream", elementName); 	
				return;		// Just a placeholder object to prevent null reference errors
			}

			// Continue here

				
			
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
				
				_AdSystem = _forxRef.AdSystem;
				_AdTitle = _forxRef.AdTitle;
				_Description = _forxRef.Description;
				UIFDebugMessage.getInstance()._debugMessage(2, "AdTitle: " + _AdTitle);
				UIFDebugMessage.getInstance()._debugMessage(3, "Description: " + _Description); 

				processUrlList(_forxRef.Impression,_trackingData.impressionArray);
				processUrlList(_forxRef.Error,_trackingData.errorArray);
				processUrlList(_forxRef.Survey,_trackingData.surveyArray);
				
				_Extensions = _forxRef.Extensions[0];
				
				/* For now, prevent more than one nonlinear element for two reasons:
						 1) Main reason - we have not determined how to give the player the choice on which nonlinear element to use. 
						  This is more of a sequencing questions and warrants further discussion with publishers. It doesn't seem there
						  will be high demand for this based on network test samples on the IAB site
						 2) We are also sharing the same trackingData for all creatives, and this will only work for having one of linear and
						  nonlinear creatives, but not more than one because trackers will be fired for the wrong creative. */
				var linearExists:Boolean = false;
				var nonlinearExists:Boolean = false;

				if(_forxRef.Creatives != undefined && _forxRef.Creatives.Creative != undefined) 
				{
					for(i = 0; i < _forxRef.Creatives.Creative.length(); i++) 
					{
						var itr:XML = _forxRef.Creatives.Creative[i];
						if(itr != null) 
						{
							if (!((itr.Linear != undefined && itr.Linear[0] == "Linear") && linearExists == true))
							if (!((itr.NonLinearAds != undefined && itr.NonLinearAds[0] == "NonLinearAds") && nonlinearExists == true)) // see note above
							{
								var creative:VAST2CreativeElement = new VAST2CreativeElement(itr, _trackingData);
								creative.parseXMLData();
								_Creatives.push(creative);
								if (itr.Linear) // see note above 
									linearExists = true;
								else if (itr.NonLinearAds) // see note above. Else if because of xsd says it's xs:choice. Giving <Linear> preference
									nonlinearExists = true;
							}
						}
					}
				}
				
		}
		
		/**
		 * @private
		 */	
		public function get AdSystem():String {return _AdSystem;}	
		/**
		 * @private
		 */	
		public function get AdTitle():String {return _AdTitle;}
		/**
		 * @private
		 */	
		public function get Description():String {return _Description;}
		/**
		 * @private
		 */	
		public function get Survey():Array {return _Survey;}
		/**
		 * @private
		 */	
		public function get Error():Array {return _Error;}
		/**
		 * @private
		 */	
		public function get Impression():Array {return _Impression;}
		/**
		 * @private
		 */	
		public function get Extensions():XML/*Array*/ {return _Extensions;}
		/**
		 * @private
		 */	
		public function get Creatives():VAST2CreativeElement {return _Creatives;}

		
	}
}
