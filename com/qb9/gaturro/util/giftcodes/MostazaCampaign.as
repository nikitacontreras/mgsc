package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public class MostazaCampaign extends Campaign
   {
       
      
      private var _giftName:String;
      
      public function MostazaCampaign(param1:Object)
      {
         super(param1);
      }
      
      public function set giftName(param1:String) : void
      {
         this._giftName = param1;
      }
      
      public function get giftName() : String
      {
         if(this._giftName)
         {
            return this._giftName;
         }
         return "";
      }
      
      override protected function codeCheckResponse(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.CODE_CHECKER,this.codeCheckResponse);
         var _loc2_:Boolean = param1.mobject.getBoolean("success");
         if(!_loc2_)
         {
            logger.debug("Code Campaign - Error - Code: " + lastGiftCode);
            tracker.event(TrackCategories.MARKET,TrackActions.CODE_MACHINE,"error");
            callbackGiftCode(this.errorString);
         }
         else
         {
            logger.debug("Code Campaign - Item Received: " + this.giftName);
            tracker.event(TrackCategories.MARKET,TrackActions.CODE_MACHINE,"success");
            process(this.giftName);
         }
      }
   }
}
