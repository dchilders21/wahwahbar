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
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.AbstractAdFormat;
	
	public class EWControl extends AbstractAdFormat implements IEWControl
	{
		
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function EWControl(instreamFramework:InstreamFrameworkBase) {
			super(instreamFramework);
			
			_instreamFramework = instreamFramework;
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function get width():Number
		{
			return _instreamFramework._ewParser.adTagWidth;
		}
		
		override public function get height():Number
		{
			return _instreamFramework._ewParser.adTagHeight;
		}
		
		override public function get duration():Number
		{
			return _instreamFramework._ewParser.adTagDuration;
		}
		
		public function get alignHorizontal():String
		{
			return _instreamFramework._ewParser.adTagAlignHorizontal;
		}
		
		public function get alignVertical():String
		{
			return _instreamFramework._ewParser.adTagAlignVertical;
		}
		
		public function get version():String
		{
			return _instreamFramework._ewParser.adTagVersion;
		}
		
		public function get URL():String
		{
			return _instreamFramework._ewParser.adURL;
		}
		
		public function get dataURL():String
		{
			return _instreamFramework._ewParser.adTagDataURL;
		}
		
		public function get clickPrepend():String
		{
			return _instreamFramework._ewParser.adTagClickPrepend;
		}

		public function set clickPrepend(newClickPrepend:String):void
		{
			_instreamFramework._ewParser.adTagClickPrepend = newClickPrepend;
		}
		
		public function get instreamType():String
		{
			return _instreamFramework._ewParser.adTagInstreamType;
		}
		
		public function get impr3rdParty():String
		{
			return _instreamFramework._ewParser.adTagImpr3rdParty;
		}
		
		public function get click3rdParty():String
		{
			return _instreamFramework._ewParser.adTagClick3rdParty;
		}
		
		public function get URLCreativeFormat():String
		{
			return _instreamFramework._ewParser.adTagURLCreativeFormat;
		}
		
		public function get reminderUnit():String
		{
			return _instreamFramework._ewParser.adTagReminderUnit;
		}
		
		public function get customPubData():String
		{
			return _instreamFramework._ewParser.adTagCustomPubData;
		}
	}
}
