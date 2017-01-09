if (typeof console == "undefined")
{
	var console = {};
	wwLog = function () { };
}
	
function wahwahFunctions() // Sandbox to avoid ad interference
{
	var uuid = window.uuid;
	
	// uuid is the only thing set, and only thing that needs to be set, in initial html's JS before this JS is written out
	var wahwah = parent.rpSharedVarArray[uuid];

	var widgetId = wahwah.id;


	// Pulls the id number from the iframe
	var fifId = wahwah.iframeVars.friendlyAdFrameId;
	var adConfig = wahwah.iframeVars.friendlyAdFrameConfig;
	var placementType = wahwah.iframeVars.friendlyAdFramePlacementType;
	var displayType = wahwah.iframeVars.friendlyAdFrameDisplayType;
	var tbBase = wahwah.iframeVars.friendlyAdFrameBase;
	var adReloaded = wahwah.iframeVars.friendlyAdReloaded;
	var app = wahwah.iframeVars.app;
	var adBase = tbBase+"ads/adcontainers/display/";
	var clientFeatures = wahwah.clientFeatures;
	var referrer = wahwah.iframeVars.friendlyAdFrameReferrerMacro;
	var domain = wahwah.iframeVars.friendlyAdFrameDomainMacro;
	var lineItemChosenMetadata = wahwah.iframeVars.friendlyAdFrameLineItemChosenMetadata;
	var uaBrowser = wahwah.iframeVars.friendlyAdFrameUABrowser;
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
					
	var lineItem = lineItemChosenMetadata.lineItem;
	var adCreative = lineItem.ad_map[lineItem.ads[0]].creative;	// What about when there's multiple creatives?

	var adHTML = adCreative.tag_contents; // Write out at bottom BEFORE wahwahFunctions

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
		
	var adType = wahwah.iframeVars.friendlyAdFrameType;
	var customCampaign = false;
	var customCampaignName;
	var myspaceAdStarted = false;

	/* Avoid `console` errors in browsers that lack a console. Modified based on: http://html5boilerplate.com/ */ (function() { var method; var noop = function () {}; var methods = ['debug','error','info', 'log','warn']; var length = methods.length; var console = (window.console = window.console || {}); while (length--) { method = methods[length]; /* Only stub undefined methods. */ if (!console[method]) { console[method] = noop; } } }()); /* First, check if IE running in Quirks mode, which treats window.console.log as an object, not ECMAScript function, and doesn't support .call on that object */ if (typeof(window.console.log.call) != "function") { console.warn("[Wahwah] This debugger doesn't support console.* as a function / console.log.call, etc. Possibly IE in Quirks/Compatibility mode or Firebug. View on web or localhost (not local or intranet) and in HTML5 or use a debug toolbar that supports console.* as a true ECMAScript function.");  /* Next, create console.log placeholder if it doesn't exist */	window.console = { 	debug : function() {}, 	error: function() {}, info: function() {}, 	log: function() {}, warn: function() {} }; }; /* Create addListener placeholder, when it doesn't exist */ var addListener = function (e, t, n) { if ("addEventListener" in e) { e.addEventListener(t, n, true) } else if ("attachEvent" in e) { var r = function () { n(window.event) }; e.attachEvent("on" + t, r) } }; var removeListener = function (e, t, n) { if ("removeEventListener" in e) { e.removeEventListener(t, n, true) } else if ("detachEvent" in e) { var r = function () { n(window.event) }; e.detachEvent("on" + t, r) } }

		
	// Todo: Pass up the parent window chain when possible
	// Later, replace with htm5 BroadcastChannel message when all browsers support to decrease size
	if (typeof(window.wwMsg) == "undefined")
	{
		window.wwMsg = new function() {
			this._module = "Display Ads";
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

	// customCreative function is called from the openX tag
	function customCreative(custom, width, height) {
		wahwah.iframeVars.customCampaign(custom, width, height);

		if (custom != null) {
			customCampaign = true;
			customCampaignName = custom;
		}
	}


	wwDebug.call(wwConsole, wwPrefix, "displayadframe ts=" + getTime());

	// Don't use parent.* because Chrome complains when doing this locally without --allow-file-access-from-files
	var scriptURL = null;
	
	var ModuleEnums = {
		MODULE_LOADER: "Loader",
		MODULE_TOOLBAR: "Toolbar",
		MODULE_ADS: "Ads"
		};
	
	window.__RedPanda_Passback = function()
	{
		wwForceLog.call(wwConsole, wwPrefix, 'Network tag handling passback. widgetId:' + wahwah.id + ' uuid:' + wahwah.uuid);
		sendMessage("onAdDisplayError", ModuleEnums.MODULE_LOADER, { "etyp": "callback" });
	}
	
	// Wait until load because DOMContentLoaded, etc, is too early to check for all elements in page
	addListener(window, "load", startLoad);
	
	function httpValidCheck()
	{
	
		// Browsers don't provide a good way to handle 404/500, etc errors for .js script tags being written out before
		// the page is available. HTML5 provides an "error" event listener for most recent browsers, but by the time the DOM is
		// available, it's too late. Additionally, the method below works in older browsers. Start at body
		// and walk the tree. If there's no other elements but text nodes, then a 404/or 50* error occurred. Care will
		// need to be taken to avoid any other tags being written out after the scr ipt call by our own code.
		var itr = window.document.body.firstChild;
		var ELEMENT_NODE = 1;

		if ((customCampaignName	== "allscreen") || (customCampaignName	== "virool")) {
			return true;
		}
		while (itr != null)
		{
			if (itr.nodeType == ELEMENT_NODE)
			{
				if (itr.nodeName.toLowerCase() != "iframe" && itr.nodeName.toLowerCase() != "script" && itr.nodeName.toLowerCase() != "div" && itr.nodeName.toLowerCase() != "noscript")
					return true;
				else // Check for empty iframe for marketplace but nothing else
					if (itr.nodeName.toLowerCase() == "iframe" && (typeof(itr.width) != "undefined" && itr.width > 1 || typeof(itr.height) != "undefined" && itr.height > 1))
						return true;
					else if (itr.nodeName.toLowerCase() == "div" || itr.nodeName.toLowerCase() == "noscript") {    // Need to check what's inside the div 
						if (itr.style.visibility != "hidden") { // Check to make sure the div or noscript isn't hidden
							for (var i=0; i < itr.childNodes.length; i++) {
								if (itr.childNodes[i].nodeName.toLowerCase() != "iframe" && itr.childNodes[i].nodeName.toLowerCase() != "script" && itr.childNodes[i].nodeName.toLowerCase() != "#text")
									return true;
								else 
									if (itr.nodeName.toLowerCase() == "iframe" && (typeof(itr.width) != "undefined" && itr.width > 1 || typeof(itr.height) != "undefined" && itr.height > 1))
										return true;
							}	
						}
					}
			}
			itr = itr.nextSibling;
		}
		return false;
	}
	
	function startLoad()
	{
			function setVolume(volume) {
				MPX_SETVOLUME = function(){}
				$pdk.controller.mute(true);
				$pdk.controller.setVolume(volume);

			}

			// Defy Hack
			if (typeof $pdk !== 'undefined') {
				$pdk.ready(function(){
					$pdk.controller.addEventListener("OnPlayerLoaded", setVolume(0));
					//$pdk.controller.addEventListener("OnVolumeChange", setVolume(0));
				});
			}

			// AllScreen Hack
			/*if (parent.__asl) {
				sendMessage("allscreen", ModuleEnums.MODULE_LOADER, "");
			}*/
			
			removeListener(window, "load", startLoad);
			
			if (!httpValidCheck())
			{
				wwForceLog.call(wwConsole, wwPrefix, "http error detected on ad server script");		
				sendMessage("onAdDisplayError", ModuleEnums.MODULE_LOADER, { "etyp": "callback" });
				return;
			} else {
				// adImpression is DISPLAY ONLY (see https://wahwah.atlassian.net/wiki/display/WAHWAH/Tracking+Specification )
				// for video, advastevent v_event=impression is used instead
				rpTrack("adimpression", {
				/* Done in loader
								"adid": trackingInfo.adid,
								"cid": trackingInfo.cid,
								"oseq": trackingInfo.oseq,*/
								
								"browser": encodeURIComponent(uaBrowser)
								}  );
				// Only send if a 300x250 Display
				if (!customCampaign) 
				{
					sendMessage("onAdSuccessfulLoad", ModuleEnums.MODULE_LOADER, "");
				} else {
					sendMessage("onAdSuccessfulLoad", ModuleEnums.MODULE_LOADER, {"customCampaign": true, "customCampaignName": customCampaignName, "isVideo": false });
				}
			}
			// End Boobox hack
			addListener(window, "message", handleMessage);
			
			if (customCampaignName	== "virool") {

					var s = document.createElement("script");
					s.type = "text/javascript";
					s.src = "http://virool.at/js/widget.messageapi.js";
					document.body.appendChild(s);
				
					s.onload = function() {

						wwDebug.call(wwConsole, wwPrefix, "RP :: Virool Custom Campaign");

						window.onViroolInlineNoAds = function (wid) {
							wwDebug.call(wwConsole, wwPrefix, "RP :: Virool - No Offers");
							sendMessage("onAdDisplayError", ModuleEnums.MODULE_LOADER, { "etyp": "callback" });
						};

						// this function will trigger when user close unit or when video ends
						window.onViroolWidgetClose = function () {
							wwDebug.call(wwConsole, wwPrefix, "RP :: Virool - Widget Close");
							sendMessage("virool", ModuleEnums.MODULE_LOADER);
						};

						// this function will trigger when whenever we remove unit from page (close clicked, video ended, no-ads happened, error, etc.) 
						window.onViroolWidgetRemove = function () {
							wwDebug.call(wwConsole, wwPrefix, "RP :: Virool - Widget Close");
							sendMessage("virool", ModuleEnums.MODULE_LOADER);
						};

					};

					return true;
				}

				if (customCampaignName	== "allscreen") {
					wwDebug.call(wwConsole, wwPrefix, "RP :: Allscreen Custom Campaign");
					sendMessage("allscreen", ModuleEnums.MODULE_LOADER, "");
					return true;
				}

				if (customCampaignName	== "wallpaper") {
					wwDebug.call(wwConsole, wwPrefix, "RP :: Wallpaper Demo Custom Campaign");
					sendMessage("wallpaper", ModuleEnums.MODULE_LOADER, "");
					return true;
				}

				if (customCampaignName	== "vibrant") {
					wwDebug.call(wwConsole, wwPrefix, "RP :: Vibrant Media Custom Campaign");
					sendMessage("allscreen", ModuleEnums.MODULE_LOADER, "");
					return true;
				}

			if (customCampaignName == "myspace") { 

				Myspace.MiniPlayer.on('adStarted', function () {
				//console.log('MYSPACE :: adStarted');
				myspaceAdStarted = true;
				if ((loadPreference == "ONLY_IF_AD_SHOWS"))
					console.log(' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
					sendMessage("adLoaded", ModuleEnums.MODULE_LOADER, {});
				console.log(scriptURL + " scriptURL");
				});

				Myspace.MiniPlayer.on('adStopped', function () {
					console.log(' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
						//wwDebug.call(wwConsole, wwPrefix, "No Myspace Ad: Displaying Error");
						sendMessage("onAdDisplayError", ModuleEnums.MODULE_LOADER, { "etyp": "callback" });
				});

				Myspace.MiniPlayer.on('adError', function () {
					console.log(' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
					console.log('MYSPACE :: adError');
				});
			}

			if (customCampaignName == "yellowhammer") {
					// _player is the yellowhammer video object
					var playerClose = _player.close;
					_player.close = function(){ playerClose(); sendMessage("yellowhammer", ModuleEnums.MODULE_LOADER); }
					_player.addErrorCallback(function(){ sendMessage("onAdDisplayError", ModuleEnums.MODULE_LOADER, { "etyp": "callback" }); });
					_player.addVideoCompleteCallback(function(){ sendMessage("yellowhammer", ModuleEnums.MODULE_LOADER); });
				}
	}

	function addListener (obj, event, handler)
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
	}

	function removeListener (obj, event, handler)
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
	}
	
	function handleMessage(evt)
	{
		if (!evt) evt = window.event;

		// console.log("displayadframe: " + evt.data);

		try {
			var messageObj = JSON.parse(evt.data);
		} catch(err) {
			return;
		}
		
		if (messageObj.type == "setDefyVolume") 
		{	
			if (messageObj.content.muted) {
				$pdk.controller.setVolume(100);
			} else if (!messageObj.content.muted) {
				$pdk.controller.setVolume(.03);
			}
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
			id: uuid
		};

		var message = JSON.stringify(messageObj);
		window.parent.postMessage(message, "*");
	}

	document.writeln("\n\n<!-- START 3rd PARTY TAG -->\n\n");
	document.writeln(adHTML);
	document.writeln("\n\n<!-- END 3rd PARTY TAG -->\n\n");

	var tagVendor = ""; // Usually will be demand source, but it's possible it may not be
	if (typeof(adCreative.vendor) != "undefined")
		tagVendor = adCreative.vendor;
		
	if (tagVendor == null)
		tagVendor = "";
	
	if (tagVendor.indexOf("MYSPACE_VINDICO_VOX") != -1)
	{
		customCreative('myspace',444,340);
	}
	else if (tagVendor.indexOf("VIROOL") != -1)
	{
		customCreative('virool',646,377);
	}
	else if (tagVendor.indexOf("DEFY") != -1)
	{
		customCreative('defy');
	}
	else if (tagVendor.indexOf("SPRINGSERVE") != -1)
	{
		customCreative('yellowhammer',544,350);
	}
	else if (tagVendor.indexOf("ALLSCREEN") != -1)
	{
		customCreative('allscreen',544,306);
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

}


wahwahFunctions();