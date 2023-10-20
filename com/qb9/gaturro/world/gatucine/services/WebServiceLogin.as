package com.qb9.gaturro.world.gatucine.services
{
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Hex;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import flash.utils.ByteArray;
   
   public class WebServiceLogin extends WebService
   {
       
      
      public function WebServiceLogin(param1:GatucineManager, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function get json() : String
      {
         var _loc1_:String = String(user.username);
         return "{" + "\"username\": \"" + _loc1_ + "\"," + "\"token\": \"" + this.createLoginToken(_loc1_) + "\"," + "\"operator\": \"gaturro\", " + "\"device_type\": \"PC\", " + "\"device_id\": \"123456789\"" + "}";
      }
      
      override public function receive(param1:String) : void
      {
         var obj:Object = null;
         var autorized:Boolean = false;
         var sessionId:String = null;
         var data:String = param1;
         try
         {
            obj = decodeResponse(data);
            autorized = Boolean(obj.response.autorized);
            if(autorized)
            {
               logger.debug("GATUCINE -> Login successfully");
               sessionId = String(obj.response.session_id);
               manager.sessionId = sessionId;
               call(new UIResponse(true));
            }
            else
            {
               if(obj.response)
               {
                  logger.debug("GATUCINE -> " + obj.response);
               }
               receiveRequestError();
            }
         }
         catch(e:Error)
         {
            receiveRequestError();
         }
      }
      
      private function createLoginToken(param1:String) : String
      {
         var _loc2_:* = param1 + "no_password";
         var _loc3_:MD5 = new MD5();
         var _loc4_:ByteArray;
         (_loc4_ = new ByteArray()).writeMultiByte(_loc2_,"utf-8");
         return Hex.fromArray(_loc3_.hash(_loc4_));
      }
      
      override public function get url() : String
      {
         return settings.gatucine.WSLoginURL;
      }
   }
}
