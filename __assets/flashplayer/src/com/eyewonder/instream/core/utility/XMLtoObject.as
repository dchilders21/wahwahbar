/*
XMLtoObject.as

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

Converts a XML to an Object
*/
package com.eyewonder.instream.core.utility 
{
	/*
		TODO Needs bugfixing for the recursion termination condition
		
		WARNING - this does not work for "deep" nested structures
		
		Something like this:
		<container>
			<firstNode>
				<secondNode>
					<thirdnode>
						CONTENT
					</thirdNode>
				</secondNode>
			</firstNoder>
		</container>
		
		Will break on secondNode, which means that the thirdNode and it's content is _not_ in the return object.
		
		
		I sense the problem at "hasComplexContent" as it returns false on the secondNode, should actually return true.
	*/
	public class XMLtoObject
	{
		
		//walk through xml and collect all nodes with their attributes
		public static function convert(input:XMLList):Object
		{
			var output:Object = new Object();
			
			for (var node:uint = 0; node < input.length(); node++ )
			{
				if (input[node].name() != null)
				{
					//attributes
					output[input[node].name()] = fetchAttributes(input[node]);
						
					//node content
					if (String(input[node].text()) != "")
					{
						output[input[node].name()]['text'] = String(input[node].text());
					}

					//only do recursion if there is XML in that upcomming node
					if ((input[node].children().length() > 0) && input[node].hasComplexContent())
					{
						
						var tmpObj:Object = convert(input[node].children());
						
						//it's not possible to combine objects as it's possible with array
						//therefore we do this by hand =D
						for (var key:String in tmpObj)
						{
							output[input[node].name()][key] = tmpObj[key];
						}
					}
				}
			}
			
			return output;
		}
		
		//collect node attributes as object, and return them
		private static function fetchAttributes(nodeWithAttributes:*):Object
		{
			var attributes:XMLList = nodeWithAttributes.attributes();
			
			var retObj:Object = new Object();
			
			for (var att:String in attributes)
			{
				//adding a '@' to attributes does not throw an error, but JavaScript refuses to work with it
				//retObj[String('@'+attributes[att].name())] = String(attributes[att]);
				retObj[String(attributes[att].name())] = String(attributes[att]);
			}
			
			return retObj;
		}
	}
}