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
package com.eyewonder.instream.publisherAPI.player 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.events.UIFEventDispatcher;
	import com.eyewonder.instream.publisherAPI.player.IPlayerControl;
	
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	
	import flash.geom.Rectangle;

	public class PlayerControl extends UIFEventDispatcher implements IPlayerControl
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		private var _contentVideoState:Number;
		
		public function PlayerControl(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
			
			_instreamFramework.addEventListener(UIFEvent.CONTROL_EVENT, playerEventForwarding);
		}
		
		public function destroy():void
		{
			_instreamFramework.removeEventListener(UIFEvent.CONTROL_EVENT, playerEventForwarding);
		}
		
		private function playerEventForwarding(event:UIFEvent):void
		{
			switch(event.info.type)
			{
				case UIFControlEvent.CONTENT_VID_PLAY:
				case UIFControlEvent.CONTENT_VID_PAUSE:
				case UIFControlEvent.CONTENT_VID_STOP:
				case UIFControlEvent.HIDE_CONTROLS:
				case UIFControlEvent.SHOW_CONTROLS:
					dispatchEvent(new UIFEvent(event.type, event.info));
					break;
			}
		}
		
		public function get bandwidth():Number
		{
			return _instreamFramework._bandwidth;
		}
		
		public function set bandwidth(newBandwidth:Number):void
		{
			_instreamFramework._bandwidth = newBandwidth;
		}
		
		public function get videoScreenRect():Rectangle
		{
			return new Rectangle(_instreamFramework._config.x, _instreamFramework._config.y, _instreamFramework._config.width, _instreamFramework._config.height);
		}
		
		public function set videoScreenRect(newScreenRect:Rectangle):void
		{
			_instreamFramework._config.x = newScreenRect.x;
			_instreamFramework._config.y = newScreenRect.y;
			_instreamFramework._config.width = newScreenRect.width;
			_instreamFramework._config.height = newScreenRect.height;
			
			_instreamFramework.resizeNotify();
		}
		
		public function get volume():Number
		{
			return _instreamFramework.audioVolume;
		}
		
		public function set volume(playerVolume:Number):void
		{
			_instreamFramework.audioVolume = playerVolume;
			_instreamFramework.dispatchUIFEvent(UIFControlEvent.AD_VOLUME_CHANGED);
		}
		
		public function get videoState():Number
		{
			return _contentVideoState;
		}
		
		public function set videoState(playerState:Number):void
		{
			_contentVideoState = playerState;
		}
	}
}
