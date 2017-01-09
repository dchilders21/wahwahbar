(function ()
{	
    var wahwah = window.wahwah;
	adConfig = wahwah.adconfig;
	var widgetId = wahwah.id;
	// Multiple widget in same page support
	function createUniqueRandomNumber()
	{
		var a = (new Date().getTime())- 946702800000; /* now minus 01-01-2000 */
		var b = Math.floor(Math.random() * 999 + 1) * Math.pow(10,13);
		return a+b
	}
    var uuid = createUniqueRandomNumber();
	wahwah.uuid = uuid;
	
	/////////////////////////////////////	
    // Tracking
    /////////////////////////////////////
	
	var trackURL = "http://t.platformpanda.com/rpt.gif?";
	
	if (!Date.now) {
		Date.now = function() { return new Date().getTime(); }
	}
	
	var imgArray = [];

	function rpAddImage(img){
		var current = imgArray.length;
		imgArray[current] = document.createElement("img");
		imgArray[current].setAttribute("src", img);
	}
	
	// Also update in vidplayerframe.js
	function rpTrack(event, parameterPairs)
	{
		
		var ts = Date.now();
		var url = generateTrackUrl(event, parameterPairs, ts);
		rpAddImage(url); 
		// Do console message after to track asap. Because we track request almost immediately, don't use rpMsg stuff here
		logMsg = "event:" + event + " widgetId:" + widgetId + " uuid:" + uuid + " ts:" + ts;
		if (typeof(wwLog) != "undefined")
			wwLog.call(wwConsole, wwPrefix, logMsg);
		else if (typeof(console.log) != "undefined")
		{
			console.log("[Wahwah Loader]  " + logMsg);
		}
		
	}
	
	function generateTrackUrl(event, parameterPairs, ts) // Allows calling directly to generate tracker url for VAST embed
	{
		var str = "";
		
		if (lineItemChosenMetadata != null && lineItemChosenMetadata.trackingInfo != null)
		{
			if (event == "advastevent" || event == "opportunity" || event == "adimpression" || event == "adclose" || event == "adplayerloading" || event == "adpassback")
			{
				parameterPairs["oseq"] = lineItemChosenMetadata.trackingInfo.oseq;
				parameterPairs["cid"] = lineItemChosenMetadata.trackingInfo.cid;
				parameterPairs["adid"] = lineItemChosenMetadata.trackingInfo.adid;
			}
		}
		
		if (parameterPairs != null)
			{
			for (key in parameterPairs)
			{
				str += "&" + key + "=" + parameterPairs[key];
			}
		}
		var url = trackURL + "event=" + event + "&u=" + uuid + "&prd=" + widgetId + "&ts=" + ts + str;
		return url;
	}
	
	
	/////////////////////////////////////	
    // Init tracker
    /////////////////////////////////////
	
	// We call this first because errors could happen when
	// gathering info for init tracker
	rpTrack("init", null);
	
	/////////////////////////////////////	
    // Request tracker
    /////////////////////////////////////
	
    function getDisplayType() // formerly getPlacementType
    {
    	var displaySize = screen.width;

    	if (displaySize <= 1024) {
            return "Mobile";
        } else if (displaySize > 1024) {
            return "Desktop";
        }

    }
	
	var ua = navigator.userAgent
	var isMobile = ua.indexOf("Mobile") != -1;
	var uaBrowser = "Unknown";
	if (ua.indexOf("Chrome/") != -1)
		uaBrowser = "Chrome";
	if ((ua.indexOf("Safari/") != -1 || ua.indexOf("AppleWebKit/") != -1) && !(uaBrowser == "Chrome"))
		uaBrowser = "Safari";
	if (ua.indexOf("Opera") != -1)
		uaBrowser = "Opera";
	if (uaBrowser == "Unknown")
	{
		if (ua.indexOf("MSIE") != -1 || ua.indexOf("Trident/") != -1)
			uaBrowser = "IE";
		else if (ua.indexOf("Edge/") != -1)
		{
				uaBrowser = "Edge";
		}
		else
		{
			if (ua.indexOf("Mozilla") != -1 && ua.indexOf("WebKit") == -1 && ua.indexOf("KHTML") == -1 && ua.indexOf("like Gecko") == -1)
				uaBrowser = "Firefox"; // Just treat all Mozilla browsers as Firefox, so know check against string "Firefox"
		}
	}
	
	
	var referrer = document.referrer || window.location.href;
	var domain = (referrer.split("//")[1]).split('/')[0];

    if (typeof(rpSharedVarArray) == 'undefined') { rpSharedVarArray = []; }
    rpSharedVarArray[uuid] = wahwah;
	
	
	rpTrack("request", {"displayType" : getDisplayType(), "domain": domain, "browser": uaBrowser} );
	

	
	rpTrack("garbage_bad_tracker", {'foo': 'bar'});
	
    /////////////////////////////////////	
    // Init
    /////////////////////////////////////
	

    var mainWindow = window;
    var pubInDapIFContainer = null;
    var pubInDapIFFrame = null;
    var pubInDapIFWindow = null;
	
	
	if (typeof(window.rpSharedVarArray) == 'undefined') { window.rpSharedVarArray = []; }
	window.rpSharedVarArray[uuid] = rpSharedVarArray[uuid];

	
	// DEBUGGING
	
	var isDebug = false;
	if (typeof(wahwah.DEBUG_MODE) != "undefined" && wahwah.DEBUG_MODE.toString() == "true") 
		isDebug = true;
	wahwah.adconfig["DEBUG_MODE"] = isDebug;	// For use in ad modules
	
	if (typeof(wahwah.logLevel) == "undefined")
		wahwah.logLevel = "info";
	if (typeof(wahwah.debugMode) != "undefined" && wahwah.debugMode == true)
		wahwah.logLevel = "debug";
		
	if (!Date.now) {
		Date.now = function() { return new Date().getTime(); }
	}
	

    /////////////////////////////////////	
    // Client features
    /////////////////////////////////////
	

	if (!wahwah.hasOwnProperty("clientFeatures"))
	{
		wwLog.call(wwConsole, wwPrefix, "clientFeatures: NONE");
		wahwah.clientFeatures = {};
	}
	else
	{
		var msg = "clientFeatures: ";
		for (name in wahwah.clientFeatures) 
		{
			if (wahwah.clientFeatures.hasOwnProperty(name)) 
			{
				msg += name + ",";
			}
		}
		msg = msg.slice(0, -1); // last comma
	}
	
	
	if (wahwah.clientFeatures.hasOwnProperty("customPublisherReportKeys"))
	{ 
		wwLog.call(wwConsole, wwPrefix, "clientFeature - customPublisherReportKeys:");
		var WAHWAH_PARSED_PUBLISHER_KEYS = wahwah.clientFeatures.customPublisherReportKeyValues = {};
		// customPublisherReportKeys should always be in charge of what publisher report keys are sent, because platform needs to know
		var reportKeysArray = wahwah.clientFeatures.customPublisherReportKeys.split(";");
		for (var idx = 0; idx < reportKeysArray.length; idx++) 
		{
		
			var key = reportKeysArray[idx];
			// If it's a key in WAHWAH_PUBLISHER_KEYS, add it. If it's a missing key, make it null.
			if ( typeof(WAHWAH_PUBLISHER_KEYS) != "undefined" && WAHWAH_PUBLISHER_KEYS.hasOwnProperty(key))
			{
				WAHWAH_PARSED_PUBLISHER_KEYS[key] = WAHWAH_PUBLISHER_KEYS[key];
				wwLog.call(wwConsole, wwPrefix, "customPublisherReportKeys[" + key + "] = '"+WAHWAH_PARSED_PUBLISHER_KEYS[key]+"'");
			}
			else
			{
				// If it's a missing key, make it null and throw a warning
				WAHWAH_PARSED_PUBLISHER_KEYS[key] = null;
				wwWarn.call(wwConsole, wwPrefix, "customPublisherReportKeys[" + key + "] not found (re-traffic tag?). Setting to null");
			}
		}
		// If it's in WAHWAH_PUBLISHER_KEYS but no longer in customPublisherReportKeys, warn. (Need to retraffic?)
		if ( typeof(WAHWAH_PUBLISHER_KEYS) != "undefined" )
		{
			for (key in WAHWAH_PUBLISHER_KEYS) 
			{
				if (!WAHWAH_PARSED_PUBLISHER_KEYS.hasOwnProperty(key))
				{
					wwWarn.call(wwConsole, wwPrefix, "WAHWAH_PUBLISHER_KEYS[" + key + "] has been removed on platform and will be ignored. Re-traffic?");
				}
			}
		}
	}

	/////////////////////////////////////	
	// Messaging
	/////////////////////////////////////
		
		
	/* Avoid `console` errors in browsers that lack a console. Modified based on: http://html5boilerplate.com/ */ (function() { var method; var noop = function () {}; var methods = ['debug','error','info', 'log','warn']; var length = methods.length; var console = (window.console = window.console || {}); /* Loader.js only */ window.oldConsole = console; /* End Loader.js only */ while (length--) { method = methods[length]; /* Only stub undefined methods. */ if (!console[method]) { console[method] = noop; } } }()); /* First, check if IE running in Quirks mode, which treats window.console.log as an object, not ECMAScript function, and doesn't support .call on that object */ if (typeof(window.console.log.call) != "function") { console.warn("[Wahwah] This debugger doesn't support console.* as a function / console.log.call, etc. Possibly IE in Quirks/Compatibility mode or Firebug. View on web or localhost (not local or intranet) and in HTML5 or use a debug toolbar that supports console.* as a true ECMAScript function.");  /* Next, create console.log placeholder if it doesn't exist */	window.console = { 	debug : function() {}, 	error: function() {}, info: function() {}, 	log: function() {}, warn: function() {} }; }; /* Create addListener placeholder, when it doesn't exist */ var addListener = function (e, t, n) { if ("addEventListener" in e) { e.addEventListener(t, n, true) } else if ("attachEvent" in e) { var r = function () { n(window.event) }; e.attachEvent("on" + t, r) } }; var removeListener = function (e, t, n) { if ("removeEventListener" in e) { e.removeEventListener(t, n, true) } else if ("detachEvent" in e) { var r = function () { n(window.event) }; e.detachEvent("on" + t, r) } }

	// Todo: Pass up the parent window chain when possible
	// Later, replace with htm5 BroadcastChannel message when all browsers support to decrease size
	

	if (typeof(window.rpMsg) == "undefined")
	{
		window.rpMsg = new function() {
			this._module = "Loader";
			this._prefix = function(module)
			{
				if (module == null)
				{
					module = this._module;
				}
				var m = "[Wahwah " + module + "]";
				if (typeof(wahwah.id) != "undefined")
					m = m + "["+wahwah.id+"]";
				return m;
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
	}

    // easier minification
    var wwConsole = window.console;
    var wwPrefix = window.rpMsg._prefix(null);
    var wwLog = window.rpMsg.logProto();
    var wwWarn = window.rpMsg.warnProto();
    var wwDebug = window.rpMsg.debugProto();
    var wwError = window.rpMsg.errorProto();
    var wwInfo = window.rpMsg.infoProto();
    var wwForceLog = window.rpMsg.forceLogProto(); // Use sparingly
	
    var domain = wahwah.domain, baseUrl = wahwah.baseUrl;

    wwForceLog.call(wwConsole, wwPrefix, 'Red Panda :: ' + wahwah.version);
	wwForceLog.call(wwConsole, wwPrefix, 'Widget Id: ' + wahwah.id);
	wwLog.call(wwConsole, wwPrefix, 'Domain: ' + domain + ' | Base URL: ' + baseUrl);
	wwForceLog.call(wwConsole, wwPrefix, "Debug level: " + wahwah.logLevel + " (" + window.rpMsg._debugLevelInt() + ")");
	if (typeof(window.__RedPanda_Passback) != "undefined")
	{
		wwForceLog.call(wwConsole, wwPrefix, 'Parent network ad detected. This is a marketplace ad. Passback to network tag supported');
	}
	
	function windowLoaded()
	{
		if (!domAccessible)
			domAvailable();
			
		rpTrack("pageloaded", null);
		
        removeListener(window, "load", windowLoaded);	
	}
	
	function domAvailable()
	{	
		if (domAccessible)
			return;
			
		domAccessible = true;
		
		rpTrack("pageready", null);
		
		
		wwDebug.call(wwConsole, wwPrefix, "DOM now available. Sending " + msgQueue.length + " queued messages."); // Todo - is it even possible to have queued messages?
		
	    removeListener(document, "DOMContentLoaded", domAvailable);
		
		for (var i in msgQueue)
		{
			receiveMessage(msgQueue[i]);	// Only send message after DOM is available
		}
		
		if (!isLoaded)
			startLoad();
	}
	
	
    /////////////////////////////////////	
    // Start functionality
    /////////////////////////////////////
	
	var startTime = getTime();
	wwDebug.call(wwConsole, wwPrefix, "start time ts="+ startTime);

	var isLoaded = false;
	var domAccessible = false;

	var msgQueue = [];

	
	
/////////////////////////////////////	
// InDapIF friendly iframe functionality
/////////////////////////////////////
	
    wwLog.call(wwConsole, wwPrefix, "Checking for inDapIF/inFIF friendly frame...");
    if (window.inDapIF == true || window.inFIF == true)
    {
    	// If we are just serving standard inAd Format don't need to do anything here
    	if (!((inAd)&&(!breakOutAd))||(purchBusinessNewsDaily)||(marketPlaceTag)) {

	        mainWindow = parent;
			mainWindow.wahwah = wahwah;
	        // Now find container div
	        window.uuid = uuid;
	        var parentIframes = mainWindow.document.getElementsByTagName("iframe");
	        // If we are breaking out of the inPage Ad we don't want to target the FiF
	        for (var frmItr = 0; frmItr < parentIframes.length; frmItr++)
		    {
		        	// Looking to see if we're in a FiF
		        try {
			        if (parentIframes[frmItr].contentWindow === window)
			        {
			            wwDebug.call(wwConsole, wwPrefix, "Friendly Frame Match found");

				        if (!breakOutAd) { // Should remodify this a bit
			                
				            wwDebug.call(wwConsole, wwPrefix, "Assigning pubInDapIFContainer..." + parentIframes[frmItr].parentNode);
						    pubInDapIFContainer = parentIframes[frmItr].parentNode;
						    pubInDapIFFrame = parentIframes[frmItr];
						    pubInDapIFWindow = parentIframes[frmItr].contentWindow;
					    	
					    	if (typeof(mainWindow.rpSharedVarArray) == 'undefined') { mainWindow.rpSharedVarArray = []; }
					    	
					    	mainWindow.rpSharedVarArray[uuid] = rpSharedVarArray[uuid];

					    	if (purchBusinessNewsDaily) { 
                                wwDebug.call(wwConsole, wwPrefix, "We are on Purch Business News Daily");
                                if(findPosY(pubInDapIFFrame) >= 1500) {
                                    wwDebug.call(wwConsole, wwPrefix, "Not the highest FiF so stopping the loading...");
                                    return;
                                }
                            }
					    	// targeting the parent window for now
					    	//initMessaging(parentIframes[frmItr].contentWindow);
					    	initMessaging(parent.window);
				        } else {
				            wwDebug.call(wwConsole, wwPrefix, "But we're 'Breaking Out' so don't want to use pubInDapIFContainer");
				            initMessaging(parent.window);
				            pubInDapIFFrame = parentIframes[frmItr];
				        }
				    }
			    } 

		        catch(e)
		        {
		            console.log("access error. shouldn't happen");  // BB - temp
		        }
		    }

		    // Need to switch the window back to the current window
			// for Purch...Just needed to find the pubInDapIFContainer so we can resize it
			if (purchBusinessNewsDaily)
			    mainWindow = window;
		}
    }

    // Need to target the window that we use to wait for the DOM to load
    // Either the DFP FiF or the mainWindow
    var targetWindow = pubInDapIFWindow || mainWindow;

    /////////////////////////////////////	
    // Main functionality
    /////////////////////////////////////

	// Replace macros
	
	
	var referrer = document.referrer || window.location.href;
	var domain = (referrer.split("//")[1]).split('/')[0];
	var pageURI = window.location.href || '';
	
		
	// Don't use for huge strings with lots of replacements. It's about 50% slower than global regex replace
	function replaceAll(target, search, replacement) 
	{
		return target.split(search).join(replacement);
	}
	
	function replaceMacros(url)
	{
		wwDebug.call(wwConsole, wwPrefix, "replaceMacros starting url="+ url);
		var vidWidth = wahwah.adconfig["inpage"]["vidWidth"];
		var vidHeight = wahwah.adconfig["inpage"]["vidHeight"];
		var width = wahwah.adconfig["inpage"]["displayWidth"];
		var height = wahwah.adconfig["inpage"]["displayHeight"];
		
		var newUrl = url;
		
		if (newUrl.indexOf('${OPEN_RTB_JSON}') != -1 || newUrl.indexOf('${OPEN_RTB_JSON_ENC}' != -1))
		{
			var openRTBVideo = '{"pos":1,"startdelay":0,"minduration":0,"maxduration":120,"maxextended":30,"minbitrate":0,"maxbitrate":1500,"api":[1,2],"protocols":[2,3,5,6],"mimes":["video/mp4","application/javascript","video/webm"],"linearity":1,"boxingallowed":1,"playbackmethod":[1,2],"delivery":[2], "w": '+vidWidth+', "h": '+vidHeight+'}';
			wwDebug.call(wwConsole, wwPrefix, "OpenRTB video param: "+ openRTBVideo);
			newUrl = replaceAll(newUrl, '${OPEN_RTB_JSON}',openRTBVideo);
			newUrl = replaceAll(newUrl, '${OPEN_RTB_JSON_ENC}',encodeURIComponent(openRTBVideo));
		}
		
		var ts = Date.now();
		newUrl = replaceAll(newUrl, '${DOMAIN}',domain);
		newUrl = replaceAll(newUrl, '${REFERRER}',referrer);
		newUrl = replaceAll(newUrl, '${PAGEURL}',pageURI);
		newUrl = replaceAll(newUrl, '${DOMAIN_ENC}',encodeURIComponent(domain));
		newUrl = replaceAll(newUrl, '${REFERRER_ENC}',encodeURIComponent(referrer));
		newUrl = replaceAll(newUrl, '${PAGEURL_ENC}',encodeURIComponent(pageURI));
		newUrl = replaceAll(newUrl, '${WIDTH}',encodeURIComponent(width));
		newUrl = replaceAll(newUrl, '${HEIGHT}',encodeURIComponent(height));
		newUrl = replaceAll(newUrl, '${VIDWIDTH}',encodeURIComponent(vidWidth));
		newUrl = replaceAll(newUrl, '${VIDHEIGHT}',encodeURIComponent(vidHeight));
		newUrl = replaceAll(newUrl, '[cachebusting]',encodeURIComponent(ts)); 
		newUrl = replaceAll(newUrl, '[CACHEBUSTING]',encodeURIComponent(ts));
		newUrl = replaceAll(newUrl, '[timestamp]',encodeURIComponent(ts));
		newUrl = replaceAll(newUrl, '[TIMESTAMP]',encodeURIComponent(ts));
		newUrl = replaceAll(newUrl, '${RANDOM}',encodeURIComponent(ts));
		
		wwDebug.call(wwConsole, wwPrefix, "replaceMacros Ending url="+ newUrl);
		return newUrl;
		
	}
	
	
	// DEBUGGING
	
	var isDebug = false;
	if (typeof(wahwah.DEBUG_MODE) != "undefined" && wahwah.DEBUG_MODE.toString() == "true") 
		isDebug = true;
	wahwah.adconfig["DEBUG_MODE"] = isDebug;	// For use in ad modules
	
	// Will be tracking load seperately
	if (mainWindow.document.readyState === "complete") 
	{
        setTimeout(windowLoaded);
    }
    else 
	{
		addListener(targetWindow, "load", windowLoaded);
    }
	
    if (mainWindow.document.readyState === "complete" || targetWindow.document.readyState === "interactive") 
	{
        setTimeout(domAvailable);
    }
    else 
	{
		addListener(targetWindow.document, "DOMContentLoaded", domAvailable);	
    }
	

		
	
	var supported = true;
	
    function startLoad() 
	{
	
	
		try {
	        if (!JSON || !postMessage || ("onstorage" in document)) { 
				supported = false;
	        }
		}
		catch(e)
		{
			supported = false;
			rpTrack("error", {'etyp': 'unsupported', 'data': encodeURIComponent(navigator.userAgent)});
			return;
		}

		initMessaging();
		
		loadFlash();
		
		demandSourceListRequest();
		
		
		
		
		sendAPIEvent('init', {"instanceUUID": wahwah.uuid});
	
	}
	
	
	
	
	
	
	
    function createScrollTracker() {
    	var img = document.createElement("img");
		img.setAttribute("src", wahwah.baseUrl + "ww.gif");
		img.setAttribute("id", "scrollTracker_" + uuid);

		// Setting height and width using 'setAttribute' didn't work
		img.style.height = "1px";
		img.style.width = "1px";

		return img;
    }

    function scrollInitialListener() {
    	
        if (checkVisible(sT)) {

            var div = createDivPlaceholder();

			sT.parentNode.insertBefore(div, sT.nextSibling);

        	wwLog.call(wwConsole, wwPrefix, "Loading Ad Module");
            mainWindow.removeEventListener('scroll', scrollInitialListener, false);
            buildFiF(true, scrolltrackerIsVideo);
    	}
    }
	
	
	
    function removeInterstitial() {
		mainWindow.document.getElementById("wwDivInterstitial_" + uuid).style.display = "none";
		mainWindow.document.getElementById("wwDivInterstitial_" + uuid).parentNode.removeChild(mainWindow.document.getElementById("wwDivInterstitial_" + uuid));
    }

    function moveClose(top, right) {

		if (typeof(right) == "undefined")
			right = 0;

        var adControlsOverlay = mainWindow.document.getElementById("wwAdControlsOverlay_" + uuid) || pubInDapIFWindow.document.getElementById("wwAdControlsOverlay_" + uuid);
        adControlsOverlay.style.right = right + "px";
        adControlsOverlay.style.top = top + "px";
        adControlsOverlay.style.display = "block";

    }
	
    var isCustomCampaign = false;
	
	
	
	
	
    /////////////////////////////////////	
    // Messaging
    /////////////////////////////////////
	
	
    var ModuleEnums = {
        MODULE_LOADER: "Loader",
        MODULE_ADS: "Ads"
    };
	
	function sendMessage(destID, message) {
        switch (destID) {
            case ModuleEnums.MODULE_ADS:
            	friendlyAdFrames[tmpIDHack].contentWindow.postMessage(message, '*');
                break;
        }
    }
	
	
    function receiveMessage(event) {
		try {
			var messageObj = JSON.parse(event.data);
		}
		catch(e)
		{
            return;
		}

		if (!domAccessible)
		{
			msgQueue[msgQueue.length] = event;
			return;
		}

        if ( domain !== "*" && event.origin !== domain) 
        {
           if (typeof(messageObj) == "undefined" || typeof(messageObj.vendor)== "undefined" || messageObj.vendor != "WahWah" )
               return;
        }

        if (messageObj.destination != ModuleEnums.MODULE_LOADER) {
            sendMessage(messageObj.destination, event.data);
        }
        else {

            if (messageObj.id == uuid) 
			{
				// Be VERY CAREFUL not to mess up this message handler
				if (messageObj.type == "rpTrack")
                {
					rpTrack(messageObj.content.event, messageObj.content.parameterPairs);
					return;
				}
				if (messageObj.type == "removeFriendlyIframe")
                {
                    removeFriendlyIframe(true); 

                    if ((messageObj.content.src == "onVideoError")&&(purchBusinessNewsDaily)) {
                        pubInDapIFFrame.style.height = "150px";
                    }

                    // Need to verify with video that we are 'removing the frames' from the close button or when the video completed successfully and not because NO VIDEO was found in VAST
                    if ((messageObj.content.src == "endCollapse")||(messageObj.content.src == "onVideoCompleted")) {

                    	if (purchBusinessNewsDaily)
							pubInDapIFFrame.style.height = "150px";

						// Need to remove "wahwahInpageAdContainer"
						// Reloads a Backup Display URL for AdOnly Inpage units 
						if (!isFloating) {
							if (!purchBusinessNewsDaily) {
								wwDebug.call(wwConsole, wwPrefix, "Video Completed Playing :: Reloading a 300x250");
								placementType = PlacementTypes.BACKUP_AD;

								var referrer = document.referrer || window.location.href;
							}
						// Otherwise a Toolbar so we'll reload the DisplayURL and Video completed and not closed out
						} else if (messageObj.content.src == "onVideoCompleted") {
							wwDebug.call(wwConsole, wwPrefix, "Video Completed Playing :: Reloading with the Display URL");
							placementType = PlacementTypes.COMBINED_AD;
							// Wait 3 seconds
							setTimeout(
								function() {
									reloadedAd = true;
						}, 3000);
						}
                    }
                }
                
                if (messageObj.type == "getClientFeatures")
                {
                        var messageObjResponse =
                        {
                            type: "clientFeatures",
                            destination: ModuleEnums.MODULE_ADS,
                            content: wahwah.clientFeatures, 
                            id: uuid
                        };
                    sendMessage(ModuleEnums.MODULE_ADS, JSON.stringify(messageObjResponse));
                }
                
                if (messageObj.type == "onAdSuccessfulLoad") {

                	customCampaignName = messageObj.content["customCampaignName"]; 

                    if (messageObj.content["customCampaignName"] == "myspace") {
                        moveClose(10);
                    } else if ((customCampaignName == "allscreen")||(isWallpaper)||(customCampaignName == "vibrant")) {
                    	//don't show close button
                    } else if ((messageObj.content["customCampaignName"] == "virool")||(messageObj.content["customCampaignName"] == "teads"))  {
                    	moveClose(15);
                    } else if (messageObj.content["isVideo"] == false){
                        moveClose(-15);
                    } else if (messageObj.content["isVideo"] == true){
                    	moveClose(0);
                    	// For Video, resizes the divPlacholder
                    	if (outstreamUnit) {
                    		mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.right = 0 + "px";
                    		mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.position = "relative";
			            	mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.width = 558 + "px";
			            	mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = 314 + "px";

			            	var messageObjResponse =
		                    {
		                        type: "showVideo",
		                        destination: ModuleEnums.MODULE_ADS,
		                        id: uuid
		                    };

		                    mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).addEventListener('transitionend', function() { 
            					sendMessage(ModuleEnums.MODULE_ADS, JSON.stringify(messageObjResponse));
            				});
			            } 

                    	// Show Transparent Overlay
						if (isInterstitial)
                    	mainWindow.document.getElementById("wwDivInterstitial_" + uuid).style.backgroundColor = "rgba(51,51,51,0.8)";

                    } else { // 300x250 Display Ad
                    	if (marketPlaceTag)
                    		moveClose(15);

                    	if (outstreamUnit) {
			            	mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.width = 300 + "px";
			            	mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = 250 + "px";

			            	mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.position = "relative";
			            } 
                    }
					
					sendAPIEvent('started', {"instanceUUID": wahwah.uuid});

                    // mainWindow.window.addEventListener('scroll', detectViewability, false);
                }

                if (messageObj.type == "onAdDisplayError") 
				{
						wwForceLog.call(wwConsole, wwPrefix, 'Display passback detected. widgetId:' + wahwah.id + ' uuid:' + uuid);
				
						if (mainWindow.document.getElementById("wwAdControlsOverlay_" + uuid))
							mainWindow.document.getElementById("wwAdControlsOverlay_" + uuid).style.display = "none";

                    	if (parentMPClose != null)
                    		parentMPClose.style.display = "none";

                        removeFriendlyIframe(true);
						
						
						if (typeof(window.__RedPanda_Passback) != "undefined")
						{
							wwForceLog.call(wwConsole, wwPrefix, 'Marketplace passback detected. widgetId:' + wahwah.id + ' uuid:' + uuid);
							window.__RedPanda_Passback();
						}
						
						var etype = "callback";
						if (typeof(messageObj.content["etyp"]) != "undefined")
							etype = messageObj.content["etyp"];
                        adErrorHandler("passback", etype);
                }

                if ((messageObj.type == "videoClosed") || (messageObj.type == "onAdVideoPlayerComplete"))  
				{
					var type = "complete"
					if (messageObj.type == "videoClosed")
						type = "skipped";
					rpTrack("adclose", {'type': type});
					removeFriendlyIframe(true);
					if (isInterstitial)
						removeInterstitial();
                }

                if (messageObj.type == "onAdVideoPlayerError") 
				{
					removeFriendlyIframe(true);
					
					wwForceLog.call(wwConsole, wwPrefix, 'Video passback detected. widgetId:' + wahwah.id + ' uuid:' + uuid);

					// Forces the placeholder and the wrapper to start back out at the 300x250 for both display calls
					/*if (!isFloating) {
						mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = "250px";
						mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.width = "300px";
					}

					mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.height = "250px";
					mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.width = "300px";*/
						
					adErrorHandler("passback", "callback");
                }

                // QUICK Fix for AllScreen for Adthrive
                if (messageObj.type == "minimizeIframe") {
                	friendlyFrameGetter().childNodes[1].style.height = "0px";
                }

                if (messageObj.type == "allscreen") {

					if (window.top.document.getElementsByClassName('ashq')) {
						var target = document.querySelector('body');
			            var seen = false;
			            var observer = new MutationObserver(function(mutations) {
			                var ashq_unit = document.querySelector("div[id^=ashq]");
			                if (seen && !ashq_unit) {
			                	var ashq = window.top.document.getElementsByClassName('ashq');
			                	console.log(ashq);
			                	removeFriendlyIframe(true);
			                	ashq[0].contentWindow._ashq.destroy();
			                    observer.disconnect();
			                } else if (ashq_unit) {
			                    seen = true;
			                }
			            });
			            observer.observe(target, { childList: true });
					}

                	if (parent.__asl) {

                		var oldStopped = parent.window.__asl.adstopped;
                		parent.window.__asl.adstopped = function() {
                			console.log( ' ============ ');
                			//removeFriendlyIframe(true);
                			oldStopped();
                		}
                		var oldStarted = parent.window.__asl.contentstart;
                		parent.window.__asl.contentstart = function() {
                			console.log( ' ++++++++ ');
                			oldStarted();
                		}
                		var oldError = parent.window.__asl.aderror;
                		parent.window.__asl.aderror = function() {
                			console.log( ' --++++_---- ');
                			oldError();
                		}
                	}
                }

                if ((messageObj.type == "virool")||(messageObj.type == "yellowhammer")) {
                	removeFriendlyIframe(true);
                }

				
			}
			
		}
	}
	
	/////////////////////////////////////	
    // File request
    /////////////////////////////////////
	
	function fileRequest(url, successcallback, failcallback, type)
	{
		wwDebug.call(wwConsole, wwPrefix, "Request URL using XMLHttpRequest START: " + url);
		var oReq = new XMLHttpRequest();
		var statusText = "";
		oReq.addEventListener("load", transferComplete);
		oReq.addEventListener("error", transferFailed);
		oReq.addEventListener("abort", transferCanceled);
		oReq.onreadystatechange = function (oEvent) {  
			if (oReq.readyState != 4)
			{
				statusText = oReq.statusText;
			}  
		}; 		
		
		function transferComplete(evt) // still may be a failure
		{
			var xhttp = evt.currentTarget;
			if (xhttp.readyState == 4 && (xhttp.status == 200 || xhttp.status == 304))
			{
				wwLog.call(wwConsole, wwPrefix, "Request URL using XMLHttpRequest SUCCESS: "+ url);
				if (typeof(type) == "undefined" || type == "text")
					successcallback.call(successcallback, evt.currentTarget.responseText);
				if (type == "xml")
					successcallback.call(successcallback, evt.currentTarget.responseXML);
			}
			else
			{
				transferFailed(evt);
			}
		}
		
		function transferFailed(evt)
		{
			wwDebug.call(wwConsole, wwPrefix, "Request URL using XMLHttpRequest FAIL: "+ url);
			fileRequestFallbackFlash(url, successcallback, failcallback, statusText + " error (status:"+evt.currentTarget.status+") for url:" + url);
		}
		
		function transferCanceled(evt)
		{
			wwDebug.call(wwConsole, wwPrefix, "Cancelled transfer, treating as failed!");
			transferFailed(evt); // Probably shouldn't happen, so just treat as the same
		}
		
		oReq.open("GET", url);
		oReq.send();
		
		
		
	}
	
	function fileRequestFallbackFlash(url, successcallback, failcallback, errorMsg1)
	{
		wwLog.call(wwConsole, wwPrefix, "Request back up method - URL using Flash START: "+ url);
		ajaxFlash(url, flashSuccess, flashFail);
		
		function flashSuccess(data)
		{
			wwLog.call(wwConsole, wwPrefix, "Request back up method - URL using Flash SUCCESS: "+ url);
			successcallback.call(successcallback, data);
		}
		
		function flashFail(errorMsg2)
		{
			wwDebug.call(wwConsole, wwPrefix, "Request back up method - URL using Flash FAIL: "+ url);
			failcallback.call(failcallback, errorMsg1, errorMsg2);
		}
	
	}
	
	
    /////////////////////////////////////	
    // 1x1 url requester
    /////////////////////////////////////

	
	function createCallbackMethod(callback)
	{
		var seed = (new Date().getTime()) + "" + Math.floor(Math.random(10000) * 1000000);
		var methodName = "_callback_" + seed;

		while(methodName in window)
		{
			methodName += "_";
		}

		window[methodName] = function (data)
		{
			callback(data);
		}

		return methodName;
	}

    var _ = function (id) {
        return document.getElementById(id);
    };

    var hasFlashStarted = false;
    var flashStartQueue = [];

    function send(destination, data) {
        data.timestamp = (new Date().getTime());
        data.rnd = Math.random();

        var key = "wahwah.tab.message." + destination;
        var value = JSON.stringify(data);

        // console.log("Sending on: [" + destination + "] => " + data);

        window.localStorage.setItem(key, value);
    }

    function listen(destination, callback) {
        var key = "wahwah.tab.message." + destination;

        addListener(window, "storage", function (e) {

            if (e.key == key) {
                // console.log("Receiving on: [" + destination + "] => " + e.newValue);

                var data = JSON.parse(e.newValue);
                callback(data);
            }
        })
    }

    function sendFlash(destination, data) {
        if (!hasFlashStarted) {
            flashStartQueue.push(function () {
                sendFlash(destination, data);
            })

            return;
        }

        _("tabMessageFlash").sendTabMessage(destination, data);
    }

    function listenFlash(destination, callback) {
        if (!hasFlashStarted) {
            flashStartQueue.push(function () {
                listenFlash(destination, callback);
            })

            return;
        }

        var methodName = createCallbackMethod(function (data) {
            callback(data);
        });

        _("tabMessageFlash").listenTabMessage(destination, methodName);
    }

    function initFlash() {
        hasFlashStarted = true;
    }

	
    function loadFlash() {


		var startMethodName = createCallbackMethod(function (data) { initFlash() });
	
        var swfurl = baseUrl + "widget/ajaxflash.swf?startMethod=" + startMethodName;
		
		var attributes = 'data="' + swfurl + '" type="application/x-shockwave-flash"';
		if (typeof(window.ActiveXObject) != "undefined")
				attributes = 'codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,2,0" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"'; // IE9
		var flashvars = "senzariDomain=&startMethod=" + startMethodName;
		var objTag = '<object id="rpFlash1x1" name="rpFlash1x1" width="1" height="1" id="rpFlash1x1" '+attributes+'><param name="movie" value="' + swfurl + '" /><param name="FlashVars" value="'+flashvars+'" /><param name="allowfullscreen" value="false"/><param name="allowscr'+'iptaccess" value="always" /><param name="scale" value="scale" /><param name="quality" value="low" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="transparent"/></object>';
		var div = document.createElement('div');
		div.style.width = "1px";
		div.style.maxHeight = "1px";
		div.style.height = "1px";
		div.style.display = "table-cell";
		div.style.padding = 0;
		div.style.position="fixed";
		div.style.bottom="0px";
		div.style.left="0px";
		div.style.zIndex = 100000000;
		//console.log(document.body);
		document.body.appendChild(div);
		div.innerHTML += objTag;
		
    }
	
	function ajaxFlash(url,successcallback, failcallback, count)
	{
		var milliTimeout = 50;
		if (typeof(count) == "undefined")
			count = 0;
		
		if (count >= maxRequestTime)
		{
				wwLog.call(wwConsole, wwPrefix, "Reached timeout trying to load ajaxflash. Connection too slow or computer resources use too high. Giving up.");
				failcallback.call(failcallback, "timeout");
				return;
		}
		if (!hasFlashStarted)
		{
			count+= milliTimeout;
			window.setTimeout(function () {
				ajaxFlash(url,successcallback, failcallback, count);
			}, milliTimeout);
			return;
		}
		
		var completeMethodName = createCallbackMethod(function (data) { 
			successcallback.call(successcallback, unescape(data));
		});
		var failMethodName = createCallbackMethod(function (data) { 
			failcallback.call(failcallback, unescape(data));
		});
		try{
		_("rpFlash1x1").ajaxProxy(url, "GET", null, completeMethodName, failMethodName);
		}
		catch(e)
		{
			wwLog.call(wwConsole, wwPrefix, "Ajaxflash error:"+e.message);
			failcallback.call(failcallback, "Flash 1x1:" + e.message);
			return;
		}
	}
	
    /////////////////////////////////////	
    // Demand Srcs
    /////////////////////////////////////
	
	var demandSourceListUrl = wahwah.demandSourceListUrl;
	var maxRequestTime = 15000;
	
    var baseDomain = wahwah.domain, baseUrl = wahwah.baseUrl;
	
	function callDefault()
	{
		wwLog.call(wwConsole, wwPrefix, "Fatal: Would call default here");
	}
	
	function demandSourceListParse(bidSourceText)
	{
		wwLog.call(wwConsole, wwPrefix, "Parse demand source list. Bytes: " + bidSourceText.length);
		try
		{
			var demandSourceListJSON = JSON.parse(bidSourceText);
			var length = demandSourceListJSON.line_items.length;	// Just make sure it's there so we throw a parse error otherwise
			startBidding(demandSourceListJSON);
		}
		catch(e)
		{
			demandSourceListParseFail(e); 
		}
		
		
		function demandSourceListParseFail(evt)
		{
			wwLog.call(wwConsole, wwPrefix, "Demand source list failed parse! " + evt.message);
			/* wwLog.call(wwConsole, wwPrefix, "Contents:\n" + bidSourceText); */
			rpTrack("bidsourcefailed", {'type': 'parse', 'data': encodeURIComponent(evt)});
			callDefault();
		}
	
	}
	
	var startRequestTime;
	function demandSourceListRequest()
	{
		wwLog.call(wwConsole, wwPrefix, "Request demand source list " + demandSourceListUrl);
		startRequestTime = getTime();
		fileRequest(demandSourceListUrl, transferSuccess, transferFailed)
		
		function transferSuccess(data)
		{
			wwDebug.call(wwConsole, wwPrefix, "Demand source list request elapsted time: " + Math.floor(getTime()  - startRequestTime) + "ms");
			demandSourceListParse(data);
		}
		
		function transferFailed(errorMsgJS, errorMsgFlash)
		{
			var timeout = false;
			if (errorMsgJS == "timeout" || errorMsgFlash == "timeout")
				timeout = true;
			wwLog.call(wwConsole, wwPrefix, "Demand source list failed transfer");
			rpTrack("bidsourcefailed", {'type': (timeout == true)?'timeout':'transfer', 'data': encodeURIComponent("jserror: " + errorMsgJS + " flasherror: " + errorMsgFlash)});
			callDefault();
		}
		
	}
	
	
	
	
	/////////////////////////////////////	
    // Bidding
    /////////////////////////////////////
	
	var bidSourcesMetadataList = [];
	var lineItemList;
	var liIdx = 0;
	var allowedTimeForInitialBids = 1000; // in milliseconds
	var startBiddingTime;
	var selectionTimeout;
	var bidsCollected = 0;
	var bidLineItemTimeout = [];
	
	function startBidding(demandSourceListJSON)
	{
		lineItemList = demandSourceListJSON.line_items;
		wwLog.call(wwConsole, wwPrefix, "Begin choosing source. Line-item count: "+ lineItemList.length);
		startBiddingTime = Date.now();
		// detach for error handling separation
		setTimeout(bidLineItem);
	}
	
	var lineItemTotalIgnored=0;
	
	function bidLineItem()
	{
		var li = lineItemList[liIdx];
		li.loader_idx = liIdx;
		liIdx++;
		if (liIdx < lineItemList.length)
		{
			setTimeout(bidLineItem);
		}
		else
		{
			// We are starting the final request, begin timeout period now
			var that = this;
			selectionTimeout = setTimeout( function () {
				wwDebug.call(wwConsole, wwPrefix, "Timeout of "+allowedTimeForInitialBids+"ms reached. Begin selection");
				beginSelection();
			} , allowedTimeForInitialBids);
		}
		wwDebug.call(wwConsole, wwPrefix, "Bidding line item: " + li.id);
		var priority = li.priority;
		
		li.startTime = Date.now();
		
		if (typeof(li.ads[0]) == "undefined")
		{
			wwWarn.call(wwConsole, wwPrefix, "No ads for line item " + li.id);
			lineItemTotalIgnored++;
			return;
		}
		
		var creative = li.ad_map[li.ads[0]].creative; // Todo: Handle multiple creatives?

		if ((creative.creative_platform != getDisplayType().toUpperCase())&&(creative.creative_platform != "BOTH")) 
		{
			wwWarn.call(wwConsole, wwPrefix, "Wrong Creative Platform Type: " + li.id + ". Skipping");
			lineItemTotalIgnored++;
			return;
		}
		
		if (li.biddable == false)
		{
			processLiNotBiddable(null, li);
			return;
		}
		else
		{
			wwDebug.call(wwConsole, wwPrefix, "BIDDABLE: " + li.id + " Begin..");
			creative._tag_contents_orig = creative.tag_contents;
			creative.tag_contents = replaceMacros(creative.tag_contents);
			if (creative.creative_type == "VAST_XML")
			{
				requestBidSourceVAST( creative.tag_contents, li);
				return;
			}
			else
			{
				wwWarn.call(wwConsole, wwPrefix, "Header bidding not supported: " + li.id + ". Skipping");
				lineItemTotalIgnored++;
				return;
			}
			return;
			
		}
		
		
		
	}
	
	function processLiNotBiddable(doc, li, creative)
	{
		// Warning: Use first creative for now and ignore what's passed in. Todo: Handle multiple creatives?
		creative = li.ad_map[li.ads[0]].creative; 
		
		// Not biddable, just use rcpmCents, then ecpmCents * fill_rate, then cpmCents * fill_rate
		wwDebug.call(wwConsole, wwPrefix, "Not biddable: " + li.id);
		var cpmCents = parseFloat(li.actual_rcpmCents) || 0;
		if (li.bid_type == "GUARANTEED_REALTIME_cpmCents")
		{
			cpmCents = parseFloat(li.actual_rcpmCents) || 0;
		}
		else if (li.bid_type == "GUARANTEED_NOMINAL_cpmCents")
		{
			cpmCents = parseFloat(li.nominal_cpmCents) * li.fill_rate;
		}
		else
		{
			if (cpmCents == 0)
			{
				cpmCents = parseFloat(li.actual_ecpmCents) || 0;
				if (cpmCents == 0)
				{
					var nominal = parseFloat(li.nominal_cpmCents) || 0;
					cpmCents = nominal * li.fill_rate;
				}
			}
		}
			
			
		if (creative.creative_type == "VAST_XML")
		{
			if (doc == null) // Only should happen w/ header bidding. May never happen?
			{
				var doc = window.queryVAST(fileRequest, url, lineItem.id, function() {
					bidResult(li,cpmCents, doc);
				} , onQVFailure, null);
			}
			else
			{
				bidResult(li,cpmCents, doc);
			}
		}
		else
			bidResult(li,cpmCents, null);
		return;
	}
	
	
	// cpmCents is in CENTS
	function bidResult(lineItem, cpmCentsCents, vastObj /* can be null */) // DON'T use li for parameter (it'll conflict)
	{
		var st = lineItem.startTime;
		var et = Date.now();
		var elapsed = et - st;
		wwDebug.call(wwConsole, wwPrefix, "Bid result for " + lineItem.id + " cpmCents_in_cents=" + cpmCentsCents + " elapsed=" + Math.floor(elapsed));
		bidsCollected++;
		var adId = lineItem.ads[0];
		var creative = lineItem.ad_map[adId].creative; // Todo: Handle multiple creatives?
		if (typeof(vastObj) == "undefined")
			vastObj = null;
		// Simplify
		var guaranteed = false;
		if ( lineItem.bid_type.indexOf("GUARANTEED") != -1 && lineItem.bid_type.indexOf("NON_GUARANTEED") == -1)
			guaranteed = true;
			
		var creativeId = creative.id || lineItem.ad_map[adId]["creative_id"];
		var vendor = lineItem.ad_map[adId]["creative"]["vendor"];
		bidSourcesMetadataList.push( 
		{
			"priority": lineItem.priority,
			"cpmCents": cpmCentsCents,
			"guaranteed": guaranteed,
			"lineItem": lineItem,
			"trackingInfo": {
					"adid": adId,
					"cid": creativeId,
					"oseq": null, // needs to be set later
					"bp": cpmCentsCents,
					"bpt": "bid_result",
					"pl": lineItem.priority,
					"vb": 100,
					"vendor": vendor
				},
			"vastObj": vastObj
		});
		if (bidsCollected >= lineItemList.length - lineItemTotalIgnored)
		{
			wwDebug.call(wwConsole, wwPrefix, "All line items processed. Begin selection. Elapsed: "+(Date.now() - startBiddingTime)+"ms");
			beginSelection();
		}
	
	}
	
	var alreadyStartedSelection = false;
	var opportunitySequence = 0;
	var lineItemChosenMetadata;
	function beginSelection()
	{
		if (selectionTimeout != null)
			clearTimeout(selectionTimeout);
		selectionTimeout = null;
		if (alreadyStartedSelection == true)
			return;
		alreadyStartedSelection = true;
		
		lineItemChosenMetadata = null;
		
		wwLog.call(wwConsole, wwPrefix, "Begin/continue selection process for uuid "+uuid+". Bids already collected:" + bidsCollected + " failures/ignored: " + lineItemTotalIgnored );
				
		
		bidSourcesMetadataList.sort(function (a,b)
		{
			if (a.priority == b.priority)
			{
				if (a.cpmCents == b.cpmCents)
				{
					return (a.guaranteed == true)?-1:1;
				}
				else
					return (a.cpmCents > b.cpmCents)?-1:1;
			}
			else
				return (a.priority > b.priority)?1:-1;
		});
		
		if (bidSourcesMetadataList.length >= 1)
		{
			lineItemChosenMetadata = bidSourcesMetadataList.shift();
			
			
			// Todo process line item
			
			wwDebug.call(wwConsole, wwPrefix, "End selection process. Chosen:" + lineItemChosenMetadata.lineItem.id);
			setTimeout(function() { // Detach so thrown error in loadCreative gets outputted (after calling without beginSelection again) w/o being caught in bidResult
				lineItemChosenMetadata.trackingInfo["oseq"] = opportunitySequence;
				wwLog.call(wwConsole, wwPrefix, "Vendor:"+lineItemChosenMetadata.trackingInfo["vendor"] + " (may be null)");
				rpTrack("opportunity", lineItemChosenMetadata.trackingInfo);
				opportunitySequence++;
				loadCreative();
			});
		}
		else
		{
			wwLog.call(wwConsole, wwPrefix, "End selection process. No remaining line items exist!");
			if (typeof(wahwah.adconfig.inpage.passback) != "undefined" && wahwah.adconfig.inpage.passback != null && wahwah.adconfig.inpage.passback != "")
			{
				loadCreativePassbackTag(wahwah.adconfig.inpage.passback);
			}
			sendAPIEvent('passback', {"instanceUUID": wahwah.uuid});
		}
	}
	
	
	function getBidcpmCents(doc,lineItem)
	{
		// Two types to look for:
		/* VAST 3 */
		// Todo
		/* Old Liverail requirement de-facto standard
		<Extension type="LR-Pricing">
<Price model="cpmCents" currency="USD" source="spotxchange">4.5</Price>
</Extension>

If no bid, use our values
*/

		try {
			if (typeof(doc.ads[0].extensions))
			{
				var extensions = doc.ads[0].extensions;
				if (extensions != null)
				{
					for (var i = 0; i < extensions.length; i++)
					{
						if (typeof(extensions[i].type) != "undefined")
						{
							if (extensions[i].type == "LR-Pricing")
							{
								wwDebug.call(wwConsole, wwPrefix, "LR-pricing found for: " + lineItem.id);
								var pricingSerialized = extensions[i].value;
								var oParser = new DOMParser();
								var pricingObj = oParser.parseFromString(pricingSerialized, "text/xml");
								if (pricingObj.firstChild != null && pricingObj.firstChild.nodeName == "Price")
								{
									var priceElem = pricingObj.firstChild;
									if (priceElem.getAttribute("currency") == "USD")
									{
										if (priceElem.getAttribute("model") == "cpmCents")
										{
											var price = parseFloat(priceElem.firstChild.textContent);
											//wwDebug.call(wwConsole, wwPrefix, "Pricing of " + price + " " +priceElem.getAttribute("currency") + " cpmCents found in "+priceElem.getAttribute("model")+" pricing model for: " + lineItem.id);
											var priceInCents = Math.floor(price*100);
											bidResult(lineItem, priceInCents, doc);
										}
										else
										{
											wwDebug.call(wwConsole, wwPrefix, "LR-pricing model "+priceElem.getAttribute("model")+" is not cpmCents for: " + lineItem.id + ". Only cpmCents supported.");
										}
									}
									else
									{
										wwDebug.call(wwConsole, wwPrefix, "LR-pricing currency "+priceElem.getAttribute("currency")+" is not USD for: " + lineItem.id + ". Only USD supported.");
									}
								}
								return;
							}
						}
					}
				}
			}
			
			// Todo - Add vast3 cpmCents (convert to cents)
			
			// DO NOT put return here; Need to get to non-biddable handler at end of function!
		}
		catch(e)
		{
		}
		
		wwDebug.call(wwConsole, wwPrefix, "No bid in VAST for: " + lineItem.id + ". Using line item");
		processLiNotBiddable(doc, lineItem);
		lineItemTotalIgnored++;
	}
			
	
	/////////////////////////////////////	
    // VAST-VMAP
    /////////////////////////////////////
	
	
	var lineItemHash = [];
	
	function requestBidSourceVAST(url, lineItem)
	{
		if (!window.__RP_VASTVMAPReady)
		{
			wwDebug.call(wwConsole, wwPrefix, "VAST-VMAP not yet loaded. Delay");
			setTimeout(function()
			{
				requestBidSourceVAST(url, lineItem);
			}, 50);
			return;
		}
		else
		{
		
			lineItemHash[lineItem.id] = lineItem; // Store for after successful parse
			// Detach
			setTimeout(function()
			{
				wwDebug.call(wwConsole, wwPrefix, "Requesting VAST url:" + url + " for lineItem:" + lineItem.id);
				window.queryVAST(fileRequest, url, lineItem.id, onQVSuccess, onQVFailure, null);
			});
			return;
		}
		
	}
	
	function onQVSuccess(doc, lineItemId)
	{
		wwLog.call(wwConsole, wwPrefix, "Loaded XML tag success. html5 request succeeded. lineItem:" + lineItemId);
		var lineItem = lineItemHash[lineItemId];
		getBidcpmCents(doc, lineItem);
	}

	function onQVFailure(type, obj, lineItemId, url, extraData)
	{
		var details = "";
		if (typeof(extraData) != "undefined" && extraData != null)
			details = extraData;
		switch(type)
		{
			case "request":
				wwError.call(wwConsole, wwPrefix, "Failed requesting XML tag! url:" + url + " lineItem:" + lineItemId);
				var lineItem = lineItemHash[lineItemId];
				
				var adId = lineItem.ads[0];
				var creativeId = lineItem.ad_map[adId]["creative_id"];
				rpTrack("vasthttperror", {"cid": creativeId, "adId": adId, "data": encodeURIComponent("VAST_URL:"+url + " " + details)});	
				break;
			case "parse":
				wwWarn.call(wwConsole, wwPrefix, "Possible passback? Failed parsing url:" + url + " lineItem:" + lineItemId);
				break;
		}
		lineItemTotalIgnored++;
	}
	
	
	window.__RP_VASTVMAPReady = false;
	
	loadScript(baseUrl+"ads/adcontainers/videoad/vast-vmap/vast-vmap.js", true);
	
	
	/////////////////////////////////////	
    // LOADSCRIPT HELPER
    /////////////////////////////////////
	
	function loadScript(url, defer)
	{
    if (document.readyState === "complete" || document.readyState === "interactive")
    {
        // In this case, loader.js will use DOM manipulations
        var fileref = document.createElement('script');
        fileref.setAttribute("type","text/javascript");
        fileref.setAttribute("src", url);
		if (defer == true)
			fileref.setAttribute("defer", true);
        document.getElementsByTagName("head")[0].appendChild(fileref);
    } else {
		var deferStr = "";
		if (defer == true)
			deferStr = 'defer="true"';
        document.writeln('<scr'+'ipt src="'+url+'" type="text/javascript "'+deferStr+'></scr'+'ipt>');
    }
	
	}
	
    /////////////////////////////////////	
    // Ad load
    /////////////////////////////////////
	
	
	var chosenVASTTechnology = "unknown"; // "flash" | "html5";
	var vastXML = null;
	
	var isFloating = false;
    var inAd = false;
    var breakOutAd = false; // Can only be for DFP
    var triggerId = "redpandaAd";
    var purchBusinessNewsDaily = false;
    var skipCombinedCall = false;
    var outstreamUnit = false;
    var outstreamAutoload = wahwah.adconfig.inpage.outstreamAutoload;
    var outstreamScrollFloater = wahwah.adconfig.inpage.outstreamFloat;
    var isInterstitial = wahwah.adconfig.interstitial.enabled;
    var isWallpaper = false;
    var videoAd = false;
    var scrollTracker = null;
	
    var purchBusinessNewsDaily = false;
    var gadgetReview = false
	
	// Marketplace tag functionality
	
    var marketPlaceTag = false;
    var parentMPClose = null;
    var parentMPFrame = null;
    var parentMPWrapper = null;
    var parentMPPlaceholder = null;
	
	
	// Friendly iframe functionality for ads
	// see http://www.iab.net/media/file/rich_media_ajax_best_practices.pdf
	var friendlyAdFrames = [];
	var friendlyWrappers = [];
    var friendlyPlaceholder = [];
	
	
    if (typeof(wahwah.clientFeatures.purchBusinessNewsDaily) != 'undefined') { gadgetReview = true } //purchBusinessNewsDaily = true }
    if (typeof(wahwah.clientFeatures.skipCombinedCall) != 'undefined') { skipCombinedCall = true }
    if (typeof(wahwah.clientFeatures.gadgetReview) != 'undefined') { gadgetReview = true }
	
	// See if we're in the marketplace call for a network
	var parentIframes = parent.document.getElementsByTagName("iframe");
	for (var frmItr = 0; frmItr < parentIframes.length; frmItr++)
	{
		if (parentIframes[frmItr].id.indexOf('wwAdFiF') != -1) {
			wwLog.call(wwConsole, wwPrefix, "Found a parent wwFrame so we're assuming we're a Market Place Tag");
			marketPlaceTag = true;
			parentMPFrame = parentIframes[frmItr];
			var parentMP_ID = parentMPFrame.id.substring(8)
			parentMPPlaceholder = parent.document.getElementById('wwDivPlaceholder_' + parentMP_ID);
			parentMPWrapper = parent.document.getElementById('wwDivWrapper_' + parentMP_ID);
			parentMPClose = parent.document.getElementById('wwAdControlsOverlay_' + parentMP_ID);
			parentMPClose.style.display = "none";
			parentMPClose.parentNode.removeChild(parentMPClose); 
		}
	}
	
	
    if (wahwah.adconfig.inpage.adFormat == "floater")
    	isFloating = true;

    if (wahwah.adconfig.inpage.adFormat == "banner")
	{
    	inAd = true; // If the Ad needs to stay where it's served - essentially only our 'inBanner' product for now
    	breakoutAd = wahwah.adconfig.inpage.inAdBreakout;
    }

    if (wahwah.adconfig.inpage.adFormat == "wallpaper") 
	{
    	isWallpaper = true;
    }

    if (wahwah.adconfig.inpage.adFormat == "ostream") 
	{

    	outstreamUnit = true;

    	if (wahwah.adconfig.inpage.outstreamTriggerId != "")
    		triggerId = wahwah.adconfig.inpage.outstreamTriggerId;

    }

	function loadCreative()
	{
		wwLog.call(wwConsole, wwPrefix, "loadCreative id:" + lineItemChosenMetadata.lineItem.id);
		
		chosenVASTTechnology = "unknown";
		
		var vastObj = lineItemChosenMetadata.vastObj;
		
		if (vastObj != null)
		{
			// vast tag
			try {
				var test1 = vastObj.ads;
				var test2 = test1[0];
			}
			catch(e)
			{
				wwLog.call(wwConsole, wwPrefix, "Passback detected: " + lineItemChosenMetadata.lineItem.id );
				adErrorHandler("passback");
				return;
			}
			
			try 
			{
				insertRPVASTTrackers(vastObj);
				chosenVASTTechnology = playerTechChoice(vastObj);
				vastXML = wwSerialize(vastObj); // Pass later, not on initial call. Very large
				if (chosenVASTTechnology == "unknown")
				{
					wwLog.call(wwConsole, wwPrefix, "Unknown mediafile type for line item id: " + lineItemChosenMetadata.lineItem.id );
					adErrorHandler("media");
				}
				else
				{
					loadCreativeDisplayTag(true);
				}
			}
			catch(e)
			{
				wwLog.call(wwConsole, wwPrefix, "loadCreative failed id:" + lineItemChosenMetadata.lineItem.id);
				adErrorHandler("loadCreative");
				throw(e);
			}
		}
		else
		{
			// html / js tag
			loadCreativeDisplayTag(false);
		}
	}
	
	var scrolltrackerIsVideo;
	function loadCreativeDisplayTag(isVideo)
	{
		createOutstreamHolder();
		if (((outstreamUnit)&&(!outstreamAutoload))||(gadgetReview))
		{
			// wait until scrolled to right area
			wwLog.call(wwConsole, wwPrefix, "Waiting for scroll action to correct part of page");
			scrolltrackerIsVideo = isVideo;
			return;
		}
		
		wwLog.call(wwConsole, wwPrefix, "Loading tag immediately");
		buildFiF(true, isVideo);
		
	}
	
	function loadCreativePassbackTag(html)
	{
		try{ // Make sure API passback is called
			wwLog.call(wwConsole, wwPrefix, "Loading passback where original tag written out");
			var right = null;
            if (isFloating)
            	right = 30;
			createDivWrapper(null, right, null, "transparent", null, null, "0px", 10000000, uuid, false)
			var wrap = mainWindow.document.getElementById("wwDivWrapper_" + uuid);
			wrap.innerHTML = html;
		}
		catch (e)
		{
			wwError.call(wwConsole, wwPrefix, "loadCreativePassbackTag error: " + e);
		}
	}
	
	function insertRPVASTTrackers(vastObj)
	{
		if (typeof(vastObj) == "undefined" || vastObj == null)
			return;
		// Date.now() will only allow cachebusting once per player load (pretty good) timestamp may add ability to call same tracker multiple times (better)
		// The two together: perfect (in theory).
		var cb = "[CACHEBUSTING]_" + Date.now(); 
		var vastImpressionTrackerURL = generateTrackUrl("advastevent", {"v_event": "impression"}, cb);
		var vastErrorTrackerURL = generateTrackUrl("advastevent", {"v_event": "error", "data": "[ERRORCODE]"}, cb);
		
		//var vastClickTrackerURL
		// var vastImpressionTrackerURL
		vastObj.ads[0].impressions.push( {
			"id": "rpImpression",
			"url": vastImpressionTrackerURL
		});
		vastObj.ads[0].errors.push(vastErrorTrackerURL);
		var vastTrackingEventArray = ["creativeView","start","firstQuartile","midpoint",
			"thirdQuartile","complete", "mute", "unmute", "pause", "rewind", "resume",
			"fullscreen", "exitFullscreen", "acceptInvitationLinear", "closeLinear", "skip", 
			"click" /* Note: Click results in a Videoclicks element in serializer*/];
		for (var i = 0; i < vastTrackingEventArray.length; i++)
		{
			var evt = vastTrackingEventArray[i];
			var trkurl = generateTrackUrl("advastevent", {"v_event": evt}, cb);
			if (typeof(vastObj.ads[0].linear.tracking.events[evt]) == "undefined")
			{
				vastObj.ads[0].linear.tracking.events[evt] = [];
			}
			var eventArray = vastObj.ads[0].linear.tracking.events[evt];
			eventArray.push( {
					event: evt,
					offset: null,
					"url": trkurl
				});
		}
	}
	
	function adErrorHandler(type, etyp)
	{
		wwLog.call(wwConsole, wwPrefix, "adError handler called. Try next. Type="+type);
		if (typeof(etyp) == "undefined" || etyp == null)
			etyp = "unknown";
		if (type == "passback")
		{
			rpTrack("adpassback", {
			/* Already added in rpTrack
				"adid": lineItemChosenMetadata.trackingInfo.adid,
				"cid": lineItemChosenMetadata.trackingInfo.cid,
				"oseq": lineItemChosenMetadata.trackingInfo.oseq,*/
				"etyp": etyp,
			});	
		}
		alreadyStartedSelection = false;
		lineItemChosenMetadata = null;
		setTimeout(beginSelection);
	}
	
	
	var tagHTML5VPAID = false;
	var tagFlashVPAID = false;
	var tagFlashVideo = false;
	var tagHTML5Video = false;
	
	function playerTechChoice(loadedXMLDoc)
	{
		var vvLinear = loadedXMLDoc.ads[0].linear;
		if (typeof(vvLinear) == "undefined" || vvLinear == null)
		{
			wwError.call(wwConsole, wwPrefix, "VAST fatal error: No linear element")
			fatalError();
		}

		var vvmf = vvLinear.mediaFiles;
		for (var i = 0; i < vvmf.length; i++)
		{
					var mediaf = vvmf[i];
					switch (mediaf["type"].toLowerCase())
					{
						case "video/mp4":
							tagFlashVideo = true;
							tagHTML5Video = true;
				break;
			  case "video/x-flv":
							tagFlashVideo = true;
							break;
						case "application/x-shockwave-flash":
							if (mediaf["apiFramework"] && mediaf["apiFramework"].toLowerCase() == "vpaid")
								tagFlashVPAID = true;
							break;
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

		wwLog.call(wwConsole, wwPrefix, ".........Decision logic time");
		wwLog.call(wwConsole, wwPrefix, "tagHTML5Video: " + tagHTML5Video);
		wwLog.call(wwConsole, wwPrefix, "tagFlashVideo: " + tagFlashVideo);
		wwLog.call(wwConsole, wwPrefix, "tagHTML5VPAID: " + tagHTML5VPAID);
		wwLog.call(wwConsole, wwPrefix, "tagFlashVPAID: " + tagFlashVPAID);

		var playerHeight = adConfig.inpage.vidHeight;

		// Make decision . Default to Flash for now on browsers that support and don't pause it and handle cases it wouldn't be paused in Chrome and Safari.
		if(tagHTML5Video || tagHTML5VPAID)
		{
			wwLog.call(wwConsole, wwPrefix, "Choosing html5 (uaBrowser=" + uaBrowser + ")");
			return "html5";
		} 
		else if ( (tagFlashVideo || tagFlashVPAID) && ( (uaBrowser != "Safari" && uaBrowser != "Chrome" ) || /* is safari or chrome and */ playerHeight >= 300) )
		{
			wwLog.call(wwConsole, wwPrefix, "Choosing Flash (uaBrowser=" + uaBrowser + " and height="+playerHeight+")");
			return "flash";
		}
		else
		{
			wwLog.call(wwConsole, wwPrefix, "Tag does not contain a valid MediaFile option! (uaBrowser=" + uaBrowser + ")");
			return "unknown";
		}

	}
	
	
	function createOutstreamHolder()
	{
		if ((outstreamUnit)&&(!outstreamAutoload)) 
		{

            // TriggerCode/Scrolling will always be in the mainWindow
            var triggerCode = mainWindow.document.getElementById(triggerId);

			//if (outstreamScrollFloater)
				triggerCode.parentNode.insertBefore(createScrollTracker(), triggerCode.nextSibling);
			/*else
				triggerCode.insertBefore(createScrollTracker(), triggerCode.firstChild);*/

			wwLog.call(wwConsole, wwPrefix, "Successfully added the scrollTracker");

			sT = mainWindow.document.getElementById("scrollTracker_" + uuid);
            mainWindow.window.addEventListener('scroll', scrollInitialListener, false);

        } else if (inAd&&gadgetReview) {
        	var wahwahScript = wahwah.currentScriptTag.parentNode
        	wahwahScript.parentNode.insertBefore(createScrollTracker(), wahwahScript.nextSibling);
        	wwLog.call(wwConsole, wwPrefix, "Successfully added the scrollTracker");
        	sT = mainWindow.document.getElementById("scrollTracker_" + uuid);
        	mainWindow.window.addEventListener('scroll', scrollInitialListener, false);
        }
        else
        {	
        	wwLog.call(wwConsole, wwPrefix, "Loading Display Ad");

            if (!isFloating && !isInterstitial && !isWallpaper) {
            	try {
            		createDivPlaceholder();
            	} catch (e) {
            		wwForceLog.call(wwConsole, wwPrefix, 'RP :: No TriggerId on Page - Stopping Loading');
            		return;
            	}
            }
		}
	}
	
	
    // Separating the Placeholder because it's not always necessary i.e. Floater units
    function createDivPlaceholder() {

            var wahwahScript = wahwah.currentScriptTag.parentNode;
            var divPlaceholder = mainWindow.document.createElement("div");
            divPlaceholder.id = "wwDivPlaceholder_" + uuid;
            divPlaceholder.style.position = "relative";
            divPlaceholder.style.bottom = "0px";
            divPlaceholder.style.transition = "height .4s";

            if (!outstreamUnit) {
            	divPlaceholder.style.width = wahwah.adconfig.inpage.displayWidth + "px";
            	divPlaceholder.style.height = wahwah.adconfig.inpage.displayHeight + "px";
            } else {
            	divPlaceholder.style.width = 0 + "px";
            	divPlaceholder.style.height = 0 + "px";
            }

            if ((inAd)&&(!breakOutAd)) {
            	// If there is no FiF, need to go off of where the script is place
            	// Otherwise will attach to the bottom of the main page
            	if ((window.inDapIF == true || window.inFIF == true) && (!marketPlaceTag))
            		mainWindow.document.body.appendChild(divPlaceholder);
               	else
               		wahwahScript.insertBefore(divPlaceholder, wahwahScript.lastChild);

				if (gadgetReview) {
					if (wahwah.adconfig.inpage.expansionAlignHoriz == "center") {
					    divPlaceholder.style.margin = "0 auto";
					}
				}
                	
            } else {
               if (outstreamAutoload) {
                	if (mainWindow.document.getElementById(triggerId))
                		mainWindow.document.getElementById(triggerId).parentNode.insertBefore(divPlaceholder, mainWindow.document.getElementById(triggerId).nextSibling); 
                	else {
                		// Trigger Id not found, finding a div to attach after...
                		// 'single-post' making sure it's a article page
                		if (mainWindow.document.body.classList.contains('single-post')) {

                			if (mainWindow.document.getElementById('content-wrapper')) {
                				var cWrapper = mainWindow.document.getElementById('content-wrapper');
                				var elementsInWrapper = cWrapper.getElementsByClassName("entry-content")[0].childNodes;
                			} else {
                				var cWrapper = mainWindow.document.body.getElementsByTagName("ARTICLE");
                				var elementsInWrapper = cWrapper[0].getElementsByClassName("entry-content")[0].childNodes;
                			}

                			if (elementsInWrapper.length >= 12) {
                				elementsInWrapper[12].parentNode.insertBefore(divPlaceholder, elementsInWrapper[12].previousSibling);
                				return true;
                			}
                		} else 
                			return false;	
                	} 

                }
                else // Need to minimize the divPlaceholder if they are floaters... otherwise they will take up space on the page
                {
                    divPlaceholder.style.width = "1px";
                    divPlaceholder.style.height = "1px";
                    if (!breakOutAd)
                        mainWindow.document.body.appendChild(divPlaceholder); 
                }
            }

            return divPlaceholder;
    }
	
	
	
	    function buildFiF(wrapper, isVideo) {

            var left = null;
            var right = null;
            var top = null;
            var bottom = null;
            var height = null;
            var width = null;
            var marginLeft = null;
            var zIndex = 10000;

            videoAd = isVideo ? true : false;

            if (isFloating || outstreamUnit)
            	right = 30;

            if (wrapper)
                createDivWrapper(left, right, top, "transparent", width, height, "none", zIndex, uuid, false);
				
            if(isVideo) {
					
                if ((inAd)&&(!breakOutAd))
                    var wrap = document.getElementById("wwDivWrapper_" + uuid);
                else 
                    var wrap = mainWindow.document.getElementById("wwDivWrapper_" + uuid);

                wrap.style.height = wahwah.adconfig.inpage.vidHeight + "px";
                
                if (!marketPlaceTag)
                	marginLeft = wahwah.adconfig.inpage.vidWidth - wahwah.adconfig.inpage.displayWidth;

                if (wahwah.adconfig.inpage.expansionAlignHoriz == "left") {
				    wrap.style.marginLeft = "0px";
				} else if (wahwah.adconfig.inpage.expansionAlignHoriz == "center") {
				    wrap.style.margin = "0 auto";
				} else { // Let's default if "right" or "null"
				    wrap.style.marginLeft = "-" + marginLeft + "px";
				}

				if (isInterstitial) {

					var interstitialDiv = mainWindow.document.getElementById("wwDivInterstitial_" + uuid);
					wrap.style.marginTop = (interstitialDiv.clientHeight/2) - (parseInt(wrap.style.height)/2) + "px";
					
					mainWindow.onresize=function() {
						if (!!interstitialDiv)
							wrap.style.marginTop = (interstitialDiv.clientHeight/2) - (parseInt(wrap.style.height)/2) + "px";
					}
				}

                width = wahwah.adconfig.inpage.vidWidth + "px";
                height = wahwah.adconfig.inpage.vidHeight + "px";
                var html = '<!DOCTYPE html><html><head><base href="${WAHWAHROOT}ads/adcontainers/videoad/"><title>wahwah adframe</title><link rel="stylesheet" type="text/css" href="${WAHWAHROOT}ads/adcontainers/videoad/vidplayerframe.css" /></head><body><scr'+'ipt>var uuid = "'+uuid+'";</scr'+'ipt><scr'+'ipt type="text/javascr'+'ipt" src="${WAHWAHROOT}ads/adcontainers/videoad/vidplayerframe.js"></scr'+'ipt></body></html>';
            } else {
                var html = '<!DOCTYPE html><html><head><base href="${WAHWAHROOT}ads/adcontainers/display/"><meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0,maximum-scale=1.0, user-scalable=0"/><title>wahwah adframe</title></head><body style="margin: 0px 0px 0px 0px; overflow: hidden; background-color: transparent;" ><scr'+'ipt>var uuid = "'+uuid+'";</scr'+'ipt><scr'+'ipt type="text/javascr'+'ipt" src="${WAHWAHROOT}ads/adcontainers/display/displayadframe.js"></scr'+'ipt></body></html>';
            	width = wahwah.adconfig.inpage.displayWidth + "px";
                height = wahwah.adconfig.inpage.displayHeight + "px";
            }
            
            html = html.replace(/\$\{WAHWAHROOT\}/g, baseUrl);             
			
            var vars = {
                "friendlyAdFrameId": "" + wahwah.adconfig.inpage.displayWidth + "x" + wahwah.adconfig.inpage.displayHeight,
                "friendlyAdFrameConfig": wahwah.adconfig,
                "friendlyAdFrameDisplayType": getDisplayType(),
                "friendlyAdFrameType": "inpage",
                "friendlyAdReloaded": false,
                "friendlyAdFramePlacementId": uuid,
				"friendlyAdFrameUABrowser": uaBrowser,
				"friendlyAdFrameReferrerMacro": referrer,
				"friendlyAdFrameDomainMacro": domain,
				"friendlyAdFrameVASTPlayer": chosenVASTTechnology, /* May not be set */
				"friendlyAdFrameVASTPlayerVastXML": vastXML, /* May not be set */
				"friendlyAdFrameLineItemChosenMetadata": lineItemChosenMetadata,
				"friendlyAdFrameTagAdTechnologies": {
						"html5VPAID": tagHTML5VPAID,
						"flashVPAID": tagFlashVPAID,
						"flashVideo": tagFlashVideo,
						"html5Video": tagHTML5Video
					},

                };

            (isFloating) ? zIndex = 100000000000 : zIndex = 1000;

            var wrapper = createFriendlyIframe(html, vars, left, right, top, "transparent", width, height, "none", zIndex, uuid, isVideo);
    }
	
	
	// We don't have to do detection for this one if page is already loaded, since this can only run after page is loaded
	function createFriendlyIframe(content, vars, left, right, top, background, width, height, border, zindex, id, isVideo)
	{

        var newIframe = mainWindow.document.createElement('iframe'); // IAB-compliant container div. Ad should not come out of it
		var divWrapper;
        if ((inAd&&!breakOutAd))
           divWrapper  = document.getElementById("wwDivWrapper_" + uuid);
        else     
           divWrapper = mainWindow.document.getElementById("wwDivWrapper_" + uuid);

		newIframe.width = width;
		newIframe.height = height;
		newIframe.src = 'about:blank'; 

		divWrapper.appendChild(newIframe);

		newIframe.contentWindow.friendlyLoaderHTML = content;
		newIframe.contentWindow.inDapIF = true;
		newIframe.id = "wwAdFiF_" + id;
		if (!isVideo) {
			//newIframe.style.width = "300px";
			//newIframe.style.height = "250px";
		} else {
			newIframe.style.width = width + 15 +"px";
			newIframe.style.height = height + 15 + "px";
		}

		if (marketPlaceTag) {

            parentMPFrame.style.height = height;
            parentMPFrame.style.width = width;
            parentMPWrapper.style.height = height;
            parentMPWrapper.style.width = width;
			if (parentMPPlaceholder != null)
			{
				parentMPPlaceholder.style.height = height;
				parentMPPlaceholder.style.width = width;
			}
            
            MPPlaceholder = document.getElementById("wwDivPlaceholder_" + uuid)
            document.getElementById("wwDivPlaceholder_" + uuid).style.height = height;
        	document.getElementById("wwDivPlaceholder_" + uuid).style.width = width;
            MPPlaceholder.style.height = height;
            //document.getElementById("wwDivPlaceholder_" + uuid).style.width = width + "px !important";

            parentMPFrame.style.marginLeft = "0px";
            
        }

        newIframe.style.border = "0px";
        newIframe.scrolling = "no";
        newIframe.style.overflow = "hidden";

		// Setting vars in the iframe contentWindow had mixed results cross-browser, probably getting cleard out sometimes on load, so stick it in current window
		if (typeof(rpSharedVarArray[uuid]) == "undefined")
			rpSharedVarArray[uuid] = {};
        rpSharedVarArray[uuid].iframeVars = {};
		for (var key in vars) {
		  if (vars.hasOwnProperty(key)) {
			rpSharedVarArray[uuid].iframeVars[key] = vars[key];
		  }
		}

		mainWindow.rpSharedVarArray = rpSharedVarArray;

		if (outstreamUnit) {  // Outstream units need to be centered in the content
            mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.margin = "0 auto";
            mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.margin = "0 auto"
            mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.height = height;
            mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.width = width;
	    }

		rpSharedVarArray[uuid].iframeVars["friendlyAdFrameBase"] = baseUrl;
		rpSharedVarArray[uuid].iframeVars["app"] = wahwah.app;

            //window.wahwah.iframeVars["customCampaign"] = function(campaign, width, height) {
            rpSharedVarArray[uuid].iframeVars["customCampaign"] = function(campaign, width, height) {	

	            isCustomCampaign = true;

	                friendlyFrameGetter().style.height = height + "px";
	                friendlyFrameGetter().style.width = width + "px";

	               	// Centering the units for headline and expanding
		        	if (outstreamUnit){
                        mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = height + "px";
                        mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.width = width + "px";
			    	}

			    		if (marketPlaceTag) { // Essentially the MP Tag is an inAd Banner unit
			    			parentMPPlaceholder.style.height = height + "px";
            				parentMPPlaceholder.style.width = width + "px";
            				parentMPWrapper.style.height = height + "px";
            				parentMPWrapper.style.width = width + "px";
                        	parentMPFrame.style.height = height + "px";
                        	parentMPFrame.style.width = width + "px";
                        }

				        // If InPage Unit
						var leftMargin = width - wahwah.adconfig.inpage.displayWidth;

				        if (wahwah.adconfig.inpage.expansionAlignHoriz == "left") {
				            friendlyFrameGetter().style.marginLeft = "0px";
				        } else if (wahwah.adconfig.inpage.expansionAlignHoriz == "center") {
				            //friendlyFrameGetter().style.marginLeft = "-" + leftMargin/2 + "px";
				            friendlyFrameGetter().style.margin = "0 auto";
				        } else { // Let's default if "right" or "null"
				            friendlyFrameGetter().style.marginLeft = "-" + leftMargin + "px";
				        }

			        if (campaign == "virool") {
                    		// virool is doing something weird , display="none" on the parent (placeholder) div
                    		// select the target node
							/*var target = document.getElementById("wwDivPlaceholder_" + uuid);
							 
							// create an observer instance
							var observer = new MutationObserver(function(mutations) {
							  mutations.forEach(function(mutation) {
							  	if (mutation.type == "attributes") {
							  		target.style.display = "block";
							  		observer.disconnect();
							  	}
							  });    
							});
							 
							// configuration of the observer:
							var config = { attributes: true, childList: true, characterData: true };
							 
							// pass in the target node, as well as the observer options
							observer.observe(target, config);*/
							 
                    }

                    if (campaign == "yellowhammer") {

                    }


	                friendlyAdFrames[tmpIDHack].style.height = height + "px";
	                friendlyAdFrames[tmpIDHack].style.width = width + "px";

					if (campaign == "allscreen") 
					{
                    	friendlyAdFrames[tmpIDHack].style.height = 0 + "px";
	                	friendlyAdFrames[tmpIDHack].style.width = 0 + "px";
	                	friendlyAdFrames[tmpIDHack].style.display = "none";
	                	divWrapper.style.height = 347 + "px";
	                	if (!isFloating) {
	                		mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = 347 + "px";
	                	}       
                    }

                    if (isWallpaper) {
                    	friendlyFrameGetter().style.height = "100%";
	                	friendlyFrameGetter().style.width = "100%";
                    	friendlyAdFrames[tmpIDHack].style.height = "100%";
	                	friendlyAdFrames[tmpIDHack].style.width = "100%";
                    }
        	}


		friendlyAdFrames[id] = newIframe;
		friendlyWrappers[id] = divWrapper;
        friendlyPlaceholder[id] = mainWindow.document.getElementById("wwDivPlaceholder_" + uuid);

		// It seems IE11 can use the open() approach, but IE9 needs it. Not sure about 10. So just using
		// it across the board in IE to be safe. Doesn't cause problems in IE11
		// Haven't seen throbber animation issue in Firefox lately, include Firefox here too?
		if (uaBrowser == "IE") 
		{
			newIframe.src = 'javascript:window["friendlyLoaderHTML"]';
		}
		else
		{
			newIframe.contentWindow.document.open().write(content);
			newIframe.contentWindow.document.close();
		}

		// console.log("~~~~~~~~loader.js 2");
		tmpIDHack = id;
		return divWrapper;
	}
	
		
	var tmpIDHack = null;
	function friendlyFrameGetter()
	{
        //wwDebug.call(wwConsole, wwPrefix, friendlyWrappers[tmpIDHack]);
		return friendlyWrappers[tmpIDHack];
	}
	
	
    function removeFriendlyIframe(wrapper) { // If wrapper is true then removes divWrapper also

        wwDebug.call(wwConsole, wwPrefix, 'Removing FriendlyIFrame');

        for (i in friendlyAdFrames) {
			if(friendlyAdFrames.hasOwnProperty(i)) {
            	friendlyAdFrames[i].src = "about:blank";
            	friendlyAdFrames[i].style.display = "none";
            	friendlyAdFrames[i].parentNode.removeChild(friendlyAdFrames[i]); 

                if (wrapper) {
                    friendlyWrappers[i].style.display = "none";
                    friendlyWrappers[i].parentNode.removeChild(friendlyWrappers[i]);

                    if (friendlyPlaceholder[i] != null) {
                        friendlyPlaceholder[i].style.display = "none";
                        friendlyPlaceholder[i].parentNode.removeChild(friendlyPlaceholder[i]);
                    }
                }
			}
        }

        // Since we're making multiple calls with the same id we need to clear these out
        friendlyWrappers = [];
        friendlyAdFrames = [];
        friendlyPlaceholder = [];
    }
	
	
    function createDivWrapper(left, right, top, background, width, height, border, zindex, id, isVideo) {

        var divWrapper = mainWindow.document.createElement('div'); // IAB-compliant container div. Ad should not come out of it
        
        divWrapper.style.width = width + "px";

        if (!isVideo) {
            if (height != null)
                divWrapper.style.height = height + "px";
            else 
                divWrapper.style.height = "250px";
        } else {
            // Needing to set height for wrapper for video
            divWrapper.style.height = vidHeight + "px";
        }

        // Make sure this isn't below the fold, or else Flash may not load
        if (top != null)
            divWrapper.style.top = top;
        else
            divWrapper.style.bottom = -height + "px";

        if (right != null)
            divWrapper.style.right = right + "px";
        else if (left != null)
            divWrapper.style.left = left;

        divWrapper.style.zIndex = zindex;
        divWrapper.style.backgroundColor = background;
        divWrapper.id = "wwDivWrapper_" + id;
        //divWrapper.style.height = "250px";

        if (isInterstitial) {
        	divWrapper.style.position = "relative";
        	divWrapper.style.width = 558 + "px";
        	divWrapper.style.margin = "0 auto";
        } else if (isWallpaper) {
        	divWrapper.style.width = "100%";
        	divWrapper.style.height = "100%";
        	divWrapper.style.position = "fixed";
        	divWrapper.style.backgroundPosition = "50% 0%";
        	divWrapper.style.zIndex = '-1000';
        } else if ((!isFloating)&&(!outstreamUnit)) {
            divWrapper.style.position = "relative"; 
    	} else {
        	divWrapper.style.position = "fixed";
        	divWrapper.style.bottom = "0px";
        }

        // these units need the placeholder - 
        if((((inAd)&&(!breakOutAd))||(outstreamUnit))&&(!marketPlaceTag)) {
            mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).appendChild(divWrapper);
        // Interstitials need to find the interstitial div
        } else if (isInterstitial) {
        	mainWindow.document.getElementById("wwDivInterstitial_" + uuid).appendChild(divWrapper);
        // Floating units do not need the "wwDivPlaceholder_"
        } else if (isWallpaper){
        	mainWindow.document.body.insertBefore(divWrapper, mainWindow.document.body.firstChild)
        } else if (marketPlaceTag) {
        	document.getElementById("wwDivPlaceholder_" + uuid).appendChild(divWrapper);
        } else {
            // 1 of 2 options :: Floater or inAd and Breaking out of the DFP 
            // But always mainWindow
            mainWindow.document.body.appendChild(divWrapper); 

            // Repositions the inpage banner on scroll
            if (breakOutAd) {
                var offSetY = 23; // This could become dependent on individual pub
                // Won't work if not in an FiF
                var FifY = findPosY(pubInDapIFFrame);
                divWrapper.style.position = "fixed";
                divWrapper.style.left = findPosX(pubInDapIFFrame) + "px";
                divWrapper.style.top = (findPosY(pubInDapIFFrame) - offSetY) + "px";

                mainWindow.window.addEventListener('scroll', positionWrapper, false);
            }
        }

        // Because the divWrapper is written on the main page we have to reposition it on user scroll
        function positionWrapper() {
            divWrapper.style.top = (FifY - offSetY - mainWindow.document.body.scrollTop) + "px";
        }

        // Don't need close button if it's a wallpaper unit
        if ((!isVideo)&&(!isWallpaper))
        {
            var adControlsOverlay = document.createElement('div');
            adControlsOverlay.id = "wwAdControlsOverlay_"+id;
            adControlsOverlay.style.position = "absolute";
            adControlsOverlay.style.textAlign = "center";

                // Ad Container Might Not Actually Fit On Screen....

                var overlayRightPos = 0;
                
                if(width > screen.width){
                    overlayRightPos = width - screen.width;
                }

                adControlsOverlay.style.width = "30px";
                adControlsOverlay.style.height = "30px";
                adControlsOverlay.style.right = overlayRightPos + "px";
                adControlsOverlay.style.top = "-15px";
                adControlsOverlay.style.cursor = "pointer";
                adControlsOverlay.innerHTML = '<img id="wwClose_'+id+'" src="'+baseUrl+'/ads/images/close.png">';


            adControlsOverlay.style.display = "none";

            function adControlsOverlayPressed()
            {
            	   // All Video need to send back to the vidplayerframe.js
                   if (videoAd) {

                   		var messageObjResponse =
	                    {
	                        type: "closeVideo",
	                        destination: ModuleEnums.MODULE_ADS,
	                        id: uuid
	                    };


	                    mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.height = 0 + "px";
						mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).style.transition = "height .4s";
						mainWindow.document.getElementById("wwDivWrapper_" + uuid).style.display = "none";
            			mainWindow.document.getElementById("wwDivPlaceholder_" + uuid).addEventListener('transitionend', function() { 
            				sendMessage(ModuleEnums.MODULE_ADS, JSON.stringify(messageObjResponse));
            			});
                    	
                   } else {

                   		// Need to be able to remove the parent Frame when the
	                    // Close button is hit on the MP Frame
	                    if (marketPlaceTag) { 
	                    	parentMPPlaceholder.style.display = "none";
	                        parentMPPlaceholder.parentNode.removeChild(parentMPPlaceholder);
	                    }

	                    if (wahwah.clientFeatures['purchBusinessNewsDaily']) {
	                        pubInDapIFFrame.style.height = "150px";
	                    }

	                    if (inAd) {
	                        wwDebug.call(wwConsole, wwPrefix, "Should reload a 300x250");
	                        placementType = PlacementTypes.BACKUP_AD;
	                   	}

                   		removeFriendlyIframe(true);
                   }	

                   //removeFriendlyIframe(true);
            }
            
            addListener(adControlsOverlay, "mouseup", adControlsOverlayPressed);
            
            divWrapper.appendChild(adControlsOverlay);
        }
    }
	
	
    /////////////////////////////////////	
    // VAST XML Serialization
    /////////////////////////////////////
	
	
	// http://help.dottoro.com/ljbcjfot.php
	function wwSerialize(vvDoc)
	{
		wwLog.call(wwConsole, wwPrefix, "Serializing doc");

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
				if (vvLinear.adParameters != null && vvLinear.adParameters.length > 0)
					conditionalCreateCDATAInfoElement(vastXML, linear, "AdParameters", vvLinear.adParameters[0].textContent);

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
					if (vvNonLinear.adParameters != null && vvNonLinear.adParameters.length > 0)
						conditionalCreateCDATAInfoElement(vastXML, nonLinear, "AdParameters", vvNonLinear.adParameters[0].textContent);
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
					if (vvCompanion.adParameters != null && vvCompanion.adParameters.length > 0)
						conditionalCreateCDATAInfoElement(vastXML, companion, "AdParameters", vvCompanion.adParameters[0].textContent);
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

	function CreateMSXMLDocumentObject () 
	{
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
	
	
	
    /////////////////////////////////////	
    // Visibility/viewability
    /////////////////////////////////////
	
	
	function checkVisible( elm ) {


        var vpH = viewPortHeight(), // Viewport Height
            st = scrollY(), // Scroll Top
            ht = parseInt(elm.style.height),
            y = elementYPos(elm);

            /*console.log('Viewport Height ' + vpH);
            console.log('scrollY ' + st);
            console.log('Element Height: ' + ht);
            console.log('Element Y Position ' + y);*/

            // Not sure why we need this if statement ---  DFP maybe?
        //if (outstreamScrollFloater) {
        	if (st > y) {
                return true;
            } else {
                return false;
            }
        /*} else {
			if ((y < (vpH + st)) && (y > (st - ht))) {
	            return true;
	        } else if ((y < (vpH + st))) {
	            return false;
	        } else {
	            return false;
	        }
        }*/
    }
	
	
    function findPosX(obj) {
		var curleft = 0;
		if (obj.offsetParent) {
		    while (1) {
		        curleft+=obj.offsetLeft;
		        if (!obj.offsetParent) {
		            break;
		        }
		        obj=obj.offsetParent;
		    }
		} else if (obj.x) {
		    curleft+=obj.x;
		}
		return curleft;
	}

	function findPosY(obj) {
		var curtop = 0;
		if (obj.offsetParent) {
		    while (1) {
		        curtop+=obj.offsetTop;
		        if (!obj.offsetParent) {
		            break;
		        }
		        obj=obj.offsetParent;
		    }
		} else if (obj.y) {
		    curtop+=obj.y;
		}
		return curtop;
	}

	function elementYPos(elm) {
        var test = elm, top = 0;

        while(!!test && test.tagName.toLowerCase() !== "body") {
            top += test.offsetTop;
            test = test.offsetParent;
        }

        return top;
    }

	function viewPortHeight() {
        var de = mainWindow.document.documentElement;
        var iw = mainWindow.window.innerWidth

        
        if(!!iw)
        { return iw; }
        else if( de && !isNaN(de.clientHeight) )
        { return de.clientHeight; }

        return 0;
    }

    function scrollY() {
        if( window.pageYOffset ) { 
            return window.pageYOffset; 
        }
        return Math.max(document.documentElement.scrollTop, document.body.scrollTop);
    }
	
    /////////////////////////////////////	
    // Performance
    /////////////////////////////////////
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
	
	

	function initMessaging(windowToAttach) // Messaging between modules
    {
		if(typeof windowToAttach == "undefined"){
			windowToAttach = window;
		}

        switch (wahwah.environment) {
            case "local":
                domain = "*"; // "localhost";
                break;
            case "staging":

                break;
            case "production":

                break;
        }

        addListener(windowToAttach, "message", receiveMessage);
    }
	
	
	
    /////////////////////////////////////	
    // API STUFF
    /////////////////////////////////////

	
	function sendAPIEvent(eventname, data)
	{
		var event; // The custom event that will be created
		
		if (typeof(wahwah.currentScriptTag) == "undefined" || wahwah.currentScriptTag == null)
		{
				wwWarn.call(wwConsole, wwPrefix, "API event fail: " + eventname + " currentScriptTag=" + wahwah.currentScriptTag);
		}
		
		var element = wahwah.currentScriptTag;
		
		try {
			if (document.createEvent) 
			{
				event = document.createEvent("HTMLEvents");
				event.initEvent(eventname, true, true);
				
				element.dispatchEvent(event);
			} 
			else 
			{
				event = document.createEventObject();
				event.eventType = eventname;
				
				element.fireEvent("on" + event.eventType, event);
			}
			
			wwLog.call(wwConsole, wwPrefix, "API event successful: " + eventname + " " + JSON.stringify(data));
		}
		catch (e)
		{
			if (typeof(wahwah.currentScriptTag) == "undefined" || wahwah.currentScriptTag == null)
			{
				wwWarn.call(wwConsole, wwPrefix, "API event fail: " + error);
			}
		}
		
	}
})(); 

// API Method 2: Allow page to immediately pick up the script tag if it doesn't know ID. Available only immediately if multiple tags on page
var __RP_CURRENTSCRIPTTAG = RP_CURRENTSCRIPTTAG = wahwah.currentScriptTag; 

