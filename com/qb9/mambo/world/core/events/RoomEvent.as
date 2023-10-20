package com.qb9.mambo.world.core.events
{
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.events.Event;
   
   public final class RoomEvent extends Event
   {
      
      public static const SCENE_OBJECT_ADDED:String = "reSceneObjectAdded";
      
      public static const READY:String = "reRoomReady";
      
      public static const CHANGE_ROOM:String = "reChangeRoom";
      
      public static const SCENE_OBJECT_REMOVED:String = "reSceneObjectRemoved";
       
      
      private var _object:Object;
      
      public function RoomEvent(param1:String, param2:Object = null)
      {
         super(param1,false,true);
         this._object = param2;
      }
      
      public function get link() : RoomLink
      {
         return this._object as RoomLink;
      }
      
      public function get sceneObject() : RoomSceneObject
      {
         return this._object as RoomSceneObject;
      }
      
      override public function clone() : Event
      {
         return new RoomEvent(type,this.object);
      }
      
      public function get object() : Object
      {
         return this._object;
      }
   }
}
