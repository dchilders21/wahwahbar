var widgetID = 2553;

var restrictedCountry = false; // rewritten  // rewritten  // If the users are outside of our restricted countries... "BR","CA","DE","ES","GB","US"
var country_code = "US"; // rewritten // rewritten


/*


Wahwah AdOnly 2_6_0




-- Generated Using: wahwah platform 3.5.4 (revision: ba7f04d9180ee6604e7ab5df592ec8157bbf55e8) --

[Product Name: {{ David's Test Site Toolbar }} ]
[Site Name: {{ David's Test Site }} ]
[Product id: {{ 208 }} ]
[Widget id: {{ 2553 }} ]

Published on:  2015-10-07 22:45:21 EST
*/

var wahwah = {
    version: "2_6_0",
    branch: "2_6_0",
    environment: "local",
    id: widgetID,
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
            "vidWidth": 400,
            "vidHeight": 225,
            "displayWidth": 300,
            "displayHeight": 250,
            "bannerAdsPerVideoAd": 4,
            "freqCap": false,
            "freqNum": 2,
            "combinedDisplayURL": "",//"ww-openx:auid=538038139;",
            "combinedDisplayLBURL": "",
            "displayURL": "",//"ww-openx:auid=537981483;",
            "displayLBURL": "",
            "mobile320URL": "ww-openx:auid=537981486;",
            "mobile728URL": "ww-openx:auid=537981485;",
            "leaveBehindAdURL": "",
            "floater": true,
            /* The following affect page position */
            "floatVertPos": "bottom",
            "floatHorizPos": "right",
            /* The following affect expansion direction. */
            "inPageAlignment": "right", /* deprecated. Use expansionAlignHoriz instead */
            "expansionAlignHoriz": "center",
            "expansionAlignVert": "bottom",
            "vidURL": "http://ox-d.wahwahnetworks.com/v/1.0/av?auid=537240432", // 537240432 - always liverail         // 537981484",
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

var WAHWAH_PUBLISHER_KEYS = {};
// should be null WAHWAH_PUBLISHER_KEYS['a'] = '%% VALUE GOES HERE %%';
WAHWAH_PUBLISHER_KEYS['b'] = 'test1';
WAHWAH_PUBLISHER_KEYS['c'] = '';
WAHWAH_PUBLISHER_KEYS['notinplatform'] = '';

// Client Features Object
wahwah.clientFeatures = {};

// Custom Publisher Key
wahwah.clientFeatures['customPublisherReportKeys'] = 'a;b;c';


if(typeof document.currentScript != "undefined"){
    wahwah.currentScript = document.currentScript;
}

// Used to make sure multiple versions don't conflict with each other
if (typeof(wahwahObjs) == 'undefined') { wahwahObjs = []; }
wahwahObjs[wahwahObjs.length] = wahwah;

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