package 
{
	import flash.external.ExternalInterface;
	import wahwahadplayer.AdManager;
	import wahwahadplayer.controls.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Security;
	import flash.display.*;

	public class wahwahadplayer extends MovieClip
	{
		// Important: For local testing, need to enable trusted location where you locate these files for EI to work
		// http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html
		public var AD_XML:*;
		public var AD_URL:*;
		public var SCALE:*;
		public var COUNTDOWN:*;
		public var HOSTAUDIO: *;
		public var HOSTVOLUME: *;
		public var displayObj:Object;
		public var playerControls:IPlayerControls;
					
		//TODO: Change the version number and date of integration.
		public static var uif_version = "WW 2.5.3-1 (UIF 3.x)";
		public static var uif_integration_date = "2015-07-30";
	
		public function wahwahadplayer()
        {
			
			var debugMsg= "";
			
			var DEBUG_SHOW_CONTROLS = false; // Set true for in-flash debugging only
			
			Security.allowDomain("*");
			root.stage.align = StageAlign.TOP_LEFT;
	
			//displayObj = new Object();
			//displayObj.playBtn = controls_mc.play_btn;
			//displayObj.pauseBtn = controls_mc.pause_btn;
			//displayObj.muteBtn = controls_mc.mute_btn;
			//displayObj.unMuteBtn = controls_mc.unmute_btn;
			//displayObj.rpBtn = controls_mc.rp_btn;
	
	
	
	
			//Load in Tag through flash vars.
			AD_URL = root.loaderInfo.parameters.AD_URL; 
			SCALE = String(root.loaderInfo.parameters.SCALE).toLowerCase() == "true";
			COUNTDOWN = String(root.loaderInfo.parameters.COUNTDOWN).toLowerCase() == "true";
			HOSTAUDIO = String(root.loaderInfo.parameters.HOSTAUDIO).toLowerCase() == "true";
			HOSTVOLUME = root.loaderInfo.parameters.HOSTVOLUME;
			AD_XML = root.loaderInfo.parameters.AD_XML; 
			
			//var AD_XML = '<?xml version="1.0" encoding="UTF-8"?><VAST xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="vast.xsd" version="2.0"> <Ad id="24283604">  <InLine>   <AdSystem>GDFP</AdSystem>   <AdTitle>IAB Vast Samples Skippable</AdTitle>   <Description><![CDATA[IAB Vast Samples Skippable ad]]></Description>   <Error><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplayfailed]]></Error>   <Impression><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=EsItuhXnHV4&cid=5GjC2Q]]></Impression>   <Creatives>    <Creative id="32948875124" AdID="ABCD1234567" sequence="1">     <Linear skipoffset="00:00:05">      <Duration>00:00:51</Duration>      <TrackingEvents>       <Tracking event="start"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=part2viewed]]></Tracking>       <Tracking event="firstQuartile"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime25]]></Tracking>       <Tracking event="midpoint"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime50]]></Tracking>       <Tracking event="thirdQuartile"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime75]]></Tracking>       <Tracking event="complete"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoplaytime100]]></Tracking>       <Tracking event="mute"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=admute]]></Tracking>       <Tracking event="unmute"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adunmute]]></Tracking>       <Tracking event="rewind"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adrewind]]></Tracking>       <Tracking event="pause"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adpause]]></Tracking>       <Tracking event="resume"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adresume]]></Tracking>       <Tracking event="fullscreen"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=adfullscreen]]></Tracking>       <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=vast_creativeview]]></Tracking>       <Tracking event="acceptInvitation"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=acceptinvitation]]></Tracking>       <Tracking event="start"><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=2&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></Tracking>       <Tracking event="complete"><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=3&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></Tracking>      </TrackingEvents>      <VideoClicks>       <ClickThrough id="GDFP"><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&num=0&cid=5GjC2Q&sig=AOD64_2lPkQto5jahGRQWCT6P-rSHTXNZg&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></ClickThrough>       <ClickTracking id=""><![CDATA[https://video-ad-stats.googlesyndication.com/video/client_events?event=6&web_property=ca-pub-8125539322129164&cpn=[CPN]&break_type=[BREAK_TYPE]&slot_pos=[SLOT_POS]&ad_id=[AD_ID]&ad_sys=[AD_SYS]&ad_len=[AD_LEN]&p_w=[P_W]&p_h=[P_H]&mt=[MT]&rwt=[RWT]&wt=[WT]&sdkv=[SDKV]&vol=[VOL]&content_v=[CONTENT_V]&conn=[CONN]&format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]]]></ClickTracking>      </VideoClicks>      <MediaFiles>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/x-flv" bitrate="379" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.flv]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/mp4" bitrate="324" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.mp4]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="426" height="240" type="video/x-flv" bitrate="337" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpsmall.flv]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="640" height="360" type="video/webm" bitrate="348" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.webm]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="320" height="180" type="video/3gpp" bitrate="234" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpbig.3gp]]></MediaFile>       <MediaFile id="GDFP" delivery="progressive" width="176" height="144" type="video/3gpp" bitrate="86" scalable="true" maintainAspectRatio="true"><![CDATA[http://test.wahwahnetworks.com/brian/vast-test/dfpvids/dfpsmall.3gp]]></MediaFile>      </MediaFiles>     </Linear>    </Creative>    <Creative id="32948875244" sequence="1">     <CompanionAds>      <Companion id="32948875244" width="300" height="250">       <StaticResource creativeType="image/jpeg"><![CDATA[https://pagead2.googlesyndication.com/pagead/imgad?id=CICAgMCuxM7V8AEQrAIY-gEyCNhCTRcyGqqI]]></StaticResource>       <TrackingEvents>        <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BXelNij0NVpLnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOzfn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&sigh=DUeexRdTP4g&cid=5GjtFw]]></Tracking>       </TrackingEvents>       <CompanionClickThrough><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BXelNij0NVpLnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOzfn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&num=0&cid=5GjtFw&sig=AOD64_1eaOCS_691NzVEXYHvQ_adnG_0_Q&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></CompanionClickThrough>      </Companion>      <Companion id="32948875364" width="728" height="90">       <StaticResource creativeType="image/jpeg"><![CDATA[https://pagead2.googlesyndication.com/pagead/imgad?id=CICAgMCuxM728wEQ2AUYWjII2NvINDqWbhI]]></StaticResource>       <TrackingEvents>        <Tracking event="creativeView"><![CDATA[https://pubads.g.doubleclick.net/pagead/adview?ai=BaDEZij0NVpTnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOTgn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&sigh=xTUO5onz1KM&cid=5Gjk_A]]></Tracking>       </TrackingEvents>       <CompanionClickThrough><![CDATA[https://pubads.g.doubleclick.net/aclk?sa=L&ai=BaDEZij0NVpTnDtCrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWOTgn996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEC2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAHSBQIIAZAGAaAGFNgHAQ&num=0&cid=5Gjk_A&sig=AOD64_25UHFQ878oXGci2BG5abEQ-1TFlA&client=ca-pub-8125539322129164&adurl=https://developers.google.com/interactive-media-ads/]]></CompanionClickThrough>      </Companion>     </CompanionAds>    </Creative>   </Creatives>   <Extensions>    <Extension type="DFP"><SkippableAdType>Generic</SkippableAdType><CustomTracking> <Tracking event="engagedView"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=video_engaged_view]]></Tracking> <Tracking event="skip"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=videoskipped]]></Tracking> <Tracking event="skipShown"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=video_skip_shown]]></Tracking></CustomTracking></Extension>    <Extension type="activeview"><CustomTracking> <Tracking event="viewable_impression"><![CDATA[https://pubads.g.doubleclick.net/pagead/conversion/?ai=BhV92ij0NVoHEB9CrhASci4z4Dfz24NEFAAAAEAEglIfHFjgAWPTen996YMmex4fgo7QQugESMzIweDUwLDMzNngyNjlfeG1syAEF2gEFaHR0cDrAAgLgAgDqAiAvNjA2Mi9pYWJfdmFzdF9zYW1wbGVzL3NraXBwYWJsZfgC9NEegAMBkAPgA5gD4AOoAwHgBAGQBgGgBiPYBwE&sigh=gtX6zHfVKcE&label=viewable_impression&acvw=[VIEWABILITY]]]></Tracking></CustomTracking></Extension>    <Extension type="geo"><Country>US</Country><Bandwidth>3</Bandwidth><BandwidthKbps>1120</BandwidthKbps></Extension>    <Extension type="waterfall" fallback_index="0"/>   </Extensions>  </InLine> </Ad></VAST>';

			if (AD_XML == undefined || AD_XML == "")
				AD_XML = null;
			if (AD_URL == undefined || AD_URL == "")
				AD_URL = "http://ad3.liverail.com/?LR_PUBLISHER_ID=1331&LR_CAMPAIGN_ID=229&LR_SCHEMA=vast2"; 	// Local testing
			if (SCALE == undefined || (SCALE != true && SCALE != false))
				SCALE = true; // Local testing
			if (COUNTDOWN == undefined || (COUNTDOWN != true && COUNTDOWN != false))
				COUNTDOWN = false; 
			if (HOSTAUDIO == undefined || (HOSTAUDIO != true && HOSTAUDIO != false))
				HOSTAUDIO = false; // Don't take any chances
			var VOLUME = 0;
			if (HOSTAUDIO == true)
			{
				VOLUME = 100;
				if (HOSTVOLUME != undefined)
					VOLUME = HOSTVOLUME;
			}
			
			if (VOLUME > 100)
				VOLUME = 100;
			
			if (VOLUME < 0)
				VOLUME = 0;
			
			debugMsg += "COUNTDOWN (flashvars):" + COUNTDOWN+ "\n";
			
			if (DEBUG_SHOW_CONTROLS == true)
				COUNTDOWN = true; // Local testing
				
			
			debugMsg+= "COUNTDOWN (modified):" + COUNTDOWN + "\n";	
			debugMsg+= "HOSTAUDIO:" + HOSTAUDIO + "\n";
			debugMsg+= "HOSTVOLUME:" + HOSTVOLUME + "\n";
			debugMsg+= "VOLUME (computed):" + VOLUME + "\n";
			debugMsg+= "SCALE:" + SCALE+ "\n";
			debugMsg+= "AD_URL: " + AD_URL+ "\n";
			debugMsg+= "DEBUG_SHOW_CONTROLS:" + DEBUG_SHOW_CONTROLS + "\n";
						
			//Start by adding a symbol to the stage in your Flash IDE,
			//name its instance "adHolder" - this will be the element/layer
			//where the ad will be placed into.
			
				
			//create basic config object with an ad call
			var config:Object = {adXML: AD_XML, preroll : AD_URL, bwDetectionFile: "bwdetect.png", overlay_delay: 1, volume: VOLUME , countdownEnabled: COUNTDOWN, scale: SCALE , companionDeliverType: "object", version: uif_version, integration_date: uif_integration_date};
				
			//create a new AdManager instance passing the config object and adHolder
			var adManager:AdManager = new AdManager(config, ewAdLayer_mc);
			
			
					
			if (DEBUG_SHOW_CONTROLS == true)
				playerControls = new PlayerControls();
			else
				playerControls = new PlayerControlsEI();
			playerControls.initialize(displayObj, adManager);
			adManager.setPlayerControls(playerControls);
			
			

			if (DEBUG_SHOW_CONTROLS == true)
			{
				boundaryClip.width = root.stage.stageWidth;
				boundaryClip.height = root.stage.stageWidth * 9 / 16;
				boundaryClip.x = 0;
				boundaryClip.y = (root.stage.stageHeight - boundaryClip.height)/4;
				//controls_mc.y = root.stage.stageHeight - 50;
				adManager.resize(0, boundaryClip.y, root.stage.stageWidth, root.stage.stageWidth * 9 / 16);
			}
			else
			{
				boundaryClip.x = boundaryClip.y = 0;
				boundaryClip.width = root.stage.stageWidth;
				boundaryClip.height = root.stage.stageHeight;
				//controls_mc.visible=false;
				adManager.resize(0, 0, root.stage.stageWidth, root.stage.stageHeight);
			}
			
			// Start with 0 sound
			debugMsg+="*** Global sound set to "+VOLUME+"%. Mixer will use this value\n";
			adManager.globalSound(VOLUME); 
	
			//start the preroll
			adManager.startAd("preroll");
			
			
			adManager.debugMessage(debugMsg);	// Have to call _AFTER_ startAd
		}
	}
}