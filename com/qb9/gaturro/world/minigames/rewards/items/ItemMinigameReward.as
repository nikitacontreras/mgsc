package com.qb9.gaturro.world.minigames.rewards.items
{
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   
   public final class ItemMinigameReward implements MinigameReward
   {
       
      
      private var _itemName:String;
      
      public function ItemMinigameReward(param1:String)
      {
         super();
         this._itemName = param1;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function get message() : String
      {
         return "You have acquired a " + this.itemName;
      }
      
      public function merge(param1:MinigameReward) : void
      {
      }
      
      public function canMergeWith(param1:MinigameReward) : Boolean
      {
         return false;
      }
   }
}
