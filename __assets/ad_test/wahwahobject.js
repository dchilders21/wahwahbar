var widgetID = 1911;
var restrictedCountry = false; // If the users are outside of our restricted countries... "BR","CA","DE","ES","GB","US"
var country_code = "US";

var wahwah = {
    version: widgetV,
    environment: "prod",
    id: widgetID,
    position: "right",
    lan: "EN",
    skin: "dark",
    app: "radio",
    restrictedCountry: restrictedCountry,
    logLevel: "info", // overridden by debugMode true
    debugMode: true,
    radioType: "tab",
    adconfig: {
        "inpage": { "enabled": true, "adSize": 300, "vidWidth": 400, "vidHeight": 225, "displayWidth": 300, "displayHeight": 250, "bannerAdsPerVideoAd": 4, "freqCap": false, "freqNum": 2,
            "combinedDisplayURL": "ww-openx:auid=" + combinedAUID + ";",
            "combinedDisplayLBURL": "",
            "displayURL": "ww-openx:auid=" + displayAUID + ";",
            "displayLBURL": "",
            "mobile728URL": "ww-openx:auid=" + mobile720AUID + ";",
            "mobile320URL": "ww-openx:auid=" + mobile320AUID + ";",
            "vidURL": "http://ox-d.wahwahnetworks.com/v/1.0/av?auid=" + videoAUID + ";", "secondsBetweenBanners": 615, "perSessionCap": 15, "secondsToExpand": 15, "vidCountdownNumFormat": "${SEC}"} ,
        "interstitial": {"enabled": false},  // Not supported in this release
        "linear": {"enabled": false } // Not supported in this release
    }
};

(function () {

var wahwah = window.wahwah;
var tbPath = "00BA6A/product/_release/prod";
var domain = "http://cdn-s.wwnstatic.com";

   switch (wahwah.environment) {
        case "local":
        case "local_www":
            wahwah["domain"] = "*";
            wahwah["baseUrl"] = window.location.href.substring(0,window.location.href.lastIndexOf("/"))+ "/";
            break;
        case "qa1":
            wahwah["domain"] = domain;
            wahwah["baseUrl"] = domain + "/" + tbPath + "/qa/"+ wahwah.version + "/";
            break;
        default:
            console.log("[Wahwah Config] *** WW warning: wahwah.environment set incorrectly");
        case "prod":
            wahwah["domain"] = domain;
            wahwah["baseUrl"] = domain + "/" + tbPath + "/"+wahwah.version+"/";
            break;
        }
        
if (document.readyState === "complete" || document.readyState === "interactive") 
{
    // In this case, loader.js will use DOM manipulations
    var fileref=document.createElement('script');
    fileref.setAttribute("type","text/javascript");
    fileref.setAttribute("src", wahwah.baseUrl + "widget/loader.js");
    document.getElementsByTagName("head")[0].appendChild(fileref);
}
else
{
    document.writeln('<scr'+'ipt src="'+wahwah.baseUrl + "widget/loader.js"+'" type="text/javascript"></scr'+'ipt>');
}

})(); 