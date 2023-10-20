package com.qb9.gaturro.world.gatucine.services
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import com.qb9.gaturro.world.gatucine.elements.GatucineReproduction;
   
   public class WebServicePlay extends WebService
   {
       
      
      private var playId:String;
      
      public function WebServicePlay(param1:GatucineManager, param2:Function, param3:String)
      {
         super(param1,param2);
         this.playId = param3;
      }
      
      override public function get json() : String
      {
         return "{" + "\"session_id\": \"" + manager.sessionId + "\"," + "\"content_id\": \"" + this.playId + "\"," + "\"device_type\": \"PC\", " + "\"quality\": \"sd\"" + "}";
      }
      
      override public function get url() : String
      {
         return settings.gatucine.WSPlayURL;
      }
      
      override public function receive(param1:String) : void
      {
         var obj:Object = null;
         var status:Boolean = false;
         var reproduction:GatucineReproduction = null;
         var data:String = param1;
         try
         {
            obj = decodeResponse(data);
            status = Boolean(obj.status);
            if(status)
            {
               reproduction = new GatucineReproduction();
               reproduction.wrapper = obj.response.url_mobile_wrapper;
               manager.setReproduction(reproduction);
               call(new UIResponse(true));
            }
            else
            {
               if(obj.response)
               {
                  logger.debug("GATUCINE -> " + obj.response);
               }
               receiveRequestError(obj.response);
            }
         }
         catch(e:Error)
         {
            receiveRequestError();
         }
      }
   }
}
