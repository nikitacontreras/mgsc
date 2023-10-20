package com.qb9.gaturro.world.minigames.rewards
{
   public interface MinigameReward
   {
       
      
      function merge(param1:MinigameReward) : void;
      
      function canMergeWith(param1:MinigameReward) : Boolean;
      
      function get message() : String;
   }
}
