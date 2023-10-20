package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.codes.CodeCheckerActionRequest;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public class Campaign
   {
       
      
      protected var campaignData:Object;
      
      protected var callbackGiftCode:Function;
      
      protected var lastGiftCode:String;
      
      public function Campaign(param1:Object)
      {
         super();
         this.campaignData = param1;
      }
      
      public function mustReject(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.campaignData.reject)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function checkItemName(param1:String) : String
      {
         param1 = param1.replace("_on","");
         return StringUtil.trim(param1);
      }
      
      protected function process(param1:String) : void
      {
         param1 = this.checkItemName(param1);
         this.deliverItem(param1);
      }
      
      protected function giveToUser(param1:String) : void
      {
         var _loc2_:Array = settings.giftCodes.noUserObject;
         if(ArrayUtil.contains(_loc2_,param1))
         {
            return;
         }
         if(param1 != "")
         {
            InventoryUtil.acquireObject(api.room.userAvatar,param1,1,0,this.lastGiftCode);
            logger.debug("Code Campaign - give to user: " + param1);
         }
      }
      
      protected function deliverItem(param1:String) : void
      {
         this.giveToUser(param1);
         this.callbackGiftCode(param1);
      }
      
      protected function get errorString() : String
      {
         return "<error>";
      }
      
      public function codeCheck(param1:Function, param2:String) : void
      {
         this.lastGiftCode = param2;
         this.callbackGiftCode = param1;
         net.sendAction(new CodeCheckerActionRequest(param2,user.username));
         net.addEventListener(GaturroNetResponses.CODE_CHECKER,this.codeCheckResponse);
      }
      
      protected function codeCheckResponse(param1:NetworkManagerEvent) : void
      {
         var _loc3_:String = null;
         net.removeEventListener(GaturroNetResponses.CODE_CHECKER,this.codeCheckResponse);
         var _loc2_:Boolean = param1.mobject.getBoolean("success");
         if(!_loc2_)
         {
            logger.debug("Code Campaign - Error - Code: " + this.lastGiftCode);
            tracker.event(TrackCategories.MARKET,TrackActions.CODE_MACHINE,"error");
            this.callbackGiftCode(this.errorString);
         }
         else if(_loc2_)
         {
            _loc3_ = param1.mobject.getString("objectId");
            if(_loc3_ == null)
            {
               _loc3_ = "";
            }
            logger.debug("Code Campaign - Item Received: " + _loc3_);
            tracker.event(TrackCategories.MARKET,TrackActions.CODE_MACHINE,"success");
            this.process(_loc3_);
         }
      }
   }
}
