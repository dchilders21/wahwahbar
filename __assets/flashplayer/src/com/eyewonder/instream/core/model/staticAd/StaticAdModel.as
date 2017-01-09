/*
StaticAdModel.as

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

Model for non-linear (static) VAST ads.

*/

package com.eyewonder.instream.core.model.staticAd 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.model.UIFConfigBase;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class StaticAdModel extends EventDispatcher
	{
		private var _imageAdView:ImageAdView;
		
		private var _canvas:MovieClip;
		
		private var _staticResource:Array;
		
		private var _instreamFramework:InstreamFrameworkBase;

		private var _adController:StaticAdController;
		
		public function StaticAdModel(instreamFramework:InstreamFrameworkBase) 
		{
			_canvas = new MovieClip();
			
			_instreamFramework = instreamFramework;
			
			_adController = new StaticAdController(_instreamFramework, this);
			
			_imageAdView = new ImageAdView(_instreamFramework, _adController, this);
		}
		
		//only called from the scale class, if scaling is off and ad is too big
		public function errorClose():void {
			_imageAdView.errorClose();
		}
		
		public function get staticResource():Array
		{
			return _staticResource;
		}
		
		public function set staticResource(newStaticResource:Array):void
		{
			_staticResource = newStaticResource;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get canvas():MovieClip
		{
			return _canvas;
		}
		
		public function get config():UIFConfigBase
		{
			return _instreamFramework.config;
		}
	}
}