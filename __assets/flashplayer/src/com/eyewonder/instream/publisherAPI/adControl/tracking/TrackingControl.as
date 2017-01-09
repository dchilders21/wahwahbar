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
package com.eyewonder.instream.publisherAPI.adControl.tracking
{
	import com.eyewonder.instream.publisherAPI.adControl.tracking.ITrackingControl;
	
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.events.UIFEventDispatcher;
	import com.eyewonder.instream.core.events.UIFEvent;
	import com.eyewonder.instream.core.events.UIFTrackEvent;
	
	/*
		Class: TrackingControl

		This layer send all tracking events on which you might want to
		do your own tracking.
		
		Events:
			TRACK_LOAD						- Creative is being loaded
			TRACK_EXPAND					- Creative has been expanded
			TRACK_CONTRACT					- Creative has being contracted
			TRACK_CLOSE						- Creative has being closed
			TRACK_INTERACTION				- Interaction with NonLinear ad (expanded, paused,..)
			TRACK_CLICKTHRU					- ClickThru has been triggered
			TRACK_START_OF_VIDEO			- Ad video is being started
			TRACK_FIRST_QUARTILE_OF_VIDEO	- 25% of ad video reached
			TRACK_MID_OF_VIDEO 				- Midpoint of ad video reached
			TRACK_THIRD_QUARTILE_OF_VIDEO	- 75% of ad video reached
			TRACK_END_OF_VIDEO				- End of ad video reached
			TRACK_GO_INTERACTIVE			- A linear interactive goes into interactive mode
			TRACK_LEAVE_INTERACTIVE			- A linear interactive leaves interactive mode
			TRACK_ENTER_FULLSCREEN			- Fullscreen mode entered
			TRACK_MUTE						- Ad has been muted
	
		Example:
		(start example)
			import com.eyewonder.instream.core.events.UIFEvent;
			import com.eyewonder.instream.core.events.UIFTrackEvent;
	
			//add event listener
			ewAPI.adControl.trackingControl.addEventListener(UIFEvent.TRACK_EVENT, trackEventHandler);
			
			//do something on an event
			private function trackEventHandler(event:UIFEvent):void
			{
				trace("%% track event [" + event.info.type +"] recieved." );
			}
		(end)
	*/
	public class TrackingControl extends UIFEventDispatcher implements ITrackingControl 
	{
		private var _instreamFramework:InstreamFrameworkBase;
		
		public function TrackingControl(instreamFramework:InstreamFrameworkBase)
		{
			_instreamFramework = instreamFramework;
			
			_instreamFramework.addEventListener( UIFEvent.TRACK_EVENT, trackEventForwarding );
		}
		
		public function destroy():void
		{
			_instreamFramework.removeEventListener( UIFEvent.TRACK_EVENT, trackEventForwarding );
		}
		
		private function trackEventForwarding(event:UIFEvent):void
		{
			dispatchEvent(new UIFEvent(event.type, event.info));
		}
	}
}