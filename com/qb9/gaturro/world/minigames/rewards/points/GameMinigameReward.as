package com.qb9.gaturro.world.minigames.rewards.points
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   
   public final class GameMinigameReward implements MinigameReward
   {
       
      
      private var _coins:uint;
      
      private var _betterScore:Boolean;
      
      private var _game:String;
      
      private var _sessionScore:Number;
      
      public function GameMinigameReward(param1:uint, param2:String = null, param3:Number = 0, param4:Boolean = false)
      {
         super();
         this._coins = param1;
         this._game = param2;
         this._sessionScore = param3;
         this._betterScore = param4;
      }
      
      public function get message() : String
      {
         return StringUtil.format(region.key("got_coins"),this.coins);
      }
      
      public function get coins() : uint
      {
         return this._coins;
      }
      
      public function canMergeWith(param1:MinigameReward) : Boolean
      {
         return param1 is GameMinigameReward;
      }
      
      public function get game() : String
      {
         return this._game;
      }
      
      public function merge(param1:MinigameReward) : void
      {
         this._coins += GameMinigameReward(param1).coins;
      }
      
      public function get betterScore() : Boolean
      {
         return this._betterScore;
      }
      
      public function get sessionScore() : Number
      {
         return this._sessionScore;
      }
   }
}
