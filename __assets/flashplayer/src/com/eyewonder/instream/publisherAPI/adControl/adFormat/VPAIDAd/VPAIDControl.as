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
package com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd
{
	import com.eyewonder.instream.core.events.*;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDEvent;
	
	
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.AbstractAdFormat;
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import flash.events.Event;
	

	public class VPAIDControl extends AbstractAdFormat implements IVPAIDControl
	{
		
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function VPAIDControl(instreamFramework:InstreamFrameworkBase)
		{
			super(instreamFramework);
			
			_instreamFramework = instreamFramework;
			
			_instreamFramework.addEventListener(UIFEvent.CONTROL_EVENT, prepareListeners);
		}
		
		private function prepareListeners(event:UIFEvent):void
		{
			//vpaid ad would available now
			if (event.info.type == UIFControlEvent.ON_AD_LOAD_COMPLETE)
			{
				_instreamFramework.addEventListener(UIFEvent.VPAID_EVENT, vpaidEventForwarding);
			}
		}
		
		private function vpaidEventForwarding(event:UIFEvent):void
		{
			dispatchEvent(new UIFEvent(event.type, event.info));
		}
		
		public function get version():String
		{
			return _instreamFramework.VPAIDVersion;
		}
		
		override public function destroy():void
		{
			_instreamFramework.removeEventListener(UIFEvent.CONTROL_EVENT, prepareListeners);
			_instreamFramework.removeEventListener(UIFEvent.VPAID_EVENT, vpaidEventForwarding);
			
			super.destroy();
		}
	}
}