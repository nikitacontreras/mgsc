package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.model.config.crafting.CraftingConfig;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingDefinition;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingModuleDefinition;
   import com.qb9.gaturro.service.crafting.CraftingPersistenceService;
   
   public class CraftingModelFactory implements IConfigHolder
   {
       
      
      private var _config:CraftingConfig;
      
      private var _persistenceService:CraftingPersistenceService;
      
      public function CraftingModelFactory()
      {
         super();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as CraftingConfig;
      }
      
      private function addCraftingItem(param1:CraftingModel, param2:CraftingModuleDefinition, param3:CraftingStatusWrapper) : void
      {
         var _loc7_:CraftingRewardModel = null;
         var _loc4_:CraftingStatusModuleWrapper = param3.getStatusModule(param2.requirement.item);
         if(param2.reward)
         {
            _loc7_ = new CraftingRewardModel(param2.reward,_loc4_.rewardStatus);
         }
         var _loc5_:CraftingRequirementModel = new CraftingRequirementModel(param2.requirement,_loc4_.requirementCount);
         var _loc6_:CraftingModuleModel = new CraftingModuleModel(_loc5_,_loc7_);
         param1.addCraftingItem(_loc6_);
      }
      
      public function set persistenceService(param1:CraftingPersistenceService) : void
      {
         this._persistenceService = param1;
      }
      
      private function buildBreakdown(param1:CraftingDefinition, param2:CraftingModel, param3:CraftingStatusWrapper) : void
      {
         var _loc5_:CraftingModuleDefinition = null;
         var _loc4_:IIterator = param1.getModuleMap();
         while(_loc4_.next())
         {
            _loc5_ = _loc4_.current() as CraftingModuleDefinition;
            this.addCraftingItem(param2,_loc5_,param3);
         }
      }
      
      public function build(param1:int) : CraftingModel
      {
         var _loc2_:CraftingDefinition = this._config.getDefinitionByCode(param1);
         var _loc3_:CraftingStatusWrapper = this._persistenceService.getCraftStatus(param1);
         var _loc4_:CraftingRewardModel = new CraftingRewardModel(_loc2_.reward,_loc3_.rewardStatus);
         var _loc5_:CraftingModel = new CraftingModel(_loc2_,_loc4_);
         this.buildBreakdown(_loc2_,_loc5_,_loc3_);
         return _loc5_;
      }
   }
}
