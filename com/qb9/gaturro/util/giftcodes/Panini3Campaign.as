package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.api;
   
   public class Panini3Campaign extends Campaign
   {
       
      
      private var pepionesGift:Array;
      
      public function Panini3Campaign(param1:Object)
      {
         this.pepionesGift = [10,25,50,100];
         super(param1);
      }
      
      override protected function deliverItem(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc3_:uint = uint(param1.replace("premiosPanini.gift",""));
         if(_loc3_ < 5)
         {
            _loc4_ = uint(this.pepionesGift[_loc3_ - 1]);
            _loc5_ = int(api.getProfileAttribute("pepionesCoins")) + _loc4_;
            api.setProfileAttribute("pepionesCoins",_loc5_);
            _loc2_ = true;
         }
         if(!_loc2_)
         {
            giveToUser(param1);
         }
         callbackGiftCode(param1,_loc4_);
      }
   }
}
