/*
About: License

Universal Instream Framework
Copyright (c) 2006-2010, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)
*/

package com.eyewonder.instream.core.utility
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MouseMove extends Sprite
	{
		private var _mouseTimer:Timer;
		
		private var _oldX:Number = 0;
		private var _oldY:Number = 0;
		
		private var _ref:MovieClip;
		
		public function MouseMove( ref:MovieClip )
		{
			super();
			
			_ref = ref;
			
			_mouseTimer = new Timer( 250, 0 );
			_mouseTimer.addEventListener( TimerEvent.TIMER, onMouseTimer );
		}
		
		public function set running( state:Boolean ):void
		{
			if ( state )
			{
				_mouseTimer.start();
			}
			else
			{
				_mouseTimer.stop();
			}
		}
		
		public function get running():Boolean
		{
			return _mouseTimer.running;
		}
		
		private function onMouseTimer( e:TimerEvent ):void
		{
			if (_oldX != _ref.mouseX || _oldY != _ref.mouseY)
			{
				dispatchEvent( new MouseEvent( MouseEvent.MOUSE_MOVE, true, false, _ref.mouseX, _ref.mouseY ) );
			}
			
			_oldX = _ref.mouseX;
			_oldY = _ref.mouseY;
		}
	}
}