package com.qb9.gaturro.world.gatucine.services
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class SecureLogin extends WebService
   {
       
      
      public function SecureLogin(param1:GatucineManager, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function get json() : String
      {
         return "sid=" + user.hashSessionId;
      }
      
      override public function createRequest() : URLRequest
      {
         var _loc1_:String = this.url + "?" + this.json;
         logger.debug("GATUCINE -> Login url --> " + _loc1_);
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         _loc2_.contentType = "application/text";
         _loc2_.method = URLRequestMethod.GET;
         return _loc2_;
      }
      
      override public function receive(param1:String) : void
      {
         var data:String = param1;
         try
         {
            data = StringUtil.trim(data);
            if(data != "0" && data.length > 5)
            {
               logger.debug("GATUCINE -> Login successfully --> " + data);
               manager.sessionId = data;
               call(new UIResponse(true));
            }
            else
            {
               logger.debug("GATUCINE -> Login error");
               receiveRequestError();
            }
         }
         catch(e:Error)
         {
            receiveRequestError();
         }
      }
      
      override public function get url() : String
      {
         return settings.gatucine.loginURL;
      }
   }
}
