/*
VAST1CompanionElement.as

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

	public dynamic class VAST1CompanionElement extends VAST1Element
	{
		/* All these variables are references or arrays of references */
		private var _id:String;
		private var _width:Number;
		private var _height:Number;
		private var _expandedWidth:Number;
		private var _expandedHeight:Number;
		private var _resourceType:String;
		private var _creativeType:String;
		private var _URL:String;
		private var _Code:String;
		private var _CompanionClickThrough:String;
		private var _AltText:String;
		private var _apiFramework:String;
	
		/** VAST1CompanionElement - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param trackingData:VAST1TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST1CompanionElement(forxData:Object, trackingData:VAST1TrackingData)	
		{
			super(forxData, "VAST1CompanionElement", trackingData);
			UIFDebugMessage.getInstance()._debugMessage(3, "Element " + elementName + " created", "Instream", elementName); 
			_id = new String();
			_width = new Number();
			_height = new Number();
			_expandedWidth = new Number();
			_expandedHeight = new Number();
			_resourceType = "";
			_creativeType = "";
			_URL = "";
			_Code = "";
			_CompanionClickThrough = "";
			_apiFramework = "";
			
			if ( forxData == null || trackingData == null)
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
			if (forxRef == null)
				return;
			if (forxRef.@id != undefined) _id = forxRef.@id;
			if (forxRef.@width != undefined) _width = forxRef.@width;
			if (forxRef.@height != undefined) _height = forxRef.@height;
			if (forxRef.@expandedWidth != undefined) _expandedWidth = forxRef.@expandedWidth;
			if (forxRef.@expandedHeight != undefined) _expandedHeight = forxRef.@expandedHeight;
			if (forxRef.@resourceType != undefined) _resourceType = forxRef.@resourceType;
			if (forxRef.@creativeType != undefined) _creativeType = forxRef.@creativeType;
			if (forxRef.URL != undefined) _URL = forxRef.URL;
			if (forxRef.Code != undefined) _Code = forxRef.Code;
			if (forxRef.CompanionClickThrough != undefined && forxRef.CompanionClickThrough.URL != undefined) _CompanionClickThrough = forxRef.CompanionClickThrough.URL;
			if (forxRef.AltText != undefined) _AltText = forxRef.AltText;
			if (forxRef.AdParameters != undefined && forxRef.AdParameters.@apiFramework != undefined) _apiFramework = forxRef.AdParameters.@apiFramework;
		}
		
		public function get id():String {return _id;}
		public function get width():Number {return _width;}
		public function get height():Number {return _height;}
		public function get expandedWidth():Number {return _expandedWidth;}
		public function get expandedHeight():Number {return _expandedHeight;}
		public function get resourceType():String {return _resourceType;}
		public function get creativeType():String {return _creativeType;}
		public function get URL():String {return _URL;}
		public function get Code():String {return _Code;}
		public function get CompanionClickThrough():String {return _CompanionClickThrough;}
		public function get AltText():String {return _AltText;}
		public function get apiFramework():String {return _apiFramework;}
		
	}
	
}