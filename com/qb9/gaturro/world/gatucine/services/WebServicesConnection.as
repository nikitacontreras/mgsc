package com.qb9.gaturro.world.gatucine.services
{
   import com.qb9.gaturro.globals.logger;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class WebServicesConnection
   {
       
      
      private var currentWs:com.qb9.gaturro.world.gatucine.services.WebService;
      
      private var currentLoader:URLLoader;
      
      public function WebServicesConnection()
      {
         super();
      }
      
      private function onResponse(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.currentTarget);
         if(this.currentWs)
         {
            this.currentWs.receive(String(_loc2_.data));
         }
         this.destroyLoader(_loc2_);
      }
      
      private function onStatus(param1:HTTPStatusEvent) : void
      {
         trace(" -- GATUCINE HTTP STATUS ----->> " + param1.status.toString());
      }
      
      private function createLoader() : void
      {
         this.currentLoader = new URLLoader();
         this.currentLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.currentLoader.addEventListener(Event.COMPLETE,this.onResponse);
         this.currentLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.currentLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         this.currentLoader.addEventListener(IOErrorEvent.VERIFY_ERROR,this.onError);
         this.currentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this.currentLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onStatus);
      }
      
      private function onError(param1:Event) : void
      {
         logger.debug("GATUCINE -> http error --> " + param1.toString());
         var _loc2_:URLLoader = URLLoader(param1.currentTarget);
         if(_loc2_ == this.currentLoader)
         {
            this.currentWs.receiveRequestError();
         }
         this.destroyLoader(_loc2_);
      }
      
      private function destroyLoader(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onResponse);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         param1.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         param1.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.onError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onStatus);
      }
      
      public function request(param1:com.qb9.gaturro.world.gatucine.services.WebService) : void
      {
         var _loc2_:URLRequest = param1.createRequest();
         this.createLoader();
         this.currentWs = param1;
         this.currentLoader.load(_loc2_);
      }
   }
}
