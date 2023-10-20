package com.qb9.gaturro.world.minigames.rewards.none.events
{
   import com.qb9.gaturro.world.minigames.rewards.none.NullMinigameReward;
   import flash.events.Event;
   
   public final class NullRewardEvent extends Event
   {
      
      public static const AWARDED:String = "nreNothingAwarded";
       
      
      private var _reward:NullMinigameReward;
      
      public function NullRewardEvent(param1:String, param2:NullMinigameReward)
      {
         super(param1);
         this._reward = param2;
      }
      
      override public function clone() : Event
      {
         return new NullRewardEvent(type,this.reward);
      }
      
      public function get reward() : NullMinigameReward
      {
         return this._reward;
      }
   }
}
