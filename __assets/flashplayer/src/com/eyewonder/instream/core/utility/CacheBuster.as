/*
CacheBuster.as

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

Used to cacheBust urls containing [timestamp] at the end of a URL

*/
package com.eyewonder.instream.core.utility
{
	import com.eyewonder.instream.core.UIFConfig;
	import flash.display.Sprite;
	
	
	public dynamic class CacheBuster extends Sprite implements ICacheBuster
	{
		
		public var _adCacheBuster:Number;
		public var _videoCacheBuster:Number;
		public var _cacheBuster:Number; // only used internally
	
		// Available CacheBusterTypes
		public static const AD:String 		= "ad";
		public static const VIDEO:String	= "video";
		
		private var _uifConfig:UIFConfig;
		
		//standard strings
		private var _standardCachebusterList:Array = new Array("\\[timestamp\\]", "\\[cachebuster\\]", "\\[random\\]", "\\[randnum\\]");
		
		public function CacheBuster(uifConfig:UIFConfig)
		{
			_uifConfig = uifConfig;
			
			randomizeCacheBuster(AD, true);
			randomizeCacheBuster(VIDEO, true);
		}
		
		/* Non-essential code omitted */
		public function cacheBustURL(urlToTag:String, cacheBusterType:String = VIDEO):String
		{
			randomizeCacheBuster(cacheBusterType, false);
			return replaceWildcardWithCacheBuster( urlToTag, _cacheBuster );	
		}
		
		// Call once per player video load, before the preroll can be called.
		public function randomizeCacheBuster(cacheBusterType:String, refresh:Boolean):void // randomize timestamp
		{
			var cb:Number = randomNumber;
				
			switch(cacheBusterType) {
				case AD:
					if(!isNaN(adCacheBuster) && !refresh) {
						cb = adCacheBuster;
					} else {
						_adCacheBuster = cb;
					}
					break;
				
				default:
				//case VIDEO:
					if (!isNaN(videoCacheBuster) && !refresh) {
						cb = videoCacheBuster;
					} else {
						_videoCacheBuster = cb;
					}
					break;
		}	
		
			_cacheBuster = cb;
		}
		
		public function replaceWildcardWithCacheBuster( urlToTag:String, cacheBuster:Number ):String
		{
			var cacheBusterReplaceArray:Array = new Array();
			
			//add standard and the customizeable cachebusters into the array thats used to find the strings that should be replaced
			cacheBusterReplaceArray = _standardCachebusterList.concat(_uifConfig.cachebusterList);
			
			for(var i:uint = 0; i < cacheBusterReplaceArray.length; i++)
			{
				urlToTag = urlToTag.replace(new RegExp(cacheBusterReplaceArray[i],"gi"), cacheBuster);
			}
			
			return urlToTag;
		}
		
		public function get adCacheBuster():Number
		{
			return _adCacheBuster;
		}
		
		public function set adCacheBuster(newNumber:Number):void
		{
			_adCacheBuster = newNumber;
		}
		
		public function get videoCacheBuster():Number
		{
			return _videoCacheBuster;
		}
		
		public function set videoCacheBuster(newNumber:Number):void
		{
			_videoCacheBuster = newNumber;
		}
		
		public function get randomNumber():Number {
			return Math.round(100000000000 * Math.random());
		}	
		
	
		
	}
	
}
