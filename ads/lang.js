(function ()
{

	if (typeof(window.wahwah) == "undefined")
	{
		var wahwah = {};
		window.wahwah = wahwah;

		var hash;

		if (typeof(window.IN_FRIENDLY_FRAME) != "undefined" && typeof(parent.wahwah.iframeVars) != "undefined" /* should only be on main page */ && typeof(parent.wahwah.iframeVars.friendlyAdFrameLang) != "undefined")
		{
			wahwah.lan = parent.wahwah.iframeVars.friendlyAdFrameLang;
		}
		else
		{
			hash = window.location.hash.split('/');
			wahwah.lan = hash[4].substring(0,2);
		}
	}
	else
		var wahwah = window.wahwah;
	
	wwDebug.call(wwConsole, wwPrefix, typeof(window.IN_FRIENDLY_FRAME) + ' IN_FRIENDLY_FRAME');

	var lan = wahwah.lan;

	var EN = {
		AD_TEXT: "Advertisement",
		COUNTDOWN_TEXT: 'This ad will close in: <span id="countdown_counter"></span>',
		UNTIL_CLOSE_TEXT: 'The close button will appear in: <span id="allow_close_countdown_counter"></span>'
	}
    var PT = {
		AD_TEXT: "Publicidade",
		COUNTDOWN_TEXT:  'Este publicidade será encerrado em: </span><span id="countdown_counter"></span>',
		UNTIL_CLOSE_TEXT: 'The close button will appear in: <span id="allow_close_countdown_counter"></span>'
	}
	var ES = {
		AD_TEXT: "Publicidad",
		COUNTDOWN_TEXT:  'Este publicidad se cerrará en: </span><span id="countdown_counter"></span>',
		UNTIL_CLOSE_TEXT: 'The close button will appear in:<span id="allow_close_countdown_counter"></span>'
	}
	var DE = {
		AD_TEXT: "Werbung",
		COUNTDOWN_TEXT:  'Dein Radio beginnt in <span id="countdown_counter"></span> Sekunden an zu spielen.',
		UNTIL_CLOSE_TEXT: 'The close button will appear in: <span id="allow_close_countdown_counter"></span>'
	}

	var langType;

	switch(lan) {
		case "EN":
		  langType = EN;
		  break;
		case "PT":
		  langType = PT;
		  break;
		case "ES":
		  langType = ES;
		  break;
		case "DE":
		  langType = DE;
		  break;
	}

	function langLoad() 
	{
		removeListener(document, "DOMContentLoaded", langLoad);
		removeListener(window, "load", langLoad);
		var elements = document.querySelectorAll('[data-lang]');

		for(var i = 0; i < elements.length; i++)
		{
				elements[i].innerHTML = langType[elements[i].getAttribute("data-lang")];
		}
	}
	
	// addListener needs to be defined in another file like ads-common.js
	if (document.readyState === "complete") {
		window.setTimeout(startLoad);
	} else {
		window.addListener(document, "DOMContentLoaded", langLoad);
		window.addListener(window, "load", langLoad);
	}	


})();