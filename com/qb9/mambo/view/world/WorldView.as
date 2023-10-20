package com.qb9.mambo.view.world
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.mambo.view.MamboView;
   import com.qb9.mambo.view.loading.BaseLoadingScreen;
   import com.qb9.mambo.view.world.events.RoomViewEvent;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.World;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import com.qb9.mambo.world.core.events.WorldEvent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class WorldView extends MamboView
   {
       
      
      protected var world:World;
      
      protected var room:DisplayObject;
      
      protected var loading:BaseLoadingScreen;
      
      public function WorldView(param1:World)
      {
         super();
         this.world = param1;
         this.init();
      }
      
      private function _dispose(param1:Event) : void
      {
         this.dispose();
      }
      
      protected function disposeRoom(param1:Event = null) : void
      {
         if(this.room)
         {
            if(this.room is IDisposable)
            {
               IDisposable(this.room).dispose();
            }
            removeChild(this.room);
         }
         this.room = null;
      }
      
      protected function createRoomView(param1:Room) : DisplayObject
      {
         return new RoomView(param1);
      }
      
      private function initEvents() : void
      {
         this.world.addEventListener(GeneralEvent.DISPOSED,this._dispose);
         this.world.addEventListener(WorldEvent.ROOM_LOADED,this.roomCreated);
         this.world.addEventListener(WorldEvent.LOADING,this.setLoading);
      }
      
      protected function whenRoomIsReady(param1:Event) : void
      {
         if(this.loading)
         {
            this.loading.hide();
         }
         this.loading = null;
         this.room.removeEventListener(RoomViewEvent.READY,this.whenRoomIsReady);
      }
      
      protected function createLoadingScreen() : BaseLoadingScreen
      {
         return new BaseLoadingScreen();
      }
      
      protected function roomCreated(param1:WorldEvent) : void
      {
         this.room = this.createRoomView(param1.room);
         this.room.addEventListener(RoomViewEvent.READY,this.whenRoomIsReady);
         addChildAt(this.room,0);
         param1.room.addEventListener(GeneralEvent.DISPOSED,this.disposeRoom);
      }
      
      private function init() : void
      {
         this.initEvents();
         this.setLoading();
      }
      
      protected function setLoading(param1:Event = null) : void
      {
         if(!this.loading)
         {
            this.loading = this.createLoadingScreen();
         }
         addChild(this.loading);
      }
      
      protected function disposeLoading(param1:Event = null) : void
      {
         if(!this.loading)
         {
            return;
         }
         this.loading.dispose();
         DisplayUtil.remove(this.loading);
         this.loading = null;
      }
      
      override public function dispose() : void
      {
         this.disposeLoading();
         this.disposeRoom();
         super.dispose();
      }
   }
}
