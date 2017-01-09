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
package com.eyewonder.instream.publisherAPI.view.background 
{
	import flash.display.MovieClip;
	
	/*
		Class: BackgroundMovieClip

		This layer provides the possibility to change the appearance of
		the ad background.
		
		Example:
		(start example)
			//returns the ad background as a MovieClip
			var anotherBackground:MovieClip = ewAPI.viewControl.background.movieClip;
			
			//change the color of the background to a random color
			ewAPI.viewControl.background.color = Math.round( Math.random() * 0xFFFFFF );
			
			//change the tranparency level of the background to 75%
			ewAPI.viewControl.background.alpha = 0.75;
		(end example)
	*/
	public interface IBackgroundMovieClip 
	{
		function destroy():void;
		
		/*
			Property: movieClip
		
			Returns the background as MovieClip.
			
			Returns:
				MovieClip - The adBackground.
		*/
		function get movieClip():MovieClip;
		
		/*
			Property: x
		
			Returns the X position of the ad background.
			
			Returns:
				Number - The x position.
		*/
		function get x():Number;
		
		/*
			Property: x
		
			Sets the X position of the ad background.
			
			Parameter:
				backgroundX - The new x position as Number.
		*/
		function set x(backgroundY:Number):void;
		
		/*
			Property: y
		
			Returns the Y position of the ad background.
			
			Returns:
				Number - The y position.
		*/
		function get y():Number;
		
		/*
			Property: y
		
			Sets the Y position of the ad background.
			
			Parameter:
				backgroundY - The new y position as Number.
		*/
		function set y(backgroundY:Number):void;
		
		/*
			Property: color
			
			Returns the color of the area behind the ad.
			
			Returns:
				uint - a color in hex notation, default is 0x000000 (black)
		*/
		function get color():uint;
		
		/*
			Property: color
			
			Set the color of the area behind the ad.
			
			Parameter:
				uint - a color in hex notation, e.g. 0x00ff00
		*/
		function set color(backgroundColor:uint):void;

		/*
			Property: alpha
			
			Returns the transparency of the area behind the ad.
			
			Returns:
				Number - Default is 1 - which means its opaque.
		*/
		function get alpha():Number;
		
		/*
			Property: alpha
			
			Sets the transparency of the area behind the ad.
			
			Parameter:
				alpha - Number between 0 and 1, setting it to 0 will cause the background to be invisible.
		*/
		function set alpha(backgroundAlpha:Number):void;
		
		/*
			Function: show
			
			Shows the with <hide> hidden ad background.
		*/
		function show():void;
		
		/*
			Function:hide
			
			Hides the ad background.
		*/
		function hide():void;
	}
}