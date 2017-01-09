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

package com.eyewonder.instream.core.modules.videoAdModule.VPAID.v_1_0
{
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.utility.Debug;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	import com.eyewonder.instream.core.modules.EWVPAIDExtensions;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDEvent;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDTranslator;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.IVPAIDBase;
	import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAIDController;
	
	/*
		Class: VPAID_1_0

		This class handles communication with v1.0 VPAID ads
	*/
	public class VPAID_1_0 extends MovieClip implements IVPAIDBase
	{
		private var _initVPAIDVersions:Array = ["1.0"];
		
		private var _controller:VPAIDController;
		private var _translator:VPAIDTranslator;
		
		private var _ad:*;
		
		/*
			Constructor: VPAID_1_0
			
			Initializes the VPAID_1_0
			
			Parameters:
				VPAIDController - A reference to an instantiated <VPAIDController>
		*/
		public function VPAID_1_0(controller:VPAIDController):void
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
				var _initVPAIDVersion:String = _ad.initVPAIDVersion("1.0");
				var initVPAIDVersionReturn:Boolean = _checkInitVPAIDVersion(_initVPAIDVersion);
			}
			catch (e:Error)
			{
				return false;
			}
			
			if (initVPAIDVersionReturn)
			{
				result = true;
			}
			
			return result;
		}
		
		public function defineVPAIDEvents():void
		{
			VPAIDEvent.LOADED					= "LOADED";
			VPAIDEvent.STARTED					= "STARTED";
			VPAIDEvent.STOPPED					= "STOPPED";
			VPAIDEvent.LINEAR_CHANGE			= "LINEAR_CHANGE";
			VPAIDEvent.EXPANDED_CHANGE			= "EXPANDED_CHANGE";
			VPAIDEvent.REMAINING_TIME_CHANGE	= "REMAININGTIME_CHANGE";
			VPAIDEvent.IMPRESSION				= "IMPRESSION";
			VPAIDEvent.VIDEO_FIRST_QUARTILE		= "FIRSTQUARTILE";
			VPAIDEvent.VIDEO_MIDPOINT			= "MIDPOINT";
			VPAIDEvent.VIDEO_THIRD_QUARTILE		= "THIRDQUARTILE";
			VPAIDEvent.VIDEO_COMPLETE			= "COMPLETE";
			VPAIDEvent.CLICK_THRU				= "CLICK_THRU";
			VPAIDEvent.USER_ACCEPT_INVITATION	= "ACCEPT_INVITATION";
			VPAIDEvent.PAUSED					= "PAUSED";
			VPAIDEvent.PLAYING					= "PLAYING";
			VPAIDEvent.ERROR					= "ERROR";
			
			//Eyewonder proprietary property
			VPAIDEvent.EW_AD_INFORMATION_DATA = "ew_AdInformationData";
		}

		/*
			Function: _addVPAIDListener
			
			Adds listeners to a VPAID 1.0 ad
		*/
		public function _addVPAIDListener():void
		{
			_ad.addEventListener(VPAIDEvent.LOADED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.STARTED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.STOPPED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.LINEAR_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.EXPANDED_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.REMAINING_TIME_CHANGE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.IMPRESSION, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_MIDPOINT, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_FIRST_QUARTILE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_THIRD_QUARTILE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.VIDEO_COMPLETE, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.CLICK_THRU, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.USER_ACCEPT_INVITATION, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.PAUSED, _vpaidEventHandler);
			_ad.addEventListener(VPAIDEvent.PLAYING, _vpaidEventHandler);
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
			_ad.removeEventListener(VPAIDEvent.IMPRESSION, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_MIDPOINT, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_FIRST_QUARTILE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_THIRD_QUARTILE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.VIDEO_COMPLETE, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.CLICK_THRU, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.USER_ACCEPT_INVITATION, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.PAUSED, _vpaidEventHandler);
			_ad.removeEventListener(VPAIDEvent.PLAYING, _vpaidEventHandler);
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
			Function: _checkInitVPAIDVersion
			
			Compares the version from the VPAID ad with the version-array of this class
			
			Return:
				Boolean - Is true if the version of the ad is found inside the _initVPAIDVersions array
		*/
		private function _checkInitVPAIDVersion(_version:String):Boolean
		{
			for (var i:Object in _initVPAIDVersions)
			{
				if (_version.substring(0,3) == _initVPAIDVersions[i].substring(0,3))
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
			_translator.remainingTime(remainingTimeVPAID);
		}
		
		/*
			Function: _vpaidEventHandler
			
			Events that come from the ad are handled here event type is
			intentionally set as asterisk, reasoning for this is
			if the event comes from a external swf the type is not predictable.
		
			Events:
				VPAIDEvent.LOADED 				- Loading of ad is done
				VPAIDEvent.STARTED				- Ad is displaying
				VPAIDEvent.STOPPED				- Ad has stopped displaying, and ressources have been cleaned up
				VPAIDEvent.LINEAR_CHANGE		- Ad has changed playback mode
				VPAIDEvent.EXPANDED_CHANGE		- Ad expanded state has being changed
				VPAIDEvent.REMAININGTIME_CHANGE	- Remaining time of ad has been changed
				VPAIDEvent.IMPRESSION			- User-visible phase of ad has begun
				VPAIDEvent.FIRSTQUARTILE		- Ad video has reached first quartile
				VPAIDEvent.MIDPOINT				- Ad video has reached it's midpoint
				VPAIDEvent.THIRDQUARTILE		- Ad video has reached third quartile
				VPAIDEvent.COMPLETE				- Ad video has been played completely
				VPAIDEvent.CLICK_THRU			- Click thru occured
				VPAIDEvent.ACCEPT_INVITATION	- Triggered on user ineraction
				VPAIDEvent.PAUSED				- Response to method call
				VPAIDEvent.PLAYING				- Response to method call
				VPAIDEvent.ERROR				- Fatal error occured
		
			Parameter:
				event - The event that was sent by the ad.
		*/
		
		public function _vpaidEventHandler(_evt:*):void 
		{
			if (_evt.type != VPAIDEvent.EXPANDED_CHANGE)
			{
				_translator._debugMessage("In _vpaidEventHandler(): " + _evt.type);
			}
			
			//Forward events
			_translator.dispatchUIFEvent(UIFEvent.VPAID_EVENT, _evt );
			
			var vpaidExtensions:EWVPAIDExtensions = new EWVPAIDExtensions();
			
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
					_translator.resize();
					
					_controller._stopEventGuardTimer();
					_translator.trackStartOfVideo();
					if(vpaidExtensions.adInformationData == null)
					{
						_translator.hideControls();
					}
					startUpRemainingTime();
					break;
				case VPAIDEvent.STOPPED:
					_translator.trackStop();
					_translator.trackClose();
					
					_translator.setVideoState(2);
					
					_controller._endAd();
					break;
				case VPAIDEvent.LINEAR_CHANGE:
					if (linearVPAID)
					{
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
				case VPAIDEvent.IMPRESSION:
					_translator.trackImpression();
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
				case VPAIDEvent.PAUSED:
					_translator.trackPause();
					break;
				case VPAIDEvent.PLAYING:
					_translator.trackPlaying();
					break;
				case VPAIDEvent.ERROR:
					_translator.trackError();
					_controller._endAd();
					break;
				case VPAIDEvent.EW_AD_INFORMATION_DATA: 
					vpaidExtensions.adInformationData = _evt.data as EWVPAIDExtensions;
					_translator.updateVPAIDExtensions(vpaidExtensions);
					break;
			}
		}
		
		/*
			Property: hasQuartileEventsVPAID

		 	The hasQuartileEventsVPAID property is to indicate if the ad supports and will fire IMPRESSION,
			MIDPOINT, etc events.

			Returns:
				Boolean - True if these events are fired, false of none will dispatched.
		 */
		public function get hasQuartileEventsVPAID():Boolean {
			return _ad.hasQuartileEvents;
		}
		
		/*
			Property: closeTimeVPAID

			The closeTimeVPAID property indicates the amount of time between a call to stop and a
			STOPPED event. The closeTimeVPAID property is in seconds and is relative to the time stop is
			called.

			Returns:
				Number - 0 if it closes immediately, -1 if not implemented and -2 if unknown
		 */
		public function get closeTimeVPAID():Number {
			return _ad.closeTime;
		}
		
		/*
			Property: linearVPAID

	    	Indicates the ad’s current linear vs. non-linear mode of operation.

			Returns: 
				Boolean - Is true when the ad is in linear playback mode, false if it's nonlinear
	    */ 
		public function get linearVPAID() : Boolean {
			return _ad.linear;
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
			return _ad.expanded;
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
			return _ad.remainingTime;
		}
	    
	    /*
			Property: volumeVPAID

			The player uses the volumeVPAID property to attempt to set or get the ad volume.

			Returns:
				Number - A Number between 0 and 1, where 0 means muted.
	    */
	    public function get volumeVPAID() : Number {
			return _ad.volume;
		}

		/*
			Property: volumeVPAID

			Sets the volume of the VPAID ad.

			Parameter:
				Number - A Number between 0 and 1, where 0 means muted.
		*/
	    public function set volumeVPAID(value : Number) : void {
			_ad.volume = value;
		}

	    // Methods
	    
	    /*
			Function: initVPAIDversion

	    	The player calls initVPAIDVersion immediately after loading the ad to indicate to the
	    	ad that VPAID will be used. The player passes in its latest VPAID version string. The ad
	    	returns a version string minimally set to “1.0”, and of the form “major.minor.patch”.
	    	The player must verify that it supports the particular version of VPAID or cancel the ad.

			Parameter:
				playerVPAIDVersion - The VPAID version string the player is able to speak, given in the form of "major.minor.patch"

			Returns:
				adVPAIDversion - The VPAID version the ad speaks,  given in the form of "major.minor.patch"
	    */
	    public function initVPAIDVersion(playerVPAIDVersion : String) : String {
			var versionString:String;
			
			try
			{
				versionString = _ad.initVPAIDVersion(playerVPAIDVersion);
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: initVPAIDVersion()");
				
				_translator.error(false);
			}
			
			return versionString;
		}
	    
	    /*
			Function: initVPAID

			After the ad is loaded and the player calls initVPAIDVersion, the player calls initVPAID to
			initialize the ad experience. The player may pre-load the ad and delay calling initVPAID
			until nearing the ad playback time, however, the ad does not load its assets until initVPAID
			is called.

			Parameters:
				width - Content players width, given as Number
				height - Content players height, given as Number
				viewMode - Content players current view mode, may be one of "normal", "thumbnail" or "fullscreen"
				desiredBitrate - Bitrate in kbps that the ad may use
				creativeData - optional parameter for passing in additional ad initialization data
				environmentVars - optional parameter for passing implementation-specific runtime variables
	    */ 
	    public function initVPAID(width : Number, height : Number, viewMode : String, desiredBitrate : Number, creativeData : String, environmentVars : String) : void {
			try
			{
				_ad.init(width , height , viewMode , desiredBitrate , creativeData , environmentVars );
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: initVPAID");

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
				_ad.resize(width , height , viewMode );
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: resizeVPAID()");
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
				_ad.start();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: startVPAID()");
				
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
				_ad.stop();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: stopVPAID()");
				
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
				_ad.pause();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: pauseVPAID()");
			}
		}
	    
	    /*
			Function: resumeVPAID

			Is called to continue ad playback following a call to pauseVPAID.
	    */
	    public function resumeVPAID() : void {
			try
			{
				_ad.resume();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: resumeVPAID()");
			}
		}
	    
	    /*
			Function: expandVPAID

			Is called by the player to request that the ad switch to its larger UI size.
	    */
	    public function expandVPAID() : void {
			try
			{
				_ad.expand();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: expandVPAID()");
			}
		}
	    
	    /*
			Function: collapseAd

			Is called by the player to request that the ad return to its smallest UI size. 
	    */
	    public function collapseVPAID() : void {
			try
			{
				_ad.collapse();
			}
			catch (e:Error)
			{
				_controller._debug.msg(e, "VPAID", "In VPAID_1_0: collapseVPAID()");
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
