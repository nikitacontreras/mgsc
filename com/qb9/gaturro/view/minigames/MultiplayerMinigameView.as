package com.qb9.gaturro.view.minigames
{
   import com.qb9.gaturro.world.minigames.Minigame;
   import com.qb9.gaturro.world.minigames.MultiplayerMinigame;
   import com.qb9.mambo.queue.ServerLoginData;
   
   public final class MultiplayerMinigameView extends MinigameView
   {
       
      
      public function MultiplayerMinigameView(param1:Minigame)
      {
         super(param1);
      }
      
      private function get login() : ServerLoginData
      {
         return MultiplayerMinigame(minigame).login;
      }
      
      override protected function initializeGame(param1:Object) : void
      {
         if("initialize" in param1)
         {
            param1.initialize(minigame.userData,this.login,minigame.roomId);
         }
      }
   }
}
