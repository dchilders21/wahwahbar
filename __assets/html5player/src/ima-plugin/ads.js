/**
 * Copyright 2014 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


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
	adsResponse: '<?xml version="1.0" encoding="UTF-8"?><VAST version="2.0">  <Ad id="linear-1">    <InLine>      <AdSystem>OVA Static Template</AdSystem>      <AdTitle>VPAID Linear Ad</AdTitle>      <Impression><![CDATA[http://localhost/log?impression]]></Impression>      <Creatives>        <Creative>          <Linear>              <Duration>00:00:00</Duration>		      <TrackingEvents> 		        <Tracking event="creativeView">http://localhost/log?creativeView</Tracking> 		        <Tracking event="start">http://localhost/log?start</Tracking>		        <Tracking event="firstQuartile">http://localhost/log?firstQuartile</Tracking>		        <Tracking event="midpoint">http://localhost/log?midpoint</Tracking>		        <Tracking event="thirdQuartile">http://localhost/log?thirdQuartile</Tracking>		        <Tracking event="complete">http://localhost/log?complete</Tracking>		        <Tracking event="pause">http://localhost/log?pause</Tracking>		        <Tracking event="resume">http://localhost/log?resume</Tracking>		        <Tracking event="rewind">http://localhost/log?rewind</Tracking>		        <Tracking event="mute">http://localhost/log?mute</Tracking>		        <Tracking event="unmute">http://localhost/log?unmute</Tracking>		        <Tracking event="fullscreen">http://localhost/log?fullscreen</Tracking>		        <Tracking event="expand">http://localhost/log?expand</Tracking>		        <Tracking event="collapse">http://localhost/log?collapse</Tracking>		        <Tracking event="acceptInvitation">http://localhost/log?acceptInvitation</Tracking>		        <Tracking event="close">http://localhost/log?close</Tracking>		      </TrackingEvents>              <MediaFiles>                 <MediaFile height="270" width="370" type="application/x-shockwave-flash" apiFramework="VPAID">	                 <![CDATA[http://cdn1.eyewonder.com/200125/instream/documentation_test_tags/vpaid/as3/VPAID_2_0.swf?adLoaderWidth=320&adLoaderHeight=240&cp=http://cdn.eyewonder.com/100125/754851/1262098/&loaderCreative=Linear_Interactive_Holder_as3.swf%3Fcp%3Dhttp://cdn.eyewonder.com/100125/754851/1262098/%26ewbase%3Dhttp://cdn.eyewonder.com/100125/754851/1262098/%26adLoaderWidth%3D300%26adLoaderHeight%3D225%26hAlign%3Dcenter%26vAlign%3Dmiddle%26keywordNames%3Dinstream_VAST_2_0_TEST%26keywordIDs%3D[103]%26ewbust%3D[timestamp]&adInstreamType=fixedroll&adTagAlignHorizontal=center&adTagAlignVertical=middle&adMode=prog&qaReportUUID=common]]>                 </MediaFile>              </MediaFiles>           </Linear>        </Creative>      </Creatives>    </InLine> </Ad></VAST>',
	//adRenderingSettings: ,
	//contribAdsSettings: ,
	debug: true,
	locale: 'en',
	nonLinearWidth: 640,
	nonLinearHeight: 120,
	showCountdown: false,
	vpaidMode: google.ima.ImaSdkSettings.VpaidMode.ENABLED // ENABLED, INSECURE, DISABLED
	
};

player.ima(options);

//adsLoader.getSettings().setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.INSECURE);

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

player.one(startEvent, function() {
    player.ima.initializeAdDisplayContainer();
    player.ima.requestAds();
    player.play();
});
