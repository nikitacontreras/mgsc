package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
   
   public class CraftingExchageItemModel
   {
       
      
      protected var definition:CraftingExchangeItemDefinition;
      
      public function CraftingExchageItemModel(param1:CraftingExchangeItemDefinition)
      {
         super();
         this.definition = param1;
      }
      
      public function get amount() : int
      {
         return this.definition.amount;
      }
      
      public function get item() : int
      {
         return this.definition.item;
      }
   }
}
