(function () {

    if (document.readyState === "complete" || document.readyState === "interactive")
    {
        // In this case, loader.js will use DOM manipulations
        var fileref = document.createElement('script');
        fileref.setAttribute("type","text/javascript");
        fileref.setAttribute("src", "http://dat.springserve.com/ttj?id=6989164");
        document.getElementsByTagName("head")[0].appendChild(fileref);
    } else {
        document.writeln('<scr'+'ipt src="http://dat.springserve.com/ttj?id=6989164" type="text/javascript"></scr'+'ipt>');
    }
})();