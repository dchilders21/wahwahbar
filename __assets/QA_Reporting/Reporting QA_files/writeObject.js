
document.writeln('<scr'+'ipt type="text/javascript" language="Javascript" src="'+qaPath+'extMouseWheel.js"></scr'+'ipt>');
if (typeof(ew_receivingWidth)=="undefined") var ew_receivingWidth=750;
if (typeof(ew_receivingHeight)=="undefined") var ew_receivingHeight=400;
function parseParam(name){
	try { var query=window.location.search; var pos=query.indexOf(name+"="); var pos2=0;
		if (pos!=-1){ pos=pos+name.length+1; pos2=query.indexOf("&", pos); if (pos2!=-1){ return query.substring(pos, pos2); } else { return query.substring(pos); }
		} else { return null; }
	} catch(e){ return null; }
}
if (typeof(useNewReceivingSwf)=='undefined'){
	var useNewReceivingSwf=false;
	if (parseParam("usenew")!=null){
	var useNew=parseParam("usenew");
	if (useNew=="true") useNewReceivingSwf=true; }
}
function setFilter(str,bool,color){
	if(navigator.userAgent.toLowerCase().indexOf("msie")>0) var recObjStr="receivingObj"; else var recObjStr="receivingEmbed";
	var recObj=document.getElementById(recObjStr); if(!str)str=''; if(!bool) bool=false; if(!color) color=false;
	if(recObj){ try{ recObj.ew_filterResults(str,bool,color); } catch(e){ alert(e); } }
}
var swfName="receiving.swf";
if (useNewReceivingSwf==true) swfName="QAReceiving.swf"; else if(typeof(useFilterSwf)!='undefined'&&useFilterSwf) swfName="FILTER_Receiving.swf";
if (typeof(ewCommon)=='undefined') var ewCommon=false;
var ewUrl=document.location.href.substring(0, document.location.href.indexOf("?"))||document.location.href.substring(0);
var ew_receivingFlashVars='qaReportUUID=common';
if (typeof(ew_qaReportUUID)!="undefined") ew_receivingFlashVars='qaReportUUID='+ew_qaReportUUID;
ew_receivingFlashVars+="&serverurl="+document.domain+'&qapath='+ewUrl+'&common='+String(ewCommon);
if (typeof(webCodeVersion)!="undefined") ew_receivingFlashVars += '&webCodeVersion='+webCodeVersion;
document.writeln('<object id="receivingObj" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" align="middle" width="'+ew_receivingWidth+'" height="'+ew_receivingHeight+'"><param name="allowScriptAccess" value="always"><param name="movie" value="'+qaPath+swfName+'?nocache='+new Date().getTime()+ '"><param name="quality" value="high"><param name="bgcolor" value="#FFFFFF"><param name="base" value="'+qaPath+'/"><param name="wmode" value="opaque"><param name="FlashVars" value="'+ew_receivingFlashVars+'"><embed id="receivingEmbed" src="'+qaPath+swfName+'?nocache='+new Date().getTime()+ '" base="'+qaPath+'/" wmode="opaque" quality="high" bgcolor="#FFFFFF" name="receivingEmbed" pluginspage="http://www.macromedia.com/go/getflashplayer" height="'+ew_receivingHeight+'" width="'+ew_receivingWidth+'" flashvars="'+ew_receivingFlashVars+'"/></object>');
