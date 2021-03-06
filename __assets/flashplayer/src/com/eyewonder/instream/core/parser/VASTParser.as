/*
VASTParser.as

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

JUST A WRAPPER FOR REAL VAST PARSER (FOR TESTING). REMOVE IN FUTURE OR JUST LEAVE FOR COMPATIBILITY REASONS.

*/
package com.eyewonder.instream.core.parser {
	
	import com.eyewonder.instream.core.parser.vast.v1.*
	import com.eyewonder.instream.core.debugger.*;
	
	public dynamic class VASTParser extends com.eyewonder.instream.core.parser.vast.v1.VAST1Parser {
		
		public static const TOGGLE_VAST_WRAPPER_CALLED:String = "toggleVastWrapperCalled"; // Static vars are not inherited :-(

		private var VASTversion:Number = 1.1; // TODO this has to be set by one of the VAST parsers
		
		public function VASTParser() {
			super();
			UIFDebugMessage.getInstance()._debugMessage(3, "Init VASTParser wrapper (legacy, deprecated)", "INSTREAM", "VASTParser");
		}
		
		
	}

/* End package */
}