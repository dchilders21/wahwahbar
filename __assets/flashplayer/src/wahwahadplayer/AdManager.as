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
package wahwahadplayer 
{
	import com.eyewonder.instream.core.utility.AdTypes;
	import com.eyewonder.instream.publisherAPI.UIFControl;
	import wahwahadplayer.controls.IPlayerControls;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.events.UIFTrackEvent;
	
	// Global sound
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
    import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	/*
		Class: AdManager

		A basic sequencing class to be extended by publisher that includes some first
		methods for interaction as well.
		
		QuickStart example for displaying a Linear Interactive Instream ad:
		(start example)
			import com.eyewonder.instream.AdManager;
			import flash.display.MovieClip;
			
			//Start by adding a symbol to the stage in your Flash IDE,
			//name its instance "adHolder" - this will be the element/layer
			//where the ad will be placed into.
			
			//create basic config object with an ad call
			var config:Object = {preroll : "http://cdn1.eyewonder.com/200125/754851/1149210/1149210_tag.xml?ewbust=[timestamp]" };
			
			//create a new AdManager instance passing the config object and adHolder
			var adManager:AdManager = new AdManager(config, adHolder);
			
			//Set the dimension of the ad by using the dimension of your players content (video display,..)
			adManager.resize(0, 0, 640, 480);
			
			//start the preroll
			adManager.startAd("preroll");
		(end)
	*/
	public class AdManager extends Sprite
	{
		private var _ewAPI:UIFControl = null;
		private var _root_mc:MovieClip;
		
		private var _canvas:MovieClip;
		private var _config:Object;
		
		private var _adPlayed:Object = { };
		private var _adPaused:Boolean = false;
		
		private var _linearIsActive:Boolean = false;
		private var _overlayIsActive:Boolean = false;
		
		public var _currentAdType:String;
		
		private var _savedCachebuster:Number;
		private var _savedReminderUnit:Array = new Array();
		
		private var _displayDimension:Rectangle;
		
		/*
			Constructor: AdManager
			
			Initializes the AdManager
			
			Parameters:
				config - A config object which holds ad URLs and other configuration properties about the player.
				canvas - This is a reference to the MovieClip where ads will be placed into
		*/
		public function AdManager(config:Object, canvas:MovieClip) 
		{
			//external config, may have been loaded via FlashVars
			_config = config;
			
			//add EyewonderFramework to the canvas
			_canvas = canvas;
			
			_root_mc = new MovieClip();
			_root_mc.name = "uif";
			_canvas.addChild( _root_mc );
			
			// reset the played state for every ad type
			for (var i:Number = 0; i < (AdTypes.ALL_TYPES()).length;i++ )
			{
				_adPlayed[AdTypes.ALL_TYPES()[i]] = false;
			}
		}
	
		/*
			Function: startAd
			
			Starts an ad, also add listeners you can listen on.
		 
			Parameter:
				adType - AdTypes.PREROLL, AdTypes.OVERLAY, AdTypes.MIDROLL, AdTypes.POSTROLL, AdTypes.REMINDERUNIT
				
			Return:
				Boolean - true if the ad could be started
		*/
		public function startAd(adType:String):Boolean
		{
			// Overlays may be played more than once, linears are only started one time
			if ( !isSet( _config[adType] ) || (_adPlayed[adType] == true && adType != AdTypes.OVERLAY))
			{
				return false;
			}
			
			if ((_linearIsActive == true) || (_overlayIsActive == true)) { 
				removeAd();
			}

			_ewAPI = new UIFControl(_root_mc);
			
			//TODO: Change the version number and date of integration.
			_ewAPI.uifConfigControl.version = _config.version;
			_ewAPI.uifConfigControl.integration_date = _config.integration_date;
				
			setConfig();
			
			setCacheBuster();
			
			addAPIlistener();
			
			var adSlotType:String;
			
			switch(adType)
			{
				case AdTypes.PREROLL:
				case AdTypes.MIDROLL:
				case AdTypes.POSTROLL:
					_linearIsActive = true;
					adSlotType = _ewAPI.adControl['AD_SLOT_TYPE_LINEAR'];
					break;
					
				case AdTypes.OVERLAY:
					_overlayIsActive = true;
					adSlotType = _ewAPI.adControl['AD_SLOT_TYPE_NONLINEAR'];
					
					setReminder();
					break;
			}
			
			_adPlayed[adType] = true;
			_currentAdType = adType;
			_adPaused = false;
			
			
			var sXML = _config["adXML"];
			var xml:XML = new XML(sXML);
			
			
			if (_config[adType] != null)
				_ewAPI.adControl.loadDataObj(xml, adSlotType);
			else
				_ewAPI.adControl.loadAdURL(_config[adType], adSlotType);
			
			return true;
		}
		
		/*
			Function: setConfig
			
			Initial Config values are written into the respective controllers here.
			 
			Publisher may want to set other config values here too.
		*/
		private function setConfig():void
		{
			volume = _config.volume;
			
			
			if (_displayDimension == null)
			{
				//set initial dimension of ad container
				_displayDimension = new Rectangle(_ewAPI.uifConfigControl.playerContentX,
												  _ewAPI.uifConfigControl.playerContentY,
												  _ewAPI.uifConfigControl.playerContentWidth,
												  _ewAPI.uifConfigControl.playerContentHeight);
			}
			
			resize(_displayDimension.x, _displayDimension.y, _displayDimension.width, _displayDimension.height);
			
			_ewAPI.uifConfigControl.overlayDelay = 5;
			_ewAPI.uifConfigControl.midrollVideoLength = 100;
			
			_ewAPI.uifConfigControl.countdownEnabled = _config.countdownEnabled;
			
			_ewAPI.uifConfigControl.companionDeliverType = _config.companionDeliverType;
			
			// Hardcode bandwidth to 2000 for now
			_ewAPI.playerControl.bandwidth = 2000;
			
			//TODO: Set the bandwith detection file if you're using Linear VAST ads
			//_ewAPI.uifConfigControl.bwDetectProgressiveURL = _config.bwDetectionFile;
		}
		
		/*
			Function: setCacheBuster
			
			In order to have the same cachebuster number for each ad within _one_ video you may,
			want to save this random number. This function will take care of it.
		*/
		private function setCacheBuster():void
		{
			if (isNaN(_savedCachebuster))
			{
				_savedCachebuster = _ewAPI.adControl.cachebuster.videoCacheBuster;
			}
			
			_ewAPI.adControl.cachebuster.videoCacheBuster = _savedCachebuster;
		}
		
		/*
			Function: setReminder
			
			In order to prevent null object errors we test whether the _savedReminderUnit contains
			something instead of _just_ setting it.
		*/
		private function setReminder():void
		{
			if (_savedReminderUnit.length > 0)
			{
				_ewAPI.adControl.reminder = _savedReminderUnit.shift();
			}
		}
		
		/*
			Function: addAPIlistener
			
			Adds listeners on ad and player event dispatchers
			
			See Also:
				<adEventHandler>
				<adErrorEventHandler>
				<playerEventHandler>
				<trackEventHandler>
			
		*/
		private function addAPIlistener():void
		{
			//adControl
			_ewAPI.adControl.addEventListener(UIFEvent.CONTROL_EVENT, adEventHandler);
			_ewAPI.adControl.addEventListener(UIFEvent.ERROR_EVENT, adErrorEventHandler);
			
			//playerControl
			_ewAPI.playerControl.addEventListener(UIFEvent.CONTROL_EVENT, playerEventHandler);
			
			//trackerControler
			_ewAPI.adControl.trackingControl.addEventListener(UIFEvent.TRACK_EVENT, trackEventHandler);
			
			//vpaidController
			_ewAPI.adControl.vpaid.addEventListener(UIFEvent.VPAID_EVENT, vpaidEventHandler );
		}
		
		/*
			Function: adEventHandler
			
			Events that come from the ad are handled here, publisher should hook up
			player functions here.
		
			Events (sorted on appearance):
				UIFControlEvent.ON_START_REQUEST_AD 		- Prior to requesting the creative (SWF,..)
				UIFControlEvent.ON_START_NONLINEAR			- NonLinear creative is being requested
				UIFControlEvent.ON_START_OVERLAY 			- (Legacy) NonLinear  is being requested
				UIFControlEvent.ON_START_LINEAR 			- Linear creative is being requested
				UIFControlEvent.ON_START_LINEAR_INTERACTIVE	- Linear interactive creative is being requested
				UIFControlEvent.ON_START_FIXEDROLL			- (Legacy) Linear interactive creative is being requested
				UIFControlEvent.ON_START_PLAY_AD			- Creative has initially loaded
				UIFControlEvent.ON_AD_LOAD_COMPLETE			- Creative has finished loading
				UIFControlEvent.AD_INFORMATION_DATA			- Type and subtype of creative can now be accessed
				UIFControlEvent.ON_END_AD					- Creative is being closed
				UIFControlEvent.ON_REMINDER_DETECTED		- Ad XML contains a ReminderUnit
				UIFControlEvent.ON_REMINDER_OVERRIDE		- Current call of NonLinear creative has been replaced with ReminderUnit
		
			Parameter:
				event - The event that was sent by the ad.
		*/
		var adEverStarted = false;
		private function adEventHandler(event:UIFEvent):void
		{
			switch(event.info.type)
			{
				case UIFControlEvent.ON_START_PLAY_AD:
					adEverStarted = true;
					if (_playerControls != null)
					{
						if (volume > 0)
							_playerControls.showMuted(false);
						else
							_playerControls.showMuted(true);
						_playerControls.showPlaying(true);
					}
					break;
				case UIFControlEvent.ON_END_AD:
					_playerControls.showPlaying(false);
					if (adEverStarted == false || errorDetected)
						_playerControls.adError();
					else
						_playerControls.adCompleted();
					onEndAd();
					break;
				case UIFControlEvent.AD_REMAINING_TIME:
					updateCountdown();
					break;
				case UIFControlEvent.ON_REMINDER_DETECTED:
					//save the reminder unit if one has been found
					_savedReminderUnit.push(_ewAPI.adControl.reminder);
					break;
				default:
					trace( "%% Untreated ad event:" + event.info.type );
					break;
			}
		}
		
		/*
			Function: updateCountdown
			
			Called on each playhead-update for linear ad-types,
			allows for updating progress-bar and/or time displays of the player.

			Variables you may want to use here are:
				_ewAPI.adControl.duration - Total time in seconds
				_ewAPI.adControl.remainingTime - Progress time in seconds
		*/
		var last:Number = -1;
		private function updateCountdown():void
		{
			if (_playerControls != null)
			{
				var duration = _ewAPI.adControl.duration;
				var remainingTime = _ewAPI.adControl.remainingTime;
				if (Math.floor(remainingTime*4) != Math.floor(last*4)) // Avoid calling too often
				{
					last = Math.floor(remainingTime);
					_playerControls.updateCountdown(remainingTime, duration);
				}
			}
		}
		
		/*
			Function: adErrorEventHandler
			
			If the adTagURL returned a capped or broken XML this event will be trigered,
			along with this UIFControlEvent.ON_END_AD is also dispatched. Usually you don't
			have to do anything in this function.
			
			Parameter:
				event - Error while loading ad XML
		*/
		var errorDetected: Boolean = false;
		private function adErrorEventHandler(event:UIFEvent):void
		{
			trace("%% [AD-ERROR] - " + event.type );
			errorDetected = true;
		}
		
		/*
			Function: playerEventHandler
			
			Publisher should add calls to methods on their player here.
			The ad will send events for the player's content video to react to.
			For example pause, or play.
			
			Interactive ads may request to hide elements within the player,
			which would otherwise block interactive elements.
			
			Events:
				UIFControlEvent.CONTENT_VID_PAUSE	- Ad requests player to pause the content
				UIFControlEvent.CONTENT_VID_PLAY	- Ad requests player to play the content
				UIFControlEvent.CONTENT_VID_STOP	- Ad requests player to stop the content 
				UIFControlEvent.HIDE_CONTROLS		- Ad requests to hide the players overlay controls, as they might block interactive objects in the ad
				UIFControlEvent.SHOW_CONTROLS		- Ad requests to unhide the elements that have been hidden on HIDE_CONTROLS
				UIFControlEvent.MOUSE_MOVE			- The mouse was moved over the ad, if the controls are not hidden notify the player to show the control bar
													  (this event is only dispatched while a linear ad is playing)
			
			Parameter:
				event - An event on which the publisher may want to hook player methods up to
		*/
		private function playerEventHandler(event:UIFEvent):void
		{
			switch(event.info.type)
			{
				case UIFControlEvent.CONTENT_VID_PLAY:
					// TODO: Add code to tell the player to play/resume the publisher's video
					break;
				case UIFControlEvent.CONTENT_VID_PAUSE:
					// TODO: Add code to tell the player to pause the publisher's video
					break;
				case UIFControlEvent.CONTENT_VID_STOP:
					// Note: This case may be used with future releases. If so...
					// TODO: Add code to tell the player to stop the publisher's video
					break;
				default:
					trace( "%% Untreated player event:" + event.info.type );
					break;
			}
		}
		
		/*
			Function: trackEventHandler

			If you have your own tracking you can hook it up here, events will be
			triggered on almost any events that can happen whithin an ad.
			Referer to UIFTrackEvents to see them all.
		  
			Events:
				UIFTrackEvent.TRACK_LOAD					- Creative is being loaded
				UIFTrackEvent.TRACK_EXPAND					- Creative was expanded
				UIFTrackEvent.TRACK_CONTRACT				- Creative was contracted
				UIFTrackEvent.TRACK_CLOSE					- Creative was closed
				UIFTrackEvent.TRACK_INTERACTION				- Interaction with NonLinear ad (expanded, paused,..)
				UIFTrackEvent.TRACK_CLICKTHRU				- ClickThru was triggered
				UIFTrackEvent.TRACK_START_OF_VIDEO			- Ad video is being started
				UIFTrackEvent.TRACK_FIRST_QUARTILE_OF_VIDEO	- 25% of ad video reached
				UIFTrackEvent.TRACK_MID_OF_VIDEO 			- Midpoint of ad video reached
				UIFTrackEvent.TRACK_THIRD_QUARTILE_OF_VIDEO	- 75% of ad video reached
				UIFTrackEvent.TRACK_END_OF_VIDEO			- End of ad video reached
				UIFTrackEvent.TRACK_GO_INTERACTIVE			- A linear interactive goes into interactive mode
				UIFTrackEvent.TRACK_LEAVE_INTERACTIVE		- A linear interactive leaves interactive mode
				UIFTrackEvent.TRACK_ENTER_FULLSCREEN		- Fullscreen mode entered
				UIFTrackEvent.TRACK_MUTE					- Ad has been muted
		  
			Parameter:
				event - An Event which the publisher may want to track on it's own
		*/
		private function trackEventHandler(event:UIFEvent):void
		{
			switch(event.info.type)
			{
				case UIFTrackEvent.TRACK_LOAD:
					trace("%% [TRACKING] - " + event.info.type );
					break;
				default:
					trace( "%% Untreated track event:" + event.info.type );
					break;
			}
		}
		
		/*
			Function: vpaidEventHandler
			
			Events that come from a VPAID ad can be handled here, the functionality to
			handle such ads is done by the framework itself for version 1.0 and 1.1.
		
			Events
				Please refer to the IAB documentation on the events that are dispatched
				from a VPAID ad. More information can be found here: http://www.iab.net/vpaid
			Parameter:
				event - The event that was sent by the VPAID ad.
		*/
		private function vpaidEventHandler(event:UIFEvent):void
		{
			switch(event.info.type)
			{
				default:
					trace( "%% [VPAID] - " + event.info.type );
					break;
			}
		}
		
		/*
			Function: resize
			Invokes resizing of the ad, this should be done whenever the
			player's content is being resized, for example when changing into
			fullscreen mode.
			The given values are the dimensions of the available content area.
			In most cases its enough to hand in the video display dimensions.

			Parameters:
				x		- X position of the content
				y		- Y position of the content
				width	- Height of the content
				height	- Width of the content
		 */
		public function resize( x:Number, y:Number, width:Number, height:Number ):void
		{
			if (_displayDimension == null)
			{
				_displayDimension = new Rectangle();
			}
			
				_displayDimension.x = x;
				_displayDimension.y = y;
				_displayDimension.width = width;
				_displayDimension.height = height;
			
			if (_ewAPI != null)
			{
				_ewAPI.playerControl.videoScreenRect = _displayDimension;
			}
		}
		
		/*
			Property: volume
			
			When the player volume is being changed the Framework will
			also be informed.
			
			Parameters:
				newVolume - the new volume. A value between 0 and 100.
		*/
		public function set volume( newVolume:Number ):void
		{
			_ewAPI.playerControl.volume = newVolume;
			if (_playerControls != null)
			{
				if (newVolume > 0)
					_playerControls.showMuted(false);
				else
					_playerControls.showMuted(true);
			}
		}
		
		/*
			Property: volume
			
			Returns the current volume that has been set.
		*/	
		public function get volume(  ):Number
		{
			return _ewAPI.playerControl.volume;
		}
		
		/*
			Function: OnEndAd
			
			Ad finished playing, maybe you want to start another ad here.
		*/
		public function onEndAd():void
		{
			_linearIsActive = false;
			_overlayIsActive = false;
			
			_currentAdType = undefined;
			_adPaused = false;
			// Send message to page

		}
		
		/*
			Function: removeAd
			
			Removes an ad, for instance when it sends an UIFControlEvent.ON_END_AD
			you can call this function to remove the listeners.
		*/
		private function removeAd():void
		{
			removeAPIlistener();
			_ewAPI.destroy();
			_ewAPI = null;
		}
		
		/*
			Function: removeAPIlistener
			
			Removes all listeners that have been placed on the sources of events via addAPIlistener
		*/
		private function removeAPIlistener():void
		{
			//adControl
			_ewAPI.adControl.removeEventListener(UIFEvent.CONTROL_EVENT, adEventHandler);
			_ewAPI.adControl.removeEventListener(UIFEvent.ERROR_EVENT, adErrorEventHandler);
			
			//playerControl
			_ewAPI.playerControl.removeEventListener(UIFEvent.CONTROL_EVENT, playerEventHandler);
			
			//trackerControler
			_ewAPI.adControl.trackingControl.removeEventListener(UIFEvent.TRACK_EVENT, trackEventHandler);
		}
		
		/*
			Function: reset
			
			Has to be called when a new content video is being started,
			this is important for players with playlists - as this
			function clears everything and resets the AdManager to
			initial values.
		*/
		private function reset():void
		{
			removeAd();
			
			onEndAd();
			
			for (var i:Number = 0; i < (AdTypes.ALL_TYPES()).length;i++ )
			{
				_adPlayed[AdTypes.ALL_TYPES()[i]] = false;
			}
			
			refreshCacheBuster();
		}
		
		/*
			Function: refreshCacheBuster
			
			Generates a new cachebuster that should be called when every video change.
	
			Ad's should have the same cachebuster number throughout a content video from start to finish
			and change if the user switches the content video.
		*/
		private function refreshCacheBuster():void
		{
			_ewAPI.adControl.cachebuster.randomizeCacheBuster("video", true);
			_savedCachebuster = _ewAPI.adControl.cachebuster.videoCacheBuster;
		}
		
		/*
			Function: isSet
			
			Tests if a string is set.
		 
			Parameter:
				variable - The String to test
				
			Return:
				Boolen - true if the string has been set
		 
		*/
		private function isSet( variable:String ):Boolean
		{
			if ( ( variable != "" ) && ( variable != null ) )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function adPlaying():Boolean
		{
			return !_adPaused;
		}

        public function pauseClick(playerControls:IPlayerControls):void
		{
			if (adPlaying())
			{
				playerControls.showPlaying(false);
				_ewAPI.adControl.pause();
				_adPaused = true;
			}
			
        }
		
		public function playClick(playerControls:IPlayerControls):void
		{
			if (!adPlaying())
			{
				playerControls.showPlaying(true);
				_ewAPI.adControl.play();
				_adPaused = false;
			}
        }
		
		private var _globalSoundIntervalCount:uint = 0;
		private var _globalSoundTimer:Timer = null;
		private var _globalVolume = -1;
		private var _globalSoundPollingMilliseconds = 50;
		private var _maxChangesInPeriod = 3;
		private var _maxChangesPeriodLengthMilliseconds = 15000;
		private var _maxChangesCountMilliseconds = 0;
		private var _maxChangesNumChanges = 0;
		private function _globalSoundIntervalHandler(e:TimerEvent):void 
		{
			if (_globalSoundIntervalCount <= 1)
			{
				debugMessage("Polling audio to make sure ad doesn't change. frequency="+_globalSoundPollingMilliseconds+" count=" + _globalSoundIntervalCount);
				if (_globalSoundIntervalCount == 1)
					debugMessage("Polling will continue, but no more messages until next audio change..."); 
				
				_globalSoundIntervalCount++;
			}
			var currentGlobalVol = SoundMixer.soundTransform.volume;
			if (_globalVolume != currentGlobalVol)
			{
				
				SoundMixer.soundTransform = new SoundTransform(_globalVolume);
				debugMessage("***An ad changed global volume from " + _globalVolume*100 + "% to " + currentGlobalVol*100 + "%. FIXING!");
				_globalSoundIntervalCount = 0;
				_maxChangesNumChanges++;
				debugMessage("*** "+_maxChangesNumChanges+" changes in "+_maxChangesCountMilliseconds+" milliseconds (of "+_maxChangesInPeriod+" changes in "+_maxChangesPeriodLengthMilliseconds+" milliseconds allowed !");
				if (_maxChangesNumChanges > _maxChangesInPeriod)
				{
					debugMessage("Too many changes. Removing ad / loader for good user experience."); 
					_maxChangesNumChanges = _maxChangesCountMilliseconds = 0; // Avoid multiple triggers while exiting
					_globalSoundTimer.stop();
					flash.utils.setTimeout(function ():void { // Try to get remaining qa reporting messages through
						_playerControls.adError();
						onEndAd();
					}, 500);
					debugMessage("Kill ad"); // Try to get remaining qa reporting messages through
				}
			}
			_maxChangesCountMilliseconds+=_globalSoundPollingMilliseconds;
			if (_maxChangesCountMilliseconds >= _maxChangesPeriodLengthMilliseconds)
			{
				_maxChangesNumChanges = _maxChangesCountMilliseconds = 0;
			}
		}
		
		public function globalSound(vol:Number):void
		{
			debugMessage("globalSound("+vol+"%)");
			_globalVolume = vol/100;
			_globalSoundIntervalCount = 0;
			SoundMixer.soundTransform = new SoundTransform(_globalVolume);
			if (_globalSoundTimer == null)
			{
				_globalSoundIntervalCount = 0;
				_globalSoundTimer = new Timer(_globalSoundPollingMilliseconds);
				_globalSoundTimer.addEventListener("timer", _globalSoundIntervalHandler);
				_globalSoundTimer.start();
			}
		}
		public function _clearSoundPollingInterval(): void
		{
			debugMessage("Polling: end audio polling");
			_globalSoundTimer.stop();
			_globalSoundTimer = null;
		}
		public function muteClick(playerControls:IPlayerControls):void
		{
			volume=0;
			debugMessage("*** Global sound set to 0%. Mixer will use this value");
			globalSound(0);
			playerControls.showMuted(true);
        }
		
		public function unMuteClick(playerControls:IPlayerControls):void
		{
			volume=100;
			debugMessage("*** Global sound set to 100%. Mixer will use this value");
			globalSound(100);
			playerControls.showMuted(false);
        }
		
		public function rpClick(playerControls:IPlayerControls):void
		{
			_ewAPI.adControl.seek(0, 0);
			playerControls.showPlaying(true);
			_ewAPI.adControl.play();
        }
		
		var _playerControls:IPlayerControls = null;
		public function setPlayerControls(playerControls:IPlayerControls): void
		{
			_playerControls = playerControls;
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
		public var messageArray: Array = null; // Can be called before _ewAPI is created, and hence startAd
		public function debugMessage(message:Object, prefix:String = "[~ Publisher Debug ~]"):void
		{
			if (messageArray == null)
				messageArray = new Array();
			if (_ewAPI != null && messageArray.length > 0)
			{
				for (var i = 0; i < messageArray.length; i++)
				{
					_ewAPI.debugMessage(1, messageArray[i].message, messageArray[i].prefix);
				}
				messageArray = new Array(); // clear
			}
			if (_ewAPI != null)
				_ewAPI.debugMessage(1, message, prefix);
			else
			{
				var msgObj:Object = new Object;
				msgObj.message = message;
				msgObj.prefix = prefix;
				messageArray.push(msgObj);
			}
		}

	}
}
