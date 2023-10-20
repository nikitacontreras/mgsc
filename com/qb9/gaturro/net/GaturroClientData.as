package com.qb9.gaturro.net
{
   import flash.utils.getTimer;
   
   public class GaturroClientData
   {
       
      
      private var startLoginTime:int = 0;
      
      private var readyToPlayTime:int = 0;
      
      public function GaturroClientData()
      {
         super();
      }
      
      public function readyToPlay() : void
      {
         this.readyToPlayTime = getTimer();
      }
      
      public function get totalLoadingTime() : int
      {
         return this.readyToPlayTime - this.startLoginTime;
      }
      
      public function startLogin() : void
      {
         this.startLoginTime = getTimer();
      }
      
      public function get actualSessionTime() : int
      {
         return getTimer() - this.readyToPlayTime;
      }
   }
}
