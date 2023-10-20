package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.manager.crafting.CraftingEnum;
   
   public class CraftingStatusModuleWrapper
   {
       
      
      private var statusModule:Object;
      
      public function CraftingStatusModuleWrapper(param1:Object)
      {
         super();
         this.statusModule = param1;
      }
      
      public function get rewardStatus() : int
      {
         return !!this.statusModule ? int(this.statusModule.r) : CraftingEnum.UNAVAILABLE_CODE;
      }
      
      public function get requirementCount() : int
      {
         return !!this.statusModule ? int(this.statusModule.c) : 0;
      }
   }
}
