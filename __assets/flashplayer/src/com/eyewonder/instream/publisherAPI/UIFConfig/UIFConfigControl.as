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
package com.eyewonder.instream.publisherAPI.UIFConfig 
{
	import com.eyewonder.instream.publisherAPI.UIFConfig.IUIFConfigControl;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.UIFConfig;
	
	
	import flash.text.TextFormat;
	import flash.display.MovieClip
	
	public class UIFConfigControl implements IUIFConfigControl
	{
		
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function UIFConfigControl(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
		}
		
		public function destroy():void
		{
			//nothing yet
		}
		
		public function get config():UIFConfig
		{
			return _instreamFramework.config;
		}
				
		public function set config(configSet:UIFConfig):void
		{
			_instreamFramework._config = configSet;
		}
		
		public function get preferredDeliveryMethod():String
		{
			return _instreamFramework._config.preferredDeliveryMethod;
		}
		
		public function set preferredDeliveryMethod(value:String):void
		{
			_instreamFramework._config.preferredDeliveryMethod = value;
		}
		
		public function get qualityFirst():Boolean
		{
			return _instreamFramework._config.qualityFirst;
		}
		
		public function set qualityFirst(enabled:Boolean):void
		{
			_instreamFramework._config.qualityFirst = enabled;
		}
		
		public function get bwDetectProgressiveURL():String
		{
			return _instreamFramework._config.bwDetectProgressiveURL;
		}

		public function set bwDetectProgressiveURL(url:String):void
		{
			_instreamFramework._config.bwDetectProgressiveURL = url;
		}
		
		public function get bwDetectStreamingServer():String
		{
			return _instreamFramework._config.bwDetectStreamingServer;
		}
		
		public function set bwDetectStreamingServer(server:String):void
		{
			_instreamFramework._config.bwDetectStreamingServer = server;
		}
		
		public function get countdownEnabled():Boolean
		{
			return _instreamFramework._config.countdown_enabled;
		}

		public function set countdownEnabled(enabled:Boolean):void
		{
			_instreamFramework._config.countdown_enabled = enabled;
		}

		public function get countdownBarPosition():String
		{
			return _instreamFramework._config.countdown_bar_position;
		}
		
		public function set countdownBarPosition(position:String):void
		{
			_instreamFramework._config.countdown_bar_position = position;
		}
		
		public function get countdownText():String
		{
			return _instreamFramework._config.countdown_text;
		}
		
		public function set countdownText(text:String):void
		{
			_instreamFramework._config.countdown_text = text;
		}
		
		public function get countdownTextColor():uint
		{
			return _instreamFramework._config.countdown_text_color;
		}
		
		public function set countdownTextColor(color:uint):void
		{
			_instreamFramework._config.countdown_text_color = color;
		}
		
		public function get countdownTextFormat():TextFormat
		{
			return _instreamFramework._config.countdown_text_format;
		}
		
		public function set countdownTextFormat(format:TextFormat):void
		{
			_instreamFramework._config.countdown_text_format = format;
		}
		
		public function get countdownBarBackColor():uint
		{
			return _instreamFramework._config.countdown_bar_back_color;
		}

		public function set countdownBarBackColor(color:uint):void
		{
			_instreamFramework._config.countdown_bar_back_color = color;
		}
		
		public function get countdownBarAlpha():Number
		{
			return _instreamFramework._config.countdown_bar_opacity;
		}

		public function set countdownBarAlpha(alpha:Number):void
		{
			_instreamFramework._config.countdown_bar_opacity = alpha;
		}
		
		public function get backgroundColor():uint
		{
			return _instreamFramework._config.backgroundColor;
		}

		public function set backgroundColor(color:uint):void
		{
			_instreamFramework._config.backgroundColor = color;
		}
		
		public function get backgroundAlpha():Number
		{
			return _instreamFramework._config.backgroundAlpha;
		}
		
		public function set backgroundAlpha(alpha:Number):void
		{
			_instreamFramework._config.backgroundAlpha = alpha;
		}
		
		public function get playerContentWidth():Number
		{
			return _instreamFramework._config.width;
		}
		
		public function set playerContentWidth(width:Number):void
		{
			_instreamFramework._config.width = width;
		}
		
		public function get playerContentHeight():Number
		{
			return _instreamFramework._config.height;
		}

		public function set playerContentHeight(height:Number):void
		{
			_instreamFramework._config.height = height;
		}
		
		public function get playerContentX():Number
		{
			return _instreamFramework._config.x;
		}
		
		public function set playerContentX(x:Number):void
		{
			_instreamFramework._config.x = x;
		}
		
		public function get playerContentY():Number
		{
			return _instreamFramework._config.y;
		}
		
		public function set playerContentY(y:Number):void
		{
			_instreamFramework._config.y = y;
		}
		
		public function get playerContentClip():MovieClip
		{
			return _instreamFramework._config.clip;
		}
		
		public function set playerContentClip(clip:MovieClip):void
		{
			_instreamFramework._config.clip = clip;
		}
		
		public function get overlayDelay():Number
		{
			return _instreamFramework._config.overlay_delay;
		}
		
		public function set overlayDelay(delayInSeconds:Number):void
		{
			_instreamFramework._config.overlay_delay = delayInSeconds;
		}
		
		public function get midrollVideoLength():Number
		{
			return _instreamFramework._config.midroll_video_length;
		}

		public function set midrollVideoLength(lengthInSeconds:Number):void
		{
			_instreamFramework._config.midroll_video_length= lengthInSeconds;
		}
		

		public function get vpaidHAlign():String { return _instreamFramework._config.vpaidHAlign; }
		public function set vpaidHAlign(value:String):void {
			_instreamFramework._config.vpaidHAlign = value;
		}
		

		public function get vpaidVAlign():String { return _instreamFramework._config.vpaidVAlign; }
		public function set vpaidVAlign(value:String):void {
			_instreamFramework._config.vpaidVAlign = value;
		}
		
		public function get scaleEW():Boolean
		{
			return _instreamFramework._config.scaleEW;
		}

		public function set scaleEW(value:Boolean):void
		{
			_instreamFramework._config.scaleEW = value;
		}
		
		public function get scaleVAST():Boolean
		{
			return _instreamFramework._config.scaleVAST;
		}
		
		public function set scaleVAST(value:Boolean):void
		{
			_instreamFramework._config.scaleVAST = value;
		}
		
		public function get positionVAST():Boolean
		{
			return _instreamFramework._config.positionVAST;
		}
		
		public function set positionVAST(enabled:Boolean):void
		{
			_instreamFramework._config.positionVAST = enabled;
		}
		
		public function get cachebusterList():Array { 
			return _instreamFramework._config.cachebusterList;
		}
		
		public function set cachebusterList(value:Array):void {
			_instreamFramework._config.cachebusterList = value;
		}
		
		public function get integration_date():String { 
			return _instreamFramework._config.integration_date;
		}
		
		public function set integration_date(text:String):void {
			_instreamFramework._config.integration_date = text;
			_instreamFramework._debugMessage(1, "EyeWonder Instream API Integration Date: " + integration_date );
		}
		
		public function get version():String { 
			return _instreamFramework._config.version;
		}
		
		public function set version(text:String):void {
			_instreamFramework._config.version = text;
			_instreamFramework._debugMessage(1, "Player Version: " + version );
		}
		
		public function get errorPopup():Boolean
		{ 
			return _instreamFramework._config.errorPopup;
		}
		
		public function set errorPopup(enabled:Boolean):void
		{
			_instreamFramework._config.errorPopup = enabled;
		}
		
		public function get companionDeliverType():String { return _instreamFramework._config.companionDeliverType; }
		public function set companionDeliverType(value:String):void {
			_instreamFramework._config.companionDeliverType = value;
		}
		
		public function get nonLinearCloseButtonPosition():Object
		{
			return _instreamFramework.config.nonLinearCloseButtonPosition;
		}
		
		public function set nonLinearCloseButtonPosition(value:Object):void
		{
			_instreamFramework.config.nonLinearCloseButtonPosition = value;
		}
		
		public function get nonLinearCloseButtonURL():String
		{
			return _instreamFramework.config.nonLinearCloseButtonURL;
		}
		
		public function set nonLinearCloseButtonURL(newCloseButtonURL:String):void
		{
			_instreamFramework.config.nonLinearCloseButtonURL = newCloseButtonURL;
		}
		
		public function get guiBorderWidth():Number
		{
			return _instreamFramework.config.guiBorderWidth;
		}
		
		public function set guiBorderWidth(newBorderWidth:Number):void
		{
			_instreamFramework.config.guiBorderWidth = newBorderWidth;
		}
		
		public function get guiBorderRadius():Number
		{
			return _instreamFramework.config.guiBorderRadius;
		}
		
		public function set guiBorderRadius(newBorderRadius:Number):void
		{
			_instreamFramework.config.guiBorderRadius = newBorderRadius;
		}
		//It is no longer necessary to use this variable
		public function get enforceVPAIDScaling():Boolean
		{
			return _instreamFramework.config.enforceVPAIDScaling;
		}
		//It is no longer necessary to use this variable
		public function set enforceVPAIDScaling(value:Boolean):void
		{
			_instreamFramework.config.enforceVPAIDScaling = value;
		}
	}
}
