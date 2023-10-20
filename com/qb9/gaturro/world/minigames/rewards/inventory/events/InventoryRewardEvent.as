package com.qb9.gaturro.world.minigames.rewards.inventory.events
{
   import com.qb9.gaturro.world.minigames.rewards.inventory.InventoryMinigameReward;
   import flash.events.Event;
   
   public final class InventoryRewardEvent extends Event
   {
      
      public static const AWARDED:String = "iaeInventoryItemAwarded";
       
      
      private var _reward:InventoryMinigameReward;
      
      public function InventoryRewardEvent(param1:String, param2:InventoryMinigameReward)
      {
         super(param1);
         this._reward = param2;
      }
      
      override public function clone() : Event
      {
         return new InventoryRewardEvent(type,this.reward);
      }
      
      public function get reward() : InventoryMinigameReward
      {
         return this._reward;
      }
   }
}
