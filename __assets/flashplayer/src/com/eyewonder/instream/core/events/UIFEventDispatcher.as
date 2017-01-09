/*
UIFEventDispatcher.as

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

A custom event dispatcher for the Universal Instream Framework that collects all added listeners.

*/

package com.eyewonder.instream.core.events {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.eyewonder.instream.core.debugger.UIFSendToPanel;
		
	public class UIFEventDispatcher extends EventDispatcher {
		private var eventListeners:Array = new Array();
		
		public function UIFEventDispatcher( target:IEventDispatcher = null ) {
			super(target);
		}
		
		public override function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			
			if ( type != UIFEvent.CONTROL_EVENT && type != UIFEvent.TRACK_EVENT && type != UIFEvent.ERROR_EVENT ) {
				var store:Object = { type: type, listener: listener };
			
				eventListeners.push( store );
			}
			
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public function listenerCleanup():void {
			while ( eventListeners.length > 0 ) {
				var event:Object = eventListeners.pop();
			
				super.removeEventListener( event.type, event.listener );
			}
		}
	}
	
}