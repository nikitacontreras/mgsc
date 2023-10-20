package com.qb9.gaturro.world.minigames.rewards.points
{
   import com.qb9.flashlib.security.SafeNumber;
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   
   public final class PointsMinigameReward implements MinigameReward
   {
       
      
      private var _points:SafeNumber;
      
      private var _game:String;
      
      private var _sessionScore:SafeNumber;
      
      public function PointsMinigameReward(param1:String, param2:uint, param3:Number)
      {
         super();
         this._game = param1;
         this._points = new SafeNumber(param2);
         this._sessionScore = new SafeNumber(param3);
      }
      
      public function get points() : uint
      {
         return this._points.value;
      }
      
      public function get message() : String
      {
         return "You achieved " + this.points + " points!";
      }
      
      public function get game() : String
      {
         return this._game;
      }
      
      public function canMergeWith(param1:MinigameReward) : Boolean
      {
         return param1 is PointsMinigameReward && PointsMinigameReward(param1).game === this.game;
      }
      
      public function merge(param1:MinigameReward) : void
      {
         this._points.value += PointsMinigameReward(param1).points;
      }
      
      public function get sessionScore() : Number
      {
         return this._sessionScore.value;
      }
   }
}
