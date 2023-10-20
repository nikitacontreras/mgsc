package com.qb9.mambo.world.core
{
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.room.ChangeRoomActionRequest;
   import com.qb9.mambo.net.requests.room.RoomDataRequest;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.core.events.WorldEvent;
   
   public class World extends MamboObject
   {
       
      
      protected var net:NetworkManager;
      
      protected var user:User;
      
      protected var roomId:int;
      
      protected var room:com.qb9.mambo.world.core.Room;
      
      public function World(param1:User, param2:NetworkManager)
      {
         super();
         this.net = param2;
         this.user = param1;
         this.init();
      }
      
      protected function prepareEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.ROOM_DATA,this.roomLoaded);
         this.net.addEventListener(NetworkManagerEvent.CHANGE_ROOM,this.whenTheRoomChanges);
      }
      
      override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new WorldEvent(param1,param2));
      }
      
      public function changeToRoom(param1:RoomLink) : void
      {
         debug("Requesting a change to room",param1.roomId);
         this.net.sendAction(new ChangeRoomActionRequest(param1));
         this.setLoading();
      }
      
      protected function roomLoaded(param1:NetworkManagerEvent) : void
      {
         this.setLoading();
         this.room = this.createRoom();
         this.room.buildFromMobject(param1.mobject);
         this.room.addEventListener(RoomEvent.CHANGE_ROOM,this.roomChanged);
         info("Loaded Room",this.room.id);
         this.dispatch(WorldEvent.ROOM_LOADED,this.room);
      }
      
      protected function disposeRoom() : void
      {
         if(this.room)
         {
            this.room.dispose();
         }
         this.room = null;
      }
      
      protected function init() : void
      {
         this.prepareEvents();
         this.loadRoomData();
      }
      
      protected function whenTheRoomChanges(param1:NetworkManagerEvent) : void
      {
         this.loadRoomData();
      }
      
      protected function loadRoomData() : void
      {
         this.setLoading();
         debug("Loading current room data");
         this.net.sendAction(new RoomDataRequest());
      }
      
      protected function createRoom() : com.qb9.mambo.world.core.Room
      {
         return new com.qb9.mambo.world.core.Room(this.user,this.net);
      }
      
      protected function roomChanged(param1:RoomEvent) : void
      {
         this.changeToRoom(param1.link);
      }
      
      protected function setLoading() : void
      {
         if(this.room)
         {
            this.dispatch(WorldEvent.LOADING);
         }
         this.disposeRoom();
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.ROOM_DATA,this.roomLoaded);
         this.net.removeEventListener(NetworkManagerEvent.CHANGE_ROOM,this.whenTheRoomChanges);
         this.disposeRoom();
         dispatchEvent(new GeneralEvent(GeneralEvent.DISPOSED));
         super.dispose();
      }
   }
}
