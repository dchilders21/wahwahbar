package com.wahwahnetworks.flash
{
	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.system.Security;

	public class AjaxProxy
	{
		
		private var requests:Array;
		
		public function AjaxProxy(){
			Security.allowDomain("*");
			requests = new Array();
		}
		
		public function handle(path:String, method:String, data:Object, callback:String, errorCallback:String):void
		{
			var isSenzariRequest:Boolean = true;
			
			if(path.indexOf("http") == 0) isSenzariRequest = false;
			
			
			var url:String = path;
			
			if(method == "GET" && data != null)
			{
				for(var prop:String in data){
					url += ("&" + prop + "=" + data[prop]);	
				}
			}
			
			var request:URLRequest = new URLRequest(url);
			
			if(data != null && method == "POST"){
				
				request.method = "POST";
				
				var dataString:String = JSON.stringify(data);
				request.data = dataString;
				
				var header:URLRequestHeader = new URLRequestHeader("Content-Type","application/json; charset=utf-8");
				
				request.requestHeaders = new Array(header);				
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,OnComplete);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnError);
            loader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
			
			var requestData:Object = {
				loader: loader,
				callback: callback,
				errorCallback: errorCallback,
				request: request
			};
			
			requests.push(requestData);
			
			if(requests.length == 1){
				loader.load(request);
			}
		}
		
		private function OnComplete(e:Event):void
		{
			var requestData:Object = requests.shift();
			var callback:String = requestData.callback;
			var loader:URLLoader = requestData.loader;
			
			var response:String = loader.data;
			
			ExternalInterface.call(callback,escape(response));
			
			if(requests.length != 0){
				var newLoader:URLLoader = requestData[0].loader;
				var newRequest:URLRequest = requestData[0].request;
				newLoader.load(newRequest);
			}
		}
		
		private function OnError(e:Event):void
		{
			var requestData:Object = requests.shift();
			var errorCallback:String = requestData.errorCallback;
			var loader:URLLoader = requestData.loader;
			
			if (errorCallback != null)
				ExternalInterface.call(errorCallback,escape(e.toString()));
		}
	}
}