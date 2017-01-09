
// ========================================================================
// START SERIALIZATION CODE

function CreateMSXMLDocumentObject () {
    if (typeof (ActiveXObject) != "undefined") {
        var progIDs = [
                        "Msxml2.DOMDocument.6.0", 
                        "Msxml2.DOMDocument.5.0", 
                        "Msxml2.DOMDocument.4.0", 
                        "Msxml2.DOMDocument.3.0", 
                        "MSXML2.DOMDocument", 
                        "MSXML.DOMDocument"
                      ];
        for (var i = 0; i < progIDs.length; i++) {
            try { 
                return new ActiveXObject(progIDs[i]); 
            } catch(e) {};
        }
    }
    return null;
}

function CreateXMLDocumentObject (rootName) {
    if (!rootName) {
        rootName = "";
    }
    var xmlDoc = CreateMSXMLDocumentObject();
    if (xmlDoc) {
        if (rootName) {
            var rootNode = xmlDoc.createElement (rootName);
            xmlDoc.appendChild (rootNode);
        }
    }
    else {
        if (document.implementation.createDocument) {
            xmlDoc = document.implementation.createDocument ("", rootName, null);
        }
    }
    
    return xmlDoc;
}

function addAttribute(doc, element, name, value)
{
	var attr = doc.createAttribute(name);
	attr.value = value;
	element.setAttributeNode(attr);
	return element;	// Makes one-liners easier
}

function conditionalCreateCDATAInfoElement(doc, parentElement, name, innerText)
{
		if (typeof(innerText) != "undefined" && innerText != null)
		{
			
			var element = doc.createElement(name);
			parentElement.appendChild(element);
			element.appendChild(doc.createCDATASection( innerText ));
			return element;
		}
		return null;
}

function conditionalCreateAttribute(doc, element, name, value)
{
	if (typeof(value) != "undefined" && value != null)
	{
		addAttribute(doc, element, name, value)
	}
}

function createTrackingElementsFromCollection(doc, parentElement, name, collection)
{
	if (typeof(collection.length) != "undefined") // Impresions, Errors
	{
		for (var i = 0; i < collection.length; i++)
		{
			var value;
			var isImpr = false;
			if (typeof(collection[i].id) != "undefined") // Impressions
			{
				value = collection[i].url;
				isImpr = true;
			}
			else // Misc
			{
				value = collection[i];
			}
			var element = conditionalCreateCDATAInfoElement(doc, parentElement, name, value);
			if (isImpr)
			{
				conditionalCreateAttribute(doc, element, "id", collection[i].id);
			}
		}
	}
	else // TrackingEvents
	{
		for (var n in collection)
		{
			var trackArray = collection[n];
			for (var i = trackArray.length - 1; i >= 0; i--)	// Go backwards to put non-wrappers first (for players that support only 1 of each)
			{
				var track = trackArray[i];
				if (track.event != "click")
				{
					var element = conditionalCreateCDATAInfoElement(doc, parentElement, name, track.url);
					conditionalCreateAttribute(doc, element, "event", track.event);
				}
			}
		}
	}
}


function appendNewline(doc, siblingNode)
{
	siblingNode.parentNode.insertBefore(doc.createTextNode("\n"), siblingNode.nextSibling);
}

function processAttributeList(doc, element, attributesArray /* named array */)
{
	for (var attr in attributesArray)
	{
		var val = attributesArray[attr];
		switch (attr) {
			case 'skipoffset':
			case 'duration':
			case 'offset':
			case 'minSuggestedDuration':
			  val = makeVASTTime(val);
		  }
		conditionalCreateAttribute(doc, element, attr, val);
	}
}

function makeVASTTime(sec)
{
	function zeroFill( number, width )
	{
		width -= number.toString().length;
		if ( width > 0 )	
		{
			return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
		}
		return number + ""; // always return a string
	}
	var hours = Math.floor(sec / 3600);
	sec -= hours*3600;
	var min = Math.floor(sec / 60);
	sec -= min*60;
	return zeroFill(hours,2) + ":" + zeroFill(min,2) + ":" + zeroFill(sec,2);

}	

// http://help.dottoro.com/ljbcjfot.php
function wwSerialize(vvDoc)
{
	testMsgOut("Serializing doc");
	
	var vastXML = CreateXMLDocumentObject("VAST");
	var rootNode = vastXML.firstChild;
	// TODO: Make 3.0 someday
	addAttribute(vastXML, rootNode, "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
	addAttribute(vastXML, rootNode, "xsi:noNamespaceSchemaLocation", "vast.xsd");
	addAttribute(vastXML, rootNode, "version", "2.0");
	
	for (var adNum = 0; adNum < vvDoc.ads.length; adNum++)
	{
		var adNode = vastXML.createElement("Ad");
		conditionalCreateAttribute(vastXML, adNode, "id", vvDoc.ads[adNum].properties.id); // Ad.id
		rootNode.appendChild(adNode);	
		// All wrappers' tracking is combined w/ final tag by now, so should always be InLine
		var inLine = adNode.appendChild(vastXML.createElement("InLine"));
		var adSystem = conditionalCreateCDATAInfoElement(vastXML, inLine, "AdSystem", vvDoc.ads[adNum].properties.AdSystem); 
		// TODO: I don't think we're collecting AdSystem.version yet
		if (adSystem != null)
		{
			conditionalCreateAttribute(vastXML, adSystem, "version", vvDoc.ads[adNum].properties.AdSystemVersion);
		}
		conditionalCreateCDATAInfoElement(vastXML, inLine, "AdTitle", vvDoc.ads[adNum].properties.AdTitle); 
		conditionalCreateCDATAInfoElement(vastXML, inLine, "Description", vvDoc.ads[adNum].properties.Description);
		conditionalCreateCDATAInfoElement(vastXML, inLine, "Survey", vvDoc.ads[adNum].properties.Survey);
		createTrackingElementsFromCollection(vastXML, inLine, "Impression", vvDoc.ads[adNum].impressions); // Impressions are unique in that they have an id that we have to take into consideration
		// TODO: We are breaking vast 2.0.1 and VAST 3 spec by allowing multiple errors (wrapper, children) and will need to extract them later, handle them out-of-bound or something
		createTrackingElementsFromCollection(vastXML, inLine, "Error", vvDoc.ads[adNum].errors);
		
		
		var creatives = inLine.appendChild(vastXML.createElement("Creatives"));
		// Add Linear
		if (vvDoc.ads[adNum].linear)
		{
			var creative = creatives.appendChild(vastXML.createElement("Creative"));
			var linear = creative.appendChild(vastXML.createElement("Linear"));
			var vvLinear = vvDoc.ads[adNum].linear;
			processAttributeList(vastXML, creative, vvLinear.creativeAttributes);
			conditionalCreateCDATAInfoElement(vastXML, linear, "Duration", makeVASTTime(vvDoc.ads[adNum].linear.duration)); 
			var trackingEvents = linear.appendChild(vastXML.createElement("TrackingEvents"));
			var events = vvLinear.tracking.events;
			createTrackingElementsFromCollection(vastXML, trackingEvents, "Tracking", events);
			var mediaFiles = linear.appendChild(vastXML.createElement("MediaFiles"));
			var vvmf = vvLinear.mediaFiles;
			for (var i = 0; i < vvmf.length; i++)
			{
				var mediaf = vvmf[i];
				var mediaFile = conditionalCreateCDATAInfoElement(vastXML, mediaFiles, "MediaFile", mediaf["src"]);
				conditionalCreateAttribute(vastXML, mediaFile, "id", mediaf["id"]);
				conditionalCreateAttribute(vastXML, mediaFile, "delivery", mediaf["delivery"]);
				conditionalCreateAttribute(vastXML, mediaFile, "type", mediaf["type"]);
				conditionalCreateAttribute(vastXML, mediaFile, "bitrate", mediaf["bitrate"]);
				conditionalCreateAttribute(vastXML, mediaFile, "width", mediaf["width"]);
				conditionalCreateAttribute(vastXML, mediaFile, "height", mediaf["height"]);
				conditionalCreateAttribute(vastXML, mediaFile, "scalable", mediaf["scalable"]);
				conditionalCreateAttribute(vastXML, mediaFile, "maintainAspectRatio", mediaf["maintainAspectRatio"]);
				conditionalCreateAttribute(vastXML, mediaFile, "apiFramework", mediaf["apiFramework"]);
			}
			var videoClicks = linear.appendChild(vastXML.createElement("VideoClicks"));
			if (typeof(events["click"]) != "undefined")
			{
				for (var i = 0; i < events["click"].length; i++)
				{
					conditionalCreateCDATAInfoElement(vastXML, videoClicks, "ClickTracking", events["click"][i].url);
				}
			}
			conditionalCreateCDATAInfoElement(vastXML, videoClicks, "ClickThrough", vvLinear.clickThrough);
			conditionalCreateCDATAInfoElement(vastXML, linear, "AdParameters", vvLinear.adParameters);
			
		}
		
		// Add NonLinear
		if (vvDoc.ads[adNum].nonlinears.length > 0)
		{
			var creative = creatives.appendChild(vastXML.createElement("Creative"))
			var nonLinearAds = creative.appendChild(vastXML.createElement("NonLinearAds"));
			
			var trackingEvents = nonLinearAds.appendChild(vastXML.createElement("TrackingEvents"));
			var events = vvDoc.ads[adNum].nonlinearsTracking.events;
			createTrackingElementsFromCollection(vastXML, trackingEvents, "Tracking", events);
				
			var vvDocNonLinears = vvDoc.ads[adNum].nonlinears;
			for (var j = 0; j < vvDocNonLinears.length; j++)
			{
				var vvNonLinear = vvDocNonLinears[j];
				var nonLinear = nonLinearAds.appendChild(vastXML.createElement("NonLinear"));
				processAttributeList(vastXML, creative, vvNonLinear.creativeAttributes);
				processAttributeList(vastXML, nonLinear, vvNonLinear.attributes);
				conditionalCreateCDATAInfoElement(vastXML, nonLinear, "NonLinearClickThrough", vvNonLinear.clickThrough);
				conditionalCreateCDATAInfoElement(vastXML, nonLinear, "AdParameters", vvNonLinear.adParameters);
				var vvResources = vvNonLinear.resources;
				conditionalCreateCDATAInfoElement(vastXML, nonLinear, "IFrameResource", vvResources.iframe);
				conditionalCreateCDATAInfoElement(vastXML, nonLinear, "HTMLResource", vvResources.html);
				for (var imgType in vvResources.images)
				{
					var staticResource = conditionalCreateCDATAInfoElement(vastXML, nonLinear, "StaticResource", vvResources.images[imgType]);	
					conditionalCreateAttribute(vastXML, staticResource, "creativeType", imgType)
				}
			}
		}
		
		// Add Companions
		if (vvDoc.ads[adNum].companions.length > 0)
		{
			var creative = creatives.appendChild(vastXML.createElement("Creative"))
			var companionAds = creative.appendChild(vastXML.createElement("CompanionAds"));
			var vvDocCompanions = vvDoc.ads[adNum].companions;
			for (var j = 0; j < vvDocCompanions.length; j++)
			{
				var companion = companionAds.appendChild(vastXML.createElement("Companion"));
				var vvCompanion = vvDocCompanions[j];
				processAttributeList(vastXML, creative, vvCompanion.creativeAttributes);
				processAttributeList(vastXML, companion, vvCompanion.attributes);
				var trackingEvents = companion.appendChild(vastXML.createElement("TrackingEvents"));
				var events = vvCompanion.tracking.events;
				createTrackingElementsFromCollection(vastXML, trackingEvents, "Tracking", events);
				conditionalCreateCDATAInfoElement(vastXML, companion, "CompanionClickThrough", vvCompanion.clickThrough);
				conditionalCreateCDATAInfoElement(vastXML, companion, "AltText", vvCompanion.altText);
				conditionalCreateCDATAInfoElement(vastXML, companion, "AdParameters", vvCompanion.adParameters);
				var vvResources = vvCompanion.resources;
				conditionalCreateCDATAInfoElement(vastXML, companion, "IFrameResource", vvResources.iframe);
				conditionalCreateCDATAInfoElement(vastXML, companion, "HTMLResource", vvResources.html);
				for (var imgType in vvResources.images)
				{
					var staticResource = conditionalCreateCDATAInfoElement(vastXML, companion, "StaticResource", vvResources.images[imgType]);	
					conditionalCreateAttribute(vastXML, staticResource, "creativeType", imgType)
				}
			}
		}
		
		var vvExtensions = vvDoc.ads[adNum].extensions;
		if (vvExtensions.length > 0)
		{
		
			var extensions = inLine.appendChild(vastXML.createElement("Extensions"));
			for (var i = 0; i < vvExtensions.length; i++)
			{
				// No CDATA here. Just trust what tag sent (otherwise we could end up with invalid XML from CDATA inside CDATA)
				var extension = extensions.appendChild(vastXML.createElement("Extension"));
				extension.appendChild(vastXML.createTextNode(vvExtensions[i].value));
				conditionalCreateAttribute(vastXML, extension, "type", vvExtensions[i].type)
			}
			
		}
	}
	
	var xmlSerializer = new XMLSerializer();
	var s = xmlSerializer.serializeToString(vastXML);
	if (s.indexOf("<?xml") == -1)
		s = '<?xml version="1.0" encoding="'+vastXML.characterSet+'"?>' + s;
	return s;
}