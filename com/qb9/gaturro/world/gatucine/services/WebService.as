package com.qb9.gaturro.world.gatucine.services
{
   import com.adobe.serialization.json.JSONDecoder;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class WebService
   {
       
      
      protected var callback:Function;
      
      protected var manager:GatucineManager;
      
      public function WebService(param1:GatucineManager, param2:Function = null)
      {
         super();
         this.manager = param1;
         this.callback = param2;
      }
      
      public function receive(param1:String) : void
      {
      }
      
      public function get json() : String
      {
         return "{}";
      }
      
      protected function decodeResponse(param1:String) : Object
      {
         var _loc2_:JSONDecoder = new JSONDecoder(param1,true);
         return _loc2_.getValue();
      }
      
      public function createRequest() : URLRequest
      {
         logger.debug("GATUCINE -> url --> " + this.url);
         var _loc1_:URLRequest = new URLRequest(this.url);
         _loc1_.contentType = "application/json";
         _loc1_.method = URLRequestMethod.POST;
         _loc1_.data = this.json;
         return _loc1_;
      }
      
      public function get url() : String
      {
         return "";
      }
      
      public function receiveRequestError(param1:String = "") : void
      {
         logger.debug("GATUCINE -> request error en " + this.url);
         this.call(new UIResponse(false,param1));
         this.dispose();
      }
      
      protected function call(param1:UIResponse) : void
      {
         if(this.callback != null)
         {
            this.callback(param1);
         }
         this.dispose();
      }
      
      private function dispose() : void
      {
         this.manager = null;
         this.callback = null;
      }
   }
}
