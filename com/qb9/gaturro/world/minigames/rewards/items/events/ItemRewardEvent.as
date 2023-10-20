package com.qb9.gaturro.world.minigames.rewards.items.events
{
   import com.qb9.gaturro.world.minigames.rewards.items.ItemMinigameReward;
   import flash.events.Event;
   
   public final class ItemRewardEvent extends Event
   {
      
      public static const AWARDED:String = "iaeItemAwarded";
       
      
      private var _reward:ItemMinigameReward;
      
      public function ItemRewardEvent(param1:String, param2:ItemMinigameReward)
      {
         super(param1);
         this._reward = param2;
      }
      
      override public function clone() : Event
      {
         return new ItemRewardEvent(type,this.reward);
      }
      
      public function get reward() : ItemMinigameReward
      {
         return this._reward;
      }
   }
}
