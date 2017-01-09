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
package com.eyewonder.instream.publisherAPI.view.ad
{
	import com.eyewonder.instream.core.utility.CacheBuster;
	import com.eyewonder.instream.publisherAPI.view.ViewControl;
	import flash.display.MovieClip;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	
	public class AdMovieClip implements IAdMovieClip
	{
		private var _instreamFramework:InstreamFrameworkBase;
	
		public function AdMovieClip(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
		}
		
		public function destroy():void
		{
			//nothing yet
		}
		
		public function get movieClip():MovieClip
		{
			return _instreamFramework._adContainerParent_mc;
		}
		
		public function get adPosition():Object
		{
			return _instreamFramework.positionAd(_instreamFramework.getAdSizes());
		}
		
		public function get positionHorizontal():String
		{
			return _instreamFramework._adTagAlignHorizontal;
		}
		
		public function set positionHorizontal(newPosition:String):void
		{
			_instreamFramework._adTagAlignHorizontal = newPosition;
			_instreamFramework.resizeNotify();
		}

		public function get positionVertical():String
		{
			return _instreamFramework._adTagAlignVertical;
		}
		
		public function set positionVertical(newPosition:String):void
		{
			_instreamFramework._adTagAlignVertical = newPosition;
			_instreamFramework.resizeNotify();
		}
		
		public function get scale():Boolean
		{
			return _instreamFramework._config.scaleEW;
			//_instreamFramework._config.scaleVAST;
		}

		public function set scale(scaling:Boolean):void
		{
			_instreamFramework._config.scaleEW = scaling;
			_instreamFramework._config.scaleVAST = scaling;
		}
		
		public function show():void
		{
			_instreamFramework._adContainerParent_mc.visible = true;
		}

		public function hide():void
		{
			_instreamFramework._adContainerParent_mc.visible = false;
		}
	}
}
