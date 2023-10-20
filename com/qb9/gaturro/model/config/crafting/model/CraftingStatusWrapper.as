package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.manager.crafting.CraftingEnum;
   import flash.utils.Dictionary;
   
   public class CraftingStatusWrapper
   {
       
      
      private var status:Object;
      
      public function CraftingStatusWrapper(param1:Object)
      {
         super();
         this.status = param1;
      }
      
      public function get breakdown() : Dictionary
      {
         return this.status.bd || null;
      }
      
      public function get rewardStatus() : int
      {
         return int(this.status.r) || CraftingEnum.UNAVAILABLE_CODE;
      }
      
      public function getStatusModule(param1:int) : CraftingStatusModuleWrapper
      {
         var _loc2_:Object = Boolean(this.status) && Boolean(this.status.bd) ? this.status.bd[param1] : null;
         return new CraftingStatusModuleWrapper(_loc2_);
      }
   }
}
