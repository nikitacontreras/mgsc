package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingDefinition;
   import flash.utils.Dictionary;
   
   public class CraftingModel
   {
       
      
      private var _reward:com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel;
      
      private var definition:CraftingDefinition;
      
      private var _breakdown:Dictionary;
      
      public function CraftingModel(param1:CraftingDefinition, param2:com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel)
      {
         super();
         this.definition = param1;
         this._reward = param2;
         this._breakdown = new Dictionary();
      }
      
      public function rewardStatus() : int
      {
         return this._reward.status;
      }
      
      public function isReached() : Boolean
      {
         var _loc1_:CraftingModuleModel = null;
         for each(_loc1_ in this._breakdown)
         {
            if(!_loc1_.isReached)
            {
               return false;
            }
         }
         return true;
      }
      
      public function increaseMaterial(param1:int, param2:int) : void
      {
         var _loc3_:CraftingModuleModel = this.getModule(param1);
         _loc3_.requirement.increase(param2);
      }
      
      public function get name() : String
      {
         return this.definition.name;
      }
      
      public function reset() : void
      {
         var _loc1_:CraftingModuleModel = null;
         for each(_loc1_ in this._breakdown)
         {
            _loc1_.reset();
         }
         this._reward.reset();
      }
      
      public function claimMaterialReward(param1:int) : void
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         _loc2_.claimReward();
      }
      
      public function rewardMaterialStatus(param1:int) : int
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.rewardStatus();
      }
      
      public function enableReward() : void
      {
         this._reward.enable();
      }
      
      public function isRewardMaterialGranted(param1:int) : Boolean
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.rewardGranted();
      }
      
      public function getMaterialRequirementAmount(param1:int) : int
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.requirement.amount;
      }
      
      public function enableMaterialReward(param1:int) : void
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         _loc2_.enableReward();
      }
      
      public function isMaterialReached(param1:int) : Boolean
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.isReached;
      }
      
      public function reserModule(param1:int) : void
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         _loc2_.reset();
      }
      
      public function isMaterialRewardAvailable(param1:int) : Boolean
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.rewardAvailable();
      }
      
      public function getMaterialAccumulatedCount(param1:int) : int
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.requirement.amount;
      }
      
      public function claimRewad() : void
      {
         this._reward.claim();
      }
      
      public function getMaterialReward(param1:int) : com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.reward;
      }
      
      public function hasMaterialRewad(param1:int) : Boolean
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return Boolean(_loc2_.reward);
      }
      
      public function get reward() : com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel
      {
         return this._reward;
      }
      
      public function get breakdown() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._breakdown);
         return _loc1_;
      }
      
      public function get isGranted() : Boolean
      {
         return this._reward.granted;
      }
      
      public function get code() : int
      {
         return this.definition.code;
      }
      
      internal function addCraftingItem(param1:CraftingModuleModel) : void
      {
         this._breakdown[param1.requirement.item] = param1;
      }
      
      public function getLackedMaterial(param1:int) : int
      {
         var _loc2_:CraftingModuleModel = this.getModule(param1);
         return _loc2_.requirement.amount - _loc2_.requirement.count;
      }
      
      private function getModule(param1:int) : CraftingModuleModel
      {
         var _loc2_:CraftingModuleModel = this._breakdown[param1];
         if(!_loc2_)
         {
            logger.debug("Doesn\'t exist a module craft registred for code= " + param1);
            throw new Error("Doesn\'t exist a module craft registred for code= " + param1);
         }
         return _loc2_;
      }
   }
}
