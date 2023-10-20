package com.qb9.mambo.user.buddies
{
   import flash.events.Event;
   
   public final class BuddyListEvent extends Event
   {
      
      public static const ADDED:String = "bleBuddyAdded";
      
      public static const BLOCK_CHANGED:String = "bleBlockChanged";
      
      public static const CHANGED:String = "bleBuddiesChanged";
      
      public static const STATUS_CHANGED:String = "bleStatusChanged";
      
      public static const REMOVED:String = "bleBuddyRemoved";
       
      
      private var _buddy:com.qb9.mambo.user.buddies.Buddy;
      
      public function BuddyListEvent(param1:String, param2:com.qb9.mambo.user.buddies.Buddy = null)
      {
         super(param1);
         this._buddy = param2;
      }
      
      override public function clone() : Event
      {
         return new BuddyListEvent(type,this.buddy);
      }
      
      public function get buddy() : com.qb9.mambo.user.buddies.Buddy
      {
         return this._buddy;
      }
   }
}
