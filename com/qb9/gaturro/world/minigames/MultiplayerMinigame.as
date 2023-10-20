package com.qb9.gaturro.world.minigames
{
   import com.qb9.mambo.queue.ServerLoginData;
   
   public final class MultiplayerMinigame extends Minigame
   {
       
      
      private var _login:ServerLoginData;
      
      public function MultiplayerMinigame(param1:ServerLoginData, param2:MinigameUserData, param3:int)
      {
         super(param1.game,param2,param3);
         this._login = param1;
      }
      
      public function get login() : ServerLoginData
      {
         return this._login;
      }
      
      override public function dispose() : void
      {
         this._login = null;
         super.dispose();
      }
   }
}
