var widgetID = 11502;

var restrictedCountry = false; // rewritten  // rewritten  // If the users are outside of our restricted countries... "BR","CA","DE","ES","GB","US"
var country_code = "US"; // rewritten // rewritten

/*


 AdOnly 4_0_0_Bidding




-- Generated Using: Red Panda Platform 4.1.9 (revision: 5a366cb43eb0383de6ba2f475282b1d21818e52e) --

[Product Name: {{ Pulsepoint Outstream Publisher Test - Dev Team Demo and Test Page - MP }} ]
[Site Name: {{ Pulsepoint Outstream Publisher Test - Dev Team Demo and Test Page - MP }} ]
[Product id: {{ 1628 }} ]
[Widget id: {{ 11502 }} ]

Published on:  2016-08-03 18:25:18 EST
*/

var wahwah = {
    version: "4_0_0_Bidding",
    branch: "4_0_0",
    environment: "local",
    id: widgetID,
    demandSourceListUrl: "http://cdn-tie.wwnstatic.com/tagintelligence/serve/11502",
    position: "bottom",
    lan: "EN",
    skin: "default",
    app: "adOnly",
    restrictedCountry: restrictedCountry,
    logLevel: "info",
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
            "combinedDisplayURL": "",
            "combinedDisplayLBURL": "",
            "displayURL": "",
            "displayLBURL": "",
            "mobile320URL": "",
            "mobile728URL": "",
            "leaveBehindAdURL": "",
            "adFormat": "ostream",
            /* The following affect page position */
            "floatVertPos": "bottom",
            "floatHorizPos": "right",
            /* The following affect expansion direction. */
            "inPageAlignment": "right", /* deprecated. Use expansionAlignHoriz instead */
            "expansionAlignHoriz": "right",
            "expansionAlignVert": "bottom",
            "inAdBreakout": false,
            "outstreamAutoload": true,
            "outstreamTriggerId": "",
            "outstreamFloat": false,
            "vidURL": "",
            "secondsBetweenBanners": 615,
            "perSessionCap": 15,
            "secondsToExpand": 15,
            "vidCountdownNumFormat": "${SEC}",
            "audioVolume": 0,
        "passback": null // not set anywhere (this is ok)
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


// Used to make sure multiple versions don't conflict with each other
if (typeof(wahwahObjs) == 'undefined') { wahwahObjs = []; }
wahwahObjs[wahwahObjs.length] = wahwah;

wahwah.currentScriptTag = null;
if (typeof(RP_CURRENTSCRIPTTAG) != "undefined")
{
    wahwah.currentScriptTag = RP_CURRENTSCRIPTTAG;
}
else
{
    if (document.currentScript)
    {
        wahwah.currentScriptTag = document.currentScript;
    }
}

(function () {

    var wahwah = window.wahwah;
    var tbPath = "00BA6A/product/_release";
    var domain = "http://cdn-s.wwnstatic.com";

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