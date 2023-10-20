package com.qb9.gaturro.world.minigames.rewards.inventory
{
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   
   public final class InventoryMinigameReward implements MinigameReward
   {
       
      
      private var _catalog:String;
      
      private var _itemName:String;
      
      public function InventoryMinigameReward(param1:String, param2:String)
      {
         super();
         this._itemName = param1;
         this._catalog = param2;
      }
      
      public function get message() : String
      {
         return "You have acquired an inventory item: " + this.itemName;
      }
      
      public function canMergeWith(param1:MinigameReward) : Boolean
      {
         return false;
      }
      
      public function merge(param1:MinigameReward) : void
      {
      }
      
      public function get catalog() : String
      {
         return this._catalog;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
   }
}
