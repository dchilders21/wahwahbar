/*
CompanionAdModel.as

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

Holds information about the companion ad
*/
package com.eyewonder.instream.core.model.companionAd 
{
	import com.eyewonder.instream.core.events.UIFEventDispatcher;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.utility.XMLtoObject;
	
	import flash.events.Event;
	
	public class CompanionAdModel extends UIFEventDispatcher
	{
	
		private var _companionInPageView:CompanionInPageView;
		private var _companionInPlayerView:CompanionInPlayerView;
		
		private var _companionXML:XMLList;
		private var _companionObject:Object;
		
		
		public function CompanionAdModel() 
		{
			_companionInPageView 	= new CompanionInPageView(this);
			_companionInPlayerView 	= new CompanionInPlayerView(this);
		}
		
		public function get companionXML():XMLList
		{
			return _companionXML;
		}
		
		public function set companionXML(newCompanionXML:XMLList):void
		{
			if (newCompanionXML.toString() != "")
			{
				_companionXML = newCompanionXML;
				
				_companionObject = convertCompanionXMLToObject();
			
				dispatchEvent(new UIFEvent(UIFControlEvent.COMPANION_DETECTED, this));
			}
		}
		
		public function get companionObject():Object
		{
			return _companionObject;
		}
		
		private function convertCompanionXMLToObject():Object
		{
			var obj:Object = new Object();
			
			var content:XMLList = _companionXML.children();
			
			for (var c:uint = 0; c < content.length(); c++)
			{
				obj[c] = XMLtoObject.convert(XMLList(content[c]));
			}
			
			return obj;
		}
		
		public function deliver():void
		{
			if (_companionXML)
			{
				dispatchEvent(new UIFEvent(UIFControlEvent.COMPANION_START_DELIVERY, this));
			}
		}
	}
}