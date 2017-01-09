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

package com.eyewonder.instream.core.modules.videoAdModule.VPAID
{

	import flash.events.IEventDispatcher;

	/*
		Interface: IVPAIDBase
	*/
	public interface IVPAIDBase extends IEventDispatcher
	{
	    // Properties
	    
	    /**
	    * Indicates the ad’s current linear vs. non-linear mode of
	    * operation. linearVPAID when true indicates the ad is in a linear playback mode, false
	    * nonlinear.
	    */ 
	    function get linearVPAID() : Boolean;
	    
		/** 
		 * Indicates whether the ad is in a state where it
		 * occupies more UI area than its smallest area. If the ad has multiple expanded states,
		 * all expanded states show expandedVPAID being true.
		 */ 	    
	    function get expandedVPAID() : Boolean;
	    
	    /**
	    * The player may use the remainingTimeVPAID property to update player UI during ad
	    * playback. The remainingTimeVPAID property is in seconds and is relative to the time the
	    * property is accessed.
	    */ 
	    function get remainingTimeVPAID() : Number;
	    
	    /**
	    * The player uses the volumeVPAID property to attempt to set or get the ad volume. The
	    * volumeVPAID value is between 0 and 1 and is linear.
	    */
	    function get volumeVPAID() : Number;
	    function set volumeVPAID(value : Number) : void; 

	    // Methods
	    
	    /**
	    * After the ad is loaded and the player calls handshakeVersion, the player calls initVPAID to
	    * initialize the ad experience. The player may pre-load the ad and delay calling initVPAID
	    * until nearing the ad playback time, however, the ad does not load its assets until initVPAID
	    * is called.
	    */ 
	    function initVPAID(width : Number, height : Number, viewMode : String, desiredBitrate : Number, creativeData : String, environmentVars : String) : void;
	    
	    /**
	    * Following a resize of the ad UI container, the player calls resizeAd to allow the ad to
	    * scale or reposition itself within its display area. The width and height always matches
	    * the maximum display area allotted for the ad, and resizeVPAID is only called when the
	    * player changes its video content container sizing.
	    */
	    function resizeVPAID(width : Number, height : Number, viewMode : String) : void;
	    
	    /**
	    * startVPAID is called by the player and is called when the player wants the ad to start
	    * displaying.
	    */ 
	    function startVPAID() : void;
	    
	    /**
	    * stopVPAID is called by the player when it will no longer display the ad. stopVPAID is also
	    * called if the player needs to cancel an ad.
	    */
	    function stopVPAID() : void;
	    
	    /**
	    * pauseVPAID is called to pause ad playback. 
	    */
	    function pauseVPAID() : void;
	    
	    /**
	    * resumeVPAID is called to continue ad playback following a call to pauseAd.
	    */
	    function resumeVPAID() : void;
	    
	    /**
	    * expandVPAID is called by the player to request that the ad switch to its larger UI size.
	    */
	    function expandVPAID() : void;
	    
	}
}
