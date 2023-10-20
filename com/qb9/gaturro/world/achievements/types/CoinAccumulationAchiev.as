package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import flash.utils.setTimeout;
   
   public class CoinAccumulationAchiev extends Achievement
   {
       
      
      protected var quantityNeeds:int;
      
      public function CoinAccumulationAchiev(param1:Object)
      {
         super(param1);
         this.quantityNeeds = param1.data.quantity;
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else
         {
            this.activate();
         }
         if(param2)
         {
            setTimeout(this.checkInitStatus,500);
         }
      }
      
      private function checkInitStatus() : void
      {
         this.checkCoinStatus(false);
      }
      
      private function winCoins(param1:NetworkManagerEvent) : void
      {
         this.checkCoinStatus(true);
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         net.addEventListener(GaturroNetResponses.MINIGAME_SCORE,this.winCoins);
      }
      
      override protected function deactivate() : void
      {
         net.removeEventListener(GaturroNetResponses.MINIGAME_SCORE,this.winCoins);
      }
      
      private function checkCoinStatus(param1:Boolean) : void
      {
         var _loc2_:Number = Number(user.attributes["coins"]);
         if(_loc2_ >= this.quantityNeeds)
         {
            achieve(param1);
         }
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
   }
}
