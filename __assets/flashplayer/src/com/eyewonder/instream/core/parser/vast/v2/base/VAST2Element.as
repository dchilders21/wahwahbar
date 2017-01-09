/*
VAST2Element.as

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

This is the Base class for an element. It is NOT a DOM element. We are still using E4X. 
An element is instead a class for storing references to the most commonly used elements.
The rest still needs to be accessed through the E4X XML tree, which is also referenced in 
this class.

*/

package com.eyewonder.instream.core.parser.vast.v2.base
{

	import com.eyewonder.instream.core.debugger.*;
	import com.eyewonder.instream.core.parser.vast.v2.base.VAST2TrackingData;
	
	/**
	 * @author bbober
	 */
	
	/**
	 * Base class for all elements
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	public dynamic class VAST2Element extends Array
	{
		
		protected var _forxRef:Object; 		//Reference to the portion of the forx tree
		protected var _elementName:String; 	//Name of the element
		protected var _trackingData:VAST2TrackingData;
	
		/**
		 * @private
		 */	
		/** VAST2Element - constructor
		 *
		 * @param forxData:Object The forx tree at the specific location where Wrapper is defined (points to Wrapper)
		 * @param eName:String The name of the class for debugging output purposes. Only sent in from the derived class.
		 * @param trackingData:VAST2TrackingData The current tracking data for the tag to be added to. (specifically, a set of arrays)
		*/ 
		public function VAST2Element(forxData:Object, eName:String, trackingData:VAST2TrackingData)
		{
			_elementName = eName;
			UIFDebugMessage.getInstance()._debugMessage(3, "Element" + _elementName + " base class", "Instream", "VAST2Element"); 
			_forxRef = forxData;	// Set a reference to the portion of the forx tree
			_trackingData = trackingData;
		}
		

				
				
	protected function processUrlList(forxData:Object, trackingArray:Array):void
	{
			if (forxData != null) 
			{
				for(var i:uint = 0; i < forxData.length(); i++)
				{
					var urlObject:Object = new Object();
					if (forxData[i] != undefined)
						urlObject.url = forxData[i].text();
					trackingArray.push(urlObject);
				}
			}
	}
		

		/**
		 * @private
		 */	
		public function get forxRef() : Object {return _forxRef;}
		/**
		 * @private
		 */	
		public function get elementName() : String {return _elementName;}
		/**
		 * @private
		 */	
		public function get trackingData(): VAST2TrackingData {return _trackingData;}
		
		
	}

}
