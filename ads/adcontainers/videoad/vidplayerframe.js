
if (typeof console == "undefined")
{
    var console = {};
    wwLog = function () { };
}

// uuid is the only thing set, and only thing that needs to be set, in initial html's JS before this JS is written out
var wahwah = parent.rpSharedVarArray[uuid];

var widgetId = wahwah.id;

var id = wahwah.iframeVars.friendlyAdFramePlacementId;
var fifId = wahwah.iframeVars.friendlyAdFrameId;
var adConfig = wahwah.iframeVars.friendlyAdFrameConfig;
var adType = wahwah.iframeVars.friendlyAdFrameType;
var tbBase = wahwah.iframeVars.friendlyAdFrameBase;
var adBase = tbBase+"ads/adcontainers/videoad/";
var uaBrowser = wahwah.iframeVars.friendlyAdFrameUABrowser;
var clientFeatures = wahwah.clientFeatures;
var referrer = wahwah.iframeVars.friendlyAdFrameReferrerMacro;
var domain = wahwah.iframeVars.friendlyAdFrameDomainMacro;
var adXML = wahwah.iframeVars.friendlyAdFrameVASTPlayerVastXML;
var chosenAdTechnology = wahwah.iframeVars.friendlyAdFrameChosenAdTechnology;
var tagAdTechnologies = wahwah.iframeVars.friendlyAdFrameTagAdTechnologies;
var lineItemChosenMetadata = wahwah.iframeVars.friendlyAdFrameLineItemChosenMetadata;
var trackingInfo = 	lineItemChosenMetadata.trackingInfo;
/* trackingInfo": {
					"adid": ..,
					"cid": ..,
					"oseq": ..,
					"bp": ..,
					"bpt": ..,
					"pl": ..,
					"vb": ..,
					}*/

var customPubReportVals = "";
if (clientFeatures.hasOwnProperty("customPublisherReportKeyValues"))
{
	var customPubReportVals = JSON.stringify(clientFeatures["customPublisherReportKeyValues"]);
	// Macros
	customPubReportVals = customPubReportVals.replace(/\$\$/g,"${$}");
	customPubReportVals = customPubReportVals.replace(/\$\{REFERRER\}/gi,encodeURIComponent(referrer));
	customPubReportVals = customPubReportVals.replace(/\$\{DOMAIN\}/gi,encodeURIComponent(domain));
	customPubReportVals = customPubReportVals.replace(/\$\{\$\}/g,"$");
	openxPubCustom="&c.pub_custom="+encodeURIComponent(customPubReportVals);
}

var persistantClose = false;
if (wahwah.app == "adOnly")
{
	if (adConfig[adType].floater == true || adConfig[adType].vidWidth > adConfig[adType].displayWidth || adConfig[adType].vidHeight > adConfig[adType].displayHeight)
		persistantClose = true;
}

var hostaudio = false;
var audioVolume = 0;

var ModuleEnums = {
MODULE_LOADER: "Loader",
MODULE_TOOLBAR: "Toolbar",
MODULE_RADIO: "Radio",
MODULE_ADS: "Ads"
};


/* Avoid `console` errors in browsers that lack a console. Modified based on: http://html5boilerplate.com/ */ (function() { var method; var noop = function () {}; var methods = ['debug','error','info', 'log','warn']; var length = methods.length; var console = (window.console = window.console || {}); while (length--) { method = methods[length]; /* Only stub undefined methods. */ if (!console[method]) { console[method] = noop; } } }()); /* First, check if IE running in Quirks mode, which treats window.console.log as an object, not ECMAScript function, and doesn't support .call on that object */ if (typeof(window.console.log.call) != "function") { console.warn("[Wahwah] This debugger doesn't support console.* as a function / console.log.call, etc. Possibly IE in Quirks/Compatibility mode or Firebug. View on web or localhost (not local or intranet) and in HTML5 or use a debug toolbar that supports console.* as a true ECMAScript function.");  /* Next, create console.log placeholder if it doesn't exist */	window.console = { 	debug : function() {}, 	error: function() {}, info: function() {}, 	log: function() {}, warn: function() {} }; }; /* Create addListener placeholder, when it doesn't exist */ var addListener = function (e, t, n) { if ("addEventListener" in e) { e.addEventListener(t, n, true) } else if ("attachEvent" in e) { var r = function () { n(window.event) }; e.attachEvent("on" + t, r) } }; var removeListener = function (e, t, n) { if ("removeEventListener" in e) { e.removeEventListener(t, n, true) } else if ("detachEvent" in e) { var r = function () { n(window.event) }; e.detachEvent("on" + t, r) } }

// Todo: Pass up the parent window chain when possible
// Later, replace with htm5 BroadcastChannel message when all browsers support to decrease size
if (typeof(window.wwMsg) == "undefined")
{
	window.wwMsg = new function() {
		this._module = "Video Ads";
		this._prefix = function(module)
		{
			if (module == null)
			{
				module = this._module;
			}
			return "[Wahwah " + module + "] ";
		}
		this._debugLevelInt = function()
		{
			switch(wahwah.logLevel)
			{
				case "debug":
					return 3;
					break;
				case "info":
					return 2;
					break;
				case "warn":
					return 1;
					break;
				case "error":
					return 0;
					break;
				default:
					return 0;
			}
		}
		this.forceLogProto = function()
		{
			return console.log;
		}
		this.errorProto = function()
		{
			if (this._debugLevelInt() >= 0)
				return console.error;
			else
				return (function () {})
		}
		this.warnProto = function()
		{
			if (this._debugLevelInt() >= 1)
				return console.warn;
			else
				return (function () {})
		}
		this.logProto = function()
		{
			if (this._debugLevelInt() >= 2)
				return console.log;
			else
				return (function () {})
		}
		this.debugProto = function()
		{
			if (this._debugLevelInt() >= 3)
				return console.debug;
			else
				return (function () {})
		}
		this.infoProto = function() {return this.logProto()}


	}

		// easier minification
		var wwConsole = window.console;
		var wwPrefix = window.wwMsg._prefix(null);
		var wwLog = window.wwMsg.logProto();
		var wwWarn = window.wwMsg.warnProto();
		var wwDebug = window.wwMsg.debugProto();
		var wwError = window.wwMsg.errorProto();
		var wwInfo = window.wwMsg.infoProto();
		var wwForceLog = window.wwMsg.forceLogProto(); // Use sparingly
}


wwLog.call(wwConsole, wwPrefix, "~~~~~~~~vidplayerframe.js");
wwDebug.call(wwConsole, wwPrefix, "vidplayerframe ts=" + getTime());

	/////////////////////////////////////	
    // Tracking
    /////////////////////////////////////
	
	if (!Date.now) {
		Date.now = function() { return new Date().getTime(); }
	}
	
	// Centralize tracking to avoid issues
	function rpTrack(event, parameterPairs)
	{
		sendMessage("rpTrack", ModuleEnums.MODULE_LOADER, { "event": event, "parameterPairs": parameterPairs });
	}

	
	/////////////////////////////////////	
    // Listeners
    /////////////////////////////////////
	
	
var addListener = function (obj, event, handler)
{
    if (typeof addEventListener != "undefined")
    {
        obj.addEventListener(event, handler, true);
    } else if (typeof attachEvent != "undefined")
    {
        var newHandler = function ()
        {
            handler(window.event);
        };

        obj.attachEvent("on" + event, newHandler);
    }
};

var removeListener = function (obj, event, handler)
{
    if (typeof removeEventListener != "undefined")
    {
        obj.removeEventListener(event, handler, true);
    } else if (typeof detachEvent != "undefined")
    {
        var newHandler = function ()
        {
            handler(window.event);
        };

        obj.detachEvent("on" + event, newHandler);
    }
};



var adCall = adConfig[adType].vidURL;
var width = adConfig[adType].width;
var height = Math.floor(width *  9/16);

function startLoad()
{

	wwLog.call(wwConsole, wwPrefix, "vidplayerframe.startLoad ts=" + getTime());

	addListener(window, "message", handleMessage);
	removeListener(document, "DOMContentLoaded", startLoad);
	removeListener(window, "load", startLoad);

	//addListener(document.getElementById("play_toggle"), "mouseup", playpauseclick);
	//addListener(document.getElementById("audio_toggle"), "mouseup", muteunmuteclick);
	addListener(document.getElementById("replay_video"), "mouseup", replayclick);
	addListener(document.getElementById("vidPlayback"), "mouseenter", adOver);
	//addListener(document.getElementById("close"), "mouseenter", closeOver);


	if (adType == "interstitial")
	{
		// Remove element otherwise lang will write to it
		document.getElementById("countdown").style.display = "none";
	}
	rpTrack("adplayerloading", {
	/* Handled in loader
					"adid": trackingInfo.adid,
					"cid": trackingInfo.cid,
					"oseq": trackingInfo.oseq, */
					"browser": encodeURIComponent(uaBrowser),
					"videoTech": encodeURIComponent(JSON.stringify(tagAdTechnologies)),
					"chosenAdTechnology": chosenAdTechnology
					}  );

	if (chosenAdTechnology == "flash")
	{
		callFlashXML(adXML);
	}
	else
	{
		callHTML5(adXML);
	}

}

var vidPaused = false;
var audMuted = true;
var successfulLoad = false;
var closeAvailable = false;
function eiShowPlaying (play)
{
	wwLog.call(wwConsole, wwPrefix, "~~~ eiShowPlaying " + play);

	vidPaused = !play;
	if (vidPaused == false)
	{
		// Chrome was having a bug where it was using the background color of vidPlayback to affect alpha of the player
		document.getElementById("vidPlayback").style.backgroundColor = "white"; // Hack for Chrome
		if (successfulLoad == false) // Only call onAdSuccessfulLoad once
		{
			successfulLoad = true;
			sendMessage("onAdSuccessfulLoad", ModuleEnums.MODULE_LOADER, {"customCampaign": false, "customCampaignName": "", "isVideo": true });

			//document.getElementById("wahwahadplayer").eiPauseClick();

			window.clearTimeout(callTimer);
			wwLog.call(wwConsole, wwPrefix, "Stopped Timer");
		}
/*
		if (persistantClose)
		{
			if (document.getElementById("close"))
				document.getElementById("close").className = "show";
		}*/
		// Show play button, etc
		//document.getElementById("videoControls").style.visibility = "visible";
		//document.getElementById("replay_video").style.visibility = "visible";
		//document.getElementById("play_toggle").childNodes[0].src = './images/pause.png';
	}
	else
	{
		//document.getElementById("play_toggle").childNodes[0].src = './images/play.png';
	}

}
function eiShowMuted (muted)
{
	audMuted = muted;
	if (audMuted == true)
	{
		// Show audio toggle muted
		//document.getElementById("audio_toggle").innerHTML = "AUDON";
		document.getElementById("audio_toggle").childNodes[0].src = './images/audio_on.png';

	}
	else
	{
		//document.getElementById("audio_toggle").innerHTML = "AUDOFF";
		document.getElementById("audio_toggle").childNodes[0].src = './images/audio_off.png';
	}
}

function eiAdCompleted ()
{
	// Chrome was having a bug where it was using the background color of vidPlayback to affect alpha of the player
	document.getElementById("vidPlayback").style.backgroundColor = "transparent"; // Hack for Chrome; change back
	removeListener(vidPlayback, "mouseenter", adOver);
	removeListener(document.getElementById("replay_video"), "mouseup", replayclick);
	//removeListener(document.getElementById("close"), "mouseover", closeOver);
	wwDebug.call(wwConsole, wwPrefix, "vidplayerframe.eiAdCompleted ts=" + getTime());
	wwForceLog.call(wwConsole, wwPrefix, "Video ad play completed");
	sendMessage("onAdVideoPlayerComplete", ModuleEnums.MODULE_LOADER,"");
}

function eiAdError ()
{
	errorHandler("flashvpaiderror");
}

function errorHandler(errorType)
{
	wwDebug.call(wwConsole, wwPrefix, "vidplayerframe.eiAdError ts=" + getTime());
	wwForceLog.call(wwConsole, wwPrefix, "Video error: Invalid tag or other error uid="+uuid+" friendlyIframe="+fifId);
	sendMessage("onAdVideoPlayerError", ModuleEnums.MODULE_LOADER, errorType);

}


function eiCountdown(remaining, duration)
{
	window.setTimeout('updateCountdown('+remaining+','+duration+')',10);
}

/*
Macros for adConfig.*.vidCountdownNumFormat
${MM} remaining minutes for time in MM:SS format
${SS} remaining seconds for time in MM:SS format
${TMM} total minutes for time in MM:SS format
${TSS} total seconds for time in MM:SS format
${SEC} remaining seconds (where time is in only seconds)
${TSEC} total seconds (where time is in only seconds)
Example:
If there is 1 minute, 5 seconds left
${MM} = 1
${SS} = 05
${SEC} = 65
*/
function updateCountdown(remaining, duration)
{
	if (remaining < 0)
		remaining = 0;
	var countdownText = adConfig[adType].vidCountdownNumFormat;
	var remainMM = Math.floor(remaining/60);
	var totalMM = Math.floor(duration/60);
	var remainSS = Math.floor(remaining - remainMM*60);
	var totalSS = Math.floor(duration - totalMM*60);
	var timeDiff = duration - remaining; // Display close button only after user has seen :15 seconds of the video
	countdownText = countdownText.replace("${MM}",remainMM);
	countdownText = countdownText.replace("${SS}",(remainSS >= 10)?remainSS : "0" + remainSS);
	countdownText = countdownText.replace("${TMM}",totalMM);
	countdownText = countdownText.replace("${TSS}",(totalSS >= 10)?totalSS : "0" + totalSS);
	countdownText = countdownText.replace("${SEC}",Math.floor(remaining));
	countdownText = countdownText.replace("${TSEC}",Math.floor(duration));
	if (adType == "interstitial")
	{
		// Handle interstitial countdowns in the parent
		sendMessage("onUpdateCountdown", ModuleEnums.MODULE_LOADER,
			{
				"remaining": remaining,
				"duration": duration
			}
		);
		return;
	}
	else {

		/*if ((timeDiff >= 15)&(remaining!=0))  // sometimes the remaining comes up as 0 which causes timeDiff to hit 30
			closeAvailable = true; */
		//document.getElementById("countdown_counter").innerHTML = countdownText;
	}

}

function  playpauseclick()
{
// Todo: Make this also work for html5, however for now this shouldn't be called in toolbar/adonly
	if (vidPaused)
		document.getElementById("wahwahadplayer").eiPlayClick();
	else
		document.getElementById("wahwahadplayer").eiPauseClick();
}

function  muteunmuteclick()
{
// Todo: Make this also work for html5, however for now this shouldn't be called in toolbar/adonly
	if (audMuted)
		document.getElementById("wahwahadplayer").eiUnMuteClick();
	else
		document.getElementById("wahwahadplayer").eiMuteClick();
}

function  replayclick()
{
	audMuted = false;
	if (chosenAdTechnology == "flash")
	{
		document.getElementById("wahwahadplayer").eiUnMuteClick(); // Because replay doesn't actually turn on volume
		document.getElementById("wahwahadplayer").eiReplayClick();
	}
	else
	{

		html5Player.muted(false);
		html5Player.ima.getAdsManager().setVolume(1.0);
		/* Can't figure out how to seek properly  **
		html5Player.ima.getAdsManager().pause();
		html5Player.currentTime(0);
		html5Player.ima.getAdsManager().resume();
		*/
	}

	document.getElementById("replay_video").style.visibility = "hidden";
}

function adOver()
{
	//removeListener(vidPlayback, "mouseenter", adOver);
	document.getElementById("replay_video").className = "show";
	addListener(document.getElementById("replay_video"), "mouseenter", replayOver);
	addListener(document.getElementById("vidPlayback"), "mouseleave", adOut);

	/*if (!persistantClose)
		document.getElementById("close").className = "show";*/

}

function adOut()
{
	//removeListener(vidPlayback, "mouseenter", adOut);
	document.getElementById("replay_video").className = "";
	/*if (!persistantClose)
		document.getElementById("close").className = "";*/
	addListener(document.getElementById("vidPlayback"), "mouseenter", adOver);
}

function replayOver()
{
	removeListener(replay_video, "mouseenter", replayOver);
	document.getElementById("replay_video").className = "over";
	addListener(document.getElementById("replay_video"), "mouseleave", replayOut);
}

function replayOut()
{
	removeListener(replay_video, "mouseenter", replayOut);
	document.getElementById("replay_video").className = "show";
	addListener(document.getElementById("replay_video"), "mouseenter", replayOver);
}

function closeOver() {
	removeListener(vidPlayback, "mouseenter", adOut);
	//removeListener(document.getElementById("close"), "mouseenter", replayOut);
	//addListener(document.getElementById("close"), "mouseup", function(e) {
		if (chosenAdTechnology == "flash")
		{
			// Temporary Fix for Chrome
			document.getElementById("wahwahadplayer").eiMuteClick();
			// End Temp Fix
		}
		else
		{
			html5Player.muted(true); // Probably overkill
			html5Player.ima.getAdsManager().setVolume(1.0); // Probably overkill
			html5Player.ima.getAdsManager().stop(); // Important (tracking, etc)
		}

		sendMessage("videoClosed", ModuleEnums.MODULE_LOADER,"");

}


function handleMessage(evt)
{
	if (!evt) evt = window.event;

	try {
		var messageObj = JSON.parse(evt.data);
	} catch(e) {
		return;
	}

	if (messageObj.type == "disableInpageAds")
	{
		inpageVideoAdsDisabled = true;
		// Next release, make it inpageAdsDisabled
		//inpageAdsDisabled = true;
		collapseAd();
	}

	if (messageObj.type == "closeVideo") {
		closeOver();
	}

	if (messageObj.type == "showVideo") {
		document.getElementById("vidPlayback").className = "show";
	}
}

function sendMessage(type,destinationModule,messageContentObj)
{
	var messageObj =
	{
		type: type,
		destination: destinationModule,
		content: messageContentObj,
		vendor: "WahWah",
		id: id
	};

	var message = JSON.stringify(messageObj);
	parent.postMessage(message, "*");
}

// Performance
function getTime() // It's fine if performance.now() isn't supported, as long as you call this routine for t1 and t2
{
	try
	{
		return window.performance.timing.navigationStart - 1403494338000 /* 6/23/2014 @ 3:32:18 GMT */ + window.performance.now();	// More accurate
	}
	catch(e)
	{
		return ( new Date().getTime);
	}
}

if (adConfig[adType].audioVolume != 0)
{
	audioVolume = adConfig[adType].audioVolume;
	hostaudio = true;
}

// CONTENT

var cb = (new Date().getTime());
var swfurl = adBase + "/wahwahadplayer.swf?cb=" + cb;
wwDebug.call(wwConsole, wwPrefix, "Ad Player URL: " + swfurl);

document.writeln("<div id=\"vidPlayback\" class=\"\">");
/*document.writeln("	<div id=\"close\"></div>");*/
document.writeln("	<div id=\"replay_video\"><img src=\"./images/unmute.png\" /><p>Audio On</p></div>");
document.writeln("</div>	");



// Important: For local testing, need to enable trusted location where you locate these files for EI to work and
// ad to contract on end of video ad
// http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html

if (document.readyState === "complete")
{
	setTimeout(startLoad);
}
else
{
	addListener(document, "DOMContentLoaded", startLoad);
	addListener(window, "load", startLoad);
}

window.IN_FRIENDLY_FRAME = true;
// html5 player
document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"./vast-vmap/vast-vmap.js\"></scr"+"ipt>");
//document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"./videojs/video.js\"></scr"+"ipt>");
// Just always use video.dev.js since we do our own minification
document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"./videojs/video.dev.js\"></scr"+"ipt>");
document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"./videojs-ads/videojs.ads.js\"></scr"+"ipt>");
document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"./ima-plugin/videojs.ima.js\"></scr"+"ipt>");
document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"//imasdk.googleapis.com/js/sdkloader/ima3.js\"></scr"+"ipt>");
// lang for controls
// document.writeln("<scr"+"ipt type=\"text/javascr"+"ipt\" src=\"../../lang.js\" defer=\"defer\"></scr"+"ipt>");


// Todo: Do we still use this? I don't think so..
function fatalError()
{
		wwError.call(wwConsole, wwPrefix, "Call next demand source. this page unloads.")
		errorHandler("unknownfatalerror");
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

function callFlashURL(url)
{
	wwLog.call(wwConsole, wwPrefix, "Calling flash url: " + xmlTag);
	writeFlash(url, null);
}

var callTimer;
var counter = 1;

function callFlashXML(xml)
{
	wwLog.call(wwConsole, wwPrefix, "Calling XML into Flash");
	wwDebug.call(wwConsole, wwPrefix, "XML: " + xml);

	writeFlash(null, xml);

	wwDebug.call(wwConsole, wwPrefix, "Starting timer... ");
	callTimer = window.setTimeout(timedOut, 8000);
}


function timedOut() {
	wwDebug.call(wwConsole, wwPrefix, "Timed Out...");
	window.clearTimeout(callTimer);
	errorHandler("timeout");
}

function writeFlash(url, xml)
{
	var swfurl = "./wahwahadplayer.swf";
	var attributes = 'data="' + swfurl + '" type="application/x-shockwave-flash"';
	if (typeof(window.ActiveXObject) != "undefined")
			attributes = 'codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,2,0" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"'; // IE9
	var vidWidth = adConfig.inpage.vidWidth;
	var vidHeight = adConfig.inpage.vidHeight;
	var flashvars;
	if (xml != null)
		flashvars = 'AD_XML='+escape(xml)+'&SCALE=true&COUNTDOWN=false&HOSTAUDIO='+hostaudio+'&HOSTVOLUME='+audioVolume;
	else
		flashvars = 'AD_URL='+escape(url)+'&SCALE=true&COUNTDOWN=false&HOSTAUDIO='+hostaudio+'&HOSTVOLUME='+audioVolume;
	var objTag = '<object id="wahwahadplayer" name="wahwahadplayer" width="'+vidWidth+'" height="'+vidHeight+'" id="wahwahadplayer" '+attributes+'><param name="movie" value="' + swfurl + '" /><param name="FlashVars" value="'+flashvars+'" /><param name="allowfullscreen" value="true"/><param name="allowscr'+'iptaccess" value="always" /><param name="scale" value="noScale" /><param name="quality" value="best" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="transparent"/></object>';
	var div = document.createElement('div');
	document.getElementById("vidPlayback").appendChild(div);
	div.innerHTML += objTag;
}


  var adEvents;


function _onAdEvent(event) {
  wwLog.call(wwConsole, wwPrefix, '*****Ad event: ' + event.type);
  switch (event.type)
  {
  		case google.ima.AdEvent.Type.ALL_ADS_COMPLETED:
			// eiAdCompleted();
		break;
		case google.ima.AdEvent.Type.CLICK:

		break;
		case google.ima.AdEvent.Type.IMPRESSION:
		// DO NOT TRACK ANY IMPRESSIONS HERE!!!! JUST USE THIS TO CONSIDER PLAYER LOADED
		html5StartMessages();
			 if (audMuted)
			 {
				// Override
				html5Player.muted(true);
				html5Player.ima.getAdsManager().setVolume(0.0);
				wwInfo.call(wwConsole, wwPrefix, "STARTED - Change Ad Volume to 0/muted");
			}
		break;
		case google.ima.AdEvent.Type.COMPLETE:
			// Only support one ad at a time for now (may change later?)
			eiAdCompleted();
		break;
		case google.ima.AdEvent.Type.FIRST_QUARTILE:
			 if (audMuted)
			 {
				// Override
				html5Player.muted(true);
				html5Player.ima.getAdsManager().setVolume(0.0);
				wwInfo.call(wwConsole, wwPrefix, "FIRST_QUARTILE - Change Ad Volume to 0/muted");
			}
		break;
		case google.ima.AdEvent.Type.LOADED:

		break;
		case google.ima.AdEvent.Type.MIDPOINT:

		break;
		case google.ima.AdEvent.Type.PAUSED:

		break;
		case google.ima.AdEvent.Type.STARTED:
			 if (audMuted)
			 {
				// Override
				html5Player.muted(true);
				html5Player.ima.getAdsManager().setVolume(0.0);
				wwInfo.call(wwConsole, wwPrefix, "STARTED - Change Ad Volume to 0/muted");
			}
		break;
		case google.ima.AdEvent.Type.THIRD_QUARTILE:

		break;
		case google.ima.AdEvent.Type.VOLUME_CHANGED:
			 if (audMuted)
			 {
				// Override
				html5Player.muted(true);
				html5Player.ima.getAdsManager().setVolume(0.0);
				wwInfo.call(wwConsole, wwPrefix, "OVERRIDE Ad Volume changed - IMA: " + html5Player.ima.getAdsManager().getVolume()) + " set back to 0/muted";
			}
			else
				wwInfo.call(wwConsole, wwPrefix, "Ad Volume changed - IMA: " + html5Player.ima.getAdsManager().getVolume());
		break;
	}
}

function imaLoaded(event)
{

	// Doesn't seem to do anything with IMA (it either treats it as on or off)
	html5Player.ima.getAdsManager().setVolume(audioVolume / 100);

	 adEvents = [
	 	google.ima.AdEvent.Type.MUTED,
	 	google.ima.AdEvent.Type.IMPRESSION,
		google.ima.AdEvent.Type.ALL_ADS_COMPLETED,
		google.ima.AdEvent.Type.CLICK,
		google.ima.AdEvent.Type.COMPLETE,
		google.ima.AdEvent.Type.FIRST_QUARTILE,
		google.ima.AdEvent.Type.LOADED,
		google.ima.AdEvent.Type.MIDPOINT,
		google.ima.AdEvent.Type.PAUSED,
		google.ima.AdEvent.Type.STARTED,
		google.ima.AdEvent.Type.THIRD_QUARTILE, 
		google.ima.AdEvent.Type.VOLUME_CHANGED
	  ];

		// Adsmanager loaded
		  wwLog.call(wwConsole, wwPrefix,'*****imaLoaded event: ' + event.type);

		  for (var index = 0; index < adEvents.length; index++) {
			html5Player.ima.addEventListener(
				adEvents[index],
				_onAdEvent);
		  }
			html5Player.ima.startFromReadyCallback();

}

function callHTML5(xml)
{
	wwLog.call(wwConsole, wwPrefix, "Calling HTML5 with XML");
	wwDebug.call(wwConsole, wwPrefix, "XML: " + xml);
	//Wait until google object is ready
	if (typeof(google) == "undefined")
	{
		// Google not ready
		setTimeout(function() {
			callHTML5(xml)
		},200);
		return;
	}

  var div = document.createElement('div');
  document.getElementById("vidPlayback").appendChild(div);
  div.innerHTML += ''
  + ' <video id="content_video" class="video-js vjs-default-skin" preload="auto" width="'+adConfig.inpage.vidWidth+'" height="'+adConfig.inpage.vidHeight+'" >'
// uppress error on initial load    + '  <source src="about:blank" type="video/mp4" ></source>'
  + ' </video>';
  html5Player = videojs('content_video');
  var player = html5Player;

  var options = {
      id: 'content_video',
      adsResponse: xml,
      //adRenderingSettings: ,
      //contribAdsSettings: ,
      debug: false,
      locale: 'en',
      nonLinearWidth: adConfig.inpage.vidWidth,
      nonLinearHeight: adConfig.inpage.vidHeight,
      showCountdown: false,
      vpaidMode: google.ima.ImaSdkSettings.VpaidMode.ENABLED // ENABLED, INSECURE, DISABLED

  };

	if (wahwah.logLevel == "debug" || wahwah.debugMode == true)
	{
		options.debug = true;
	}


//adsLoader.getSettings().setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.INSECURE);


	player.ima(options, imaLoaded);

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
	player.muted(!hostaudio);
	// throws an error here line 224 of videojs.ima.js player.volume = audioVolume/100;	// percent as fraction
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

	callTimer = window.setTimeout(timedOut, 8000);

}

var html5Player;





function html5StartMessages()
{

	eiShowPlaying (true);
}

