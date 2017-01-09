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
	import flash.display.MovieClip;
	
	/*
		Class: AdMovieClip

		This layer provides the possibility to change the appearance of
		the ad.
		
		Example:
		(start example)
			//place an ad to the bottom left
			ewAPI.viewControl.ad.positionVertical = "bottom";
			ewAPI.viewControl.ad.positionHorizontal = "left";
			
			//disable scaling of ads
			ewAPI.viewControl.ad.scale = false;
		(end example)
	*/
	public interface IAdMovieClip 
	{
		function destroy():void;
		
		/*
			Property: movieClip
		
			Returns the ad as MovieClip.
			
			Returns:
				MovieClip - The adCountown.
		*/
		function get movieClip():MovieClip;
		
		/*
			Property: adPosition

			Returns position of the ad, by ratio, scaled ad.

			Returns:
				Object - Where y and x are accessible
		 */
		function get adPosition():Object;
		
		/*
			Property: positionHorizontal
			
			Returns the horizontal position of the ad,
			if this is not changed by the publisher it
			will return the position that has been defined
			in the Eyewonder Instream ad tag XML.
			
			Returns:
				String - 'left', 'center', 'right'
		*/
		function get positionHorizontal():String;

		/*
			Property: positionHorizontal
			
			Set the horizontal position of the ad.
			
			Parameter:
				String - 'left', 'center', 'right'
		*/
		function set positionHorizontal(newPosition:String):void;
		
		/*
			Property: positionVertical
			
			Returns the vertical position of the ad,
			if this is not changed by the publisher it
			will return the position that has been defined
			in the Eyewonder Instream ad tag XML.
			
			Returns:
				newPosition - 'top', 'middle', 'bottom'
		*/
		function get positionVertical():String;
		
		/*
			Property: positionVertical
			
			Set the vertical position of the ad.
			
			Parameter:
				newPosition - 'top', 'middle', 'bottom'
		*/
		function set positionVertical(newPosition:String):void;
		
		/*
			Property: scale
			
			Returns whether ads should be scaled.
			
			Returns:
				Boolean - Default is: true
		*/
		function get scale():Boolean;
		
		/*
			Property: scale
			
			Sets whether ads should be scaled.
			
			Parameter:
				Boolean - True means scaling is enabled
		*/
		function set scale(scaling:Boolean):void;
		
		/*
			Function: show
			
			Shows the with <hide> hidden ad.
		*/
		function show():void;
		
		/*
			Function:hide
			
			Hides the ad.
		*/
		function hide():void;
	}
}