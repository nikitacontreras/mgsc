package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.api;
   import flash.utils.setTimeout;
   import mx.utils.StringUtil;
   
   public class JumboCampaign extends Campaign
   {
       
      
      private var itemGift:String;
      
      private const CHARACTER_BURNED:String = "x";
      
      private const CHARACTER_NOT_BURNED:String = "-";
      
      public function JumboCampaign(param1:Object)
      {
         super(param1);
      }
      
      public function set gift(param1:String) : void
      {
         this.itemGift = param1;
      }
      
      public function getItem(param1:int) : String
      {
         return campaignData.gifts[param1];
      }
      
      private function fillPosition(param1:String, param2:int, param3:int) : String
      {
         if(param2 < param3)
         {
            if(param1.length < param2)
            {
               param1 += this.CHARACTER_NOT_BURNED;
            }
         }
         else if(param2 == param3)
         {
            if(param1.length < param2)
            {
               param1 += this.CHARACTER_BURNED;
            }
            else
            {
               param1 = param1.substr(0,param3 - 1) + this.CHARACTER_BURNED + param1.substr(param3);
            }
         }
         return param1;
      }
      
      private function saveGift(param1:String) : void
      {
         var _loc2_:String = String(campaignData.customAttrNameGifts);
         var _loc3_:String = "";
         if(api.getProfileAttribute(_loc2_))
         {
            _loc3_ = api.getProfileAttribute(_loc2_) as String;
         }
         api.setProfileAttribute(_loc2_,_loc3_ + ";" + param1);
      }
      
      private function saveAttr(param1:int) : void
      {
         var _loc2_:String = String(campaignData.customAttrNameCodes);
         var _loc3_:String = "";
         if(api.getProfileAttribute(_loc2_))
         {
            _loc3_ = api.getProfileAttribute(_loc2_) as String;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= param1)
         {
            _loc3_ = this.fillPosition(_loc3_,_loc4_,param1);
            _loc4_++;
         }
         api.setProfileAttribute(_loc2_,_loc3_);
      }
      
      private function checkIfCodeUsed(param1:int) : Boolean
      {
         var _loc2_:String = String(campaignData.customAttrNameCodes);
         if(!api.getProfileAttribute(_loc2_))
         {
            return false;
         }
         var _loc3_:String = api.getProfileAttribute(_loc2_) as String;
         _loc3_ = StringUtil.trim(_loc3_);
         if(_loc3_.length < param1)
         {
            return false;
         }
         if(_loc3_.substr(param1 - 1,1) != this.CHARACTER_BURNED)
         {
            return false;
         }
         return true;
      }
      
      private function checkIfGiftUsed(param1:String) : Boolean
      {
         var _loc2_:String = String(campaignData.customAttrNameGifts);
         var _loc3_:String = "";
         if(api.getProfileAttribute(_loc2_))
         {
            _loc3_ = api.getProfileAttribute(_loc2_) as String;
         }
         if(_loc3_.indexOf(param1) >= 0)
         {
            return true;
         }
         return false;
      }
      
      override public function codeCheck(param1:Function, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc3_:int = 1;
         for each(_loc4_ in campaignData.codes)
         {
            if(_loc4_ == param2.toUpperCase())
            {
               if(this.checkIfCodeUsed(_loc3_))
               {
                  setTimeout(param1,2000,"<codeUsed>");
                  return;
               }
               if(this.checkIfGiftUsed(this.itemGift))
               {
                  setTimeout(param1,2000,"<giftUsed>");
                  return;
               }
               this.saveAttr(_loc3_);
               this.saveGift(this.itemGift);
               setTimeout(param1,2000,"");
               return;
            }
            _loc3_++;
         }
         setTimeout(param1,2000,"<error>");
      }
      
      public function itemCount() : int
      {
         return campaignData.gifts.length;
      }
   }
}
