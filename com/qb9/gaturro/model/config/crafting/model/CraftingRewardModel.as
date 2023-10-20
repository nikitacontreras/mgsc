package com.qb9.gaturro.model.config.crafting.model
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.manager.crafting.CraftingEnum;
   import com.qb9.gaturro.model.config.crafting.definition.CraftingExchangeItemDefinition;
   
   public class CraftingRewardModel extends CraftingExchageItemModel
   {
       
      
      private var _status:int;
      
      public function CraftingRewardModel(param1:CraftingExchangeItemDefinition, param2:int)
      {
         this._status = CraftingEnum.UNAVAILABLE_CODE;
         super(param1);
         this._status = param2 || CraftingEnum.UNAVAILABLE_CODE;
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function get statusLabel() : String
      {
         return CraftingEnum.getRewardStatusLabel(this._status);
      }
      
      public function get available() : Boolean
      {
         return this._status == CraftingEnum.AVAILABLE_CODE;
      }
      
      public function enable() : void
      {
         this._status = CraftingEnum.AVAILABLE_CODE;
      }
      
      public function get granted() : Boolean
      {
         return this._status == CraftingEnum.GRANTED_CODE;
      }
      
      public function claim() : void
      {
         if(this._status == CraftingEnum.AVAILABLE_CODE)
         {
            this._status = CraftingEnum.GRANTED_CODE;
            return;
         }
         logger.debug("Attempted to grant unavailable reward");
         throw new Error("Attempted to grant unavailable reward");
      }
      
      public function reset() : void
      {
         this._status = CraftingEnum.UNAVAILABLE_CODE;
      }
   }
}
