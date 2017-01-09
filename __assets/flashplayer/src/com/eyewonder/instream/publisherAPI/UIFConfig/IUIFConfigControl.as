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
	import com.eyewonder.instream.core.UIFConfig;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	
	/*
		Class: UIFConfigControl

		Most preferences can be set in the respective layers, this layer/class gives
		you the opportunity to set the config without touching them all.
		<config> can be used to pass a UIFConfig data object.
		
		Example:
		(start example)
			//enable the ad countdown
			_ewAPI.uifConfigControl.countdownEnabled = true;
			
			//set a overlay delay
			_ewAPI.uifConfigControl.overlayDelay = 5;
			
			//set a file that is used to detect the bandwidth for e.g. VAST ads
			_ewAPI.uifConfigControl.bwDetectProgressiveURL = "http://www.exaple.com/detection.png";
		(end example)
	*/
	public interface IUIFConfigControl 
	{
		function destroy():void;
		
		/*
			Property: config
			
			Returns:
				UIFConfig - A class with all settings combined, these could also be set individually here
		 */
		function get config():UIFConfig
		
		/*
			Property: config
			
			Parameter:
				configSet - A set of config variables with the type UIFConfig
		 */
		function set config(uifConfig:UIFConfig):void;
		
		/*
			Property: version
			
			Returns the integration version of the player
			
			Returns:
				String - "Player Name and version number"
		 */
		function get version():String;
		
		/*
			Property: version
			
			Provides the integration version of the player and outputs it to the QA reporting panel.
			
			Parameter:
				String - "Player Name and version number"
		*/
		function set version(text:String):void;
		
		/*
			Property: integration_date
			
			Returns the date the player was integrated
			
			Returns:
				String - "year-mm-dd"
		 */
		function get integration_date():String;
		
		/*
			Property: integration_date
			
			Provides the date the player was integrated and outputs it to the QA reporting panel.
			
			Parameter:
				String - "year-mm-dd"
		*/
		function set integration_date(text:String):void;

		/*
			Property: preferredDeliveryMethod
			
			The preferred delivery method of ads when using VAST tags.
		
			Returns:
				String - 'progressive' or 'streaming'
		*/
		function get preferredDeliveryMethod():String;
		
		/*
			Property: preferredDeliveryMethod
			
			The preferred delivery method of ads when using VAST tags.
			
			Parameter:
				String - 'progressive' or 'streaming'
		*/
		function set preferredDeliveryMethod(value:String):void;
		
		/*
			Property: qualityFirst
			
			If set to true this will take the ad with the highest bandwidth consumption,
			even when it doesn't match the delivery method specified by preferredDeliveryMethod.
			
			Returns:
				Boolean - False/Undefined by default
		*/
		function get qualityFirst():Boolean;
		
		/*
			Property: qualityFirst
			
			If set to true this will take the ad with the highest bandwidth consumption,
			even when it doesn't match the delivery method specified by preferredDeliveryMethod.
			
			Parameter:
				Boolean - If set to true, UIF will take the VAST ad with the highest bandwidth, even when it's not the preferred delivery method
		*/
		function set qualityFirst(enabled:Boolean):void;
		
		/*
			Property: bwDetectProgressiveURL
			
			Returns the URL to a file which is being used to detect the bandwidth
			for _progressive_ video ads. The file itself should be at least
			a few hundred KB on a fast and trusted CDN.
			
			Returns:
				String - A URL String, is empty by default
		*/
		function get bwDetectProgressiveURL():String;
		
		/*
			Property: bwDetectProgressiveURL
			
			Set the URL to a file which is being used to detect the bandwidth
			for _progressive_ video ads. The file itself should be at least
			a few hundred KB on a fast and trusted CDN.
			
			Parameter:
				String - A URL String
		*/
		function set bwDetectProgressiveURL(url:String):void;
		
		/*
			Property: bwDetectStreamingServer
			
			Returns the URL to a file which is being used to detect the bandwidth
			for _streaming_ video ads. The file itself should be at least
			a few hundred KB on a fast and trusted CDN.
			
			Returns:
				String - A URL String, null by dafault
		*/
		function get bwDetectStreamingServer():String;
		
		/*
			Property: bwDetectStreamingServer
			
			Set the URL to a file which is being used to detect the bandwidth
			for _streaming_ video ads. The file itself should be at least
			a few hundred KB on a fast and trusted CDN.
			
			Parameter:
				String - A URL String
		*/
		function set bwDetectStreamingServer(server:String):void;
		
		//= settings that could be changed in their respective controller too =
		//== countdown ==
		
		/*
			Property: countdownEnabled
			
			Returns the state of the countdown.
			
			Returns:
				Boolean - If true, the ad countdown is enabled
		*/
		function get countdownEnabled():Boolean;
		
		/*
			Property: countdownEnabled
			
			Enables or disables the ad countdown.
			
			Parameter:
				Boolean - Setting this to true will enable the ad countdown. Set to false by default.
		*/
		function set countdownEnabled(enabled:Boolean):void;

		/*
			Property: countdownBarPosition
			
			Returns the position of the ad countdown.
			
			Returns:
				String - 'top' or 'bottom'. Default is 'bottom'.
		*/
		function get countdownBarPosition():String;
		
		/*
			Property: countdownBarPosition
			
			Set the position of the ad countdown.
			
			Parameter:
				String - 'top' or 'bottom'
		*/
		function set countdownBarPosition(position:String):void;
		
		/*
			Property: countdownText
			
			Returns the text of the count down timer.
			
			Returns:
				String - Default is: '[time] ([percent])'
		*/
		function get countdownText():String;
		
		/*
			Property: countdownText
			
			Set the text of the ad countdown. You may want to use
			one (or both) of the short tags to indicate the
			remaining time in either percent or seconds.
			
			[time] - Remaing time in seconds (counting downwards)
			[percent] - Remaining time in percent  (counting downwards)
			
			Parameter:
				String - A string which can contain one or both of [time] and [percent]
		*/
		function set countdownText(text:String):void;
		
		/*
			Property: countdownTextColor
			
			Returns the current color of the ad countdown text.
			
			Returns:
				uint - default is '0xffffff' (white)
		*/
		function get countdownTextColor():uint;
		
		/*
			Property: countdownTextColor
			
			Set the color of the ad countdown text.
			
			Parameter:
				color - A color in hex notation, e.g. 0xeeeeec
		*/
		function set countdownTextColor(color:uint):void;
		
		/*
			Property: countdownTextFormat
			
			Returns the format of the ad countdown text.
			
			See Adobe Help for more information:
				<http://livedocs.adobe.com/flash/9.0_de/ActionScriptLangRefV3/flash/text/TextFormat.html>
			
			Returns:
				TextFormat - Default is: "Arial", 10, 0xffffff, null, null, null, null, null, "center"
		*/
		function get countdownTextFormat():TextFormat;
		
		/*
			Property: countdownTextFormat
			
			Set the format of the ad countdown text.
			
			See Adobe Help for more information:
				<http://livedocs.adobe.com/flash/9.0_de/ActionScriptLangRefV3/flash/text/TextFormat.html>
			
			Parameter:
				TextFormat - e.g. new Textformat("Comic Sans MS", 12, 0xff00FF, null, null, null, null, null, "center");
		*/
		function set countdownTextFormat(format:TextFormat):void;
		
		/*
			Property: countdownBarBackColor
			
			Returns background color of the ad countdown.
			
			Returns:
				uint - a color in hex notation, default is: 0x000000 (black)
		*/
		function get countdownBarBackColor():uint;
		
		/*
			Property: countdownBarBackColor
			
			Set the background color of the ad countdown.
			
			Parameter:
				uint - A color in hex notation, e.g. 0xff0000
		*/
		function set countdownBarBackColor(color:uint):void;
		
		/*
			Property: countdownBarAlpha
			
			Returns the opacity/alpha value of the ad countdown background.
			
			Returns:
				Number - Default is: 0.8
		*/
		function get countdownBarAlpha():Number;
		
		/*
			Property: countdownBarAlpha
			
			Set the opacity/alpha value of the ad countdown background.
			
			Parameter:
				Number - A number between 0 and 1, setting it to 0 will cause the background to be invisible.
		*/
		function set countdownBarAlpha(alpha:Number):void;
		
		//== background ==
		
		/*
			Property: backgroundColor
			
			Returns the color of the area behind the ad.
			
			Returns:
				uint - a color in hex notation, default is 0x000000 (black)
		*/
		function get backgroundColor():uint;
		
		/*
			Property: backgroundColor
			
			Set the color of the area behind the ad.
			
			Parameter:
				uint - a color in hex notation, e.g. 0x00ff00
		*/
		function set backgroundColor(color:uint):void;
		
		/*
			Property: backgroundAlpha
			
			Returns the transparency of the area behind the ad.
			
			Returns:
				Number - Default is 1 - which means its opaque.
		*/
		function get backgroundAlpha():Number;
		
		/*
			Property: backgroundAlpha
			
			Sets the transparency of the area behind the ad.
			
			Parameter:
				alpha - Number between 0 and 1, setting it to 0 will cause the background to be invisible.
		*/
		function set backgroundAlpha(alpha:Number):void;
		
		//== player ==
		/*
			Property: playerContentWidth
			
			Returns the current player content width, which has to be set first.
			This should match the width of the area where the players content
			video is being shown.
			
			Returns:
				Number - The width of the players content.
		*/
		function get playerContentWidth():Number;
		
		/*
			Property: playerContentWidth
			
			Sets the current width of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			You have to call <AdControl.resize> to make the changes happen.
			
			Parameter:
				Width - The width of the players content as Number.
		*/
		function set playerContentWidth(width:Number):void;
		
		/*
			Property: playerContentHeight
			
			Returns the current height of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			Returns:
				Height - The height of the players content.
		*/
		function get playerContentHeight():Number;
		
		/*
			Property: playerContentHeight
			
			Sets the current height of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			You have to call <AdControl.resize> to make the changes happen.
			
			Parameter:
				Height - The height of the players content.
		*/
		function set playerContentHeight(height:Number):void;
		
		/*
			Property: playerContentX
			
			Returns the current X position of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			Returns:
				Number - The current X position of the players content.
		*/
		function get playerContentX():Number;
		
		/*
			Property: playerContentX
			
			Sets the current X position of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			You have to call <AdControl.resize> to make the changes happen.
			
			Parameter:
				Number - The current X position of the players content.
		*/
		function set playerContentX(x:Number):void;
		
		/*
			Property: playerContentY
			
			Returns the current Y position of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			Returns:
				Number - The current Y position of the players content.
		*/
		function get playerContentY():Number;
		
		/*
			Property: playerContentY
			
			Sets the current Y position of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			You have to call <AdControl.resize> to make the changes happen.
			
			Parameter:
				Number - The current Y position of the players content.
		*/
		function set playerContentY(y:Number):void;
		
		/*
			Property: playerContentClip
			
			Returns the current position and dimension of the player content. This has to be set initially,
			see <PlayerControl.videoScreenRect>.
			
			Returns:
				MovieClip - The current position and dimension position of the players content.
		*/
		function get playerContentClip():MovieClip;
		
		/*
			Property: playerContentClip
			
			This can be used to set a reference to the content players clip, this will then be used 
			to set the available area for the ad <PlayerControl.videoScreenRect>.
			
			You have to call <AdControl.resize> to make the changes happen.
			
			Parameter:
				Clip - A clip that serves as reference to the publishers player content clip.
		*/
		function set playerContentClip(value:MovieClip):void;
		
		/*
			Property: vpaidHAlign
			
			This can be used to position VPAID ads when scaling is turned off.
			
			Parameter:
				value - A string that specifies horizontal positioning. Possible variables are "center", "right", and "left"
			
		*/
		function get vpaidHAlign():String 
		function set vpaidHAlign(value:String):void 
		
			/*
			Property: vpaidHAlign
			
			This can be used to position VPAID ads when scaling is turned off.
			
			Parameter:
				value - A string that specifies horizontal positioning. Possible variables are "middle", "bottom", and "top"
			
		*/
		function get vpaidVAlign():String 
		function set vpaidVAlign(value:String):void 
		
		//== ad ==
		/*
			Property: overlayDelay
			
			Returns the current overlay delay in seconds.
			
			Returns:
				Number - Delay in seconds
		*/
		function get overlayDelay():Number;
		
		/*
			Property: overlayDelay
			
			Sets overlay delay, this is used to delay
			the visibility of Non-Linear (e.g. Overlay/Ticker/Bug) ads
			after they have been started with <AdControl.loadAdURL>.
			
			Returns:
				Number - Delay in seconds
		*/
		function set overlayDelay(delayInSeconds:Number):void;
		
		/*
			Property: midrollVideoLength
			
			Returns the minimum length a content video must have to enable
			midrolls.
			
			Returns:
				Number - Content length in seconds
		*/
		function get midrollVideoLength():Number;
		
		/*
			Property: midrollVideoLength
			
			Sets the minimum length a content video must have to enable
			midrolls.
			
			Parameter:
				Number - Content length in seconds
		*/
		function set midrollVideoLength(lengthInSeconds:Number):void;
		
		/*
			Property: scaleEW
			
			Whether to enable scaling for EyeWonder Instream ads.
			
			Returns:
				Boolean - True means scaling is enabled.
		*/
		function get scaleEW():Boolean;
		
		/*
			Property: scaleEW
			
			Whether to enable scaling for EyeWonder Instream ads.
			
			Parameter:
				Boolean - True means scaling is enabled
		*/
		function set scaleEW(value:Boolean):void;
		
		/*
			Property: scaleVAST
			
			Whether to enable scaling for VAST ads.
			
			Returns:
				Boolean - True means scaling is enabled
		*/
		function get scaleVAST():Boolean;
		
		/*
			Property: scaleVAST
			
			Whether to enable scaling for VAST ads.
			
			Parameter:
				Boolean - True means scaling is enabled
		*/
		function set scaleVAST(value:Boolean):void;
		
		/*
			Property: errorPopup
			
			Returns whether the error popup from flash should be shown
			or not. If it's set to "false", then the error
			message will be traced and printed into the QA
			reporting page.
			
			Returns:
				Boolean - True if errors should be shown in pop up
		 */
		function get errorPopup():Boolean;
		
		/*
			Property: errorPopup
			
			Enable or disable Flash error popups, if set to off errors will
			be traced and printed to QA console.
			
			Parameter:
				Boolean - False will print the error messages into QA console and will trace them
		*/
		function set errorPopup(enabled:Boolean):void;
		
		/*
			Property: companionDeliverType
			
			If a companion ad is being found in the ad XML, it will be delivered to
			a JavaScript function. You can change the format of what is being handed over
			to that JavaScript function to 'xml' or 'object' here.
			Where 'object' is the default setting.
			
			Parameter:
				String - either 'xml' or 'object'
		*/
		function get companionDeliverType():String;
		function set companionDeliverType(value:String):void;
		
		/*
			Property: positionVAST
			
			Returns boolean if positioning for VAST ads is enabled or not.
			
			Returns:
				Boolean - True means positioning is enabled
		*/
		function get positionVAST():Boolean;
		
		/*
			Property: positionVAST
			
			Whether to enable positiong for VAST ads, it will be placed middle, center
			of the player content height and width if this is set to true.
			
			Parameter:
				Boolean - True means positioning is enabled
		*/
		function set positionVAST(enabled:Boolean):void;
		
		/*
			Property: cachebusterList
			
			An array of strings that will be replaced within URLs.
			
			Returns:
				Array - Default is: "\\[timestamp\\]", "\\[cachebuster\\]", "\\[random\\]", "\\[randnum\\]"
		 */
		function get cachebusterList():Array;
		
		/*
			Property: cachebusterList
			
			To allow custom cachebuster strings you may want to add your strings to the array.
			
			Beware that you have to escape square brackets, as the strings
			will be replaced via Regular Expressions. This is case-insensitive.
			
			Parameter:
				Array - ie.: new Array("\\[rndNmbr\\]", "\\[timestamp\\]", "\\[cachebuster\\]", "\\[random\\]", "\\[randnum\\]");
		*/
		function set cachebusterList(newArrayWithStrings:Array):void;

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
		function get nonLinearCloseButtonPosition():Object;
		function set nonLinearCloseButtonPosition(value:Object):void;
		
		/*
			Property: nonLinearCloseButtonURL
			
			NonLinear ads that consist of static data (images) have a close
			button attached.
			You can set the link to a close button graphic here, this can either be an image or even
			a SWF with animations. Refer to the closeButton.fla in the assets folder for an example.
			
			If you omit the URL or set it to a place which does not exists then a red bar
			will be displayed instead of the graphic.
			
			Returns:
				String - An URL to a SWF or an image, default is "./closeButton.swf"
		*/
		function get nonLinearCloseButtonURL():String
		function set nonLinearCloseButtonURL(newCloseButtonURL:String):void
		
		/*
			Property: guiBorderWidth
			
			Width of the border that is being added to GUI elements.
			Used by NonLinear VAST ads that consist of a image,
			they're placed upon a rounded rectancle.
			
			Returns:
				Number - Width of the border (in pixels), default is 12
		*/
		function get guiBorderWidth():Number;
		function set guiBorderWidth(value:Number):void;
		
		/*
			Property: guiBorderRadius
			
			The roundness of the rectancle that is being placed behind
			NonLinear VAST ads that consist of a static resource (image).
			
			A setting of 0 will result in sharp edges instead of round
			corners.
			
			Returns:
				Number - Radius of the border (in pixels), default is 7
		*/
		function get guiBorderRadius():Number;
		function set guiBorderRadius(value:Number):void;
		
		/*
			Property: enforceVPAIDScaling
			
			Some VPAID ads don't scale as they should, as written in the IAB specifications
			the VPAID ads should scale themselves with the given content display sizes.
			
			To ensure that these ads are still looking good you may want to force them to
			do so. This is against the IAB standards, but may come in handy if you really
			need it.
			
			Source of above mentioned boundaries:
			http://www.iab.net/media/file/VPAIDFINAL51109.pdf
			8.1 API Specifics
			(..)
			Note, it is especially important that the player never set the width, height, scaleX,
			or scaleY properties of the ad directly or risk having unpredictable scaling effect on the ad.
			The player should call resize instead"
			
			Default value is false, so the ad should be able to scale itself - without any
			external scaling help.
			
			Returns:
				Boolean - Whether VPAID ads should be external scaled or not
		*/
		function get enforceVPAIDScaling():Boolean;
		function set enforceVPAIDScaling(value:Boolean):void;
	}
}