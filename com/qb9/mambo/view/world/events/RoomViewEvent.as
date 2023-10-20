package com.qb9.mambo.view.world.events
{
   import flash.events.Event;
   
   public final class RoomViewEvent extends Event
   {
      
      public static const READY:String = "rvReady";
       
      
      public function RoomViewEvent(param1:String)
      {
         super(param1,false,true);
      }
      
      override public function clone() : Event
      {
         return new RoomViewEvent(type);
      }
   }
}
