package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public class Boca3Passport extends Campaign
   {
       
      
      public function Boca3Passport(param1:Object)
      {
         super(param1);
      }
      
      private function setPP() : void
      {
         api.setProfileAttribute("pasaporteBoca3Dias",api.serverTime);
      }
      
      override public function codeCheck(param1:Function, param2:String) : void
      {
         var _loc3_:String = "BO" + this.trimCode(param2);
         super.codeCheck(param1,_loc3_);
         logger.debug("------------------------------------- " + _loc3_);
      }
      
      override protected function codeCheckResponse(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.CODE_CHECKER,this.codeCheckResponse);
         var _loc2_:Boolean = param1.mobject.getBoolean("success");
         if(!_loc2_)
         {
            callbackGiftCode(this.errorString);
            api.trackEvent("BOCA:PIN_3_DIAS","rejected");
         }
         else
         {
            api.trackEvent("BOCA:PIN_3_DIAS","success");
            process("");
            this.setPP();
         }
      }
      
      private function trimCode(param1:String) : String
      {
         return param1.substring(8);
      }
   }
}
