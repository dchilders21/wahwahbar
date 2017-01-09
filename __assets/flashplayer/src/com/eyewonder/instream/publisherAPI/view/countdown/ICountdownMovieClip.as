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
	import flash.display.MovieClip;
	
	/*
		Class: CountdownMovieClip

		This layer provides the possibility to change the appearance of
		the ad countdown UI.
		
		Example:
		(start example)
			//change the text
			ewAPI.viewControl.countdown.text = "Just one spot - content will start in [time] seconds";
			
			//change the color of the background and the text to a random color
			ewAPI.viewControl.countdown.backgroundColor = Math.round( Math.random() * 0xFFFFFF );
			ewAPI.viewControl.countdown.textColor = Math.round( Math.random() * 0xFFFFFF );
			
			//change the position
			ewAPI.viewControl.countdown.position = "bottom";
		(end example)
	*/
	public interface ICountdownMovieClip
	{
		function destroy():void;
		
		/*
			Property: movieClip
		
			Returns the adCountdown as MovieClip.
			
			Returns:
				MovieClip - The adCountown.
		*/
		function get movieClip():MovieClip;
		
		/*
			Property:[Read-Write] position
			
			Returns the position of the ad countdown.
			
			Returns:
				String - 'top' or 'bottom'. Default is 'bottom'.
		*/
		function get position():String;
		
		/*
			Property:[Read-Write] position
			
			Set the position of the ad countdown.
			
			Parameter:
				String - 'top' or 'bottom'
		*/
		function set position(position:String):void;
		
		/*
			Property:[Read-Write] text
			
			Returns the text of the count down.
			
			Returns:
				String - Default is: '[time] ([percent])'
		*/
		function get text():String;
		
		/*
			Property:[Read-Write] text
			
			Set the text of the ad countdown. You may want to use
			one (or both) of the short tags to indicate the
			remaining time in either percent or seconds.
			
			[time] - Remaing time in seconds (counting downwards)
			[percent] - Remaining time in percent  (counting downwards)
			
			Parameter:
				String - A string which can contain one or both of [time] and [percent]
		*/
		function set text(countdownText:String):void;
		
		/*
			Property:[Read-Write] textColor
			
			Returns the current color of the ad countdown text.
			
			Returns:
				uint - default is '0xffffff' (white)
		*/
		function get textColor():uint;
		
		/*
			Property:[Read-Write] textColor
			
			Set the color of the ad countdown text.
			
			Parameter:
				color - A color in hex notation, e.g. 0xeeeeec
		*/
		function set textColor(color:uint):void;
		
		/*
			Property:[Read-Write] backgroundColor
			
			Returns background color of the ad countdown.
			
			Returns:
				uint - a color in hex notation, default is: 0x000000 (black)
		*/
		function get backgroundColor():uint;
		
		/*
			Property:[Read-Write] backgroundColor
			
			Set the background color of the ad countdown.
			
			Parameter:
				uint - A color in hex notation, e.g. 0xff0000
		*/
		function set backgroundColor(color:uint):void;
		
		/*
			Property:[Read-Write] backgroundAlpha
			
			Returns the opacity/alpha value of the ad countdown background.
			
			Returns:
				Number - Default is: 0.8
		*/
		function get backgroundAlpha():Number;
		
		/*
			Property:[Read-Write] backgroundAlpha
			
			Set the opacity/alpha value of the ad countdown background.
			
			Parameter:
				Number - A number between 0 and 1, setting it to 0 will cause the background to be invisible.
		*/
		function set backgroundAlpha(alpha:Number):void;
		
		/*
			Function: show
			
			Shows the with <hide> hidden ad countdown.
		*/
		function show():void;
		
		/*
			Function:hide
			
			Hides the ad countdown.
		*/
		function hide():void;
	}
}