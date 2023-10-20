package com.qb9.mambo.user.events
{
   import flash.events.Event;
   
   public final class UserEvent extends Event
   {
      
      public static const INVENTORY_LOADED:String = "ueInventoryLoaded";
      
      public static const LOADED:String = "ueLoaded";
       
      
      public function UserEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new UserEvent(type);
      }
   }
}
