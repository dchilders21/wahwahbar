/*
VAST2Time.as

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
		
	/**
	 * @author bbober
	 */
	 
	/**
	 * Vast time data
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 

	public dynamic class VAST2Time
	{
		/* Time in hh:mm:ss format */
		private var _hours:Number;
		private var _minutes:Number;
		private var _seconds:Number;
		
		/** VAST2Time - constructor
		 *
		 * @param hours:Number Hours
		 * @param minutes:Number Minutes
		 * @param seconds:Number Seconds 
		*/ 
		public function VAST2Time(hours:Number = 0, minutes:Number = 0, seconds:Number = 0)	
		{
			_hours = hours;
			_minutes = minutes;
			_seconds = seconds;
		}
		
		public function get hh() : Number { return _hours;} 
		public function set hh(val:Number):void { _hours = val; }		
		public function get mm() : Number { return _minutes;} 
		public function set mm(val:Number):void { _minutes = val; }		
		public function get ss() : Number { return _minutes;} 
		public function set ss(val:Number):void { _minutes = val; }
		public function get totalSeconds():Number { return (_hours*3600 + _minutes*60 + _seconds)}	
		public function get totalMilliseconds():Number { return 1000*totalSeconds}			
	}
}
