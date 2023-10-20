package com.qb9.gaturro.world.minigames.rewards.none
{
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   
   public final class NullMinigameReward implements MinigameReward
   {
       
      
      public function NullMinigameReward()
      {
         super();
      }
      
      public function canMergeWith(param1:MinigameReward) : Boolean
      {
         return param1 is NullMinigameReward;
      }
      
      public function get message() : String
      {
         return "You achieved no reward";
      }
      
      public function merge(param1:MinigameReward) : void
      {
      }
   }
}
