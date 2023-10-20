package com.qb9.gaturro.world.core.events
{
   import flash.events.Event;
   
   public final class AvatarHomeEvent extends Event
   {
      
      public static const LEAVE:String = "aheLeaveHome";
       
      
      public function AvatarHomeEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new AvatarHomeEvent(type);
      }
   }
}
