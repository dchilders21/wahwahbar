/*
VASTClickThru.as

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

Handles clickThru for the VAST module.

*/
package com.eyewonder.instream.core.modules.videoAdModule.VAST {

	import com.eyewonder.instream.core.utility.ClickThru;
	import com.eyewonder.instream.core.utility.CacheBuster;
	import flash.events.Event;
	import com.eyewonder.instream.core.debugger.UIFDebugMessage;
		
	public dynamic class VASTClickThru extends ClickThru
	{
		
		public function VASTClickThru(cb:CacheBuster, URL:String, trackingURLs:Array = null)
		{
			super(cb, URL, trackingURLs);
		}

		override public function onClickThru(event:Event):void
		{
			super.onClickThru(event);
		}
		
		override public function trackClickThru():void
		{	
			UIFDebugMessage.getInstance()._debugMessage(2, "In trackClickThru().", "VAST", "VASTClickThru");
			
			super.trackClickThru();
		}

		override public function getBrowserEngine() : String
		{
			return super.getBrowserEngine();
			}
			
		override public function getURL( url : String, window : String = "_self" ) : void
		{
			super.getURL(url, window);
		}
		
		override public function cacheBustURL(urlToTag:String):String
		{
			return super.cacheBustURL(urlToTag);
		}		
	}
}

//MAKE SURE TO REWORK FOR VAST
//IMPORT EXTERNALINTERFACE CLASS
//NEED TO BUILD INTO OUR OWN CLASS OF VASTCLICKTHRU
