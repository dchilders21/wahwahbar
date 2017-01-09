﻿/*
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
package com.eyewonder.instream.publisherAPI.view 
{
	import com.eyewonder.instream.publisherAPI.view.background.IBackgroundMovieClip;
	import com.eyewonder.instream.publisherAPI.view.IViewControl;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	
	import com.eyewonder.instream.publisherAPI.view.ad.AdMovieClip;
	import com.eyewonder.instream.publisherAPI.view.ad.IAdMovieClip;
	import com.eyewonder.instream.publisherAPI.view.background.BackgroundMovieClip;
	import com.eyewonder.instream.publisherAPI.view.background.IBackgroundMovieClip;
	import com.eyewonder.instream.publisherAPI.view.countdown.CountdownMovieClip;
	import com.eyewonder.instream.publisherAPI.view.countdown.ICountdownMovieClip;


	public class ViewControl implements IViewControl
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		private var _adMovieClip:AdMovieClip;
		private var _backgroundMovieClip:BackgroundMovieClip;
		private var _countdownMovieClip:CountdownMovieClip;
		
		public function ViewControl(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
			
			_adMovieClip = new AdMovieClip(_instreamFramework);
			_backgroundMovieClip = new BackgroundMovieClip(_instreamFramework);
			_countdownMovieClip = new CountdownMovieClip(_instreamFramework);
		}
		
		public function destroy():void
		{
			ad.destroy();
			background.destroy();
			countdown.destroy();
		}
		
		public function get ad():IAdMovieClip
		{
			return _adMovieClip;
		}
		
		public function get background():IBackgroundMovieClip
		{
			return _backgroundMovieClip;
		}
		
		public function get countdown():ICountdownMovieClip
		{
			return _countdownMovieClip;
		}
	}
}