package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
   
   public class CraftingRequirementModel extends CraftingExchageItemModel
   {
       
      
      private var _count:int;
      
      public function CraftingRequirementModel(param1:CraftingExchangeItemDefinition, param2:int = 0)
      {
         super(param1);
         this._count = param2;
      }
      
      public function increase(param1:int = 1) : void
      {
         if(this._count + param1 <= this.amount)
         {
            this._count += param1;
         }
         else if(this._count + param1 > this.amount && this._count < this.amount)
         {
            this._count = this.amount;
         }
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get isReached() : Boolean
      {
         return this._count >= amount;
      }
      
      public function reset() : void
      {
         this._count = 0;
      }
   }
}
