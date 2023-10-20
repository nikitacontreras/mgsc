package com.qb9.gaturro.model.config.crafting.definition
{
   public class CraftingExchangeItemDefinition
   {
       
      
      private var _item:int;
      
      private var _amount:int;
      
      public function CraftingExchangeItemDefinition(param1:Object)
      {
         super();
         this._amount = param1.amount;
         this._item = param1.item;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function get item() : int
      {
         return this._item;
      }
   }
}
