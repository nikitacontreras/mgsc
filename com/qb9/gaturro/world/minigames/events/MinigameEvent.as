package com.qb9.gaturro.world.minigames.events
{
   import com.qb9.gaturro.world.minigames.Minigame;
   import flash.events.Event;
   
   public final class MinigameEvent extends Event
   {
      
      public static const STARTED:String = "meMinigameStarted";
      
      public static const CREATED:String = "meMinigameCreated";
      
      public static const FINISHED:String = "meMinigameFinished";
       
      
      private var data:Object;
      
      public function MinigameEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
      
      public function get minigame() : Minigame
      {
         return this.data as Minigame || target as Minigame;
      }
      
      override public function clone() : Event
      {
         return new MinigameEvent(type,this.data);
      }
   }
}
