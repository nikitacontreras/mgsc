package com.qb9.gaturro.manager.crafting
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.commons.model.item.ItemConfig;
   import com.qb9.gaturro.commons.model.item.ItemDefinition;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.model.config.crafting.CraftingConfig;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingBannerDefinition;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingDefinition;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModel;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModelFactory;
   import com.qb9.gaturro.model.config.crafting.model.CraftingRewardModel;
   import com.qb9.gaturro.service.crafting.CraftingPersistenceService;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import flash.utils.Dictionary;
   
   public class CraftingManager implements IConfigHolder
   {
       
      
      private var _modelFactory:CraftingModelFactory;
      
      private var user:GaturroUser;
      
      private var inventory:GaturroInventory;
      
      private var frozenInventoryMap:Dictionary;
      
      private var _config:CraftingConfig;
      
      private var modelList:Dictionary;
      
      private var itemConfig:ItemConfig;
      
      private var _persistenceService:CraftingPersistenceService;
      
      public function CraftingManager()
      {
         super();
         this.setupItemConfig();
         this.setupInventory();
         this.setupUser();
      }
      
      private function onInventoryAdded(param1:ContextEvent) : void
      {
         this.inventory = Context.instance.getByType(GaturroInventory) as GaturroInventory;
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInventoryAdded);
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as CraftingConfig;
         this.setupModel();
      }
      
      public function isRewardGranted(param1:int) : Boolean
      {
         var _loc2_:CraftingModel = this.getModel(param1);
         return _loc2_.isGranted;
      }
      
      private function onAddedUser(param1:ContextEvent) : void
      {
         this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedUser);
         this.setupModel();
      }
      
      public function increase(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:CraftingModel;
         (_loc4_ = this.getModel(param1)).increaseMaterial(param2,param3);
         if(_loc4_.isMaterialReached(param2) && _loc4_.rewardMaterialStatus(param2) == CraftingEnum.UNAVAILABLE_CODE)
         {
            _loc4_.enableMaterialReward(param2);
         }
         if(_loc4_.isReached() && _loc4_.rewardStatus() == CraftingEnum.UNAVAILABLE_CODE)
         {
            _loc4_.enableReward();
         }
         var _loc5_:ItemDefinition = this.itemConfig.getDefinitionByCode(param2);
         var _loc6_:int = _loc4_.getMaterialAccumulatedCount(param2);
         var _loc7_:int = _loc4_.getMaterialRequirementAmount(param2);
         var _loc8_:int = _loc6_ / _loc7_ * 100;
         api.trackEvent("CRAFTING:INTERACTION:" + _loc4_.name + ":" + _loc5_.path,"INCREASE_FROM_INVENTORY","",_loc8_);
         api.trackEvent("CRAFTING:INTERACTION:" + _loc4_.name + ":" + _loc5_.path,"INCREASE_FROM_INVENTORY_percent");
         this._persistenceService.storeCraftStatus(_loc4_);
      }
      
      public function claimMaterialReward(param1:int, param2:int) : void
      {
         var _loc4_:CraftingRewardModel = null;
         var _loc5_:ItemDefinition = null;
         var _loc3_:CraftingModel = this.getModel(param1);
         if(_loc3_.rewardMaterialStatus(param2) == CraftingEnum.AVAILABLE_CODE)
         {
            if(_loc3_.hasMaterialRewad(param2))
            {
               _loc4_ = _loc3_.getMaterialReward(param2);
               this.grantReward(_loc4_);
               _loc3_.claimMaterialReward(param2);
               _loc5_ = this.itemConfig.getDefinitionByCode(param2);
               api.trackEvent("CRAFTING:INTERACTION:" + _loc3_.name + ":" + _loc5_.path,"CLAIM_MATERIAL_REWARD");
               this._persistenceService.storeCraftStatus(_loc3_);
            }
            return;
         }
         logger.debug("The reward identified with the crafting code = " + param1 + " and the material= " + param2 + " is not available to be claimed.");
         throw new Error("The reward identified with the crafting code = " + param1 + " and the material= " + param2 + " is not available to be claimed.");
      }
      
      private function updateMap(param1:String, param2:int) : void
      {
         var _loc3_:Array = this.frozenInventoryMap[param1];
         _loc3_.length -= param2;
      }
      
      public function getBannerDefinition(param1:int) : CraftingBannerDefinition
      {
         return this._config.getCraftingBannerDefinition(param1);
      }
      
      public function freezeInventoryMap() : void
      {
         var _loc1_:Array = null;
         var _loc2_:GaturroInventorySceneObject = null;
         this.frozenInventoryMap = new Dictionary();
         for each(_loc1_ in this.user.allItemsGrouped)
         {
            for each(_loc2_ in _loc1_)
            {
               if(!this.frozenInventoryMap[_loc2_.name])
               {
                  this.frozenInventoryMap[_loc2_.name] = new Array();
               }
               this.frozenInventoryMap[_loc2_.name].push(_loc2_);
            }
         }
      }
      
      public function inventoryHasStock(param1:int) : Boolean
      {
         var _loc2_:ItemDefinition = this.itemConfig.getDefinitionByCode(param1);
         var _loc3_:Array = this.frozenInventoryMap[_loc2_.path];
         return Boolean(_loc3_) && Boolean(_loc3_.length);
      }
      
      private function setupItemConfig() : void
      {
         if(Context.instance.hasByType(ItemConfig))
         {
            this.itemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedItemConfig);
         }
      }
      
      public function claimReward(param1:int) : void
      {
         var _loc3_:CraftingRewardModel = null;
         var _loc2_:CraftingModel = this.getModel(param1);
         if(_loc2_.rewardStatus() == CraftingEnum.AVAILABLE_CODE)
         {
            _loc3_ = _loc2_.reward;
            this.grantReward(_loc3_);
            _loc2_.claimRewad();
            api.trackEvent("CRAFTING:INTERACTION:" + _loc2_.name,"CLAIM_REWARD");
            this._persistenceService.storeCraftStatus(_loc2_);
            return;
         }
         logger.debug("The reward identified with the crafting code = " + param1 + " is not available to be claimed.");
         throw new Error("The reward identified with the crafting code = " + param1 + " is not available to be claimed.");
      }
      
      public function getMaterialList(param1:int) : IIterator
      {
         var _loc2_:CraftingModel = this.getModel(param1);
         return _loc2_.breakdown;
      }
      
      public function reset(param1:int, param2:int = 0) : void
      {
         var _loc3_:CraftingModel = this.getModel(param1);
         if(param2 > 0)
         {
            _loc3_.reserModule(param2);
         }
         else
         {
            _loc3_.reset();
         }
         this._persistenceService.storeCraftStatus(_loc3_);
      }
      
      private function setupInventory() : void
      {
         if(Context.instance.getByType(GaturroInventory))
         {
            this.inventory = Context.instance.getByType(GaturroInventory) as GaturroInventory;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onInventoryAdded);
         }
      }
      
      public function isRewardMaterialGranted(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingModel = this.getModel(param1);
         return _loc3_.isRewardMaterialGranted(param2);
      }
      
      public function set modelFactory(param1:CraftingModelFactory) : void
      {
         this._modelFactory = param1;
         this.setupModel();
      }
      
      public function isMaterialReached(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingModel = this.getModel(param1);
         return _loc3_.isMaterialReached(param2);
      }
      
      public function isMaterialRewardAvailable(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingModel = this.getModel(param1);
         return _loc3_.isMaterialRewardAvailable(param2);
      }
      
      private function grantReward(param1:CraftingRewardModel) : void
      {
         var _loc2_:ItemDefinition = this.itemConfig.getDefinitionByCode(param1.item);
         trace("ENTREGARÍA : ",param1.amount,_loc2_.path);
      }
      
      private function setupModel() : void
      {
         var _loc1_:IIterator = null;
         var _loc2_:CraftingDefinition = null;
         if(this._modelFactory && this._config && Boolean(this.user))
         {
            this.modelList = new Dictionary();
            _loc1_ = this._config.getIterator();
            while(_loc1_.next())
            {
               _loc2_ = _loc1_.current() as CraftingDefinition;
               this.modelList[_loc2_.code] = this._modelFactory.build(_loc2_.code);
            }
         }
      }
      
      private function setupUser() : void
      {
         if(Context.instance.hasByType(GaturroUser))
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
            this.setupModel();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedUser);
         }
      }
      
      public function increaseFromInventory(param1:int, param2:int) : void
      {
         var _loc10_:int = 0;
         var _loc3_:CraftingModel = this.getModel(param1);
         var _loc4_:ItemDefinition = this.itemConfig.getDefinitionByCode(param2);
         var _loc5_:Array;
         if((Boolean(!!(_loc5_ = this.frozenInventoryMap[_loc4_.path]) ? int(_loc5_.length) : 0)) && !_loc3_.isMaterialReached(param2))
         {
            _loc10_ = Math.min(0,_loc3_.getLackedMaterial(param2));
            api.takeFromUser(_loc4_.path,_loc10_);
            _loc3_.increaseMaterial(param2,_loc10_);
            this.updateMap(_loc4_.path,_loc10_);
         }
         if(_loc3_.reward && _loc3_.isMaterialReached(param2) && _loc3_.rewardMaterialStatus(param2) == CraftingEnum.UNAVAILABLE_CODE)
         {
            _loc3_.enableMaterialReward(param2);
         }
         if(_loc3_.isReached() && _loc3_.rewardStatus() == CraftingEnum.UNAVAILABLE_CODE)
         {
            _loc3_.enableReward();
         }
         var _loc7_:int = _loc3_.getMaterialAccumulatedCount(param2);
         var _loc8_:int = _loc3_.getMaterialRequirementAmount(param2);
         var _loc9_:int = _loc7_ / _loc8_ * 100;
         api.trackEvent("CRAFTING:INTERACTION:" + _loc3_.name + ":" + _loc4_.path,"INCREASE_FROM_INVENTORY","",_loc9_);
         api.trackEvent("CRAFTING:INTERACTION:" + _loc3_.name + ":" + _loc4_.path,"INCREASE_FROM_INVENTORY_percent");
         this._persistenceService.storeCraftStatus(_loc3_);
      }
      
      private function onAddedItemConfig(param1:ContextEvent) : void
      {
         if(param1.instanceType == ItemConfig)
         {
            this.itemConfig = param1.instance as ItemConfig;
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedItemConfig);
         }
      }
      
      private function getModel(param1:int) : CraftingModel
      {
         var _loc2_:CraftingModel = this.modelList[param1];
         if(!_loc2_)
         {
            logger.debug("There is no definition of craft with the code " + param1);
            throw new Error("There is no definition of craft with the code " + param1);
         }
         return _loc2_;
      }
      
      public function inventoryItemQuantity(param1:int) : int
      {
         var _loc2_:ItemDefinition = this.itemConfig.getDefinitionByCode(param1);
         var _loc3_:Array = this.frozenInventoryMap[_loc2_.path];
         return Boolean(_loc3_) && Boolean(_loc3_.length) ? int(_loc3_.length) : 0;
      }
      
      public function set persistenceService(param1:CraftingPersistenceService) : void
      {
         this._persistenceService = param1;
      }
   }
}
