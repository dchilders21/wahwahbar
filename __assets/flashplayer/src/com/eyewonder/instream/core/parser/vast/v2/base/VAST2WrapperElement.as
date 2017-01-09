/*
VAST2WrapperElement.as

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
	import com.eyewonder.instream.core.debugger.*;
	
	/**
	 * @author bbober
	 */
		
	/**
	 * Internal wrapper tag parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	public dynamic class VAST2WrapperElement extends VAST2Element
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
		private var _Creatives:VAST2CreativeElement;		
		
		/**
		 * @private
		 */	
		/** VAST2WrapperElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param trackingData:VAST2TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST2WrapperElement(forxData:Object = null, trackingData:VAST2TrackingData = null)	
		{
			super(forxData, "VAST2WrapperElement", trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 
			
			_AdSystem= new String();
			_VASTAdTagURL = new String();
			_CompanionAdImpression = new Array();
			_CompanionAdTagURL = new Array();
			_CompanionAdTagCode = new String();
			_NonLinearImpression = new Array();
			_NonLinearAdTagURL = new Array();
			_NonLinearAdTagCode = new String();	
			_Creatives = new VAST2CreativeElement(forxData, _trackingData);
			
			if ( forxData == null || trackingData == null)
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
				
				_AdSystem = _forxRef.AdSystem;

				if(_forxRef.VASTAdTagURI != undefined) {
					_VASTAdTagURL = _forxRef.VASTAdTagURI;
				}
				
				processUrlList(_forxRef.Impression,_trackingData.impressionArray);
				processUrlList(_forxRef.Error,_trackingData.errorArray);
				
				
				if(_forxRef.Creatives != undefined && _forxRef.Creatives.Creative != undefined) 
				{
					for(i = 0; i < _forxRef.Creatives.Creative.length(); i++) 
					{
						if(_forxRef.Creatives.Creative[i] != undefined) 
						{
							var creative:VAST2CreativeElement = new VAST2CreativeElement(_forxRef.Creatives.Creative[i], _trackingData);
							creative.parseXMLData();
							_Creatives.push(creative)
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
		public function get VASTAdTagURL():String {return _VASTAdTagURL;}
		/**
		 * @private
		 */	
		public function get CompanionImpression():Array {return _CompanionAdImpression;}
		/**
		 * @private
		 */	
		public function get CompanionAdTagURL():Array {return _CompanionAdTagURL;}
		/**
		 * @private
		 */	
		public function get CompanionAdTagCode():String {return _CompanionAdTagCode;}
		/**
		 * @private
		 */	
		public function get NonLinearImpression():Array {return _NonLinearImpression;}
		/**
		 * @private
		 */	
		public function get NonLinearAdTagURL():Array {return _NonLinearAdTagURL;}
		/**
		 * @private
		 */	
		public function get NonLinearAdTagCode():String {return _NonLinearAdTagCode;}		
		
		
	}
}
