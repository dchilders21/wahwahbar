var widgetID = 10538;

var restrictedCountry = false; // If the users are outside of our restricted countries... "BR","CA","DE","ES","GB","US"
var country_code = "US";

/*


 AdOnly 4_0_0_Bidding




-- Generated Using: Red Panda Platform 4.0.6 (revision: 8a2647ec26a01349321ba362908fe596024a71d0) --

[Product Name: {{ BRIAN_IMPORTANT_TEST_BIDDING_DO_NOT_DELETE - Floater }} ]
[Site Name: {{ BRIAN_IMPORTANT_TEST_BIDDING_DO_NOT_DELETE - Floater }} ]
[Product id: {{ 888 }} ]
[Widget id: {{ 10538 }} ]

Published on:  2016-06-10 10:53:59 EST
*/

var wahwah = {
    version: "4_0_0_Bidding",
    branch: "4_0_0",
    environment: "prod",
	demandSourceListUrl: "http://test.wahwahnetworks.com/brian/tb4/tags/demand/altitude.biddingsources.json.txt",
    id: widgetID,
    position: "bottom",
    lan: "EN",
    skin: "default",
    app: "adOnly",
    restrictedCountry: restrictedCountry,
    logLevel: "debug",
    debugMode: true,
    loadPreference: "ALWAYS",
    fastLoad: true,
    adconfig: {
        "inpage": {
            "enabled": true,
            "adSize": 300,
            "vidWidth": 558,
            "vidHeight": 314,
            "displayWidth": 300,
            "displayHeight": 250,
            "bannerAdsPerVideoAd": 4,
            "freqCap": false,
            "freqNum": 2,
            "combinedDisplayURL": "ww-openx:auid=538489066;",
            "combinedDisplayLBURL": "",
            "displayURL": "ww-openx:auid=538489067;",
            "displayLBURL": "",
            "mobile320URL": "ww-openx:auid=538489070;",
            "mobile728URL": "ww-openx:auid=538489069;",
            "leaveBehindAdURL": "ww-openx:auid=538489071;",
            "adFormat": "floater",
            /* The following affect page position */
            "floatVertPos": "bottom",
            "floatHorizPos": "right",
            /* The following affect expansion direction. */
            "inPageAlignment": "right", /* deprecated. Use expansionAlignHoriz instead */
            "expansionAlignHoriz": "right",
            "expansionAlignVert": "bottom",
            "inAdBreakout": false,
            "outstreamAutoload": false,
            "outstreamTriggerId": "",
            "outstreamFloat": false,
            "vidURL": "http://ox-d.wahwahnetworks.com/v/1.0/av?auid=538489068",
            "secondsBetweenBanners": 615,
            "perSessionCap": 15,
            "secondsToExpand": 15,
            "vidCountdownNumFormat": "${SEC}",
            "audioVolume": 0
        },
        "interstitial": {
            "enabled": false,
            "freqCap": false,
            "freqNum": 2
        },
        "linear": {
            "enabled": false
        }
    }
};


if (typeof(RP_PUBLISHER_KEYS) != "undefined")
{
	var WAHWAH_PUBLISHER_KEYS = RP_PUBLISHER_KEYS;
}

// Client Features Object
wahwah.clientFeatures = {};



if(typeof document.currentScript != "undefined"){
    wahwah.currentScript = document.currentScript;
}

// Used to make sure multiple versions don't conflict with each other
if (typeof(wahwahObjs) == 'undefined') { wahwahObjs = []; }
wahwahObjs[wahwahObjs.length] = wahwah;
	

(function () {

    var wahwah = window.wahwah;
    var tbPath = "brian/tb4/code";
    var domain = "http://test.wwnstatic.com";

    switch (wahwah.environment) {
        case "local":
        case "local_www":
            wahwah["domain"] = "*";
            wahwah["baseUrl"] = window.location.href.substring(0,window.location.href.lastIndexOf("/"))+ "/";
            break;
        case "dev":
        case "qa":
        case "prod":
            wahwah["domain"] = domain;
            wahwah["baseUrl"] = domain + "/" + tbPath + "/" + wahwah.environment + "/" + wahwah.version + "/";

            if(wahwah.debugMode){
                wahwah.baseUrl += "_original/";
            }

            break;
        default:
            console.log("*** WW warning: wahwah.environment set incorrectly");
    }

    if (document.readyState === "complete" || document.readyState === "interactive")
    {
        // In this case, loader.js will use DOM manipulations
        var fileref = document.createElement('script');
        fileref.setAttribute("type","text/javascript");
        fileref.setAttribute("src", wahwah.baseUrl + "widget/loader.js");
        document.getElementsByTagName("head")[0].appendChild(fileref);
    } else {
        document.writeln('<scr'+'ipt src="'+wahwah.baseUrl + "widget/loader.js"+'" type="text/javascript"></scr'+'ipt>');
    }
	
})();