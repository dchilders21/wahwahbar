/*
UIFSendToPanel.as

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

A custom trace output class for the Universal Instream Framework. Ouptut can be seen on EyeWonder's Reporting QA website.
http://apps.eyewonderlabs.com/adWdrVideoSpace/ad/QA/Reporting/receiving.html
*/
package com.eyewonder.instream.core.debugger {
	
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.events.Event;
	
	
	import com.eyewonder.instream.core.events.MessageThrottlerEvent;
			
			
	import com.eyewonder.instream.core.debugger.SendToPanelThrottler;
			
	
	
	public dynamic class UIFSendToPanel
	{
		
		private static var _instance:UIFSendToPanel;
		private var _throttler:SendToPanelThrottler;
		
		public var _QAConnection : LocalConnection ;
		public var _debugMessages:Number;
		
		public function UIFSendToPanel()
		{
			_QAConnection = new LocalConnection();
			_QAConnection.allowDomain("*");
			_QAConnection.addEventListener(StatusEvent.STATUS, handleLCEvents);
			
			_throttler = new SendToPanelThrottler();
			_throttler.addEventListener(MessageThrottlerEvent.SEND_MESSAGES, onSendMessages);
		}
		
		public static function getInstance():UIFSendToPanel
		{
			if(_instance == null) 
            {
                _instance = new UIFSendToPanel();
            }
            return _instance;
		}
		
	    public function _sendToPanel( message:Object ) : void
		{
			_throttler.addMessage(message.toString());
		}
		
		public function destroy():void
		{
			_throttler.destroy();
			
			_throttler.removeEventListener(MessageThrottlerEvent.SEND_MESSAGES, onSendMessages);
			
			_throttler = null;
			_instance = null;
		}
		
		private function onSendMessages(e:MessageThrottlerEvent):void
		{
			for(var i:int = 0; i < e.messages.length; i++)
			{
				_QAConnection.send("_ewQAConnection", "ewDisplayText", e.messages[i].toString());     // Send to common receiving
			}
			_throttler.resumeTimer();
		}
		
		public function handleLCEvents(event:Event) : void
		{
			//Keep this function
		}
		
		
	}


}