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
package com.eyewonder.instream.publisherAPI.adControl.companion 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import flash.events.Event;
	import com.eyewonder.instream.core.events.UIFEventDispatcher;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFEvent;
	
	/*
		Class: CompanionAd
		
		This layer provides basic mehods to interact with companion ads.
		
		You'll be able to get the companion node from the XML as an object,
		basic methods to interact with your page are also provided.
	*/
	public class CompanionAd implements ICompanionAd
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		private var _companionInPageView:CompanionInPageView;
		private var _companionInPlayerView:CompanionInPlayerView;
		
		/*
			Function: CompanionAd
			
			This is initialized by the core classes
			after a VAST XML has been parsed completely.
		*/
		public function CompanionAd(instreamFramework:InstreamFrameworkBase) 
		{
			_instreamFramework = instreamFramework;
			
			_instreamFramework._companionAd.addEventListener(UIFControlEvent.COMPANION_DETECTED, init);
			_instreamFramework._companionAd.addEventListener(UIFControlEvent.COMPANION_START_DELIVERY, deliver);
		}
		
		/*
			Destructor: destroy
			
			Destroys all layers that have been initialized by calling the <CompanionAd> constructor
		*/
		public function destroy():void
		{
			_instreamFramework._companionAd.removeEventListener(UIFControlEvent.COMPANION_DETECTED, init);
			_instreamFramework._companionAd.removeEventListener(UIFControlEvent.COMPANION_START_DELIVERY, deliver);
		}
		
		/*
			Function: init
			
			Instantiates the leaf views.
			This is done when the VAST parser has found a companion ad node within the XML.
			
			Parameter: 
				e - Event (COMPANION_DETECTED)
		*/
		private function init(e:UIFEvent):void
		{
			_companionInPageView = new CompanionInPageView(this);
			_companionInPlayerView = new CompanionInPlayerView(this);
		}
		
		/*
			Function: deliver
			
			Invokes the method to deliver the node information to the page
		*/
		private function deliver(e:UIFEvent):void
		{
			switch(_instreamFramework.config.companionDeliverType)
			{
				case 'xml':
					_companionInPageView.deliverXML();
					break;
				
				case 'object':
				default:
					_companionInPageView.deliverObject();
					break;
			}
		}
		
		/*
			Property: companionXML
			
			Returns:
				XMLList - A XMLList representation of the companion node
		*/
		public function get companionXML():XMLList
		{
			return _instreamFramework._companionAd.companionXML;
		}
		
		/*
			Property: companionObject
			
			Returns:
				Object - A Object representation of the companion node
		*/
		public function get companionObject():Object
		{
			return _instreamFramework._companionAd.companionObject;
		}
	}
}