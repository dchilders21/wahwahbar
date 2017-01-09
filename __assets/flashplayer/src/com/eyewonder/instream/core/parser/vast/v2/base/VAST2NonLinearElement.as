/*
VAST2NonLinearElement.as

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
	 * Internal non-linear element parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	public dynamic class VAST2NonLinearElement extends VAST2Element
	{
		/* All these variables are references or arrays of references */
		private var _id:String;
		private var _width:Number;
		private var _height:Number;
		private var _expandedWidth:Number;
		private var _expandedHeight:Number;
		/* NO LONGER USED
		private var _resourceType:String;
		private var _creativeType:String; */
		private var _scalable:Boolean;
		private var _maintainAspectRatio:Boolean;
		private var _staticResource:String;
		private var _iframeResource:String;
		private var _htmlResource:String;
		private var _staticResourceCreativeType:String;
		/* NO LONGER USED
		private var _URL:String;
		private var _Code:String; */
		private var _AltText:String;
		private var _apiFramework:String;
		private var _adParameters:String;
		private var _NonLinearClickThrough:String;
		private var _minSuggestedDuration:VAST2Time;
	
		/**
		 * @private
		 */	
		/** VAST2NonLinearElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param trackingData:VAST2TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST2NonLinearElement(forxData:Object, trackingData:VAST2TrackingData)	
		{
			super(forxData,"VAST2NonLinearElement", trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 
			_id = "";
			_width = new Number();
			_height = new Number();
			_expandedWidth = new Number();
			_expandedHeight = new Number();
			/* NO LONGER USED
			_resourceType = "";
			_creativeType = ""; */
			_scalable = new Boolean();
			_maintainAspectRatio = new Boolean();
			_staticResource = new String();
			_iframeResource = new String();
			_htmlResource = new String();
			_staticResourceCreativeType = new String();
			/* _URL = ""; NO LONGER USED */
			/* _Code = ""; NO LONGER USED */
			_NonLinearClickThrough = new String();
			_apiFramework = new String();
			_adParameters = new String();
			
			_minSuggestedDuration = new VAST2Time();
			
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
			if (forxRef == null)
				return;
			if (forxRef.@id != undefined) _id = forxRef.@id;
			if (forxRef.@width != undefined) _width = forxRef.@width;
			if (forxRef.@height != undefined) _height = forxRef.@height;
			if (forxRef.@expandedWidth != undefined) _expandedWidth = forxRef.@expandedWidth;
			if (forxRef.@expandedHeight != undefined) _expandedHeight = forxRef.@expandedHeight;
			if (forxRef.@scalable != undefined) _scalable = StringManipulation.toBoolean(forxRef.@scalable, true);
			if (forxRef.@maintainAspectRatio != undefined) _maintainAspectRatio = StringManipulation.toBoolean(forxRef.@maintainAspectRatio, true);
			if (forxRef.@minSuggestedDuration != undefined )
			{
				var durationArray : Array = _forxRef.@minSuggestedDuration.split(":");
				
				if (durationArray.length)
				{
					_minSuggestedDuration = new VAST2Time(durationArray[0], durationArray[1], durationArray[2]);
				}
			}
			
			if (forxRef.@apiFramework != undefined ) 
			{
				_apiFramework = forxRef.@apiFramework;
				_apiFramework = _apiFramework.toUpperCase();
			}
			
			if (forxRef.AdParameters != undefined)
			{
				_adParameters = forxRef.AdParameters;
			}
 			
			//static resource ads
			if ((forxRef.StaticResource != undefined ) && (forxRef.StaticResource != "" ))
			{
				_staticResource = forxRef.StaticResource.text();
			}
			
			if ((forxRef.StaticResource.@creativeType != undefined ) && (forxRef.StaticResource.@creativeType != "" ))
			{
				_staticResourceCreativeType = forxRef.StaticResource.@creativeType;
			}
		
			//clickThru
			if ((forxRef.NonLinearClickThrough.text() != undefined ) && (forxRef.NonLinearClickThrough.text() != "" ))
			{
				_NonLinearClickThrough = forxRef.NonLinearClickThrough.text();
			}
			
			//IFrameResource
			if ((forxRef.IFrameResource != undefined ) && (forxRef.IFrameResource != "" ))
			{
				_iframeResource = forxRef.IFrameResource.text();
			}
			
			if ((forxRef.HTMLResource != undefined ) && (forxRef.HTMLResource != "" ))
			{
				_htmlResource = forxRef.HTMLResource.text();
			}
		}

		/**
		 * @private
		 */	
		public function get id():String {return _id;}
		/**
		 * @private
		 */	
		public function get width():Number {return _width;}
		/**
		 * @private
		 */	
		public function get height():Number {return _height;}
		/**
		 * @private
		 */	
		public function get expandedWidth():Number {return _expandedWidth;}
		/**
		 * @private
		 */	
		public function get expandedHeight():Number {return _expandedHeight;}
		/**
		 * @private
		 */	
		public function get resourceType():String {return "";}  // NO LONGER USED
		/**
		 * @private
		 */	
		public function get creativeType():String {return staticResourceCreativeType;} // DEPRECATED. USE staticResourceCreativeType
		/**
		 * @private
		 */	
		public function get URL():String {return staticResource;} // DEPRECATED. USE staticResource
		/**
		 * @private
		 */	
		public function get scalable():Boolean {return _scalable;}
		/**
		 * @private
		 */	
		public function get maintainAspectRatio():Boolean {return _maintainAspectRatio;}
		/**
		 * @private
		 */	
		public function get Code():String {return "";} // NO LONGER USED
		/**
		 * @private
		 */	
		public function get nonLinearClickThrough():String {return _NonLinearClickThrough;}
		/**
		 * @private
		 */	
		public function get apiFramework():String {return _apiFramework;}
		/**
		 * @private
		 */	
		public function get staticResource():String {return _staticResource;}
		/**
		 * @private
		 */	
		public function get staticResourceCreativeType():String { return _staticResourceCreativeType;}
		/**
		 * @private
		 */	
		public function get iframeResource():String {return _iframeResource };
		/**
		 * @private
		 */	
		public function get htmlResource():String { return _htmlResource};
		/**
		 * @private
		 */	
		public function get adParameters():String { return _adParameters};	
		/**
		 * @private
		 */	
		public function get minSuggestedDuration():VAST2Time { return _minSuggestedDuration };
	}
}
