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
package com.eyewonder.instream.publisherAPI.adControl.adFormat 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	
	import flash.events.EventDispatcher;
	
	/*
		Class: AbstractAdFormat

		Based upon the currently completely parsed XML,
		this layer will return the values specified in the XML.
		
		Example:
		(start example)
			adWidth:Number = ewAPI.adControl.width;
			trace("the current ad width: " + adWidth);
		(end)
	*/
	public class AbstractAdFormat extends EventDispatcher implements IAbstractAdFormat
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function AbstractAdFormat(instreamFramework:InstreamFrameworkBase) 
		{
			_instreamFramework = instreamFramework;
		}
		
		public function destroy():void
		{
			
		}

		/*
			Property: width
			
			Returns the width specified in the ad XML
			
			Returns:
				Number - width of the ad
		*/
		public function get width():Number
		{
			return _instreamFramework._adTagWidth;
		}
		
		/*
			Property: height
			
			Returns the height specified in the ad XML
			
			Returns:
				Number - height of the ad
		*/
		public function get height():Number
		{
			return _instreamFramework._adTagHeight;
		}
		
		/*
			Property: duration
			
			Returns the duration specified in the ad XML
			
			Returns:
				Number - duration of the ad in seconds
		*/
		public function get duration():Number
		{
			return _instreamFramework._adTagDuration;
		}
	}
}