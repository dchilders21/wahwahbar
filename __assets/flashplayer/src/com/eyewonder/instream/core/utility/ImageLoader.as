/*
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

package com.eyewonder.instream.core.utility 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class ImageLoader extends EventDispatcher
	{
		private var _loader:Loader;
		private var _request:URLRequest;
		
		public function ImageLoader() 
		{

		}
		
		public function load(url:String):void
		{
			_loader = new Loader();
			_request = new URLRequest(url);
			
			addListener();
			
			_loader.load(_request);
		}
		
		private function addListener():void
		{
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function removeListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(e:Event):void
		{
			removeListener();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/*
			Function: loadError
			
			Is being called when a error occured while loading the resource,
			it dispatches an error event.
		*/
		private function onError(e:Event):void
		{
			removeListener();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}

		public function get loader():Loader
		{
			return _loader;
		}
	}

}