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

	import flash.xml.XMLNode;

	/**
	 * @author mthomas
	 */
	public dynamic class EWHardCodedParser extends HardCodedParser{
			
		/*
		 * Constructor
		 */
		public function EWHardCodedParser()
		{
			super();
			tagType = "EWHardCoded Parser";
		}
		
		public override function parse(xml : String) : void 
		{		
			//Parse Data Here: _adTagXML:XMLDocument is the XML Data
			// Allow comments and other XML nodes prior to instreamAd element
			
			try{
			 _adTagXML = new XML(xml);
			}catch(e:Error){}
			
			var i:Number;
			for( i = 0; i < _adTagXML.childNodes.length; i++)	// Find instreamAd element
			{
				if ( _adTagXML.childNodes[i].nodeName == "instreamAd" || _adTagXML.childNodes[i].nodeName == "ewAd" /* legacy: use instreamAd instead on new tags */)
					break;
			}
			
			if (i >= _adTagXML.childNodes.length)
			{
				dispatchError(4);
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
						// _adTagClickPrepend = InstreamFrameworkUtility.strnreplace(_adTagClickPrepend, "[clickthru]", "", 1);
						// _adTagClickPrepend = InstreamFrameworkUtility.strnreplace(_adTagClickPrepend, "[ewclickthru]", "", 1); // legacy
					}
					else if (currentTag.nodeName == "dataURL")
					{
						_adTagDataURL = currentValue;			
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
						
					}
				}
			}
		}
	}
}
