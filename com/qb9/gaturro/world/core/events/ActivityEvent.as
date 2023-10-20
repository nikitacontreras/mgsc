package com.qb9.gaturro.world.core.events
{
   import com.qb9.mambo.queue.ServerLoginData;
   import com.qb9.mambo.world.core.RoomLink;
   import flash.events.Event;
   
   public final class ActivityEvent extends Event
   {
      
      public static const START_MULTIPLAYER:String = "aeStartMutiplayer";
      
      public static const START_MINIGAME:String = "aeStartMinigame";
       
      
      private var _returnLink:RoomLink;
      
      private var data:Object;
      
      public function ActivityEvent(param1:String, param2:Object, param3:RoomLink = null)
      {
         super(param1);
         this.data = param2;
         this._returnLink = param3;
      }
      
      public function get login() : ServerLoginData
      {
         return this.data as ServerLoginData;
      }
      
      public function get returnLink() : RoomLink
      {
         return this._returnLink;
      }
      
      public function get name() : String
      {
         return this.data as String;
      }
      
      override public function clone() : Event
      {
         return new ActivityEvent(type,this.name,this.returnLink);
      }
   }
}
