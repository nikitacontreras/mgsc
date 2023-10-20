package com.qb9.mambo.world.core.events
{
   import com.qb9.mambo.world.core.Room;
   import flash.events.Event;
   
   public final class WorldEvent extends Event
   {
      
      public static const ROOM_LOADED:String = "weRoomLoaded";
      
      public static const LOADING:String = "weLoading";
       
      
      private var _room:Room;
      
      public function WorldEvent(param1:String, param2:Room = null)
      {
         super(param1,false,true);
         this._room = param2;
      }
      
      public function get room() : Room
      {
         return this._room;
      }
      
      override public function clone() : Event
      {
         return new WorldEvent(type,this.room);
      }
   }
}
