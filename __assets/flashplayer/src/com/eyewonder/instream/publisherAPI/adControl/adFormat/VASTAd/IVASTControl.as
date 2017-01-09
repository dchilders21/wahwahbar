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
package com.eyewonder.instream.publisherAPI.adControl.adFormat.VASTAd 
{
	
	import com.eyewonder.instream.publisherAPI.adControl.adFormat.IAbstractAdFormat;
	
	/*
		Class: VASTControl

		Based upon the currently completely parsed XML,
		this layer will return the values specified in the XML.
		
		Example:
		(start example)
			var adSystem:String = ewAPI.adControl.ad["system"];
			trace("the VAST ad system: " + adSystem);
		(end)
	*/
	public interface IVASTControl extends IAbstractAdFormat
	{
		/*
			Property: isWrapper
			
			If the XML is a wrapper this will return true;
			
			Returns:
				Boolean - returns true if VAST XML has had wrappers in it
		*/
		function get isWrapper():Boolean;
		
		/*
			Property: tagID
			
			Returns the tag ID specified in the VAST XML.
			
			Returns:
				String - The tag ID
		*/
		function get tagID():String;
		
		/*
			Property: wrapperSystem
			
			Returns the wrappers system
			
			Returns:
				String - the system of the wrapper
		*/
		function get wrapperSystem():String;
		
		/*
			Property: tagURL
			
			The URL String of the tag.
			
			Returns:
				String -  URL String
		*/
		function get tagURL():String;
		
		/*
			Property: wrapperError
			
			Returns the URL that will be tracked on an Error.
			
			Returns:
				String - URL String
		*/
		function get wrapperError():String;
		
		/*
			Property: wrapperImpression
			
			Returns the URL that will be tracked on an Impression.
			
			Returns:
				String - URL String
		*/
		function get wrapperImpression():String;
		
		/*
			Property: wrapperTrackingEvent
			
			Returns a Object. ????
			
			Returns:
				Object - ????
		*/
		function get wrapperTrackingEvent():Object;
		
		/*
			Property: system
			
			Returns the system of the VAST XML.
			
			Returns:
				String - URL String
		*/
		function get system():String;
		
		/*
			Property: title
			
			Returns the title of the VAST XML.
			
			Returns:
				String - A String with the title.
		*/
		function get title():String;

		/*
			Property: impressionURL
			
			Returns the URL that will be tracked on an Impression.
			
			Returns:
				String - URL String
		*/
		function get impressionURL():String;

		/*
			Property: impressionArray
			
			Returns an Array with URLs that will be tracked on an Impression.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get impressionArray():Array;
		
		/*
			Property: impressionWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that will be tracked on an Impression.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get impressionWrapperArray():Array;
		
		/*
			Property: clickThruArray
			
			Returns an Array with URLs that will be tracked on click through.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get clickThruArray():Array;
		
		/*
			Property: clickThruWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that will be tracked on click through.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get clickThruWrapperArray():Array;
		
		/*
			Property: errorArray
			
			Returns an Array with URLs that will be tracked on error.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get errorArray():Array;
		
		/*
			Property: errorWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that will be tracked on error.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get errorWrapperArray():Array;
		
		/*
			Property: trackingArray
			
			????
			
			Returns:
				Array - An array with URL Strings
		*/		
		function get trackingArray():Array;
		
		/*
			Property: adTagClickThrough
			
			Returns a URL String that will be tracked on click through.
			
			Returns:
				String - An array with URL Strings
		*/
		function get adTagClickThrough():String;
		
		/*
			Property: mediafileArray
			
			Returns an Array with URLs to the media files.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get mediafileArray():Array;
		
		/*
			Property: trkStartEvent
			
			Returns an Array with URLs that will be tracked on start of the ad video.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkStartEvent():Array;
		
		/*
			Property: trkMidPointEvent
			
			Returns an Array with URLs that will be tracked on the midpoint of the ad video.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkMidPointEvent():Array;
		
		/*
			Property: trkFirstQuartileEvent
			
			Returns an Array with URLs that will be tracked on the first quartile of the ad video.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkFirstQuartileEvent():Array;
		
		/*
			Property: trkThirdQuartileEvent
			
			Returns an Array with URLs that will be tracked on the third quartile of the ad video.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkThirdQuartileEvent():Array;
		
		/*
			Property: trkCompleteEvent
			
			Returns an Array with URLs that will be tracked at the end of the ad video.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkCompleteEvent():Array;
		
		/*
			Property: trkMuteEvent
			
			Returns an Array with URLs that will be tracked when the ad video has been muted.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkMuteEvent():Array;
		
		/*
			Property: trkPauseEvent
			
			Returns an Array with URLs that will be tracked when the ad video has been paused.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkPauseEvent():Array;
		
		/*
			Property: trkReplayEvent
			
			Returns an Array with URLs that will be tracked when the ad video has been replayed.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkReplayEvent():Array;
		
		/*
			Property: trkFullScreenEvent
			
			Returns an Array with URLs that will be tracked when the ad video has been set to fullscreen.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkFullScreenEvent():Array;
		
		/*
			Property: trkStopEvent
			
			Returns an Array with URLs that will be tracked when the ad video has been stopped.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkStopEvent():Array;
		
		/*
			Property: trackingStartWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been started.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingStartWrapperArray():Array;
		
		/*
			Property: trackingMidPointWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has reached the mid point.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingMidPointWrapperArray():Array;
		
		/*
			Property: trackingFirstQuartileWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has reached the first quartile.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingFirstQuartileWrapperArray():Array;
		
		/*
			Property: trackingThirdQuartileWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has reached the third quartile.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingThirdQuartileWrapperArray():Array;
		
		/*
			Property: trackingCompleteWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has reached the end.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingCompleteWrapperArray():Array;
		
		/*
			Property: trackingMuteWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been muted.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingMuteWrapperArray():Array;
		
		/*
			Property: trackingPauseWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been paused.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingPauseWrapperArray():Array;
		
		/*
			Property: trackingReplayWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been replayed.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingReplayWrapperArray():Array;
		
		/*
			Property: trackingFullScreenWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been set to fullscreen.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingFullScreenWrapperArray():Array;
		
		/*
			Property: trackingStopWrapperArray
			
			Returns an Array with URLs from the VAST wrapper that 
			will be tracked when the ad video has been set to stop.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trackingStopWrapperArray():Array;
		
		/*
			Property: companionArray
			
			Returns an Array with URLs for companion ads.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get companionArray():Array;
		
		/*
			Property: nonlinearArray
			
			Returns an Array with URLs for nin linear ads.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get nonlinearArray():Array;
		
		/*
			Property: trkClickThru
			
			Returns an Array with URLs that will
			be tracked on click through.
			
			Returns:
				Array - An array with URL Strings
		*/
		function get trkClickThru(): Array;
	}
}