﻿/*
UIFEvent.as

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

Defines a set of custom events for the EyeWonder instream framework and extends Event.

*/

package com.eyewonder.instream.core.events 
{
	import flash.events.Event;
	
	public dynamic class UIFEvent extends Event
	{
		public static const CONTROL_EVENT:String = "controlEvent";
		public static const TRACK_EVENT:String 	 = "trackingEvent";
		public static const VAST_EVENT:String 	 = "vastEvent";
		public static const VPAID_EVENT:String 	 = "vpaidEvent";
		
		public static const ERROR_EVENT:String = "sOnError";
		
		public var info:Object = new Object();
		
		public function UIFEvent(_type:String, _info:Object = null) 
		{
			super( _type );
			this.info = _info;
		}
		
		public override function toString():String
		{
			var eventString:String = super.toString();
			eventString = eventString.slice(0, eventString.length - 1);
			return eventString + " UIFEvent=" + String(info) + "]";
		}
	}
}