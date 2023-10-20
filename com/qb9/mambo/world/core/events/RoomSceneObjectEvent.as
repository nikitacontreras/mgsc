package com.qb9.mambo.world.core.events
{
   import flash.events.Event;
   
   public final class RoomSceneObjectEvent extends Event
   {
      
      public static const REPOSITIONED:String = "rsoeRepositioned";
       
      
      public function RoomSceneObjectEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new RoomSceneObjectEvent(type);
      }
   }
}
