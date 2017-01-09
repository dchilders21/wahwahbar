/*
SendToPanelThrottler.as

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

 */

package com.eyewonder.instream.core.debugger
{
	import com.eyewonder.instream.core.events.MessageThrottlerEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public dynamic class SendToPanelThrottler extends EventDispatcher
	{
		private var _messageHolder:Array;
		private var _timer:Timer;
		
		public function SendToPanelThrottler()
		{
			_messageHolder = new Array();
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimerCalled);
			_timer.start();
		}
		
		public function destroy():void
		{
			//send last batch of messages
			dispatchEvent(new MessageThrottlerEvent(MessageThrottlerEvent.SEND_MESSAGES, _messageHolder));
			
			if(_timer.running)_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerCalled);
			_timer = null;
			_messageHolder = null;
		}
		
		public function addMessage(message:String):void
		{
				_messageHolder.push(message);
		}
		
		private function onTimerCalled(e:TimerEvent):void
		{
			if(_messageHolder.length > 1)
			{
				_timer.stop();
				_timer.reset();
				dispatchEvent(new MessageThrottlerEvent(MessageThrottlerEvent.SEND_MESSAGES, _messageHolder));
				_messageHolder = new Array();
			}
		}
		
		public function resumeTimer():void
		{
			_timer.start();
		}
	}
}