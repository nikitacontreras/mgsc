package com.qb9.gaturro.world.core.elements.events
{
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.events.Event;
   
   public final class HolderRoomSceneObjectEvent extends Event
   {
      
      public static const ENTERING:String = "ENTERING";
      
      public static const LEAVING:String = "LEAVING";
       
      
      private var _holder:HolderRoomSceneObject;
      
      private var _object:RoomSceneObject;
      
      public function HolderRoomSceneObjectEvent(param1:String, param2:HolderRoomSceneObject, param3:RoomSceneObject)
      {
         super(param1,true);
         this._object = param3;
         this._holder = param2;
      }
      
      public function get holder() : HolderRoomSceneObject
      {
         return this._holder;
      }
      
      override public function clone() : Event
      {
         return new HolderRoomSceneObjectEvent(type,this.holder,this.object);
      }
      
      public function get object() : RoomSceneObject
      {
         return this._object;
      }
   }
}
