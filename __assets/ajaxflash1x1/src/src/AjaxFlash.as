package
{
	import com.wahwahnetworks.flash.AjaxProxy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	public class ajaxflash extends Sprite
	{
		private var ajaxProxy:AjaxProxy;
		
		Security.allowDomain("*");
		
		public function ajaxflash()
		{
			ajaxProxy = new AjaxProxy();
			
			addEventListener(Event.ADDED_TO_STAGE,OnAddedToStage);
		}
		
		private function OnAddedToStage(e:Event):void
		{
			var startMethodName:String = root.loaderInfo.parameters.startMethod;
			
			ExternalInterface.addCallback("ajaxProxy",HandleAjaxProxy);
			
			ExternalInterface.call(startMethodName);
		}
		
		private function HandleAjaxProxy(path:String, method:String, data:Object, callback:String, errorCallback:String):void
		{
			errorCallback = errorCallback || null;
			ajaxProxy.handle(path,method,data,callback, errorCallback);	
		}
	}
}