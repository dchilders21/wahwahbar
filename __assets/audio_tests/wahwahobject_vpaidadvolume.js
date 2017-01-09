var widgetID = 2480;

var restrictedCountry = false; // If the users are outside of our restricted countries... "BR","CA","DE","ES","GB","US"
var country_code = "US";

/*


Wahwah AdOnly 2.5.0

-- Generated Using: wahwah platform 2.1.0 (revision: f3eda188278a50f1bb57322d1b5dfeb9687faaf9) --

[Product Name: {{ CBS - David's Product }} ]
[Site Name: {{ David's Site }} ]
[Product id: {{ 5 }} ]
[Widget id: {{ 2468 }} ]

*/

var wahwah = {
    version: "2.5.0",
    branch: "2_5_0",
    environment: "local",
    id: widgetID,
    position: "right",
    lan: "EN",
    skin: "dark",
    app: "radio",
    restrictedCountry: restrictedCountry,
    logLevel: "debug",
    debugMode: true,
    loadPreference: "ONLY_IF_AD_SHOWS",
    radioType: "tab",

    adconfig: {
        "inpage": {
            "enabled": true,
            "floater": false,
            "floatVertPos": "bottom",
            "floatHorizPos": "right",
            "expansionAlignHoriz": "left",
            "expansionAlignVert": "middle",
            "adSize": 300,
            "vidWidth": 400,
            "vidHeight": 225,
            "displayWidth": 300,
            "displayHeight": 250,
            "bannerAdsPerVideoAd": 4,
            "freqCap": false,
            "freqNum": 2,
            "combinedDisplayURL": "", //"ww-openx:auid=537228577;",//537981482 - Beanstock //537981004  // No Fill - 537981021
            "combinedDisplayLBURL": "", 
            "displayURL": "ww-openx:auid=;",
            "displayLBURL": "",
            "mobile320URL": "ww-openx:auid=;",
            "mobile728URL": "ww-openx:auid=;",
            "vidURL": "http://test.wahwahnetworks.com/brian/hackmyaudio073015/ads/vpaidadvolume/vast.xml", //"http://test.wahwahnetworks.com/brian/audio072015/spotxchange_test_touchstone.xml",
            //"vidURL": "http://ad3.liverail.com/?LR_PUBLISHER_ID=1331&LR_CAMPAIGN_ID=229&LR_SCHEMA=vast2",
            "secondsBetweenBanners": 615,
            "perSessionCap": 15,
            "secondsToExpand": 10000,
            "vidCountdownNumFormat": "${SEC}"
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
