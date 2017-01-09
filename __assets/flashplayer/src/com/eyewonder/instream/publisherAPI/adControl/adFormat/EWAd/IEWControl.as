/*
About: License

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
*/
package com.eyewonder.instream.publisherAPI.adControl.adFormat.EWAd 
{
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.IAbstractAdFormat;
	
	/*
		Class: EWControl

		Based upon the currently completely parsed XML,
		this layer will return the values specified in the XML.
		
		Example:
		(start example)
			var adVersion:String = ewAPI.adControl.ad["version"];
			trace("EyeWonder ad version: " + adVersion);
		(end)
	*/
	public interface IEWControl extends IAbstractAdFormat
	{
		/*
			Property: width
			
			Returns the width specified in the ad XML
			
			Returns:
				Number - width of the ad
		*/
		function get width():Number;
		
		/*
			Property: height
			
			Returns the height specified in the ad XML
			
			Returns:
				Number - height of the ad
		*/
		function get height():Number;
		
		/*
			Property: duration
			
			Returns the duration specified in the ad XML
			
			Returns:
				Number - duration of the ad in seconds
		*/
		function get duration():Number;
		
		/*
			Property: alignHorizontal
			
			Returns the horizontal position of the ad.
			
			Returns:
				String - 'top', 'middle', 'bottom'
		*/
		function get alignHorizontal():String;
		
		/*
			Property: alignVertical
			
			Returns the vertical position of the ad.
			
			Returns:
				String - 'left', 'center', 'right'
		*/
		function get alignVertical():String;

		/*
			Property: version
			
			Returns the version.
			
			Returns:
				String - Version Number String
		*/
		function get version():String;
		
		/*
			Property: URL
			
			Returns the URL.
			
			Returns:
				String - A URL
		*/
		function get URL():String;
		
		/*
			Property: dataURL
			
			Returns the URL of the ad data.
			
			Returns:
				String - A URL
		*/
		function get dataURL():String;
		
		/*
			Property: clickPrepend
			
			A string thats prepended to click trackers.
			
			Returns:
				String - A URL
		*/
		function get clickPrepend():String;
		
		/*
			Property: clickPrepend
			
			A string thats prepended to click trackers.
			
			Parameter:
				String - The string to prepend to click trackers
		*/
		function set clickPrepend(newClickPrepend:String):void;
		
		/*
			Property: instreamType
			
			The instream type.
			
			Returns:
				String - "linear", "fixedroll", "takeover", "fixedrollwithreminder", "ticker", "bug"
		*/
		function get instreamType():String;
		
		/*
			Property: impr3rdParty
			
			A third party impression.
			
			Returns:
				String - 
		*/
		function get impr3rdParty():String;
		
		/*
			Property: click3rdParty
			
			A third party click.
			
			Returns:
				String -
		*/
		function get click3rdParty():String;
		
		/*
			Property: URLCreativeFormat
			
			The creative format of the URL.
			
			Returns:
				String - "SWF", "FLV"
		*/
		function get URLCreativeFormat():String;
		
		/*
			Property: reminderUnit
			
			Based upon what is placed into the ad XML
			this may either be a URL or a XML String with
			the reminder unit in it.
			
			Returns:
				String - XML as String or URL String
		*/
		function get reminderUnit():String;
		
		/*
			Property: customPubData
			
			Returns:
				String -
		*/
		function get customPubData():String;
	}
}