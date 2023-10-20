package com.qb9.gaturro.model.config.crafting.definition
{
   public class CraftingModuleDefinition
   {
       
      
      private var _code:int;
      
      private var _requirement:com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
      
      private var _reward:com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
      
      public function CraftingModuleDefinition(param1:com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition, param2:com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition = null)
      {
         super();
         this._code = param1.item;
         this._reward = param2;
         this._requirement = param1;
      }
      
      public function get requirement() : com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition
      {
         return this._requirement;
      }
      
      public function get reward() : com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition
      {
         return this._reward;
      }
      
      public function get code() : int
      {
         return this._code;
      }
   }
}
