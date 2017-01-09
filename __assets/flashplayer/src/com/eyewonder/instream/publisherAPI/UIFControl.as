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
package com.eyewonder.instream.publisherAPI
{
	import com.eyewonder.instream.publisherAPI.IUIFControl;
	import com.eyewonder.instream.publisherAPI.UIFConfig.IUIFConfigControl;
	import com.eyewonder.instream.publisherAPI.view.IViewControl;
	import com.eyewonder.instream.publisherAPI.player.IPlayerControl;
	import com.eyewonder.instream.publisherAPI.adControl.IAdControl;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.publisherAPI.UIFConfig.UIFConfigControl;
	import com.eyewonder.instream.publisherAPI.view.ViewControl;
	import com.eyewonder.instream.publisherAPI.player.PlayerControl;
	import com.eyewonder.instream.publisherAPI.adControl.AdControl;
	
	import flash.display.MovieClip;
	
	/*
		Class: UIFControl

		This is the APIs master controller.  Once this layer is initialized, you will have access to all other
		layers. 
		
		Example:
		(start example)
			import com.eyewonder.instream.publisherAPI.UIFControl;
			import flash.geom.Rectangle;
			
			var ewAPI:UIFControl = new UIFControl(rootMC);
			
			//To set the available player dimensions the ad loads into, simply do the following:
			ewAPI.playerControl.videoScreenRect = new Rectangle(0, 0, 640, 480);
		(end example)
	*/
	public class UIFControl implements IUIFControl
	{
		private const _apiVersion:String = "0.3"		
		private var _instreamFramework:InstreamFrameworkBase;
		private var _uifConfigControl:UIFConfigControl;
		private var _viewControl:ViewControl;
		private var _playerControl:PlayerControl;
		private var _adControl:AdControl;
		
		private var _rootMC:MovieClip;
		
		/*
			Constructor: UIFControl
			
			Initializes all layers, and makes them available to the publisher.
			
			Parameter:
				rootMC - Represents the MovieClip/VideoScreen the ad will be placed in.
		*/
		public function UIFControl(rootMC:MovieClip):void
		{
			_rootMC = rootMC;
			
			constructChildren();
		}
		
		/*
			Function: constructChildren
			
			Initializes all layers, this is being called by <UIFControl> constructor
		*/
		private function constructChildren():void
		{
			_instreamFramework = new InstreamFrameworkBase(_rootMC);
			_uifConfigControl = new UIFConfigControl(_instreamFramework);
			_viewControl = new ViewControl(_instreamFramework);
			_playerControl = new PlayerControl(_instreamFramework);
			_adControl = new AdControl(_instreamFramework);
		}
		
		/*
			Destructor: destroy
			
			Destroys all layers that was initialized by calling the <UIFControl> constructor
		*/
		public function destroy():void
		{
			adControl.endAd();			

			viewControl.destroy();
			playerControl.destroy();
			adControl.destroy();
			uifConfigControl.destroy();
		}
		
		/*
			Property: uifConfigControl
			
			[read-only] 
			
			Returns:
				IUIFConfigControl - see <UIFConfigControl>
		*/
		public function get uifConfigControl():IUIFConfigControl
		{
			return _uifConfigControl;
		}
		
		/*
			Property: viewControl
			
			[read-only] 
			
			Returns:
				IViewControl - see <ViewControl>
		*/
		public function get viewControl():IViewControl
		{
			return _viewControl;
		}
		
		/*
			Property: playerControl
			
			[read-only] 
			
			Returns:
				IPlayerControl - see <PlayerControl>
		*/
		public function get playerControl():IPlayerControl
		{
			return _playerControl;
		}
		
		/*
			Property: adControl
			
			[read-only] 
			
			Returns:
				IAdControl - see <AdControl>
		*/
		public function get adControl():IAdControl
		{
			return _adControl;
		}
		
		/*
			Property: uifVersion
			
			[read-only] Use this property to get the current version of Universial Instream Framework.
			
			Returns:
				versionString - Returns a String with the following format "major.minor[.maintenance]" (e.g. "2.9")
		*/
		public function get uifVersion():String
		{
			return _instreamFramework.getAPIVersion();
		}
		
		/*
			Property: apiVersion
			
			[read-only] Use this property to get the current version of the Publisher API.
			
			Returns:
				versionString - Returns a String of the following format "major.minor[.maintenance]" (e.g. "0.3")

		*/
		public function get apiVersion():String
		{
			return _apiVersion;
		}
		
		/*
			Property: actionscriptVersion
			
			[read-only] Returns the ActionScript version of the Framework being used.
			
			Returns:
				versionNumber - Returns a number greater than or equal to 2.
		*/
		public function get actionscriptVersion():Number
		{
			return _instreamFramework._actionscriptVersion;
		}
		
		/*
			Function: debugMessage
			
			Use this method to append messages to the debug log.
			
			The QA console can be viewed via this URL:
			http://cdn1.eyewonder.com/200125/qa/reporting/receiving.html			
			
			The level decides which category the message will be placed into,
			the higher the number the less important the message.

			Parameters:
				level - Number, where 1 = error, 2 = warning, 3 = info
				message - Object

		*/
		public function debugMessage(level:Number, message:Object, prefix:String = "[~ Publisher Debug ~]"):void
		{
			_instreamFramework._debugMessage(level, message, prefix);
		}
	}
}