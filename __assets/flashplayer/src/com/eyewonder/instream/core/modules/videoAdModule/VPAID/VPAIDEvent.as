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



Description
-----------

Defines a set of custom events for VPAID ads and extends UIFEvent.

*/

package com.eyewonder.instream.core.modules.videoAdModule.VPAID 
{
	import com.eyewonder.instream.core.events.UIFEvent;
	import flash.events.Event;
	
	public class VPAIDEvent extends UIFEvent 
	{
		private var _data:Object;
		
		//VPAID 1.0 and up
		public static var LOADED					: String;
		public static var STARTED					: String;
		public static var STOPPED					: String;
		public static var LINEAR_CHANGE				: String;
		public static var EXPANDED_CHANGE			: String;
		public static var REMAINING_TIME_CHANGE		: String;
		public static var IMPRESSION				: String;
		public static var VIDEO_FIRST_QUARTILE		: String;
		public static var VIDEO_MIDPOINT			: String;
		public static var VIDEO_THIRD_QUARTILE		: String;
		public static var VIDEO_COMPLETE			: String;
		public static var CLICK_THRU				: String;
		public static var USER_ACCEPT_INVITATION	: String;
		public static var PAUSED					: String;
		public static var PLAYING					: String;
		public static var ERROR						: String;
		
		//Eyewonder proprietary property
		public static var EW_AD_INFORMATION_DATA:String;	

		//introduced with VPAID 1.1
		public static var VIDEO_START				: String;
		public static var VOLUME_CHANGE				: String;
		public static var LOG						: String;
		public static var USER_CLOSE				: String;
		public static var USER_MINIMIZE				: String;
		
		public function VPAIDEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles);
			_data = data;
		} 
		
	    public function get data():Object
		{
			return _data;
	    }
	}
}