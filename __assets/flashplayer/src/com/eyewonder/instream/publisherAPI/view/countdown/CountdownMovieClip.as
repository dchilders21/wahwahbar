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
package com.eyewonder.instream.publisherAPI.view.countdown
{
	import com.eyewonder.instream.publisherAPI.view.ViewControl;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import flash.display.MovieClip;
	
	import flash.geom.ColorTransform;
	
	public class CountdownMovieClip implements ICountdownMovieClip
	{
		private var _instreamFramework:InstreamFrameworkBase;
	
		public function CountdownMovieClip(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
		}
		
		public function destroy():void
		{
			//nothing yet
		}
		
		public function get movieClip():MovieClip
		{
			return _instreamFramework.adCountdown_mc;
		}
		
		public function get position():String
		{
			return _instreamFramework._config.countdown_bar_position;
		}
		
		public function set position(position:String):void
		{
			_instreamFramework._config.countdown_bar_position = position;
			_instreamFramework.adCountdown_mc.resize(_instreamFramework.getPlayerInformation());
		}
		
		public function get text():String
		{
			return _instreamFramework._config.countdown_text;
		}

		public function set text(countdownText:String):void
		{
			_instreamFramework._config.countdown_text = countdownText;
		}
		
		public function get textColor():uint
		{
			return _instreamFramework._config.countdown_text_color;
		}
		
		public function set textColor(color:uint):void
		{
			_instreamFramework.adCountdown_mc.adCountdownTextField.textColor = color;
			_instreamFramework._config.countdown_text_color = color;
		}
		
		public function get backgroundColor():uint
		{
			return _instreamFramework._config.countdown_bar_back_color;
		}
		
		public function set backgroundColor(color:uint):void
		{
			var colorTransform:ColorTransform = _instreamFramework.adCountdown_mc.adCountdownBackground_mc.transform.colorTransform;
			colorTransform.color = color;
			_instreamFramework.adCountdown_mc.adCountdownBackground_mc.transform.colorTransform = colorTransform;
			
			colorTransform = null;
			
			_instreamFramework._config.countdown_bar_back_color = color;
		}

		public function get backgroundAlpha():Number
		{
			return _instreamFramework._config.countdown_bar_opacity;
		}
		
		public function set backgroundAlpha(alpha:Number):void
		{
			_instreamFramework.adCountdown_mc.adCountdownBackground_mc.alpha = alpha;
			
			_instreamFramework._config.countdown_bar_opacity = alpha;
		}
		
		public function show():void
		{
			movieClip.visible = true;
		}
		
		public function hide():void
		{
			movieClip.visible = false;
		}
	}
}
