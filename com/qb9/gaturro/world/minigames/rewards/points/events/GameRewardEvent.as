package com.qb9.gaturro.world.minigames.rewards.points.events
{
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import flash.events.Event;
   
   public final class GameRewardEvent extends Event
   {
      
      public static const AWARDED_REYES:String = "creReyesAwarded";
      
      public static const AWARDED_HALLOWEEN:String = "creHalloweenAwarded";
      
      public static const AWARDED:String = "creCoinsAwarded";
      
      public static const AWARDED_NAVIDAD:String = "creNavidadAwarded";
       
      
      private var _reward:GameMinigameReward;
      
      public function GameRewardEvent(param1:String, param2:GameMinigameReward)
      {
         super(param1);
         this._reward = param2;
      }
      
      override public function clone() : Event
      {
         return new GameRewardEvent(type,this.reward);
      }
      
      public function get reward() : GameMinigameReward
      {
         return this._reward;
      }
   }
}
