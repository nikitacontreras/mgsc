package com.qb9.gaturro.util.giftcodes
{
   import com.qb9.gaturro.globals.api;
   
   public class VirtualGoodsCampaign extends Campaign
   {
       
      
      public function VirtualGoodsCampaign(param1:Object)
      {
         super(param1);
      }
      
      public function virtualGoodItem() : String
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Array = null;
         var _loc7_:Date = null;
         var _loc1_:Date = new Date(api.time);
         var _loc2_:Date = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date);
         for each(_loc3_ in campaignData.data.dates)
         {
            _loc4_ = String(_loc3_.from).split("-");
            _loc5_ = new Date(int(_loc4_[2]),int(_loc4_[1]) - 1,int(_loc4_[0]));
            _loc6_ = String(_loc3_.to).split("-");
            _loc7_ = new Date(int(_loc6_[2]),int(_loc6_[1]) - 1,int(_loc6_[0]));
            if(_loc2_.time >= _loc5_.time && _loc2_.time < _loc7_.time)
            {
               return _loc3_.item;
            }
         }
         return campaignData.data.§default§;
      }
      
      override protected function checkItemName(param1:String) : String
      {
         super.checkItemName(param1);
         if(param1 == "gift.vigut")
         {
            param1 = this.virtualGoodItem();
         }
         return param1;
      }
   }
}
