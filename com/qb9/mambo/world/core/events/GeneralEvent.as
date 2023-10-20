package com.qb9.mambo.world.core.events
{
   import flash.events.Event;
   
   public final class GeneralEvent extends Event
   {
      
      public static const READY:String = "geReady";
      
      public static const DISPOSED:String = "geDisposed";
       
      
      public function GeneralEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new GeneralEvent(type);
      }
   }
}
