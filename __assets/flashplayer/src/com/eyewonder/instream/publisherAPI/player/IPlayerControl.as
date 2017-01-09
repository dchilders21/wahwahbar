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
package com.eyewonder.instream.publisherAPI.player
{
	import flash.geom.Rectangle;
	import com.eyewonder.instream.core.events.IUIFEventDispatcher;
	
		/*
		Class: PlayerControl

		The publisher should hook onto events from this class, and use them
		to respond to play, pause and stop events the ad is sending. Additionally
		showControlbar and hideControlbar is being sent, which should be used to show or 
		hide all elements on the player content that would otherwise block interactive elements
		of the ad.
		
		Volume and size changes should be provided to this class too.
		
		Events:
			CONTENT_VID_PAUSE	- Ad requests player to pause the content
			CONTENT_VID_PLAY	- Ad requests player to play the content
			CONTENT_VID_STOP	- Ad requests player to stop the content 
			HIDE_CONTROLS		- Ad requests to hide the players overlay controls, as they might block interactive objects in the ad
			SHOW_CONTROLS		- Ad requests to unhide the elements that have been hidden on HIDE_CONTROLS
		
		Example:
		(start example)
			
			//to set the available dimensions for the ad you simply do the following:
			ewAPI.playerControl.videoScreenRect = new Rectangle(0, 0, 640, 480);
			
			//add a listener to events the player should react to
			ewAPI.playerControl.addEventListener(UIFEvent.CONTROL_EVENT, playerEventHandler);
			
			//match the volume of the player with the ad
			ewAPI.playerControl.volume = myPlayer.volume;
		(end example)
	*/
	public interface IPlayerControl extends IUIFEventDispatcher
	{
		function destroy():void;
		
		/*
			Property: bandwidth
			
			The bandwidth of the publishers content player.
			This has to be set first.
			
			Returns:
				Number - The bandwidth
		*/
		function get bandwidth():Number;
		
		/*
			Property: bandwidth
			
			If the bandwidth of the publishers content player is set,
			then the VAST bandwidth detection will not take place.
			
			This has to be set first.
			
			Parameter:
				Number - The bandwidth
		*/
		function set bandwidth(value:Number):void;
		
		/*
			Property: videoScreenRect
			
			Returns the player content dimensions and positioning.
			This has to be set first.
			
			Returns:
				Rectangle - A Rectangle with the dimension and position of the publishers content.
		*/
		function get videoScreenRect():Rectangle;
		
		/*
			Property: videoScreenRect
			
			It's important to set this on initialization and after each resize
			of the player's content video, e.g. when changing to fullscreen.
			
			If it's set, then the ad will resize itself. This is the preferred way to set the publisher's content video dimensions. _no_ call
			to <AdControl.resize> is necessary.
			
			Parameter:
				Rectangle - A Rectangle with the dimension and position of the publishers content.
		*/
		function set videoScreenRect(value:Rectangle):void;
		
		/*
			Property: volume
			
			Returns the volume of the player content.
			
			Returns:
				Number - The volume.
		*/
		function get volume():Number;
		
		/*
			Property: volume
			
			Sets the volume of the player's content video. The publisher
			should always set the volume after it has been changed
			in the content player - to notify the ad.
			
			Parameter:
				Number - The volume.
		*/
		function set volume(value:Number):void;
		
		/*
			Property: videoState
			
			The current content state of the publishers player. This has to be set
			first, provides a way to store the publishers player content state, won't
			interagate with the framework.
			
			Returns:
				Number - undefined
				
		*/
		function get videoState():Number;
		
		/*
			Property: videoState
			
			Set the current content state of the publishers player. This has to be set
			first, provides a way to store the publishers player content state, won't
			interagate with the framework.
			
			Parameter:
				playerState - Number
		*/
		function set videoState(value:Number):void;
	}
}