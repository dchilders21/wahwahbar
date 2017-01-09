function testErrorOut(msg)
{
	var div = document.getElementById("outputdiv");
	div.style.visibility="visible";
	msg = "test error: " + msg;
	div.innerHTML += msg + "<br>";
	console.error(msg);
}

function testMsgOut(msg)
{
	var div = document.getElementById("outputdiv");
	div.style.visibility="visible";
	msg = "test msg: " + msg;
	div.innerHTML += msg + "<br>";
	console.log(msg);
}

function prettyPrintXML(s)
{
	var sXML = vkbeautify.xml(s);
	sXML = sXML.replace(new RegExp("<", "g"), "&lt;");
	sXML = sXML.replace(new RegExp("\n", "g"), "<br>"); // Make sure to do this last (<br> has "<" in it)
	console.log(s);
	var div = document.getElementById("outputdiv");
	div.innerHTML += "<pre>" + sXML + "</pre>";
}


function getParameterByName(name)
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return decodeURIComponent(results[1].replace(/\+/g, " "));
}

var loadedXMLDoc = null;
function onQVSuccess(doc, identifier)
{
	testMsgOut("Loaded XML tag success. html5 request succeeded.");
	loadedXMLDoc = doc;
	setTimeout(function() { var sXML = wwSerialize(loadedXMLDoc); prettyPrintXML(sXML); playerTechChoice(loadedXMLDoc, sXML); } );
}

function onQVFailure(type, obj, identifier, url)
{
	switch(type)
	{
		case "request":
			var request = obj;
			testErrorOut("Failed requesting XML tag!");
			testErrorOut("readyState=" + request.readyState + " status=" + request.status);
			testErrorOut("url failure= " + url);
			if (request.status == 0)
			{
				testErrorOut("Probably CORS header missing. Call Flash!");
				failToFlash();
			}
			break;
		case "parse":
			testErrorOut("Failed parsing!");
			break;
	}
}

function failToFlash()
{
	testMsgOut("Call Flash here with url: " + xmlTag);
	callFlashURL(xmlTag);
}


function fatalError()
{
		testErrorOut("Call backup openx calls here through loader. this page unloads.")
}

var xmlTag = getParameterByName("xmlTag");
if (xmlTag != "")
{
	testMsgOut("Detected xmlTag parameter");
}
else
{
	testMsgOut("Loading default tag");
	// dfp test
	xmlTag = "http://test.wahwahnetworks.com/brian/vast-test/dfptesthtml5.xml";
// good wrapper
//	xmlTag = "http://test.wahwahnetworks.com/brian/vast-test/vast_wrapper_linear_1.xml";
// nocors error on final tag
//	xmlTag = "http://test.wahwahnetworks.com/brian/vast-test/vast_wrapper_nocors_vastadtaguri.xml";
// cors error on request pointed to by wrapper (Note: test.wahwahnetworks.com will not provide CORS headers, for now. See: http://serverfault.com/questions/393532/allowing-cross-origin-requests-cors-on-nginx-for-404-responses)
	// xmlTag = "http://test.wahwahnetworks.com/brian/vast-test/doesnotexist.doesnot";
	// sizmek
	// http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=is&c=23&pl=VAST&pli=10724976&PluID=0&pos=113&ord=[timestamp]&cim=1&t=1&ai=23227072
	// innovid
	// http://rtr.innovid.com/r1.5554946ab01d97.36996823;cb=%25%CACHEBUSTER%25%25
}

function playerTechChoice(loadedXMLDoc, sXML)
{
	var vvLinear = loadedXMLDoc.ads[0].linear;
	if (typeof(vvLinear) == "undefined" || vvLinear == null)
	{
		testErrorOut("VAST fatal error: No linear element")
		fatalError();
	}
	
	var vvmf = vvLinear.mediaFiles;
	var tagHTML5VPAID = false;
	var tagFlashVPAID = false;
	var tagFlashVideo = false;
	var tagHTML5Video = false;
	for (var i = 0; i < vvmf.length; i++)
	{
				var mediaf = vvmf[i];
				switch (mediaf["type"].toLowerCase())
				{
					case "video/x-flv":
					case "video/mp4":
						tagFlashVideo = true;
						break;
					case "application/X-shockwave-flash":
						if (mediaf["apiFramework"] && mediaf["apiFramework"].toLowerCase() == "vpaid")
							tagFlashVPAID = true;
						break;
					case "video/mp4":
					case "video/webm":
					case "video/ogg":
					case "video/3gp":
					// Todo: More specific browser checking. The files above don't work on every browser
						tagHTML5Video = true;
						break;
					case "application/javascript":
					
						if (mediaf["apiFramework"] && mediaf["apiFramework"].toLowerCase() == "vpaid")
						tagHTML5VPAID = true;
				}
	}
	
	testMsgOut("<br>\n<br>\n.......................................................................................<br>\n<br>\nDecision logic time");
	testMsgOut("tagHTML5Video: " + tagHTML5Video);
	testMsgOut("tagFlashVideo: " + tagFlashVideo);
	testMsgOut("tagHTML5VPAID: " + tagHTML5VPAID);
	testMsgOut("tagFlashVPAID: " + tagFlashVPAID);
				
	// Make decision
	if (tagHTML5Video || tagHTML5VPAID)
	{
		callHTML5(sXML);
	}
	else
	{
		callFlashXML(sXML);
	}
	
}



var cacheBusterReplaceArray = ["\\[timestamp\\]", "\\[cachebuster\\]", "\\[random\\]", "\\[randnum\\]"];
var cacheBuster = Math.round(100000000000 * Math.random());
function replaceWildcardWithCacheBuster( urlToTag)
{
	
	for(var i = 0; i < cacheBusterReplaceArray.length; i++)
	{
		urlToTag = urlToTag.replace(new RegExp(cacheBusterReplaceArray[i],"gi"), cacheBuster);
	}
			
	return urlToTag;
}


testMsgOut("xmlTag = " + xmlTag);
document.forms[0].xmlTag.value = xmlTag;
xmlTag = replaceWildcardWithCacheBuster(xmlTag);
queryVAST(xmlTag, "N/A", onQVSuccess, onQVFailure, null );

function callFlashURL(url)
{
	testMsgOut("Calling flash url: " + xmlTag);
	writeFlash(url, null);
}

function callFlashXML(xml)
{
	testMsgOut("Calling flash w/ XML");
	writeFlash(null, xml);
}

function writeFlash(url, xml)
{
	var swfurl = "./wahwahadplayer.swf";
	var attributes = 'data="' + swfurl + '" type="application/x-shockwave-flash"';
	if (typeof(window.ActiveXObject) != "undefined")
			attributes = 'codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,2,0" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"'; // IE9
	var vidWidth = 400;
	var vidHeight = 225;
	var audioVolume = 100;
	var hostaudio = true;
	var flashvars;
	if (xml != null)
		flashvars = 'AD_XML='+escape(xml)+'&SCALE=true&COUNTDOWN=false&HOSTAUDIO='+hostaudio+'&HOSTVOLUME='+audioVolume;
	else
		flashvars = 'AD_URL='+escape(url)+'&SCALE=true&COUNTDOWN=false&HOSTAUDIO='+hostaudio+'&HOSTVOLUME='+audioVolume;
	var objTag = '<object id="wahwahadplayer" name="wahwahadplayer" width="'+vidWidth+'" height="'+vidHeight+'" id="wahwahadplayer" '+attributes+'><param name="movie" value="' + swfurl + '" /><param name="FlashVars" value="'+flashvars+'" /><param name="allowfullscreen" value="true"/><param name="allowscr'+'iptaccess" value="always" /><param name="scale" value="noScale" /><param name="quality" value="best" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="transparent"/></object>';
	document.getElementById("vid").innerHTML = objTag;		
}

function callHTML5(xml)
{
	testMsgOut("Calling HTML5");
	//Wait until google object is ready
	if (typeof(google) == "undefined")
	{
		// Google not ready
		setTimeout(function() {
			callHTML5(xml)
		},200);
		return;
	}
	var player = videojs('content_video');

	var options = {
		id: 'content_video',
		/*
		adTagUrl: 'http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&' +
		  'iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&' +
		  'impl=s&gdfp_req=1&env=vp&output=xml_vmap1&unviewed_position_start=1&' +
		  'cust_params=sample_ar%3Dpremidpostpod%26deployment%3Dgmf-js&cmsid=496&' +
		  'vid=short_onecue&correlator=',
		  */
		  // SWF - Eyewonder
		//adTagUrl: 'https://raw.githubusercontent.com/dave-hansen/openvideoads/master/ova.flowplayer/dist/templates/ad-servers/eyewonder/vpaid-linear-01.xml',
		// Video - Google
		//adTagUrl: 'https://pubads.g.doubleclick.net/gampad/ads?sz=640x360&iu=/6062/iab_vast_samples/skippable&ciu_szs=300x250,728x90&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]',
		// VPAID
		adsResponse: xml,
		//adsResponse: '<?xml version="1.0" encoding="UTF-8"?><VAST xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="vast.xsd" version="2.0"> <Ad id="24283604">  <InLine>   <AdSystem>GDFP</AdSystem>   <AdTitle>IAB Vast Samples Skippable</AdTitle>   <Description><![CDATA[IAB Vast Samples Skippable ad]]></Description>   <Error><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplayfailed]]></Error>   <Impression><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=EsItuhXnHV4&cid=5GjC2Q]]></Impression>   <Creatives>    <Creative id="32948875124" AdID="ABCD1234567" sequence="1">     <Linear skipoffset="00:00:05">      <Duration>00:00:51</Duration>      <TrackingEvents>       <Tracking event="start"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=part2viewed]]></Tracking>       <Tracking event="firstQuartile"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime25]]></Tracking>       <Tracking event="midpoint"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime50]]></Tracking>       <Tracking event="thirdQuartile"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime75]]></Tracking>       <Tracking event="complete"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime100]]></Tracking>       <Tracking event="mute"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=admute]]></Tracking>       <Tracking event="unmute"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adunmute]]></Tracking>       <Tracking event="rewind"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adrewind]]></Tracking>       <Tracking event="pause"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adpause]]></Tracking>       <Tracking event="resume"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adresume]]></Tracking>       <Tracking event="fullscreen"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adfullscreen]]></Tracking>       <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=vast_creativeview]]></Tracking>       <Tracking event="acceptInvitation"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=acceptinvitation]]></Tracking>       <Tracking event="start"><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=2&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></Tracking>       <Tracking event="complete"><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=3&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></Tracking>      </TrackingEvents>      <VideoClicks>       <ClickThrough id="GDFP"><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&num=0&cid=5GjC2Q&sig=AOD64_2lPkQto5jahGRQWCT6P-rSHTXNZg&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></ClickThrough>       <ClickTracking id=""><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=6&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></ClickTracking>      </VideoClicks>      <MediaFiles>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/x-flv" bitrate="379" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.flv]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/mp4" bitrate="324" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.mp4]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="426" height="240" type="video/x-flv" bitrate="337" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpsmall.flv]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/webm" bitrate="348" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.webm]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="320" height="180" type="video/3gpp" bitrate="234" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.3gp]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="176" height="144" type="video/3gpp" bitrate="86" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpsmall.3gp]]></MediaFile>      </MediaFiles>     </Linear>    </Creative>    <Creative id="32948875244" sequence="1">     <CompanionAds>      <Companion id="32948875244" width="300" height="250">       <StaticResource creativeType="image/jpeg"><![CDATA[https://pagead2.googlesyndication.com/pagead/imgad?id=CICAgMCuxM7V8AEQrAIY-gEyCNhCTRcyGqqI]]></StaticResource>       <TrackingEvents>        <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BXelNij0NVpLnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOzfn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&sigh=DUeexRdTP4g&cid=5GjtFw]]></Tracking>       </TrackingEvents>       <CompanionClickThrough><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BXelNij0NVpLnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOzfn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&num=0&cid=5GjtFw&sig=AOD64_1eaOCS_691NzVEXYHvQ_adnG_0_Q&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></CompanionClickThrough>      </Companion>      <Companion id="32948875364" width="728" height="90">       <StaticResource creativeType="image/jpeg"><![CDATA[https://pagead2.googlesyndication.com/pagead/imgad?id=CICAgMCuxM728wEQ2AUYWjII2NvINDqWbhI]]></StaticResource>       <TrackingEvents>        <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BaDEZij0NVpTnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOTgn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&sigh=xTUO5onz1KM&cid=5Gjk_A]]></Tracking>       </TrackingEvents>       <CompanionClickThrough><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BaDEZij0NVpTnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOTgn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&num=0&cid=5Gjk_A&sig=AOD64_25UHFQ878oXGci2BG5abEQ-1TFlA&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></CompanionClickThrough>      </Companion>     </CompanionAds>    </Creative>   </Creatives>   <Extensions>    <Extension type="DFP"><SkippableAdType>Generic</SkippableAdType><CustomTracking> <Tracking event="engagedView"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=video_engaged_view]]></Tracking> <Tracking event="skip"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoskipped]]></Tracking> <Tracking event="skipShown"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=video_skip_shown]]></Tracking></CustomTracking></Extension>    <Extension type="activeview"><CustomTracking> <Tracking event="viewable_impression"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=viewable_impression&acvw=[VIEWABILITY]]]></Tracking></CustomTracking></Extension>    <Extension type="geo"><Country>US</Country><Bandwidth>3</Bandwidth><BandwidthKbps>1120</BandwidthKbps></Extension>    <Extension type="waterfall" fallback_index="0"/>   </Extensions>  </InLine> </Ad></VAST>',
		

		//adRenderingSettings: ,
		//contribAdsSettings: ,
		debug: true,
		locale: 'en',
		nonLinearWidth: 400,
		nonLinearHeight: 200,
		showCountdown: false,
		vpaidMode: google.ima.ImaSdkSettings.VpaidMode.ENABLED // ENABLED, INSECURE, DISABLED
		
	};
	
	
//adsLoader.getSettings().setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.INSECURE);

	player.ima(options);

	// Remove controls from the player on iPad to stop native controls from stealing
	// our click
	var contentPlayer =  document.getElementById('content_video_html5_api');
	if ((navigator.userAgent.match(/iPad/i) ||
		  navigator.userAgent.match(/Android/i)) &&
		contentPlayer.hasAttribute('controls')) {
	  contentPlayer.removeAttribute('controls');
	}

	// Initialize the ad container when the video player is clicked, but only the
	// first time it's clicked.
	var startEvent = 'click';
	if (navigator.userAgent.match(/iPhone/i) ||
		navigator.userAgent.match(/iPad/i) ||
		navigator.userAgent.match(/Android/i)) {
	  startEvent = 'tap';
	}


//player.one(startEvent, function() {
    player.ima.initializeAdDisplayContainer();
    player.ima.requestAds();
    player.play();
	// Is there a better way to do the following?
	var el = document.getElementById("content_video_html5_api");
	el.style.position="absolute";
	el.style.zIndex="1";
	el.style.top="0px";
	el.style.left="0px";
	el = document.getElementById("ima-ad-container");
	el.style.position="absolute";
	el.style.zIndex="2";
	el.style.top="0px";
	el.style.left="0px";
//});


}