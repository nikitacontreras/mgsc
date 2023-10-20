package com.qb9.gaturro.service.crafting
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.manager.crafting.CraftingEnum;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModel;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.model.config.crafting.model.CraftingStatusWrapper;
   
   public class CraftingPersistenceService
   {
       
      
      public function CraftingPersistenceService()
      {
         super();
      }
      
      public function storeCraftStatus(param1:CraftingModel) : void
      {
         var _loc2_:Object = this.getStatusObject(param1);
         var _loc3_:Object = com.adobe.serialization.json.JSON.encode(_loc2_);
         user.profile.attributes[CraftingEnum.CRAFTING_PREFIX + param1.code] = _loc3_;
      }
      
      private function getBreakdown(param1:CraftingModel) : Object
      {
         var _loc3_:CraftingModuleModel = null;
         var _loc4_:Object = null;
         var _loc2_:IIterator = param1.breakdown;
         var _loc5_:Object = new Object();
         while(_loc2_.next())
         {
            _loc3_ = _loc2_.current() as CraftingModuleModel;
            (_loc4_ = new Object()).c = _loc3_.requirement.count;
            _loc4_.r = !!_loc3_.reward ? _loc3_.reward.status : null;
            _loc5_[_loc3_.requirement.item] = _loc4_;
         }
         return _loc5_;
      }
      
      public function getCraftStatus(param1:int) : CraftingStatusWrapper
      {
         var _loc2_:String = String(user.profile.attributes[CraftingEnum.CRAFTING_PREFIX + param1]);
         var _loc3_:Object = !!_loc2_ ? com.adobe.serialization.json.JSON.decode(_loc2_) : new Object();
         return new CraftingStatusWrapper(_loc3_);
      }
      
      private function getStatusObject(param1:CraftingModel) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.r = param1.reward.status;
         _loc2_.bd = this.getBreakdown(param1);
         return _loc2_;
      }
   }
}
