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

package com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd {
	import flash.events.IEventDispatcher;

	/*
		Class: VPAIDControl

		This layer forwards all events from the ad to this layer,
		therefore a listener can be added to receive them all.
		A list of events for the available VPAID versions is availabe at
		http://www.iab.net/vpaid
		
		Example:
		(start example)
		//(1) Get the version of the loaded VPAID ad
		
			//you can add this case to the AdManager.as
			private function adEventHandler(event:UIFEvent):void
			{
				switch(event.info)
				{
					// version of the ad is available after it's completely loaded
					case UIFControlEvent.ON_AD_LOAD_COMPLETE:
						
						trace("The loaded VPAID ad is of version: " + ewAPI.adControl.vpaid.version);
					break;
				}
			}
		
		//(2) Receive raw VPAID events
			//you can add this functionality to the AdManager.as
			
			//add the listener on the VPAID layer
			ewAPI.adControl.vpaid.addEventListener(UIFEvent.VPAID_EVENT, vpaidEventHandler );
			
			//this function will receive all events that the VPAID ad is dispatching
			private function vpaidEventHandler(event:UIFEvent):Void
			{
				switch(event.info)
				{
					default:
						trace( "received raw VPAID event: " + event.info );
					break;
			}
			}
		(end)
	*/
	public interface IVPAIDControl extends IEventDispatcher
	{
		/*
			Property: version
			
			Returns the version.
			
			Returns:
				String - Version Number String
		*/
		function get version():String;
	}
	
}