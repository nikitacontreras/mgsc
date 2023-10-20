package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.manager.crafting.CraftingEnum;
   
   public class CraftingModuleModel
   {
       
      
      private var _requirement:com.qb9.gaturro.model.config.crafting.model.CraftingRequirementModel;
      
      private var _reward:com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel;
      
      public function CraftingModuleModel(param1:com.qb9.gaturro.model.config.crafting.model.CraftingRequirementModel, param2:com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel = null)
      {
         super();
         this._requirement = param1;
         this._reward = param2;
      }
      
      public function rewardStatus() : int
      {
         return this.hasRweward() ? this._reward.status : CraftingEnum.NON_EXISTENT_CODE;
      }
      
      public function increase(param1:int) : void
      {
         this._requirement.increase(param1);
      }
      
      public function get requirement() : com.qb9.gaturro.model.config.crafting.model.CraftingRequirementModel
      {
         return this._requirement;
      }
      
      public function hasRweward() : Boolean
      {
         return Boolean(this._reward);
      }
      
      public function claimReward() : void
      {
         this._reward.claim();
      }
      
      public function rewardGranted() : Boolean
      {
         return this._reward.granted;
      }
      
      public function reset() : void
      {
         if(this._reward)
         {
            this._reward.reset();
         }
         this._requirement.reset();
      }
      
      public function get requirementCode() : int
      {
         return this._requirement.item;
      }
      
      public function enableReward() : void
      {
         this._reward.enable();
      }
      
      public function get reward() : com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel
      {
         return this._reward;
      }
      
      public function get isReached() : Boolean
      {
         return this._requirement.isReached;
      }
      
      public function rewardAvailable() : Boolean
      {
         return this._reward.available;
      }
      
      public function toString() : String
      {
         return "CraftingModuleModel = [ code: " + this._requirement.item + " // count: " + this._requirement.count + "/" + this._requirement.amount + " // reward.status: " + this._reward.statusLabel + "]";
      }
   }
}
