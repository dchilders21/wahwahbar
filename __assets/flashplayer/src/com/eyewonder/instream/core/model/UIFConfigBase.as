/*
UIFConfigBase.as

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
Don't modify the config here, instead set variables in UIFConfig.as

*/

package com.eyewonder.instream.core.model {
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.utils.describeType;
	
	public dynamic class UIFConfigBase extends Object {
		
		// clip parameters, used by InstreamFramework:getPlayerInformation()
		private var _width:Number = 320;					// content width
		private var _height:Number = 240;					// content height
		
		private var _x:Number = 0;							// x position of the content
		private var _y:Number = 0;							// y position of the content
		
		private var _clip:MovieClip;						// player clip reference
		
		// ad specific settings
		private var _overlay_delay:Number = 5;				// delay overlay this ammount of seconds
		private var _midroll_video_length:Number = 100;		// video length has to be greater then that to allow a midroll playback
		
		// countdown timer
		private var _countdown_enabled:Boolean = false;		
		private var _countdown_text:String = '[time] ([percent])';
		private var _countdown_text_format:TextFormat = new TextFormat( "Arial", 10, 0xffffff, null, null, null, null, null, "center" );
		private var _countdown_text_color:Number = 0xffffff;
		private var _countdown_bar_position:String = "bottom";
		private var _countdown_bar_back_color:Number = 0x000000;
		private var _countdown_bar_opacity:Number = 0.8;
		
		// ad background
		private var _backgroundColor:Number = 0x000000;
		private var _backgroundAlpha:Number = 1;
		
		// vast specific
		private var _preferredDeliveryMethod:String = "progressive";
		private var _qualityFirst:Boolean = true;
		private var _bwDetectProgressiveURL:String = "";	// This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		private var _bwDetectStreamingServer:String = null;
		
		//Scaling
		private var _scaleEW:Boolean = true;
		private var _scaleVAST:Boolean = true;
		private var _positionVAST:Boolean = true;
		private var _enforceVPAIDScaling:Boolean = false; //It is no longer necessary to use this variable
		
		//positioning
		private var _vpaidHAlign:String;
		private var _vpaidVAlign:String;
		
		//error
		private var _errorPopup:Boolean = true;
		
		private var _cachebusterList:Array = new Array("\\[timestamp\\]", "\\[cachebuster\\]", "\\[random\\]", "\\[randnum\\]");
		
		//companionAd
		private var _companionDeliverType:String = 'object'; //'object', 'xml'
		
		//nonLinear VAST (nonVPAID!)
		private var _nonLinearCloseButtonURL:String = "./closeButton.swf";
		private var _nonLinearCloseButtonPosition:Object = ({top:0, right:0});
		private var _guiBorderWidth:Number = 12;
		private var _guiBorderRadius:Number = 7;
		
		// default values
		private var defaults:Object = {};
		
		public function UIFConfigBase() {
			super();

			// collect all available set functions and variables available
			var describedType:XML = describeType(this);
			var properties:XMLList = describedType..variable.@name + describedType..accessor.@name;
			
			// loop thru them and save them to an object
			for (var name:String in properties) {
				defaults[properties[name]] = this['_' + properties[name]];
			}
		}
		
		/**
		 * content width
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = validate( value, defaults.width );
		}
		
		/**
		 * content height
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = validate(value, defaults.height);
		}
		
		/**
		 * x position of the content
		 */
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = validate(value, defaults.x);
		}
		
		/**
		 * y position of the content
		 */
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = validate(value, defaults.y);
		}
		
		/**
		 * delay overlay this ammount of seconds
		 */
		public function get overlay_delay():Number { return _overlay_delay; }
		public function set overlay_delay(value:Number):void {
			_overlay_delay = validate(value, defaults.overlay_delay);
		}
		
		/**
		 * video length has to be greater then that to allow a midroll playback
		 */
		public function get midroll_video_length():Number { return _midroll_video_length; }
		public function set midroll_video_length(value:Number):void {
			_midroll_video_length = validate(value, defaults.midroll_video_length);
		}
		
		/**
		 * player clip reference
		 */
		public function get clip():MovieClip { return _clip; }
		public function set clip(value:MovieClip):void {
			_clip = value;
			
			height = clip.height;
			width = clip.width;
			x = clip.x;
			y = clip.y;
		}
		
		/**
		 * text shown in the countdown bar
		 */
		public function get countdown_text():String { return _countdown_text; }
		public function set countdown_text(value:String):void {
			_countdown_text = validate(value, defaults.countdown_text);
		}
		
		/**
		 * where the countdown bar is positioned. either "top" or "bottom"
		 */
		public function get countdown_bar_position():String { return _countdown_bar_position; }
		public function set countdown_bar_position(value:String):void {
			_countdown_bar_position = validate(value, defaults.countdown_bar_position);
		}
		
		/**
		 * enable the countdown bar
		 */
		public function get countdown_enabled():Boolean { return _countdown_enabled; }
		public function set countdown_enabled(value:Boolean):void {
			_countdown_enabled = validate(value, defaults.countdown_enabled);
		}
		
		/**
		 * background color of the countdown bar
		 */
		public function get countdown_bar_back_color():Number { return _countdown_bar_back_color; }
		public function set countdown_bar_back_color(value:Number):void {
			_countdown_bar_back_color = validate(value, defaults.countdown_bar_back_color);
		}
		
		/**
		 * transparency of the reamining timer bar
		 */
		public function get countdown_bar_opacity():Number { return _countdown_bar_opacity; }
		public function set countdown_bar_opacity(value:Number):void {
			_countdown_bar_opacity = validate(value, defaults.countdown_bar_opacity);
		}
		
		/**
		 * text format used on the timer bar
		 */
		public function get countdown_text_format():TextFormat { return _countdown_text_format; }
		public function set countdown_text_format(value:TextFormat):void {
			_countdown_text_format = validate(value, defaults.countdown_text_format);
		}
				
		/**
		 * text color used for the text on the countdown bar
		 */
		public function get countdown_text_color():Number { return _countdown_text_color; }
		public function set countdown_text_color(value:Number):void {
			_countdown_text_color = validate(value, defaults.countdown_text_color);
		}
		
		/**
		 * ad backdrop color
		 */
		public function get backgroundColor():Number { return _backgroundColor; }
		public function set backgroundColor(value:Number):void {
			_backgroundColor = validate(value, defaults.backgroundColor);
		}
		
		/**
		 * ad backdrop alpha
		 */
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void {
			_backgroundAlpha = validate(value, defaults.backgroundAlpha);
		}
		
		/**
		 * ad delivery mode if available
		 * either 'progressive' or 'streaming'
		 */
		public function get preferredDeliveryMethod():String { return _preferredDeliveryMethod; }
		public function set preferredDeliveryMethod(value:String):void {
			_preferredDeliveryMethod = validate(value, defaults.preferredDeliveryMethod);
		}
		
		/**
		 * quality before speed
		 */
		public function get qualityFirst():Boolean { return _qualityFirst; }
		public function set qualityFirst(value:Boolean):void {
			_qualityFirst = validate(value, defaults.qualityFirst);
		}
		
		/**
		 * This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		 */
		public function get bwDetectProgressiveURL():String { return _bwDetectProgressiveURL; }
		public function set bwDetectProgressiveURL(value:String):void {
			_bwDetectProgressiveURL = validate(value, defaults.bwDetectProgressiveURL);
		}
		
		/**
		 * 
		 */
		public function get bwDetectStreamingServer():String { return _bwDetectStreamingServer; }
		public function set bwDetectStreamingServer(value:String):void {
			_bwDetectStreamingServer = validate(value, defaults.bwDetectStreamingServer);
		}
		
		/**
		 * Allow publishers to position VPAID creatives horizontally when scaling is turned off
		 */
		public function get vpaidHAlign():String { return _vpaidHAlign; }
		public function set vpaidHAlign(value:String):void {
			_vpaidHAlign = value;
		}
		
		/**
		 * Allow publishers to position VPAID creatives vertically when scaling is turned off
		 */
		public function get vpaidVAlign():String { return _vpaidVAlign; }
		public function set vpaidVAlign(value:String):void {
			_vpaidVAlign = value;
		}
		
		/**
		 * Allow up and down scaling of ads
		 */
		public function get scaleEW():Boolean { return _scaleEW; }
		public function set scaleEW(value:Boolean):void {
			_scaleEW = validate(value, defaults.scaleEW);
		}
		
		/** 
		 * Allow up and down scaling of VAST ads
		 */
		public function get scaleVAST():Boolean { return _scaleVAST; }
		public function set scaleVAST(value:Boolean):void {
			_scaleVAST = validate(value, defaults.scaleVAST);
		}
		
		/**
		 * Allow positioning of VAST ads
		 */
		public function get positionVAST():Boolean { return _positionVAST; }
		public function set positionVAST(value:Boolean):void {
			_positionVAST = validate(value, defaults.positionVAST);
		}
		
		/**
		 * These strings will be replaced in URLs
		 */
		public function get cachebusterList():Array { return _cachebusterList; }
		public function set cachebusterList(value:Array):void {
			_cachebusterList = validate(value, defaults.cachebusterList);
		}
		
		/**
		 * Enable or disable the triggering of debug window when using the flash debug player
		 */
		public function get errorPopup():Boolean { return _errorPopup; }
		public function set errorPopup(value:Boolean):void {
			_errorPopup = validate(value, defaults.errorPopup);
		}
		
		
		/*
			If a companion ad is being found in the ad XML, it will be delivered to
			a JavaScript function. You can change the format of what is being handed over
			to that JavaScript function to 'xml' or 'object' here.
			Where 'object' is the default setting.
		 */
		public function get companionDeliverType():String { return _companionDeliverType; }
		public function set companionDeliverType(value:String):void {
			_companionDeliverType = validate(value, defaults.companionDeliverType);
		}
		
		/*
			Property: nonLinearCloseButtonPosition
			
			NonLinear ads that consist of static data (images, ..) have a close
			button attached.
			You can set its position in a css-like way.
			
			Example:
			(start example)
				//make it appear in the lower, left
				_ewAPI.uifConfigControl.nonLinearCloseButtonPosition = ({bottom:0, left:0});
				
				//make it appear in the upper right, with 8px padding
				_ewAPI.uifConfigControl.nonLinearCloseButtonPosition = ({top:8, right:8});
			(end)
			
			Parameter:
				Object - An object with at least one position of "top", "right", "bottom" and "left"
		*/
		public function get nonLinearCloseButtonPosition():Object { return _nonLinearCloseButtonPosition; }
		public function set nonLinearCloseButtonPosition(value:Object):void
		{
			//existing values are "deleted"
			_nonLinearCloseButtonPosition = new Object();
			_nonLinearCloseButtonPosition = value;
		}
		
		/**
		 * source used as the close-button for non-linear VAST ads
		 */
		public function get nonLinearCloseButtonURL():String { return _nonLinearCloseButtonURL; }
		public function set nonLinearCloseButtonURL(value:String):void
		{
			_nonLinearCloseButtonURL = validate(value, defaults.nonLinearCloseButtonURL);
		}
		
		/**
		 * border width/thickness for non-linear VAST ads
		 */
		public function get guiBorderWidth():Number { return _guiBorderWidth; }
		public function set guiBorderWidth(value:Number):void
		{
			_guiBorderWidth = validate(value, defaults.guiBorderWidth);
		}
		
		/**
		 * set greater 0 to use round "corners" with non-linear VAST ads
		 */
		public function get guiBorderRadius():Number { return _guiBorderRadius; }
		public function set guiBorderRadius(value:Number):void {
			_guiBorderRadius = validate(value, defaults.guiBorderRadius);
		}
		
		//It is no longer necessary to use this variable
		public function get enforceVPAIDScaling():Boolean {	return _enforceVPAIDScaling;}
		public function set enforceVPAIDScaling(value:Boolean):void	{
			_enforceVPAIDScaling = validate(value, defaults.enforceVPAIDScaling);
		}
		
		/**
		 * @desc ....
		 * 
		 * @param	value the value to be tested
		 * @param	_default the default value to return if the validation of value fails
		 * 
		 * @return  a valid value for the value tested
		 */
		public function validate( value:*, _default:* ):* {	
			switch ( typeof(_default) ) {
				case "number":
					if ( isNaN(value) ) return _default;
					
					break;
					
				default:		// string, boolean, color
					if ( value == undefined || value == null ) return _default;
			}
			
			return value;
		}
	}
}