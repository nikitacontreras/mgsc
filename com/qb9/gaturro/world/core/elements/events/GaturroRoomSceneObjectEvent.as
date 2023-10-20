package com.qb9.gaturro.world.core.elements.events
{
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.events.Event;
   
   public final class GaturroRoomSceneObjectEvent extends Event
   {
      
      public static const LOOK_AT:String = "grsoveLookAt";
      
      public static const SHOWING:String = "grsoeShowing";
      
      public static const NOT_SHOWING:String = "grsoeNotShowing";
      
      public static const TRY_TO_GRAB:String = "grsoveTryToGrab";
       
      
      private var _object:RoomSceneObject;
      
      public function GaturroRoomSceneObjectEvent(param1:String, param2:RoomSceneObject = null)
      {
         super(param1,true);
         this._object = param2;
      }
      
      override public function clone() : Event
      {
         return new GaturroRoomSceneObjectEvent(type,this.object);
      }
      
      public function get object() : RoomSceneObject
      {
         return this._object || target as RoomSceneObject;
      }
   }
}
