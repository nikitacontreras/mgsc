package com.qb9.gaturro.model.config.crafting.definition
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class CraftingDefinition implements IDefinition
   {
       
      
      private var _name:String;
      
      private var _code:int;
      
      private var _reward:com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
      
      private var _craftModuleMap:Dictionary;
      
      public function CraftingDefinition(param1:int, param2:String, param3:Object)
      {
         super();
         this._code = param1;
         this._name = param2;
         this._reward = new com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition(param3);
         this._craftModuleMap = new Dictionary();
      }
      
      public function get reward() : com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition
      {
         return this._reward;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function getRewardModule(param1:int) : com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition
      {
         var _loc2_:CraftingModuleDefinition = this.getCraftModule(param1);
         return _loc2_.reward;
      }
      
      public function addCraftItem(param1:Object) : void
      {
         var _loc2_:CraftingModuleDefinition = CraftModuleFactory.build(param1);
         this._craftModuleMap[_loc2_.code] = _loc2_;
      }
      
      public function getCraftModule(param1:int) : CraftingModuleDefinition
      {
         var _loc2_:CraftingModuleDefinition = this._craftModuleMap[param1];
         if(!_loc2_)
         {
            logger.debug("Doesn\'t exist a module with the code = " + param1);
            throw new Error("Doesn\'t exist a module with the code = " + param1);
         }
         return _loc2_;
      }
      
      public function getRequirementModule() : com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition
      {
         var _loc1_:CraftingModuleDefinition = this.getCraftModule(this.code);
         return _loc1_.requirement;
      }
      
      public function getModuleMap() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._craftModuleMap);
         return _loc1_;
      }
   }
}

import com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
import com.qb9.gaturro.model.config.crafting.definition.CraftingModuleDefinition;

class CraftModuleFactory
{
    
   
   public function CraftModuleFactory()
   {
      super();
   }
   
   public static function build(param1:Object) : CraftingModuleDefinition
   {
      var _loc4_:CraftingExchangeItemDefinition = null;
      var _loc2_:CraftingExchangeItemDefinition = new CraftingExchangeItemDefinition(param1.requirement);
      if(param1.reward)
      {
         _loc4_ = new CraftingExchangeItemDefinition(param1.reward);
      }
      return new CraftingModuleDefinition(_loc2_,_loc4_);
   }
}
