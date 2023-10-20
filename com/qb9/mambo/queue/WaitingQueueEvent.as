package com.qb9.mambo.queue
{
   import flash.events.Event;
   
   public final class WaitingQueueEvent extends Event
   {
      
      public static const ADDED:String = "wqeQueueAdded";
      
      public static const READY:String = "wqeQueueReady";
      
      public static const REMOVED:String = "wqeQueueRemoved";
      
      public static const CREATED:String = "wqeCreated";
      
      public static const CANCELLED:String = "wqeCancelled";
      
      public static const CHANGED:String = "wqeChanged";
       
      
      private var data:Object;
      
      public function WaitingQueueEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.data = param2;
      }
      
      public function get users() : Array
      {
         return this.data as Array;
      }
      
      public function get login() : ServerLoginData
      {
         return this.data as ServerLoginData;
      }
      
      public function get user() : String
      {
         return this.data as String;
      }
      
      override public function clone() : Event
      {
         return new WaitingQueueEvent(type,this.users);
      }
   }
}
