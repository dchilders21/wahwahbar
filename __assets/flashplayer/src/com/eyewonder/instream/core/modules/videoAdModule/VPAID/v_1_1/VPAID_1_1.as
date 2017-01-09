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

package com.eyewonder.instream.core.modules.videoAdModule.VPAID.v_1_1
{
	
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.utility.Debug;
	import com.eyewonder.instream.core.modules.EWVPAIDExtensions;
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDEvent;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDTranslator;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.IVPAIDBase;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDController;
	
	/*
		Class: VPAID_1_1

		This class handles communication with v1.1 VPAID ads
	*/
		public class VPAID_1_1 extends MovieClip implements IVPAIDBase
	{
		private var _handshakeVersions:Array = ["1.1", "1.0"];
		
		private var _controller:VPAIDController;
		private var _translator:VPAIDTranslator;
		
		
		public var adVersion:String;
		private var _ad:*;
		
		/*
			Constructor: VPAID_1_1
			
			Initializes the VPAID_1_1
			
			Parameters:
				VPAIDController - A reference to an instantiated <VPAIDController>
		*/
		public function VPAID_1_1(controller:VPAIDController):void
		{
			_controller = controller;
			_translator = _controller._VPAIDTranslator;
			
			_ad = _controller.ad;
		}

		public function probeVersion():Boolean
		{
			var result:Boolean = false;

			try
			{
				adVersion = _ad.handshakeVersion("1.1");
				var handshakeReturn:Boolean = _checkHandShakeVersion(adVersion);
			}
			catch (e:Error)
			{
				return false;
			}
			
			if (handshakeReturn)
			{
				result = true;
			}
			
			return result;
		}
		
		public function defineVPAIDEvents():void
		{
			VPAIDEvent.LOADED					="AdLoaded";
			VPAIDEvent.STARTED					="AdStarted";
			VPAIDEvent.STOPPED					="AdStopped";
			VPAIDEvent.LINEAR_CHANGE			="AdLinearChange";
			VPAIDEvent.EXPANDED_CHANGE			="AdExpandedChange";
			VPAIDEvent.REMAINING_TIME_CHANGE	="AdRemainingTimeChange";
			VPAIDEvent.IMPRESSION				="AdImpression";
			VPAIDEvent.VIDEO_FIRST_QUARTILE		="AdVideoFirstQuartile";
			VPAIDEvent.VIDEO_MIDPOINT			="AdVideoMidpoint";
			VPAIDEvent.VIDEO_THIRD_QUARTILE		="AdVideoThirdQuartile";
			VPAIDEvent.VIDEO_COMPLETE			="AdVideoComplete";
			VPAIDEvent.CLICK_THRU				="AdClickThru";
			VPAIDEvent.USER_ACCEPT_INVITATION	="AdUserAcceptInvitation";
			VPAIDEvent.PAUSED					="AdPaused";
			VPAIDEvent.PLAYING					="AdPlaying";
			VPAIDEvent.ERROR					="AdError";
			
			
			//Eyewonder proprietary property
			VPAIDEvent.EW_AD_INFORMATION_DATA = "ew_AdInformationData";

			VPAIDEvent.VIDEO_START				="AdVideoStart";
			VPAIDEvent.VOLUME_CHANGE			="AdVolumeChange";
			VPAIDEvent.LOG						="AdLog";
			VPAIDEvent.USER_CLOSE				="AdUserClose";
			VPAIDEvent.USER_MINIMIZE			="AdUserMinimize";
		}

		/*
			Function: _addVPAIDListener
			
			Adds listeners to an VPAID 1.1 ad
		*/
		public function _addVPAIDListener():void
		{
			_ad.addEventListener(VPAIDEvent.LOADED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.STARTED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.STOPPED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.LINEAR_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.EXPANDED_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.REMAINING_TIME_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VOLUME_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.IMPRESSION, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_START, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_FIRST_QUARTILE, _vpaidEventHandler); 
			_ad.addEventListener(VPAIDEvent.VIDEO_MIDPOINT, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_THIRD_QUARTILE, _vpaidEventHandler); 
			_ad.addEventListener(VPAIDEvent.VIDEO_COMPLETE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.CLICK_THRU, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.USER_ACCEPT_INVITATION, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.USER_MINIMIZE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.USER_CLOSE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.PAUSED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.PLAYING, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.LOG, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.ERROR, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.EW_AD_INFORMATION_DATA, _vpaidEventHandler);
		}
		
		/*
			Function: _removeVPAIDListener
			
			Removes all listeners that have been placed on the sources of events via _addVPAIDListener
		*/
		public function _removeVPAIDListener():void
		{
			_ad.removeEventListener(VPAIDEvent.LOADED, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.STARTED, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.STOPPED, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.LINEAR_CHANGE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.EXPANDED_CHANGE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.REMAINING_TIME_CHANGE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VOLUME_CHANGE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.IMPRESSION, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_START, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_FIRST_QUARTILE, _vpaidEventHandler); 
			_ad.removeEventListener(VPAIDEvent.VIDEO_MIDPOINT, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_THIRD_QUARTILE, _vpaidEventHandler); 
			_ad.removeEventListener(VPAIDEvent.VIDEO_COMPLETE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.CLICK_THRU, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.USER_ACCEPT_INVITATION, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.USER_MINIMIZE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.USER_CLOSE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.PAUSED, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.PLAYING, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.LOG, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.ERROR, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.EW_AD_INFORMATION_DATA, _vpaidEventHandler);
		}
		
		public function init():void
		{
			defineVPAIDEvents();
			
			_addVPAIDListener();
			
			_controller._startEventGuardTimer();
		}
		
		/*
			Function: _checkHandShakeVersion
			
			Compares the version from the VPAID ad with the version-array of this class
			
			Return:
				Boolean - Is true if the version of the ad is found inside the _handshakeVersions array
		*/
		private function _checkHandShakeVersion(_version:String):Boolean
		{
			for (var i:Object in _handshakeVersions)
			{
				if (_version.substring(0,3) == _handshakeVersions[i].substring(0,3))
				return true;
			}
			return false;
		}
		
		/*
			Function: _remainingTimerHandler
			
			Called on each playhead-update for linear ad-types,
			allows updating progress-bar and/or time displays of the player.
			
			See Also:
				<AdControl.remainingTime>
		*/
		public function _remainingTimerHandler(event:TimerEvent):void 
		{
			if(remainingTimeVPAID)_translator.remainingTime(remainingTimeVPAID);
		}
		
		
		/*
			Function: _vpaidEventHandler
			
			Events that come from the ad are handled here. Event type is
			intentionally set as asterisk, reasoning for this is
			if the event comes from a external swf the type is not predictable.
		
			Events:
				VPAIDEvent.LOADED 				- Loading of ad is done
				VPAIDEvent.STARTED 				- Ad is displaying
				VPAIDEvent.STOPPED 				- Ad has stopped displaying, and ressources have been cleaned up
				VPAIDEvent.LINEAR_CHANGE 			- Ad has changed playback mode
				VPAIDEvent.EXPANDED_CHANGE 		- Ad expanded state has being changed
				VPAIDEvent.REMAINING_TIME_CHANGE	- Remaining time of ad has been changed
				VPAIDEvent.VOLUME_CHANGE 			- Ad has changed it's volume
				VPAIDEvent.IMPRESSION 			- User-visible phase of ad has begun
				VPAIDEvent.VIDEO_START 			- Video has started progress
				VPAIDEvent.VIDEO_FIRST_QUARTILE 	- Ad video has reached first quartile
				VPAIDEvent.VIDEO_MIDPOINT 			- Ad video has reached it's midpoint
				VPAIDEvent.VIDEO_THIRD_QUARTILE 	- Ad video has reached third quartile
				VPAIDEvent.VIDEO_COMPLETE 			- Ad video has been played completely
				VPAIDEvent.CLICK_THRU 				- Click thru occured
				VPAIDEvent.USER_ACCEPT_INVITATION 	- Triggered on user ineraction
				VPAIDEvent.USER_MINIMIZE 			- Triggered on user ineraction
				VPAIDEvent.USER_CLOSE 				- Triggered on user ineraction
				VPAIDEvent.PAUSED 				- Response to method call
				VPAIDEvent.PLAYING 				- Response to method call
				VPAIDEvent.LOG 					- Ad sends debug message to relay
				VPAIDEvent.ERROR 					- Fatal error occured
		
			Parameter:
				event - The event that was sent by the ad.
		*/
		public function _vpaidEventHandler(_evt:*):void 
		{
			if (_evt.type != VPAIDEvent.EXPANDED_CHANGE && _evt.type != VPAIDEvent.LOG)
			{
				_translator._debugMessage("In _vpaidEventHandler(): " + _evt.type);	
			}
			//Forward events
			_translator.dispatchUIFEvent(UIFEvent.VPAID_EVENT, _evt );
			
			switch(_evt.type)
			{
				case VPAIDEvent.LOADED:
					_controller._stopEventGuardTimer();
					_controller._startEventGuardTimer();
					_translator.trackLoad();
					startVPAID();
					
					//initial check if its a liniar, if so - pause the content
					if (linearVPAID)
					{
						_translator.setVideoState(3);
					}
					break;
				case VPAIDEvent.STARTED:
					_translator.wwAdStarted();
					if(!_translator.getAdInformationData()['type'] && !_translator.getAdInformationData()['subtype'])
					{
						_translator.hideControls();
					}
					_translator.resize();
					_controller._stopEventGuardTimer();
					startUpRemainingTime();
					break;
				case VPAIDEvent.STOPPED:
					_translator.trackStop();
					_translator.setVideoState(2);
					_controller._endAd();
					break;
				case VPAIDEvent.LINEAR_CHANGE:
					if (linearVPAID){
						_translator.setVideoState(3);	//pause ContentVideo
					}else {
						_translator.setVideoState(2);	//play ContentVideo
					}
					break;
				case VPAIDEvent.EXPANDED_CHANGE:
					_translator._debugMessage("In _vpaidEventHandler(): AdExpandedChange - adExpanded:" + expandedVPAID);
					if (expandedVPAID)
					{
						_translator.trackExpand();
					}
					else
					{
						_translator.trackContract();
					}
					break;
				case VPAIDEvent.REMAINING_TIME_CHANGE:
					startUpRemainingTime();
					break;
				case VPAIDEvent.VOLUME_CHANGE:
					_translator.audioVolume(volumeVPAID);
					break;
				case VPAIDEvent.IMPRESSION:
					_translator.trackImpression();
					break;
				case VPAIDEvent.VIDEO_START:
					_translator.trackStartOfVideo();
					break;
				case VPAIDEvent.VIDEO_FIRST_QUARTILE:
					_translator.trackFirstQuartileOfVideo();
					break;
				case VPAIDEvent.VIDEO_MIDPOINT:
					_translator.trackMidOfVideo();
					break;
				case VPAIDEvent.VIDEO_THIRD_QUARTILE:
					_translator.trackThirdQuartileOfVideo();
					break;
				case VPAIDEvent.VIDEO_COMPLETE:
					_translator.trackEndOfVideo();
					break;
				case VPAIDEvent.CLICK_THRU:
					_translator.trackClickthru();
					break;
				case VPAIDEvent.USER_ACCEPT_INVITATION:
					_translator.trackUserAcceptInvitation();
					break;
				case VPAIDEvent.USER_MINIMIZE:
					_translator.trackContract();
					break;
				case VPAIDEvent.USER_CLOSE:
					_translator.trackClose();
					break;
				case VPAIDEvent.PAUSED:
					_translator.trackPause();
					break;
				case VPAIDEvent.PLAYING:
					_translator.trackPlaying();
					break;
				case VPAIDEvent.LOG:
				_translator._debugMessage("In _vpaidEventHandler(): " + _evt.type + " [" +  _evt.data.message + "]");	
					break;
				case VPAIDEvent.ERROR: 
					_translator.trackError();
					_controller._endAd();
					break;
				case VPAIDEvent.EW_AD_INFORMATION_DATA: 
					var vpaidExtensions:EWVPAIDExtensions = new EWVPAIDExtensions();
					vpaidExtensions.adInformationData = _evt.data ;
					_translator._debugMessage("In _vpaidEventHandler() ***** EW_AD_INFORMATION_DATA ***** " + EWVPAIDExtensions(vpaidExtensions).adInformationData.type);
					_translator.updateVPAIDExtensions(vpaidExtensions);
					break;
			}
		}
		
		/*
			Property: linearVPAID
			
	    	Indicates the ad’s current linear vs. non-linear mode of operation.
			
			Returns:
				Boolean - Is true when the ad is in linear playback mode, false if it's nonlinear
	    */ 
		public function get linearVPAID() : Boolean {
			return _ad.adLinear;
		}
	    
		/*
			Property: expandedVPAID
			
			Indicates whether the ad is in a state where it
			occupies more UI area than its smallest area. If the ad has multiple expanded states,
			all expanded states show expandedVPAID being true.
			
			Returns:
				Boolean - Returns true when ad is in a state where it occupies more UI area than its smallest area
		 */ 	    
	    public function get expandedVPAID() : Boolean {
			return _ad.adExpanded;
		}
	    
	    /*
			Property: remainingTimeVPAID

	    	The player may use the remainingTimeVPAID property to update player UI during ad
	    	playback. The remainingTimeVPAID property is in seconds and is relative to the time the
	    	property is accessed.

			Returns:
				Number - Remaining time of the VPAID ad in Seconds
	    */ 
	    public function get remainingTimeVPAID() : Number {
			return _ad.adRemainingTime;
		}
	    
	    /*
			Property: volumeVPAID

			The player uses the volumeVPAID property to attempt to set or get the ad volume.
			
			Returns:
				Number - A Number between 0 and 1, where 0 means muted.
	    */
	    public function get volumeVPAID() : Number {
			return _ad.adVolume;
		}

	    /*
			Property: volumeVPAID

			Sets the volume of the VPAID ad.
			
			Parameter:
				Number - A Number between 0 and 1, where 0 means muted.
	    */
	    public function set volumeVPAID(value : Number) : void {
			_ad.adVolume = value;
		}

	    // Methods
	    
	    /*
			Function: handshakeVersion

			The player calls handshakeVersion immediately after loading the ad to indicate to the
			ad that VPAID will be used. The player passes in its latest VPAID version string. The ad
			returns a version string minimally set to “1.0”, and of the form “major.minor.patch”.
			The player must verify that it supports the particular version of VPAID or cancel the ad.

			Parameter: 
				playerVPAIDVersion - The VPAID version string the player is able to speak, given in the form of "major.minor.patch"

			Returns:
				adVPAIDversion - The VPAID version the ad speaks,  given in the form of "major.minor.patch"
	    */
	    public function handshakeVersion(playerVPAIDVersion : String) : String
		{
			try
			{
				adVersion = _ad.handshakeVersion(playerVPAIDVersion);
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: handshakeVersion()");
				
				_translator.error(false);
			}
			
			return adVersion;
		}
	    
	    /*
			Function: initVPAID
	    
			After the ad is loaded and the player calls handshakeVersion, the player calls initVPAID to
			initialize the ad experience. The player may pre-load the ad and delay calling initVPAID
			until nearing the ad playback time, however, the ad does not load its assets until initVPAID
			is called.
			
			Parameters:
				width - Content players width, given as Number
				height - Content players width, given as Number
				viewMode - Content players current view mode, may be one of "normal", "thumbnail" or "fullscreen"
				desiredBitrate - Bitrate in kbps that the ad may use
				creativeData - optional parameter for passing in additional ad initialization data
				environmentVars - optional parameter for passing implementation-specific runtime variables
	    */ 
	    public function initVPAID(width : Number, height : Number, viewMode : String, desiredBitrate : Number, creativeData : String, environmentVars : String) : void {
			try
			{
				_ad.initAd(width , height , viewMode , desiredBitrate , creativeData , environmentVars );
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: initVPAID");

				_translator.error();
			}
		}
		
	    /*
			Function: resizeVPAID
			
			Following a resize of the ad UI container, the player calls resizeVPAID to allow the ad to
			scale or reposition itself within its display area. The width and height always matches
			the maximum display area allotted for the ad, and resizeVPAID is only called when the
			player changes its video content container sizing.
			
			Parameters:
				width - Content players width, given as Number
				height - Content players width, given as Number
				viewMode - "normal", "thumbnail" or "fullscreen"
	    */
	    public function resizeVPAID(width : Number, height : Number, viewMode : String) : void {
			try
			{
				_ad.resizeAd(width , height , viewMode );
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: resizeVPAID()");
			}
		}
	    
	    /*
			Function: startVPAID
			
			Is called by the player and is called when the player wants the ad to start
			displaying.
	    */ 
	    public function startVPAID() : void {
			try
			{
				_ad.startAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: startVPAID()");
				
				_translator.error();
				return;
			}
			
		}
	    
	    /*
			Function: stopVPAID
			
			Is called by the player when it will no longer display the ad. stopVPAID is also
			called if the player needs to cancel an ad.
	    */
		public function stopVPAID() : void {
			try
			{
				_ad.stopAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: stopVPAID()");
				
				_translator.error();
			}
		}   
	    
	    /*
			Function: pauseVPAID
			
			Is called to pause ad playback. 
	    */
	    public function pauseVPAID() : void {
			try
			{
				_ad.pauseAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: pauseVPAID()");
			}
		}
	    
	    /*
			Function: resumeVPAID
			
			Is called to continue ad playback following a call to pauseVPAID.
	    */
	    public function resumeVPAID() : void {
			try
			{
				_ad.resumeAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: resumeVPAID()");
			}
		}
	    
	    /*
			Function: expandVPAID
			
			Is called by the player to request that the ad switch to its larger UI size.
	    */
	    public function expandVPAID() : void {
			try
			{
				_ad.expandAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: expandVPAID()");
			}
		}
	    
	    /*
			Function collapseVPAID
			
			Is called by the player to request that the ad return to its smallest UI size. 
	    */
	    public function collapseVPAID() : void {
			try
			{
				_ad.collapseAd();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_1: collapseVPAID()");
			}
		}
		
		private function startUpRemainingTime():void
		{
			if (_controller._remainingTimer == null) {
				_controller._remainingTimer = new Timer(200);
				_controller._remainingTimer.addEventListener("timer", _remainingTimerHandler);
			}
			_controller._remainingTimer.reset();
			_controller._remainingTimer.start();		
		}
	}
}
