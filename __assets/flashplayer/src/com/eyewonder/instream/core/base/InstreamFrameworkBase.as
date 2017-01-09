﻿/*
InstreamFrameworkBase.as

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

EyeWonder instream framework Flash-in-Flash base class
This class is parent to InstreamFramework.as and contains most of the code logic for the Universal Instream Framework. It controls video and
audio state, dispatches events for ad playback, and talks to other major classes of the Univeral Instream Framework.

Do not modify this file directly and instead make changes to com.eyewonder.instream.core.InstreamFramework

*/
package com.eyewonder.instream.core.base {

import com.eyewonder.instream.core.model.staticAd.StaticAdModel;
import com.eyewonder.instream.core.modules.AdCountdown;
import com.eyewonder.instream.core.model.companionAd.CompanionAdModel;
import com.eyewonder.instream.core.modules.videoAdScreenModule.ewVideoAdScreen.EWVideoAdScreenModule;
import com.eyewonder.instream.core.cartridge.base.PublisherCartridgeBase;
import com.eyewonder.instream.core.parser.vast.v1.VAST1Translator;
import com.eyewonder.instream.core.parser.vast.v2.VAST2Translator;
import com.eyewonder.instream.core.utility.RequestQueue;
import com.eyewonder.instream.core.utility.Scale;
import com.eyewonder.instream.core.utility.StringManipulation;
import com.eyewonder.instream.core.modules.videoAdModule.VAST.VASTVideoAdModule;
import com.eyewonder.instream.core.utility.AdTagService;
import com.eyewonder.instream.core.utility.CacheBuster;
import com.eyewonder.instream.core.parser.EWParser;
import com.eyewonder.instream.core.parser.vast.v1.VAST1Parser;
import com.eyewonder.instream.core.parser.vast.v2.VAST2Parser;
import com.eyewonder.instream.core.parser.events.*;
import com.eyewonder.instream.core.parser.ew.*;
import com.eyewonder.instream.core.events.UIFEvent;
import com.eyewonder.instream.core.events.UIFTrackEvent;
import com.eyewonder.instream.core.events.UIFControlEvent;
import com.eyewonder.instream.core.events.UIFEventDispatcher;
import com.eyewonder.instream.core.UIFConfig;
import com.eyewonder.instream.core.debugger.*;
import flash.events.FullScreenEvent;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.geom.Rectangle;
import flash.net.LocalConnection;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.system.Security;
import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import com.eyewonder.instream.core.modules.videoAdModule.VPAID.VPAID;

 public dynamic class InstreamFrameworkBase extends UIFEventDispatcher {

	/* Variables */
	// Version variables
	public static var _APIVersion:String = "3.0.12";
	public static var _preReleaseString:String = "Final";
	public static var _APISupportedTagVersions:Array  = ["3.0.12","3.0.11","3.0.10","3.0.9","3.0","2.9","2.8.2","2.8.1","2.8","2.7","2.5.6","2.5.5","2.5.1","2.5", "2.1","2.0","1.2","1.1"];

	
	// Ad tag variables
	public var _adURL:String;

	public var _adTagRedirectURL:String;
	public var _adTagDataURL:String;
	public var _adTagClickPrepend:String;
	public var _adTagVersion:String;
	public var _adTagInstreamType:String;
	public var _adTagWidth:Number;
	public var _adTagHeight:Number;
	public var _adTagAlignHorizontal:String;
	public var _adTagAlignVertical:String;
	public var _adTagCustomPubData:String;
	// Tag parsing variables
	public var _urlLoader:URLLoader;			// Used by loadAdXML
	public var _urlRequest:URLRequest;			// Used by loadAdXM
	public var _adTagXML:XMLDocument;			// Used by loadAdXML
	// Movieclip variables
	public var _adContainerParent_mc:AdContainerParent;// The ad's movieclip's parent movieclip
	public var _adContainer_mc:MovieClip;		// The ad's movieclip's parent movieclip
	public var _adContainerRect:Rectangle;		// Dimensions of the ad movieclip
	public var _adContainerBackground_mc:MovieClip; //The background to _adContainerParent_mc
	// State variables
	public var _adIsPlaying:Boolean;
	// Timer variables
	public var _timerStep:Number;
	public var _timerID:Number;
	public var _timerCountdown:Number;
	public var _timerPauseCountdown:Number;
	public var _defaultPause:Number;
	// Player info
	public var _playerWidth:Number;
	public var _playerHeight:Number;
	public var _videoRect:Rectangle;
	public var _backgroundRect:Rectangle;
	
	public var _maxPrerollTimer:Number;
	public var _maxInteractionTimerPause:Number;
	public var _overlayLoadDelay:Number;


	// Other variables
	public var _adCleanupCallbacks:Array;
	public var _overlayLoadDelayTimerID:Number;
	// Tracking variables
	public var _loadTrackerCalled:Boolean;	// Prevent multiple calls to trackLoad

	// Debug messages
	public var _debugMessages:Number;	// 0=none, 1=quiet, 2=verbose 3=all
	public var _QAConnection : LocalConnection;

	// Root (for debugging flashvars)
	public var _root_mc:MovieClip;

	// Cartridges (for custom methods and variables)
	public var _vendorCartridge:Object;
	public var _publisherCartridge:PublisherCartridgeBase;

	// Actionscript version (for QA panel or creative to check)
	public var _actionscriptVersion:Number;

	// Fixedroll specific
	public var _adTagDuration:Number;
	public var _adTagImpr3rdParty:String;
	public var _adTagClick3rdParty:String;
	public var _adTagURLCreativeFormat:String;

	// Reminder Unit Constants & Variables
	public static const REMINDER_TYPE_URL:String = "reminderTypeURL";
	public static const REMINDER_TYPE_XML:String = "reminderTypeXML";
	public var _adTagReminderUnit:String;
	public var _reminderUnit:ReminderUnit;
	public var _reminderList:ReminderList;

	// Ad Slot Type Constants & Variables
	public static const AD_SLOT_TYPE_LINEAR:String = "adSlotTypeLinear";
	public static const AD_SLOT_TYPE_NONLINEAR:String = "adSlotTypeNonLinear";
	public var _adSlotType:String;

	//VAST Variables
	public var _vast1Parser:VAST1Parser;  //reference to VAST Parser
	public var _vast2Parser:VAST2Parser;  //reference to VAST Parser
	public var _vastWrapperCalled:Boolean = false;
	public var _adTagService:AdTagService;  //reference to Ad xml
	public var _tagParser:Object;
	public var _onParseComplete:Object;
	public var _ewParser:EWParser;
	public var _adFormat:String;
	public var _cacheBuster:CacheBuster;

	//companion ads
	public var _companionAd:CompanionAdModel;
	
	//static ads
	public var _staticAd:StaticAdModel;
	
	public var _vastModule:String = "as3_module.swf";

	public var _wrapperCount : Number = 0;
	public var _vastAdLoaded:Boolean = false;

	public var _ewVideoScreen:EWVideoAdScreenModule;

	private var _adVolume:Number = -1;

	/*
	 * Publisher provided bandwidth.
	 * If set VAST's bandwidth detect will not run
	 */
	public var _bandwidth:Number;

	public var _eventData:Object;
	public var _adInformationData:Object;
	public var _videoState:Number;

	public var _config:UIFConfig;

	public var adCountdown_mc:AdCountdown;

	
	private var _adAPI:String; //VPAID
	
	private var _scale:Scale;
	
	public function InstreamFrameworkBase(root_mc:MovieClip)
	{
		_debugMessages = 2; // 0=none, 1=quiet, 2=verbose, 3=all

		Security.allowDomain("*");	// We may want to fine-tune this later

		// Initialize QA LC
		_QAConnection = new LocalConnection();
		_QAConnection.addEventListener(StatusEvent.STATUS,OnStatus);

		_loadTrackerCalled = false;

		_root_mc = root_mc;

		_config = new UIFConfig();
		
		_adTagXML = new XMLDocument();

		_urlLoader = new URLLoader();

		_cacheBuster = new CacheBuster(_config);

		_reminderList = new ReminderList();

		_companionAd = new CompanionAdModel();
		
		_eventData = new Object();
		_adInformationData = new Object();

		_adContainerParent_mc = new AdContainerParent(this, this.endAd);
		_adContainerParent_mc.name = "uif_loadercontainer_" + (new Date().getTime());

		_actionscriptVersion = 3;

		_debugMessage(1,"Loading EyeWonder Instream Framework " + _APIVersion + " " + _preReleaseString);
		_debugMessage(1,"Supported tag major versions: " + _APISupportedTagVersions);
		_debugMessage(1,"Actionscript version: " + _actionscriptVersion);

		_root_mc.stage.addEventListener( FullScreenEvent.FULL_SCREEN, onFullScreen );

		// TODO: Add any additional constructor code here */
		customInit();
	}

	public function get config():UIFConfig {
		return _config;
	}

	public function get scale():Scale
	{
		return _scale;
	}
	
	public function OnStatus( event:StatusEvent ):void
	{
		return;
	}


	/*** Player Methods

	The following methods should be modified to call existing player methods

	*/

	public function customInit():void
	{
		_debugMessage(2,"In customInit().");
		// TODO: Add any custom initiation code here
	}

	public function setVideoState(state : Number):void /* 1= stopped, 2= playing, 3=paused */
	{
		_debugMessage(2, "In setVideoState(" + state + ").");

		_videoState = state;

		switch ( state ) {
			case 1:
				dispatchUIFEvent( UIFControlEvent.CONTENT_VID_STOP );

				break;
			case 2:
				dispatchUIFEvent( UIFControlEvent.CONTENT_VID_PLAY );

				break;
			case 3:
				dispatchUIFEvent( UIFControlEvent.CONTENT_VID_PAUSE );

				break;
		}

	}

	public function getVideoState() : Number /* 1= stopped, 2= playing, 3=paused */
	{
		_debugMessage(2,"In getVideoState().");
		// TODO: Add calls to publisher API in subclass com.eyewonder.instream.core.InstreamFramework
		return _videoState;
	}

	public function set audioVolume(vol:Number):void /* 1-100 */
	{
		_debugMessage(2,"In set audioVolume("+vol+").");
		if (vol > 100)
			vol = 100;
		if (vol <= 0) {
			vol = 0;

			if ( (_adFormat == "VAST" || _adFormat == "VAST2") && _adContainer_mc && (_adAPI != "VPAID"))
			{
				//VASTVideoAdModule is not available when we're dealing with a VPAID or static image ad
				if (_adSlotType != AD_SLOT_TYPE_NONLINEAR)
				{
					VASTVideoAdModule(_adContainer_mc).videoAdScreenModule.dispatchEvent( new Event("mute") );
				}
			}
			else
			{
				dispatchUIFEvent( UIFTrackEvent.TRACK_MUTE );
			}
		}
		// TODO: Add calls to publisher API in subclass com.eyewonder.instream.core.InstreamFramework
		_adVolume = vol;
	}

	public function get audioVolume() : Number /* -1,0-100 (-1 means "ignore") */
	{
		_debugMessage(2,"In get audioVolume().");
		// TODO: Add calls to publisher API in subclass com.eyewonder.instream.core.InstreamFramework
		return _adVolume;	// -1 means "ignore" to the ad.
	}
	/* NOTE: setAudioState and getAudioState are deprecated! Use the audioVolume properties instead. */

	public function setAudioState(state : Number):void /* 1=mute, 2=unmuted */
	{
		_debugMessage(2,"In setAudioState("+state+").");
		if (state==1)
			audioVolume = 0;
		if (state==2)
			audioVolume = 100;
		// TODO: Add calls to publisher API in subclass com.eyewonder.instream.core.InstreamFramework
	}

	public function getAudioState() : Number /* 1=mute, 2=unmuted */
	{
		_debugMessage(2,"In getAudioState().");
		if (audioVolume==0)
			return 1;
		else
			return 2;
	}

	/* endAdNotify is deprecated! Handle sOnEndAd event instead! */
	public function endAdNotify() : void
	{
		_debugMessage(2,"In endAdNotify().");
		// TODO: Add calls to publisher API in subclass com.eyewonder.instream.core.InstreamFramework
	}

	/* Convenience methods */
	public function playVideo():void {_debugMessage(2,"In playVideo()."); setVideoState(2);}
	public function pauseVideo():void {_debugMessage(2,"In pauseVideo()."); setVideoState(3);}
	public function get isPaused():Boolean {_debugMessage(2,"In isPaused()."); return (getVideoState() == 3);}
	public function get isPlaying():Boolean {_debugMessage(2,"In isPlaying()."); return (getVideoState() == 2);}
	public function get isStopped():Boolean {_debugMessage(2,"In isStopped()."); return (getVideoState() == 1);}

	/* 1.4 Template Functionality */
	public function onPlayerVideoPause() : void
	{
		_debugMessage(2,"In adVidPause().");
		dispatchUIFEvent(UIFControlEvent.AD_VID_PAUSE);
	}

	public function onPlayerVideoPlay() : void
	{
		_debugMessage(2, "In adVidPlay().");
		dispatchUIFEvent(UIFControlEvent.AD_VID_PLAY);
	}

	public function onPlayerVideoSeek(pos:Number,offS:Number) : void
	{
		_debugMessage(2, "In adVidSeek() - adVidSeekPosition:"+pos+":::adVidSeekOffset:"+offS);
		var tmp_obj:Object = new Object();
		if ((pos != -2) && (pos != -1))
		{
			tmp_obj.adVidSeekPosition = pos * 1000;		// in milliseconds
		}else {
			tmp_obj.adVidSeekPosition = pos;
		}
		tmp_obj.adVidSeekOffset = offS * 1000;

		eventData = tmp_obj;

		dispatchUIFEvent(UIFControlEvent.AD_VID_SEEK);
	}

	public function forward() : void
	{
		_debugMessage(2,"SEEK");
		onPlayerVideoSeek(-2,5);
	}
	public function next() : void
	{
		_debugMessage(2,"SEEK");
		onPlayerVideoSeek(-1,0);
	}

	public function rewind() : void
	{
		_debugMessage(2,"SEEK");
		onPlayerVideoSeek(-2,-5);
	}
	public function prev() : void
	{
		_debugMessage(2,"SEEK");
		onPlayerVideoSeek(0,0);
	}

	public function remainingTime(remaining:Number, total:Number) : void
	{
		//_debugMessage(2, "In remainingTime()");
		var tmp_obj_time:Object = new Object();
		tmp_obj_time.adRemainingTime = remaining;
		tmp_obj_time.adTotalTime = total;

		dispatchUIFEvent(UIFControlEvent.AD_REMAINING_TIME, tmp_obj_time);

		if ( adCountdown_mc ) {
			adCountdown_mc.updateRemainingTimeDisplay( tmp_obj_time );
		}
	}


	public function set eventData(obj:Object):void {
		_eventData = obj;
	}
	public function get eventData() : Object {
		return _eventData;
	}

	public function set adInformationData( value:Object ):void {
			_debugMessage(2, "In adInformationData(" + value +").");

			_adInformationData = new Object();
			_adInformationData = value;

			dispatchUIFEvent( UIFControlEvent.AD_INFORMATION_DATA, value );

		var currentAdType:String    = String(value['type']).toUpperCase();
		var currentAdSubType:String = String(value['subType']).toUpperCase();

		if ( currentAdType == "LINEAR" ) {
			if ( currentAdSubType == "INTERACTIVE" ) { 
				_debugMessage(2, "Linear interactive detected.");
				dispatchUIFEvent( UIFControlEvent.ON_START_LINEAR_INTERACTIVE );
				dispatchUIFEvent( UIFControlEvent.HIDE_CONTROLS );
			}
		}
	}
	public function get adInformationData():Object {
		return _adInformationData;
	}

	public function get adCustomPubData():String {
		return _adTagCustomPubData;
	}
	
	public function getPlayerInformation() : Object
	{
		_debugMessage(2, "In getPlayerInformation().");

		var info:Object = new Object();

		info.videoRect = new Rectangle(config.x,config.y,config.width,config.height);
		info.backgroundRect = new Rectangle(config.x,config.y,config.width,config.height);
		info.backgroundColor = config.backgroundColor;
		info.backgroundAlpha = config.backgroundAlpha;
		info.overlayLoadDelay = config.overlay_delay * 1000;
			
		/* Examples (See Deployment Guide for details):
		 * info.videoRect = new Rectangle(myVideo_mc._x,myVideo_mc._y,myVideo_mc._width,myVideo_mc._height);
		 * info.backgroundRect = new Rectangle(myVideo_mc.x,myVidoe_mc.y,myVideo_mc._width,myVideo_mc._height);
		 * info.backgroundColor=0x000000;
		 * info.backgroundAlpha=1;
		 * info.maxPrerollTimer=15000;
		 * info.maxInteractionTimerPause=3000;
		 * info.overlayLoadDelay=5000;
		 */

		return info;
	}


	/*** Player Tracking Methods

	The following methods should be modified to call existing player methods

	*/

	public function trackExpand() : void
	{
		_debugMessage(2, "In trackExpand().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_EXPAND);
		// This method will be called by the creative advertisement.
	}

	public function trackContract() : void
	{
		_debugMessage(2, "In trackContract().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_CONTRACT);

	}

	public function trackLoad() : void
	{
		_debugMessage(2,"In trackLoad().");
		if (_loadTrackerCalled == true)
			return;
		_loadTrackerCalled = true;
		_debugMessage(2,"trackLoad: First call verified. Tracking.");
		dispatchUIFEvent(UIFTrackEvent.TRACK_LOAD);
		// This method will be called by the creative advertisement.
	}

	public function trackClose() : void
	{
		_debugMessage(2,"In trackClose().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_CLOSE);

	}

	public function trackInteraction() : void
	{
		_debugMessage(2,"In trackInteraction().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_INTERACTION);
		// This method will be called by the creative advertisement.
	}

	public function trackClickthru() : void
	{
		_debugMessage(2,"In trackClickthru().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_CLICKTHRU);

	}

	public function trackStartOfVideo() : void
	{
		_debugMessage(2,"In trackStartOfVideo().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_START_OF_VIDEO);
		// This method will be called by the creative advertisement.
	}

	public function trackFirstQuartileOfVideo() : void
	{
		_debugMessage(2,"In trackFirstQuartileOfVideo().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_FIRST_QUARTILE_OF_VIDEO);
		// This method will be called by the creative advertisement.
	}

	public function trackMidOfVideo() : void
	{
		_debugMessage(2,"In trackMidOfVideo().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_MID_OF_VIDEO);
		// This method will be called by the creative advertisement.
	}

	public function trackThirdQuartileOfVideo() : void
	{
		_debugMessage(2,"In trackThirdQuartileOfVideo().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_THIRD_QUARTILE_OF_VIDEO);
		// This method will be called by the creative advertisement.
	}

	public function trackEndOfVideo() : void
	{
		_debugMessage(2,"In trackEndOfVideo().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_END_OF_VIDEO);
		// This method will be called by the creative advertisement.
	}

	public function trackGoInteractive() : void
	{
		_debugMessage(2,"In trackGoInteractive().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_GO_INTERACTIVE);
		// This method will be called by the creative advertisement and is dispatching an event the player/publisher can lsiten on.
	}

	public function trackLeaveInteractive() : void
	{
		_debugMessage(2,"In trackLeaveInteractive().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_LEAVE_INTERACTIVE);
		// This method will be called by the creative advertisement and is dispatching an event the player/publisher can lsiten on.
	}

	public function trackEnterFullscreen() : void
	{
		_debugMessage(2,"In trackEnterFullscreen().");
		dispatchUIFEvent(UIFTrackEvent.TRACK_ENTER_FULLSCREEN);
	}

	public function beginVideoOnlyFixedroll(creativeFormat:String, adURL:String, adDuration:Number, impr3rdParty:String, click3rdParty:String):void
	{
		_debugMessage(2,"In beginVideoOnlyFixedroll().");

		_debugMessage(2,"Video only pre/mid/postroll not supported!");
		dispatchUIFEvent(UIFEvent.ERROR_EVENT);
	}

	public function insertVendorCartridge(cartridge:Object) : void
	{
		_debugMessage(2,"In insertVendorCartridge(" + cartridge + ")");


		_vendorCartridge = cartridge;

		if (_vendorCartridge.getVendorName() == "EyeWonder")
		{
			if (_root_mc.loaderInfo.parameters._qaReportUUID != undefined)
				Object(_vendorCartridge)._qaReportUUID = _root_mc.loaderInfo.parameters._qaReportUUID;
		}
	}

	/*** Pre-defined methods	*/

	public function registerAdCleanupCallback(callbackFunc : Function) : void
	{
		_debugMessage(2,"In registerAdCleanupCallback("+callbackFunc+").");

		_adCleanupCallbacks[_adCleanupCallbacks.length] = callbackFunc;
	}

	public function getAdMovieClip(mcPos:Rectangle) : MovieClip
	{
		_debugMessage(2,"In getAdMovieClip ( Rectangle[x="+mcPos.x+",y="+mcPos.y+",width="+mcPos.width+",height="+mcPos.height+"]).");

		// Setting dimension on the movieclip prior to loading the movie causes it not to display.
		_adContainerRect = new Rectangle (mcPos.x, mcPos.y, mcPos.width, mcPos.height);
		if(_adContainerBackground_mc == null)
			_adContainerBackground_mc = new MovieClip();

		_adContainerBackground_mc.mouseEnabled = false;
		_root_mc.mouseEnabled = false;

		return _root_mc;
	}

	public function removeAdMovieClip():void
	{
		_debugMessage(2,"In removeAdMovieClip().");
		_unloadSWF();
	}

	public function timerStop() : void
	{
		_debugMessage(2,"In timerStop.");
		if (_timerID != -1)
		{
			_debugMessage(1,"timerStop: Stopping timer.");
			clearInterval(_timerID);
			_timerID = -1;
		}
	}

	public function timerPause(milliseconds:Number) : void
	{
		_debugMessage(2,"In timerPause("+milliseconds+").");
		if (_timerID == -1)
			return;
		_debugMessage(1,"timerPause: Pausing timer.");
		milliseconds = Math.floor(milliseconds);
		if (milliseconds < 1)
			milliseconds = 1;
		_timerPauseCountdown = milliseconds;
	}

	public function timerStart(milliseconds:Number): void
	{
		_debugMessage(2,"In timerStart("+milliseconds+").");
		timerStop();
		_debugMessage(1,"timerStart: Starting timer.");
		milliseconds = Math.floor(milliseconds);
		if (milliseconds < 1)
			milliseconds = 1;
		_timerStep = 500;
		_timerCountdown = milliseconds;
		_timerPauseCountdown = 0;
		_timerID = setInterval(_timerInterval, _timerStep);
	}

	public function timerCountdownCompleted(): void
	{
		_debugMessage(2,"In timerCountdownCompleted().");
		endAd();
	}

	/*** EyeWonder methods

	These methods are defined by EyeWonder and should  be left unmodified

	*/

	// This method can be called by the publisher in order to show messages on the EW debug console at http://cdn.eyewonder.com/100125/QA/Reporting/receiving.html.
	public function pubTrace(msg:Object) : void
	{
			_sendToPanel( "[::Publisher (Instream)::] " + msg );
			trace("[::Publisher (Instream)::] " + msg);
	}

	public function setDebugLevel(level:Number) : void
	{
		if (level != 0)
			_debugMessage(0,"In setDebugLevel("+level+").");

		if (level > 2)
			level = 2;
		if (level < 0)
			level = 0;
		_debugMessages = level;
	}

	public function getAPIVersion():String
	{
		_debugMessage(2,"In getAPIVersion().");
		return _APIVersion;
	}

	public function loadAdCleanup() : void
	{
		_debugMessage(2,"In loadAdCleanup().");
		if (_overlayLoadDelayTimerID != -1)	// It's possible to cause an ad to be requested twice before interval clears out
		{
			clearInterval(_overlayLoadDelayTimerID);
		}

		if (_adIsPlaying)
			endAd();
	}

	public function get reminderListArray():Array {
		return _reminderList.reminderArray;
	}
	
	public function set reminderListArray(arr:Array):void {
		_reminderList.reminderArray = arr;
		_reminderList.numReminders = _reminderList.reminderArray.length;
		_debugMessage(2, "ReminderList array replaced ( " + arr + ").");
	}
	
	public function replaceReminderAdAt(pos:Number, value:Object):void 
	{
		_reminderList.replaceAt(pos, value as ReminderUnit);
		_debugMessage(2, "Reminder Unit replaced ( " + value + ").");
	}

	public function loadReminderAdXML(value:XML):void
	{
		_debugMessage(2, "In loadReminderAdXML().");

		dispatchUIFEvent(UIFControlEvent.ON_REMINDER_OVERRIDE);

		loadAdCleanup();

		_adURL = "";
		_adTagClickPrepend = "";
		_adTagDataURL = "";
		_adTagVersion = "";
		_adTagInstreamType = "";
		_adTagWidth = 0;
		_adTagHeight = 0;
		_adTagAlignHorizontal = "";
		_adTagAlignVertical = "";
		_adTagDuration = 0;
		_adTagImpr3rdParty = "";
		_adTagClick3rdParty = "";
		_adTagURLCreativeFormat = "";
		_adTagReminderUnit = "";

		addEventListener( UIFEvent.ERROR_EVENT, onErrorHandler );

		//Service Class that loads and stores the xml file passed into the loadAdURL method
		//The xml can be access through the _adTagService's adTagData property
		_adTagService = new AdTagService();
		_adTagService.addEventListener(Event.COMPLETE, onAdTagServiceComplete);
		_adTagService.addEventListener(AdTagService.ERROR_LOADING_XML, onXmlError);
		_adTagService.setXMLData(value);
	}

	public function loadAdURL(url : String, adSlotType:String, adFormat:String = "unknown"):void
	{
		_adFormat = adFormat;
		_adSlotType = adSlotType;

		_cacheBuster.randomizeCacheBuster(CacheBuster.AD, true);

		// Check for existing Reminder Units
		if (_adSlotType == AD_SLOT_TYPE_NONLINEAR && _reminderList.numReminders > 0) {
			_debugMessage(2, "Reminder Unit detected, ignoring Nonlinear Ad.");

			var reminderUnit:ReminderUnit = _reminderList.getOldest();
			_debugMessage(2, "Reminder Unit poped (now available: " + _reminderList.numReminders + ").");
			if (reminderUnit.reminderType == REMINDER_TYPE_URL) {
				url = reminderUnit.reminderURL;
				dispatchUIFEvent(UIFControlEvent.ON_REMINDER_OVERRIDE);
			}
			else if(reminderUnit.reminderType == REMINDER_TYPE_XML){
				var reminderAdInLineXML:XML = new XML(reminderUnit.reminderXML);
				var reminderAdXML:XML = new XML(reminderAdInLineXML.children().toString());
				loadReminderAdXML(reminderAdXML);
				return;
			}
			else {
				_debugMessage(2, "Type of Reminder Unit unknown. Continue with Nonlinear Ad.");
			}
		}

		//cache busts the adURL passed to the loadAdURL method
		var cachedURL:String = _cacheBuster.cacheBustURL(url);

		_debugMessage(2,"In loadURL("+cachedURL+").");

		loadAdCleanup();

		_adURL = "";
		_adTagClickPrepend = "";
		_adTagDataURL = "";
		_adTagVersion = "";
		_adTagInstreamType = "";
		_adTagWidth = 0;
		_adTagHeight = 0;
		_adTagAlignHorizontal = "";
		_adTagAlignVertical = "";
		_adTagDuration = 0;
		_adTagImpr3rdParty = "";
		_adTagClick3rdParty = "";
		_adTagURLCreativeFormat = "";
		_adTagReminderUnit = "";

		addEventListener( UIFEvent.ERROR_EVENT, onErrorHandler );
		
		//Service Class that loads and stores the xml file passed into the loadAdURL method
		//The xml can be access through the _adTagService's adTagData property
		_adTagService = new AdTagService();
		_adTagService.addEventListener(Event.COMPLETE, onAdTagServiceComplete);
		_adTagService.addEventListener(AdTagService.ERROR_LOADING_XML, onXmlError);
		_adTagService.loadAdXMLURL(cachedURL);

	}

	public function onErrorHandler( evt:UIFEvent ):void {
		_debugMessage( 2, "In onErrorHandler()" );

		_adIsPlaying = true;
		endAd();
	}
	
	public function onEndAdHandler( evt:UIFEvent ):void {
		listenerCleanup();
	}
	
	public function controlEventDispatcher( evt:UIFEvent ):void {
		dispatchUIFEvent( UIFEvent.CONTROL_EVENT, { type: evt.type, data: evt.info } );
	}

	public function trackEventDispatcher( evt:UIFEvent ):void {
		dispatchUIFEvent( UIFEvent.TRACK_EVENT, { type: evt.type, data: evt.info } );
	}

	public function vastEventDispatcher( evt:UIFEvent ):void {
		dispatchUIFEvent( UIFEvent.VAST_EVENT, { type: evt.type, data: evt.info } );
	}

	public function attachControlListeners():void {
		addEventListener( UIFControlEvent.AD_REMAINING_TIME, controlEventDispatcher );
		addEventListener( UIFControlEvent.AD_INFORMATION_DATA, controlEventDispatcher );
		addEventListener( UIFControlEvent.AD_VID_PAUSE, controlEventDispatcher );
		addEventListener( UIFControlEvent.AD_VID_PLAY, controlEventDispatcher );
		addEventListener( UIFControlEvent.AD_VID_SEEK, controlEventDispatcher );
		addEventListener( UIFControlEvent.AD_VOLUME_CHANGED, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_AD_LOAD_COMPLETE, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_END_AD, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_REMINDER_OVERRIDE, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_REMINDER_DETECTED, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_RESIZE_NOTIFY, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_FIXEDROLL, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_NONLINEAR, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_LINEAR, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_LINEAR_INTERACTIVE, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_OVERLAY, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_PLAY_AD, controlEventDispatcher );
		addEventListener( UIFControlEvent.ON_START_REQUEST_AD, controlEventDispatcher );
		addEventListener( UIFControlEvent.RESIZE_NOTIFY, controlEventDispatcher );
		addEventListener( UIFControlEvent.SHOW_CONTROLS, controlEventDispatcher );
		addEventListener( UIFControlEvent.HIDE_CONTROLS, controlEventDispatcher );
		addEventListener( UIFControlEvent.CONTENT_VID_PAUSE, controlEventDispatcher );
		addEventListener( UIFControlEvent.CONTENT_VID_PLAY, controlEventDispatcher );
		addEventListener( UIFControlEvent.CONTENT_VID_STOP, controlEventDispatcher );
	}

	public function attachTrackingListeners():void {
		addEventListener( UIFTrackEvent.TRACK_CLICKTHRU, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_CLOSE, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_CONTRACT, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_END_OF_VIDEO, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_EXPAND, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_FIRST_QUARTILE_OF_VIDEO, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_INTERACTION, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_LOAD, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_MID_OF_VIDEO, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_START_OF_VIDEO, trackEventDispatcher );
		addEventListener( UIFTrackEvent.TRACK_THIRD_QUARTILE_OF_VIDEO, trackEventDispatcher );
	}

	public function attachVastListeners():void {

	}

	public function loadDataObj(value:XML, adSlotType:String, adFormat:String):void
	{
		_adSlotType = adSlotType;
		
		_adFormat = adFormat;

		_adTagService = new AdTagService();
		_adTagService.addEventListener(Event.COMPLETE, onAdTagServiceComplete);
		_adTagService.addEventListener(AdTagService.ERROR_LOADING_XML, onXmlError);
		_adTagService.setXMLData(value);
	}

	//deprecated use loadAdURL
	public function loadAdXML(url:String, adSlotType:String) : void
	{
		loadAdURL(url, adSlotType);
	}

	public function endAd() : void
	{
		_debugMessage(2, "In endAd().");
		
		_wrapperCount = 0;
		_vastWrapperCalled = false;
		
		try {
			_root_mc.removeChild( adCountdown_mc );
		} catch ( e:Error ) { };
		
		if ( !hasEventListener( UIFControlEvent.ON_END_AD ) )
		{
			_debugMessage( 3, "endAd: an error happened before the ad started playing." );
			// ad loading failed at some point, before we could add the event listeners
			attachControlListeners();
			attachTrackingListeners();
		}		
		
		if (!_adIsPlaying)
			return;
			
		_debugMessage(1,"endAd: Killing ad.");
		_adIsPlaying = false;
		timerStop();
		removeAdMovieClip();	// Hide the ad's movie clip
		
		try {	// Protect against bad external code
			if (_adCleanupCallbacks != null)
			{
				for (var i:Number = 0; i < _adCleanupCallbacks.length; i++)
				{
						_adCleanupCallbacks[i]();
				}
			}
			endAdNotify();	// Allow publisher to handle endAd event
		} catch (e:Error){
			_debugMessage(2,"endAd: error caused by 3rd party code ignored.");
		}
		_loadTrackerCalled = false;

		try {
			clearInterval( _overlayLoadDelayTimerID );
		} catch ( e:Error ) {
			_debugMessage(2, "endAd: _overlayLoadDelayTimerID clear failed." );
		}
		
		dispatchUIFEvent(UIFControlEvent.SHOW_CONTROLS);
		dispatchUIFEvent(UIFControlEvent.ON_END_AD);
		
		UIFSendToPanel.getInstance().destroy();
		
		_adAPI = "";
		_adFormat = "unknown";
		_adInformationData = new Object();
	}

	public function timerReset(): void
	{
		_debugMessage(2,"In timerReset().");
		timerStart(_maxPrerollTimer);
	}

	public function handleInteraction(): void
	{
		_debugMessage(2,"In handleInteraction().");
		timerPause(_maxInteractionTimerPause);
	}

	public function handleInteractiveModeStart():void {
		_debugMessage(2, "In handleInteractiveModeStart().");
		// This method will be called by the creative advertisement.
	}

	public function handleInteractiveModeEnd():void {
		_debugMessage(2, "In handleInteractiveModeEnd().");
		// This method will be called by the creative advertisement.
	}

	public function handleExpand():void {
		_debugMessage(2, "In handleExpand().");
		// This method will be called by the creative advertisement.
	}

	public function handleContract():void {
		_debugMessage(2, "In handleContract().");
		// This method will be called by the creative advertisement.
	}

	public function reportInteraction(): void	// Legacy: Do not call
	{
		handleInteraction();
	}

	/* public helper functions */
	public function resizeNotify():void
	{
		_debugMessage(2, "In resizeNotify().");
		
		drawBackground();
		
		switch(_adFormat)
		{
			case "VAST":
			case "VAST2":
				if (_adAPI == "VPAID")
				{
					if (_config.enforceVPAIDScaling)
					{
						//this is being done for ads which don't scale like they should
						scaleVPAID();
					}
					else
					{
						if (_config.scaleVAST)
						{
							//VPAID ads scale themselves, they just need an event
							dispatchUIFEvent(UIFControlEvent.ON_RESIZE_NOTIFY);
						}
						else
						{
							//position the VPAID, don't scale
							_adTagWidth = _adContainer_mc.translator.vpaidWidth;
							_adTagHeight = _adContainer_mc.translator.vpaidHeight;
							_adTagAlignHorizontal = _config.vpaidHAlign;
							_adTagAlignVertical = _config.vpaidVAlign;
						
							_scale = new Scale(this);
							_scale.positionVPAID();
						}
					}
				}
				else
		{
					scaleVAST();
		}
				break;

			case "EW":
				if (_adContainerParent_mc)
				{
					_scale = new Scale(this);
					_scale.fitScreen();
		}
				break;
	}

		//resize countdown
		if ( adCountdown_mc )
	{
		var playerInfo:Object = getPlayerInformation();
			adCountdown_mc.resize( playerInfo );
		}
		}

	private function scaleVPAID():void
		{
		var _vastTranslator:Object;

		_adTagAlignHorizontal = "center";
		_adTagAlignVertical = "middle";

		switch(_adFormat)
			{
			case "VAST":
				_vastTranslator = new VAST1Translator(_vast1Parser);
				break;
			case "VAST2":
				_vastTranslator = new VAST2Translator(_vast2Parser);
				break;
			}

		switch(_adSlotType)
		{
			case AD_SLOT_TYPE_LINEAR:
				_adTagWidth  = _vastTranslator.mediafileArray[0].width;
				_adTagHeight = _vastTranslator.mediafileArray[0].height;
				break;

			default:
				_adTagAlignHorizontal = "center";
				_adTagAlignVertical = "bottom";

				_adTagWidth  = _vastTranslator.nonlinearArray[0].width;

				if (isNaN(_vastTranslator.nonlinearArray[0].expandedHeight) || (_vastTranslator.nonlinearArray[0].expandedHeight == 0))
			{
					//no expanded height given, so we take normal height
					_adTagHeight = Number(_vastTranslator.nonlinearArray[0].height);
			}
			else
			{
					//expanded height is given
					_adTagHeight = Number(_vastTranslator.nonlinearArray[0].expandedHeight);
				}
				break;
			}

		_scale = new Scale(this);
		_scale.fitScreen();
			}
	
	private function scaleVAST():void
			{
		switch(_adSlotType)
			{
			case AD_SLOT_TYPE_LINEAR:

				if (_ewVideoScreen && _ewVideoScreen._videoPlayer)
				{
					_adTagAlignHorizontal = "center";
					_adTagAlignVertical = "middle";

					_adTagWidth = _ewVideoScreen.getWidth();
					_adTagHeight = _ewVideoScreen.getHeight();
					
					_scale = new Scale(this);
					_scale.fitScreen();
				}
				break;

			case AD_SLOT_TYPE_NONLINEAR:
				//make sure it's actually there
				//it could have been either removed because it's too big or is still in it's delay
				if (_staticAd)
				{
				//there is no alignment specified in the XML, therefore we set the default position
				_adTagAlignHorizontal = "center";
				_adTagAlignVertical = "bottom";

				_scale = new Scale(this);
				_scale.fitHeightInPercent(21);
				}
				break;
		}
	}

	public function _loadAdXMLError(event:IOErrorEvent):void
	{
		_debugMessage(2,"_loadAdXMLError: Invalid HTTP Request");
		dispatchUIFEvent(UIFEvent.ERROR_EVENT);
	}
	
	//Deprecated methods
	public function _loadAdXMLHandler(event:Event):void
	{
		_debugMessage(2,"In _loadAdXMLHandler().");

		_urlLoader.removeEventListener(Event.COMPLETE, _loadAdXMLHandler);

		try {
			_adTagXML = new XMLDocument(_urlLoader.data);
		} catch (e:Error){
			_debugMessage(2,"_loadAdXMLHandler: Malformed XML data.");
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			return;
		}


			// Allow comments and other XML nodes prior to instreamAd element
			var i:Number;
			for( i = 0; i < _adTagXML.childNodes.length; i++)	// Find instreamAd element
			{
				if ( _adTagXML.childNodes[i].nodeName == "instreamAd" || _adTagXML.childNodes[i].nodeName == "ewAd" /* legacy: use instreamAd instead on new tags */)
					break;
			}

			if (i >= _adTagXML.childNodes.length)
			{
				_debugMessage(2,"_loadAdXMLHandler: Expected parent element not found.");
				dispatchUIFEvent(UIFControlEvent.ON_END_AD);
				return;
			}

			var itr:XMLNode = _adTagXML.childNodes[i];

			for( i = 0; i < itr.childNodes.length; i++)
			{
			    var currentTag:XMLNode = itr.childNodes[i];
				if (currentTag.childNodes.length > 0)
				{
					var currentValue:String = currentTag.childNodes[0].nodeValue;
					if (currentTag.nodeName == "adURL")
					{
						_adURL = currentValue;
					}
					else if (currentTag.nodeName == "adClickPrepend")
					{
						_adTagClickPrepend = currentValue;
						/* Temporarily disabling below into a solution is found to Flash's complaints */
						_adTagClickPrepend = StringManipulation.strnreplace(_adTagClickPrepend, "[clickthru]", "", 1);
						_adTagClickPrepend = StringManipulation.strnreplace(_adTagClickPrepend, "[ewclickthru]", "", 1); // legacy
					}
					else if (currentTag.nodeName == "dataURL")
					{
						_adTagDataURL = currentValue;
					}
					else if(currentTag.nodeName == "redirectURL")
					{
						_adTagRedirectURL = currentValue;
					}
					else if (currentTag.nodeName == "adTagVersion")
					{
						_adTagVersion = currentValue;
					}
					else if (currentTag.nodeName == "adWidth")
					{
						_adTagWidth = parseInt(currentValue);
					}
					else if (currentTag.nodeName == "adHeight")
					{
						_adTagHeight = parseInt(currentValue);
					}
					else if (currentTag.nodeName == "adInstreamType")
					{
						_adTagInstreamType = currentValue;
					}
					else if (currentTag.nodeName == "adAlignHorizontal")
					{
						_adTagAlignHorizontal = currentValue;
					}
					else if (currentTag.nodeName == "adAlignVertical")
					{
						_adTagAlignVertical = currentValue;
					}
					else if (currentTag.nodeName == "adDuration")
					{
						_adTagDuration = parseInt(currentValue);
					}
					else if (currentTag.nodeName == "adImpr3rdParty")
					{
						_adTagImpr3rdParty = currentValue;
					}
					else if (currentTag.nodeName == "adClick3rdParty")
					{
						_adTagClick3rdParty = currentValue;
					}
					else if (currentTag.nodeName == "adURLCreativeFormat")
					{
						_adTagURLCreativeFormat = currentValue;
					}
					else if (currentTag.nodeName == "adComment")
					{
						_debugMessage(2,"Ad Comment: "+ currentValue);
					}
					else if (currentTag.nodeName == "reminderAdURL")
					{
						_adTagReminderUnit = currentValue;
					}
					else if (currentTag.nodeName == "reminderAdInLine")
					{
						_adTagReminderUnit = currentValue;
					}
				}
			}

			if(_adURL == "redirect")
			{
				_debugMessage(1,"In _loadAdXMLHandler:  EW Redirect" );
				var redirectURL:String = _adTagRedirectURL;

				loadAdURL(redirectURL, _adSlotType);
				return;
			}

			_debugMessage(1,"_loadAdXMLHandler final values: _adURL=" + _adURL + " _adTagClickPrepend=" + _adTagClickPrepend + " _adTagVersion=" + _adTagVersion +
						  " _adTagDataURL=" + _adTagDataURL + " _adTagInstreamType=" + _adTagInstreamType + " _adTagAlignHorizontal=" + _adTagAlignHorizontal
						  + " _adTagAlignVertical=" + _adTagAlignVertical + " _adTagWidth=" + _adTagWidth + " _adTagHeight=" + _adTagHeight);

			_setupAd();


	}

	public function onAdTagServiceComplete(e:Event):void
	{
        	_onParseComplete = null; // Set member function reference _onParseComplete

			// Note: Future – abstract this out so 3rd parties can add additional parsers without either modifying UIF or bypassing loadAdXML
            	if(_adFormat == "EW" || _adFormat =="unknown")
            	{
            		if(String(_adTagService.adTagData.adURL) == "redirect")
            		{
            			var newURL:String = String(_adTagService.adTagData.redirectURL);

            			loadAdURL(newURL, _adSlotType);
            			return;
            		}

                    _tagParser = _ewParser = new EWParser();
                    if(_tagParser.checkFormat(XML(_adTagService.adTagData)))
                    {
                    	_adFormat = "EW";  // Set if unknown
                    	_onParseComplete = onEWParseComplete;
                    }
                }

                if ((_adFormat == "VAST" || _adFormat == "VAST2") || _adFormat =="unknown")
                {
			if (!_vastWrapperCalled)
			{
				_tagParser = _vast1Parser = new VAST1Parser();
			} 

			if (_vastWrapperCalled && _adFormat == "unknown") 
			{
				_tagParser = _vast1Parser;
			}

			if (!_tagParser)
			{
				_tagParser = _vast1Parser = new VAST1Parser();
			}

     				if(_tagParser.checkFormat(XML(_adTagService.adTagData)))
                    {
                    	_adFormat = "VAST"; // Set if unknown
                    	_onParseComplete = onVASTParseComplete;
                    }
					else 
					{
				if (!_vastWrapperCalled)
				{
					_tagParser = _vast2Parser = new VAST2Parser();
				}
					
				if (_vastWrapperCalled && _adFormat == "unknown")
				{
					_tagParser = _vast2Parser;
				}

				if (!_tagParser) 
				{
					_tagParser = _vast2Parser = new VAST2Parser();
				}
						
		     			if(_tagParser.checkFormat(XML(_adTagService.adTagData)))
		                {
		                _adFormat = "VAST2"; // Set if unknown
		                _onParseComplete = onVASTParseComplete;
		                }
						else 
						{
								// VideoAdServingTemplate not found in root node, rejecting
								dispatchUIFEvent( UIFEvent.ERROR_EVENT );
								return;
						}
					}
                }

                if (_adFormat == "unknown" || _onParseComplete == null)
                {
					_debugMessage(1," onAdTagServiceComplete: Unable to detect ad format. Dispatching sOnError");

                    dispatchUIFEvent(UIFEvent.ERROR_EVENT);
                    return;
                }

                if(_adFormat != "VAST" && _adFormat != "VAST2" && _adFormat != "EW")
                {
					_debugMessage(1," onAdTagServiceComplete: Unknown ad format indicated. Dispatching sOnError");

                    dispatchUIFEvent(UIFEvent.ERROR_EVENT);
                    return;
                }

                _tagParser.addEventListener(ParserErrorEvent.XML_ERROR, onXmlError);
				_tagParser.addEventListener(ParserEvent.XML_PARSED, _onParseComplete);

				_tagParser.addEventListener(ParserEvent.XML_COMPANION_DETECTED, startCompanionAd);
				
				UIFDebugMessage.getInstance().setDebugLevel(_debugMessages);
				customPublisherTagHandler();
				_tagParser.parse(_adTagService.adTagData);

				//check if it's vapid
				checkForVPAID();
				
				return;
	}

	/*
	 * It's neccessary to know wether the ad is a vpaid or not for resizing, and other
	 * important things.
	 * Non-Linear VPAID ads tend to disappear while resizing in their "overlay delay",
	 * when _adAPI remains unset.
	 */
	private function checkForVPAID():void
	{
		_adAPI  = null;

		//decide on which translator will be needed
		var _vastTranslator:Object = new Object();
		switch (_adFormat)
		{
			case "VAST":
				_vastTranslator = new VAST1Translator(_vast1Parser);
				break;
			case "VAST2":
				_vastTranslator = new VAST2Translator(_vast2Parser);
				break;
		}
		
		//fetch the information
		if ((_adFormat == "VAST") || (_adFormat == "VAST2"))
		{
			if (_adSlotType == AD_SLOT_TYPE_NONLINEAR)
			{
				_adAPI = _vastTranslator.nonlinearArray[0].apiFramework;
			}
			else
			{
				_adAPI = _vastTranslator.mediafileArray[0].apiFramework;
			}
		}

		//sanitize, the following tests if it's set to null
		//so we set it null, when it's empty
		if (_adAPI == "")
		{
			_adAPI = null;
		}
	}

	public function onVASTParseComplete(e:Event):void
	{
		if(_tagParser.isVASTXMLWRAPPER && !_vastWrapperCalled)
		{
			_vastWrapperCalled = true;
			if(_wrapperCount > 10)
			{
				_debugMessage(2,"More than 10 wrappers called, breaking loop. Dispatching sOnError");
				dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				return;
			}

			_wrapperCount ++;
			_tagParser.addEventListener(VAST2Parser.TOGGLE_VAST_WRAPPER_CALLED, onToggleVastWrapperCalled);
			var vastTag:String = String(_tagParser.VASTAdTagURL);

			loadAdURL(vastTag, _adSlotType);
		}
		else
		{
			_adURL = "VAST";
			
			//TODO VAST parser does not yet send an event that it detected a companionAd therefore we fake this
			//TODO When VAST parser sends "ParserEvent.XML_COMPANION_DETECTED", this call can be removed
			startCompanionAd(new ParserEvent(ParserEvent.XML_COMPANION_DETECTED));
			
			_setupAd();
		}
	}

	public function onToggleVastWrapperCalled(e:Event):void
	{

		_vastWrapperCalled = false;
		_vast1Parser.removeEventListener(VAST1Parser.TOGGLE_VAST_WRAPPER_CALLED, onToggleVastWrapperCalled);
	}

	//called when companionAd is detected
	private function startCompanionAd(e:ParserEvent):void
	{
		//Parser is done, we remove the listener on it
		_tagParser.removeEventListener(ParserEvent.XML_COMPANION_DETECTED, startCompanionAd);
		
		//hand over companion xml node
		switch(_adFormat)
		{
			case "VAST":
				_companionAd.companionXML = _vast1Parser.mainXML.Ad.InLine.CompanionAds;
				break;
			case "VAST2":
				if (_vast2Parser.companionXML != null)
					_companionAd.companionXML = _vast2Parser.companionXML;
				break;
			case "EW":
				_companionAd.companionXML = new XMLList(_ewParser.adTagCompanionAdXML);
				break;
		}
			
			//invoke delivering to page
			_companionAd.deliver();
	}
	
	public function onEWParseComplete(e:Event):void
	{
			setEWVariables();
	}

	public function onXmlError(e:Event):void
	{
		_debugMessage(2, "onXmlError: Malformed XML data. Dispatching sOnError");
		dispatchUIFEvent(UIFEvent.ERROR_EVENT);
	}

	public function customPublisherTagHandler():void
	{
		_debugMessage(2,"In customPublisherTagHandler().");
		// Convenience references
		var format:String = _adFormat;
		var tagData:XML = _adTagService.adTagData;

		return;
	}

	public function setEWVariables():void
	{
		_adURL = String(_ewParser.adURL);
		_adTagDataURL = String(_ewParser.adTagDataURL);
		_adTagClickPrepend = String(_ewParser.adTagClickPrepend);
		_adTagVersion = String(_ewParser.adTagVersion);
		_adTagInstreamType = String(_ewParser.adTagInstreamType);
		_adTagWidth = Number(_ewParser.adTagWidth);
		_adTagHeight = Number(_ewParser.adTagHeight);
		_adTagAlignHorizontal = String(_ewParser.adTagAlignHorizontal);
		_adTagAlignVertical = String(_ewParser.adTagAlignVertical);

		// Fixedroll specific
		_adTagDuration = Number(_ewParser.adTagDuration);
		_adTagImpr3rdParty = String(_ewParser.adTagImpr3rdParty);
		_adTagClick3rdParty = String(_ewParser.adTagClick3rdParty);
		_adTagURLCreativeFormat = String(_ewParser.adTagURLCreativeFormat);

		// Reminder Unit specific
		_adTagReminderUnit = String(_ewParser.adTagReminderUnit);
		
		_adTagCustomPubData = String(_ewParser.adTagCustomPubData);

		_setupAd();
	}

	// A common method for any tag format
	public function _setupAd():void
	{
		_debugMessage(2,"In _setupAd().");

		dispatchUIFEvent( UIFControlEvent.ON_AD_FORMAT_DETECTED );
		
		_adContainerParent_mc = null;
		_adContainerParent_mc = new AdContainerParent(this, this.endAd);
		_adContainerParent_mc.name = "uif_loadercontainer_" + (new Date().getTime());

		if (_adFormat == "EW" && (_adURL == "" || _adURL == "frequency_capped" || _adURL == "ew_capped"))	// Frequency capped tag, end ad
		{
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			return;
		}

		if (_adFormat == "EW" && !_verifyAdTag())
		{
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			return;
		}
		
		// reset, then add all relevant listeners
		listenerCleanup();
		attachControlListeners();
		attachTrackingListeners();
		
		addEventListener( UIFControlEvent.ON_END_AD, onEndAdHandler );
		addEventListener( UIFControlEvent.ON_START_LINEAR, onStartLinearHandler );
		
		// Reminder Unit
		// Note: _adTagReminderUnit becomes "null" if the corresponding XML-Node doesn't exist
		// Note: _adTagReminderUnit can be the a reminderAdURL and reminderAdXML
		if (_adTagReminderUnit != "null" && _adTagReminderUnit != "" && _adTagInstreamType == "fixedroll")
		{
			_reminderUnit = new ReminderUnit();
			if (_adTagReminderUnit.indexOf("reminderAdInLine", 0) == -1) {
				_reminderUnit.reminderType = REMINDER_TYPE_URL;
				_reminderUnit.reminderURL = _adTagReminderUnit;
				_reminderUnit.reminderXML = "";
			}
			else {
				_reminderUnit.reminderType = REMINDER_TYPE_XML;
				_reminderUnit.reminderURL = "";
				_reminderUnit.reminderXML = _adTagReminderUnit;
			}
			// as long as no multiple reminders are used with multiple fixedrolls, always replace item 0, otherwise use _reminderList.add(_reminderUnit) instead
			_reminderList.replaceAt(0, _reminderUnit);
			
			dispatchUIFEvent( UIFControlEvent.ON_REMINDER_DETECTED );
			
		}

		var playerInfo:Object = getPlayerInformation();

		_playerHeight = _root_mc.stage.height;
		_playerWidth = _root_mc.stage.width;
		_videoRect = new Rectangle(0,0,_root_mc.stage.width,_root_mc.stage.height);
		_backgroundRect = new Rectangle(0, 0, _root_mc.stage.width, _root_mc.stage.height);
		_maxPrerollTimer = 15000;
		_maxInteractionTimerPause = 120000;
		_overlayLoadDelay = 5000;
		if (typeof(playerInfo) != "undefined" && playerInfo != null)
		{
			if (typeof(playerInfo["videoRect"]) != "undefined" && playerInfo["videoRect"] != null)
				_videoRect = playerInfo["videoRect"];
			if (typeof(playerInfo.backgroundRect) != "undefined" && playerInfo.backgroundRect != null)
				_backgroundRect = playerInfo.backgroundRect;
			else if(typeof(playerInfo.videoRect) != "undefined" && playerInfo.videoRect != null)
				_backgroundRect = _videoRect;
			if (typeof(playerInfo["maxPrerollTimer"]) != "undefined" && playerInfo["maxPrerollTimer"] != null)
				_maxPrerollTimer = playerInfo["maxPrerollTimer"];
			if (typeof(playerInfo["maxInteractionTimerPause"]) != "undefined" && playerInfo["maxInteractionTimerPause"] != null)
				_maxInteractionTimerPause = playerInfo["maxInteractionTimerPause"];
			if (typeof(playerInfo["overlayLoadDelay"]) != "undefined" && playerInfo["overlayLoadDelay"] != null)
				_overlayLoadDelay = playerInfo["overlayLoadDelay"];

			var outString:String = "";
			if (typeof(playerInfo["videoRect"]) != "undefined" && playerInfo["videoRect"] != null)
				outString += "getPlayerInformation returned ( videoRect = Rectangle[x="+playerInfo["videoRect"].x+",y="+
					playerInfo["videoRect"].y+",width="+playerInfo["videoRect"].width+",height="+playerInfo["videoRect"].height+"],";
			if (typeof(playerInfo["maxPrerollTimer"]) != "undefined" && playerInfo["maxPrerollTimer"] != null)
				outString += " maxPrerollTimer="+playerInfo["maxPrerollTimer"];
			if (typeof(playerInfo["maxInteractionTimerPause"]) != "undefined" && playerInfo["maxInteractionTimerPause"] != null)
				outString += " maxInteractionTimerPause="+playerInfo["maxInteractionTimerPause"];
			if (typeof(playerInfo["overlayLoadDelay"]) != "undefined" && playerInfo["overlayLoadDelay"] != null)
				outString += " overlayLoadDelay="+playerInfo["overlayLoadDelay"];


			_debugMessage(1,outString + ").");

		}
		else
		{
			_debugMessage(1,"getPlayerInformation returned undefined.");
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
		}

		

		var positionRect:Rectangle = new Rectangle(config.x, config.y, config.width, config.height);//alignAd(_videoRect);

		_debugMessage(1,"_setupAd final values: _playerHeight=" + _playerHeight + " _playerWidth=" + _playerWidth + " positionRect=Rectangle[x=" + positionRect.x + ",y=" + positionRect.y + ",width=" + positionRect.width + ",height=" + positionRect.height + "] _maxPrerollTimer=" + _maxPrerollTimer+ " _maxInteractionTimerPause=" + _maxInteractionTimerPause + " _overlayLoadDelay=" + _overlayLoadDelay);
		getAdMovieClip(positionRect).addChild(_adContainerBackground_mc);
		getAdMovieClip(positionRect).addChild(_adContainerParent_mc);
		drawBackground();
		_adContainerBackground_mc.visible = false;

		dispatchUIFEvent(UIFControlEvent.ON_START_REQUEST_AD);

		_adCleanupCallbacks = [];

		_overlayLoadDelayTimerID = -1;

		var shouldDelayLoad:Boolean = false;
		
		if(_adSlotType == AD_SLOT_TYPE_NONLINEAR)
		{
			_debugMessage(1,_adTagInstreamType+" overlay detected (non-linear).");
			shouldDelayLoad = true;
			
			this.dispatchUIFEvent(UIFControlEvent.ON_START_OVERLAY);	// Legacy
			dispatchUIFEvent(UIFControlEvent.ON_START_NONLINEAR);
		}
		else if (_adFormat == "EW" && _adTagInstreamType == "linear" /* Preparing for future tags */ || _adTagInstreamType == "fixedroll" || _adTagInstreamType == "takeover" || _adTagInstreamType == "fixedrollwithreminder")
		{
			_debugMessage(1,_adTagInstreamType+" linear detected.");
			
			setVideoState(3);	// pause. If player is already paused, this should be ignored.
			shouldDelayLoad = false;
			if (_adTagDuration != 0)
			{
				//Replaced with current variable setup so that the timer is _adTagDuration*1000 for milliseconds with an additional 5000 milliseconds for precaution - Workaround for http://devserv05/trac/ticket/3498
				_maxPrerollTimer = Number(_adTagDuration)*1000 + 5000;
			}
			if (_adTagURLCreativeFormat == "FLV")
			{
				endAd();
				beginVideoOnlyFixedroll(_adTagURLCreativeFormat, _adURL, _maxPrerollTimer, _adTagImpr3rdParty, _adTagClick3rdParty);
				return;
			}
			dispatchUIFEvent(UIFControlEvent.ON_START_FIXEDROLL);	// Legacy
			dispatchUIFEvent(UIFControlEvent.ON_START_LINEAR);
		}

		/* Do not display if too large */
		if (config.scaleEW == false && ((typeof(_adTagWidth) != "undefined" && _adTagWidth > 0 && _videoRect.width + 1 < _adTagWidth)
			|| (typeof(_adTagHeight) != "undefined" && _adTagHeight > 0 && _videoRect.height + 1 < _adTagHeight)))
		{
			_debugMessage(1,"_setupAd: Ad width or height is larger than video width or height. Not displaying ad. Ad width=" + _adTagWidth + " Ad height=" + _adTagHeight +
			" Player dimensions=Rectangle[x="+playerInfo.videoRect.x+",y="+
			playerInfo.videoRect.y+",width="+playerInfo.videoRect.width+",height="+playerInfo.videoRect.height+"]" );
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			return;
		}

		if (shouldDelayLoad == true && _overlayLoadDelay > 0)
		{
			_debugMessage(1, "Delaying " + _overlayLoadDelay + " milliseconds. Setting _overlayLoadDelayTimerID interval.");
			_overlayLoadDelayTimerID = setInterval(_loadSWF, _overlayLoadDelay);
		}
		else
		{
			_loadSWF();
		}
	}
	
	public function onStartLinearHandler( e:UIFEvent ):void {
		removeEventListener( UIFControlEvent.ON_START_LINEAR, onStartLinearHandler );
		
		drawAdCountdown(); 
		if ( (_adFormat == "VAST" || _adFormat == "VAST2") || _adFormat == "EW" ) { 
			
			if (_adAPI != "VPAID")
			{
				adCountdown_mc.visible = true;
			}
		}
	}

	public function _checkMajorVersion(tagVersion:String):Boolean
	{
		for (var i:Object in _APISupportedTagVersions)
		{
			if (tagVersion.substring(0,2) == _APISupportedTagVersions[i].substring(0,2))
			return true;
		}

		return false;
	}

	public function _verifyAdTag():Boolean	// Check ad tag for errors
	{
		_debugMessage(2,"In _verifyAdTag().");
		// Check URL
		if (typeof(_adURL) == "undefined" || _adURL.indexOf("http") != 0)
		{
			_debugMessage(1,"_verifyAdTag -- url check failed.");
			return false;
		}

		// Check support ad tag versions
		if (typeof(_adTagVersion) == "undefined" || !_checkMajorVersion(_adTagVersion) )
		{
			_debugMessage(1,"_verifyAdTag -- ad tag version check failed.");
			return false;
		}

		return true;
	}

	// Unload the ad SWF (called by removeAdMovieClip)
	public function _unloadSWF():void
	{
		_debugMessage(2,"In _unloadSWF().");
		_adIsPlaying = false;
		_adContainerParent_mc.visible = false;
		if(_adContainerBackground_mc)
			_adContainerBackground_mc.visible = false;
		if (_vendorCartridge != null)
			_vendorCartridge.closeAd();
			
		try {
		if (_adContainerParent_mc != null)
			_adContainerParent_mc.unloadClip();
		} catch (e:Error) {
			_debugMessage(1,"adContainer could not be removed from _adContainerParent_mc");
		}

		try {
			if((_adFormat == "VAST" || _adFormat == "VAST2"))
			{
				if (_adAPI == "VPAID")
				{
					_adContainer_mc = null;
				}
				else
				{
					_adContainer_mc.cleanUp();
					_adContainer_mc = null;
					_ewVideoScreen.cleanUp();
					_ewVideoScreen = null;
				}
			}
			_adContainerParent_mc.removeChild(_adContainer_mc);
			_root_mc.removeChild(_adContainerParent_mc);
		}catch(error:Error)
		{

		}
	}

	// Load SWF into movieclip
	public function _loadSWF():void
	{
		_debugMessage(2,"In _loadSWF("+_adURL+").");
		_debugMessage(2,"Preparing to load advertisement...");
		if (_overlayLoadDelayTimerID != -1)
		{
			_debugMessage(1,"Clearing _overlayLoadDelayTimerID interval.");
			clearInterval(_overlayLoadDelayTimerID);
		}

		if ( _adSlotType == AD_SLOT_TYPE_NONLINEAR) {
			dispatchUIFEvent( UIFControlEvent.HIDE_CONTROLS );
		}
			
		_adContainerParent_mc.addEventListener(Event.INIT,_movieClipLoadInit);
		_adContainerParent_mc.addEventListener(Event.COMPLETE,_movieClipLoadComplete);
		_adContainerParent_mc.addEventListener(IOErrorEvent.IO_ERROR, _movieClipLoadError);
		_adContainerParent_mc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _movieClipLoadError);


		// Set useful objects within movieclip (legacy -- deprecated)
		_adContainerParent_mc.ew_instreamObject = this;	// _instreamObject is how the ad will access the instream object to bind to the component interface
		_adContainerParent_mc.ew_instreamEndAd = endAd;	// Convenience function
		// Set useful objects within movieclip(preferred method). Note: _adContainerParent_mc.ew_instreamEndAd is now uif_instreamObject.endAd
		_adContainerParent_mc.uif_instreamObject = this;	// _instreamObject is how the ad will access the instream object to bind to the component interface

		_adContainerParent_mc.x = _adContainerRect.x;
		_adContainerParent_mc.y = _adContainerRect.y;

		//Added for timer reset on ad load call - Workaround for http://devserv05/trac/ticket/3498
		//timerStart(_maxPrerollTimer);

		//moved to InstreamFramework
		//Added for timer reset on ad load call - Workaround for http://devserv05/trac/ticket/3498
		//timerStart(_maxPrerollTimer);

		switch(_adFormat)
		{
			case "VAST":
			case "VAST2":
				//loads VAST ad
				createVASTAd();
				break;
		
			default:
				//loads instreamAd
				_adContainerParent_mc.loadClip(_cacheBuster.cacheBustURL(_adURL));
				break;
		}
	}

	public function createVASTAd():void
	{
		_adContainerParent_mc.visible = true;

		var _vastTranslator:Object;
		
		//check which parser we have to ask for information
		switch(_adFormat)
		{
			case "VAST":
				_vastTranslator = new VAST1Translator(_vast1Parser);
				break;
			case "VAST2":
				_vastTranslator = new VAST2Translator(_vast2Parser);
				break;
		}
		
		switch(_adSlotType)
		{
			//non-linear
			case AD_SLOT_TYPE_NONLINEAR:
			
				if (_vastTranslator.nonlinearArray.length > 0)
				{
					this.dispatchUIFEvent(UIFControlEvent.ON_START_OVERLAY);	// Legacy
					dispatchUIFEvent(UIFControlEvent.ON_START_NONLINEAR);
				
					if (_vastTranslator.nonlinearArray && 
						_vastTranslator.nonlinearArray[0] &&
						_vastTranslator.nonlinearArray[0].apiFramework == "VPAID")
					{
						startVPAID();
					}
					else
					{
						_staticAd = new StaticAdModel(this);
						_debugMessage(2,"In createVASTAd(): start a NonLinearAd");
						_staticAd.staticResource = _vastTranslator.nonlinearArray;
						_adContainer_mc = _staticAd.canvas;
						_adIsPlaying = true;
					}
				}
				else
				{
					//capped
					dispatchUIFEvent(UIFEvent.ERROR_EVENT);
					return;
				}
					break;
				
			//linear
				default:
				
				if (_vastTranslator.mediafileArray != null && _vastTranslator.mediafileArray.length > 0)
				{
					if (_vastTranslator.mediafileArray &&
						_vastTranslator.mediafileArray[0] &&
						_vastTranslator.mediafileArray[0].apiFramework == "VPAID")
					{
						startVPAID();
					}
					else
					{
						_debugMessage(2,"In createVASTAd(): start a VASTVideoAdModule");
						_adContainerBackground_mc.visible = true;
						_ewVideoScreen = new EWVideoAdScreenModule(config);
						_adContainer_mc = new VASTVideoAdModule(this, _ewVideoScreen);
					}
				}
				else
				{
					//capped
					dispatchUIFEvent(UIFEvent.ERROR_EVENT);
					
					// if an error element exists, dispatch an error tracker
					var mXML:XML = _tagParser.mainXML as XML;
					var trkURL:String = mXML..Error;
					if (trkURL != "") {
							
						var cacheBustURL:String = _cacheBuster.cacheBustURL(trkURL, CacheBuster.AD);
						var trkRequest:URLRequest = new URLRequest(cacheBustURL);
						var impressionHolder:MovieClip = new MovieClip();
						impressionHolder.requestQueue = new RequestQueue();
						impressionHolder.requestQueue.addRequest(trkRequest);
					}
					
					return;
				}
					break;
			}
		_adContainerParent_mc.addChild(_adContainer_mc);
	}

	private function startVPAID():void
	{
		_adAPI = "VPAID";
		if(_adSlotType != AD_SLOT_TYPE_NONLINEAR) {
			_adContainerBackground_mc.visible = true;
		}

		_debugMessage(2,"In createVASTAd(): start a VPAIDModule");
		_adContainer_mc = new VPAID(this);
		
		if(_config.scaleVAST == false)
		{
			_adTagWidth = _adContainer_mc.translator.vpaidWidth;
			_adTagHeight = _adContainer_mc.translator.vpaidHeight;
			_adTagAlignHorizontal = _config.vpaidHAlign;
			_adTagAlignVertical = _config.vpaidVAlign;
		
			_scale = new Scale(this);
			_scale.positionVPAID();
		}	
		
		_adIsPlaying = true;
	}

	
	// Handle the movie clip having loaded AND initialized
	public function _movieClipLoadInit(event:Event) : void
	{
		_debugMessage(2,"In _movieClipLoadInit("+event+").");
		_adIsPlaying = true;

		// WW: EW API only. VPAID is in another location
		dispatchUIFEvent(UIFControlEvent.ON_START_PLAY_AD);

		trace("Instream object = " + _adContainerParent_mc.uif_instreamObject);
	}

	// Handle the movie clip loaded AND initialized (different meaning in AS3?)
	public function _movieClipLoadComplete(event:Event) : void
	{
		_debugMessage(2,"In _movieClipLoadComplete("+event+").");

		// Create a parent and child container, so that the parent container can hold the variables that would otherwise be cleared by loading the SWF
		// Can only do this when it becomes available (see class AdContainerParent)
		_adContainer_mc = MovieClip(_adContainerParent_mc._adContainer.content);
		if ((_adFormat != "VAST") && (_adFormat != "VAST2"))
			resizeNotify();
		_adContainerParent_mc.visible = true;
		if(_adTagInstreamType != "ticker" && _adTagInstreamType != "bug")
			_adContainerBackground_mc.visible = true;
		dispatchUIFEvent(UIFControlEvent.ON_AD_LOAD_COMPLETE);
	}

	// Handle the error that occurres if the ad's URL isn't reachable for some reason
	public function _movieClipLoadError(event:IOErrorEvent) : void
	{
		_debugMessage(2, "In _movieClipLoadError("+event+").");
		dispatchUIFEvent(UIFEvent.ERROR_EVENT);
	}

	public function drawBackground():void
	{
		_debugMessage(2,"In drawBackground. ["+config.width+" x "+config.height+"]  :: ("+config.x+" ,"+config.y+")");
		if(_adContainerBackground_mc)
		{
			_adContainerBackground_mc.graphics.clear();
			_adContainerBackground_mc.graphics.beginFill(config.backgroundColor, config.backgroundAlpha);
			_adContainerBackground_mc.graphics.drawRect(0, 0, config.width, config.height);
			_adContainerBackground_mc.graphics.endFill();
			_adContainerBackground_mc.x = config.x;
			_adContainerBackground_mc.y = config.y;
		}
	}

	public function drawAdCountdown() : void {
		_debugMessage(2,"In drawAdCountdown.");
		
		var playerInfo:Object = getPlayerInformation();
		
		adCountdown_mc = new AdCountdown( config );
		adCountdown_mc.draw( playerInfo );
		adCountdown_mc.visible = false;
		adCountdown_mc.mouseEnabled = false;
		adCountdown_mc.mouseChildren = false;
		
		_root_mc.addChild( adCountdown_mc );
	}
	
	// A single timer interval
	public function _timerInterval(): void
	{
		if (_timerPauseCountdown != 0)	// If timer is paused (for interaction), decrement pause timer countdown
		{
			_timerPauseCountdown -= _timerStep;
			if (_timerPauseCountdown <= 0)
				_timerPauseCountdown = 0;
		}
		else 	// Decrement main timer
		{
			_timerCountdown -= _timerStep;
			if (_timerCountdown <= 0)
			{
				_timerCountdown = 0;
				timerCountdownCompleted();
			}
		}
		_debugMessage(2,"_timerInterval _timerPauseCountdown=" + _timerPauseCountdown + " _timerCountdown=" + _timerCountdown);
	}

	public function _errorMessage(msg:Object) : void
	{
		var emsg:String = "Error: " + msg.toString()
		_debugMessage(0, emsg)
	}

	// Debug messages from within the API (level is the minimum verbosity that will show the message)
	public function _debugMessage(level:Number, msg:Object, prefix:String = "[::EW Instream API::]") : void
	{
			if (_debugMessages >= level)
			{
				trace("");	// newline
				trace(prefix + " " + msg.toString());

				_sendToPanel( prefix + " " + msg );
			}
	}

	// Should only be called by _debugMessage
	public function _sendToPanel( message:Object ):void
	{
		UIFSendToPanel.getInstance()._sendToPanel(message);
	}

	public function dispatchUIFEvent(name:String, info:Object = null):void
	{
		if (name == UIFControlEvent.ON_START_PLAY_AD || name == UIFControlEvent.ON_END_AD || name == UIFEvent.ERROR_EVENT)
		{
			_debugMessage(1, name + " event dispatched." );
		}
		
		dispatchEvent(new UIFEvent(name, info));
	}

	public function onFullScreen( evt:FullScreenEvent ):void {
		if (_adContainer_mc)
		{
			if ( evt.fullScreen )
			{
				//NonLinear ads are right now (v3.0) only StaticResource ads, which don't use the Linear VAST classes
				if ( (_adFormat == "VAST" || _adFormat == "VAST2") && _adSlotType != AD_SLOT_TYPE_NONLINEAR)
				{
					if (_adAPI != "VPAID")
					{
						_adContainer_mc.videoAdScreenModule.dispatchEvent(new Event("fullscreen"));
					}
				}
				else
				{
					dispatchUIFEvent( UIFTrackEvent.TRACK_ENTER_FULLSCREEN );
				}
			}
		}
	}
}
/* End package */
}
