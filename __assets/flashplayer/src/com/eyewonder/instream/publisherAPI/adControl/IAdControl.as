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
package com.eyewonder.instream.publisherAPI.adControl
{

	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.events.IUIFEventDispatcher;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.VPAIDAd.IVPAIDControl;
	import com.eyewonder.instream.publisherAPI.adControl.companion.ICompanionAd;
	
	import com.eyewonder.instream.publisherAPI.adControl.parser.IParserControl;
	import com.eyewonder.instream.publisherAPI.adControl.tracking.ITrackingControl;
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.IAbstractAdFormat;
	import com.eyewonder.instream.core.utility.ICacheBuster;
	
	/*
		Class: AdControl

		Dispatches events and provides the possibilty
		to control the ad - independent from it's type.
		
		Events (sorted on appearance):
			ON_START_REQUEST_AD 		- Prior to requesting the creative (SWF,..)
			ON_START_NONLINEAR			- NonLinear creative is being requested
			ON_START_OVERLAY 			- (Legacy) NonLinear  is being requested
			ON_START_LINEAR 			- Linear creative is being requested
			ON_START_LINEAR_INTERACTIVE	- Linear interactive creative is being requested
			ON_START_FIXEDROLL			- (Legacy) Linear interactive creative is being requested
			ON_START_PLAY_AD			- Creative has initially loaded
			ON_AD_LOAD_COMPLETE			- Creative has finished loading
			AD_INFORMATION_DATA			- Type and subtype of creative can now be accessed
			ON_END_AD					- Creative is being closed
			ON_REMINDER_DETECTED		- Ad XML contains a ReminderUnit
			ON_REMINDER_OVERRIDE		- Current call of NonLinear creative has been replaced with ReminderUnit
		
			ERROR_EVENT					- Error while loading ad XML
			
		Example:
		(start example)
			//load an ad, it will be played automatically.
			//make sure to use either 'adSlotTypeLinear' or 'adSlotTypeNonLinear' as adSlotType "THIS IS REQUIRED"
			ewAPI.adControl.loadAdURL(adURL[adType], adSlotType);
			
			//pause the ad (e.g. when your player has recieved a click on pause)
			ewAPI.adControl.pause();
			
			//set the volume of an ad to 50%
			ewAPI.adControl.volume = 50;
		(end)
	*/
	public interface IAdControl extends IUIFEventDispatcher
	{	
		function destroy():void;
		
		/*
			Function: trackingControl
			
			see <TrackingControl>
		*/
		function get trackingControl():ITrackingControl;
			
		/*
			Function: parserControl
			
			see <ParserControl>
		*/
		function get parserControl():IParserControl;
		
		/*
			Property: ad
			
			see <AbstractAdFormat>
		*/
		function get ad():IAbstractAdFormat;
		
		/*
			Property: vpaid
			
			see <VPAIDControl>
		*/
		function get vpaid():IVPAIDControl;
				
		/*
			Property: cachebuster
			
			Provides a layer for the cachebuster.
		*/
		function get cachebuster():ICacheBuster;
		
		/*
			Property: companionAd
			
			Provides a layer for the companion ads.
		*/
		function get companionAd():ICompanionAd;
		
		/*
			Function: play
			
			Sets the ad to play.
		*/
		function play():void;
		
		/*
			Function: pause
			
			Sets the ad to pause.
		*/
		function pause():void;

		/*
			Function: forward
			
			Seeks the ad forward.
		*/
		function forward():void;
		
		/*
			Function: next
			
			Plays the next video in the ad, if theres none, the current one will be seeked to its end.
		*/
		function next():void;

		/*
			Function: previous
			
			Plays the previous video in the ad, if theres none, the current one will be seeked to its start.
		*/
		function previous():void;
		
		/*
			Function: seek
			
			Seeks the video in the ad by the given values.
			
			Parameters:
				position - Number
				offset - Number
		*/
		function seek(position:Number, offset:Number):void;
		
		/*
			Function: rewind
			
			Rewinds the ad backwards.
		*/
		function rewind():void;
		
		/*
			Function: loadAdURL
			
			Loads and plays an ad URL regardless of its type.
			
			Parameters:
				adTagURL - A URL String to the ad tag
				adSlotType - "adSlotTypeLinear", "adSlotTypeNonLinear"
				adFormat - "EW", "VAST", "unknown"
		*/
		function loadAdURL(adTagUrl:String, adSlotType:String, adFormat:String = "unknown"):void;
		function loadDataObj(value:XML, adSlotType:String, adFormat:String = "unknown"):void;
		
		/*
			Function: resize
			
			Will cause the ad to resize itself based upon the values given via <UIFConfigControl.playerContentClip>.
			
			If you use <PlayerControl.videoScreenRect> this function will be called
			for you.
		*/
		function resize():void;
		
		//properties
		/*
			Property: adInformationData
			
			Returns an object with the subtype of the ad,
			this object may also contain the remaining time.
			
			Returns:
				Object - An object with various data from the ad.
		*/
		function get adInformationData():Object;
		
		/*
			Property: volume
			
			Returns the current volume. Volume must be specified first,
			as it'll be NaN at start. Not setting the volume property will cause the
			ad to be started in a muted state.
			
			See <PlayerControl.volume>
			
			Returns:
				Number - A number between 0 and 100
		*/
		function get volume():Number;
		
		/*
			Property: format
			
			Returns the current format of the ad.
			This may be usefull if using one of the <AbstractAdController>
			
			Returns:
				String - "VAST", "EW" or "unknown"
		*/
		function get format():String;
		
		/*
			Property: isPlaying
			
			Returns true if the ad has been paused in prior.
			
			Returns:
				Boolean - True if it's playing
		*/
		function get isPlaying():Boolean;
		
		/*
			Property: slotType
			
			Returns the current ad slot type,
			which has been set via <loadAdURL>
			
			Returns:
				String - "adSlotTypeLinear", "adSlotTypeNonLinear"
		*/	
		function get slotType():String;
		
		/*
			Property: remainingTime
			
			Returns the amount of time remaining in an ad. This value is
			counted backwards, meaning this variable will decrease
			while the ad is playing.
			
			Returns:
				Number - remaining time left in an ad in Seconds
		*/
		function get remainingTime():Number;

		/*
			Property: duration
			
			The total time of the ad.
			
			Returns:
				Number - total time of the ad in Seconds
		*/
		function get duration():Number;
		
		/*
			Property: reminder
			
			When you're using multiple instances of the
			uifControler you're supposed to save the reminder
			array.
			
			Returns:
				Array - The reminder array
		*/
		function get reminder():Array;
		
		/*
			Property: reminder
			
			When you're using multiple instances of the
			uifControler you're supposed to save the reminder
			array.
			
			Parameter:
				Array - The reminder array
		*/
		function set reminder(newRemidnerArray:Array):void;
		
		/*
			Function:endAd
		
			Closes an ad
		*/
		function endAd():void;
	}
}