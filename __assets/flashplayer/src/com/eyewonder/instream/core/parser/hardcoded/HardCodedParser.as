
/*
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
package com.eyewonder.instream.core.parser.hardcoded {

	import flash.xml.XMLDocument;
	import flash.events.Event;

	import com.eyewonder.instream.core.parser.base.TagParserBase;
	import com.eyewonder.instream.core.parser.events.ParserEvent;
	import com.eyewonder.instream.core.parser.IParser;

	public dynamic class HardCodedParser extends TagParserBase {
		
		public function HardCodedParser()
		{
			super();
			tagType = "HardCoded Parser";
		}
		
		protected function _loadAdXMLHandler(xml:String):void
		{
			dispatchEvent(new Event(ParserEvent.XML_LOADED));
			//_sendToPanel("In _loadAdXMLHandler()." );
			
			try {
				_adTagXML = XML(new XMLDocument(xml));
			} catch (e:Error){
				//_sendToPanel("_loadAdXMLHandler: Malformed XML data.");
				dispatchError(5);
				return;
			}
			parse(_adTagXML);
		}
		
		public function parse(xml : String) : void 
		{
			//_sendToPanel("In parse("+xml+").");
			//_sendToPanel("tagType: " + tagType);
			
			_uifVars = new Object();
			
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
			
			_loadAdXMLHandler(xml);
		}
	}
}