package com.qb9.mambo.world.avatars.events
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import flash.events.Event;
   
   public final class MovingRoomSceneObjectEvent extends Event
   {
      
      public static const STOPPED_MOVING:String = "wrsoeStoppedMoving";
      
      public static const WANTS_TO_MOVE:String = "wrsoeWantsToMove";
      
      public static const MOVE_STEP:String = "wrsoeMoveStep";
      
      public static const STARTED_MOVING:String = "wrsoeStartedMoving";
       
      
      private var _coord:Coord;
      
      public function MovingRoomSceneObjectEvent(param1:String, param2:Coord = null)
      {
         super(param1);
         this._coord = param2;
      }
      
      override public function clone() : Event
      {
         return new MovingRoomSceneObjectEvent(type,this.coord);
      }
      
      public function get coord() : Coord
      {
         return this._coord;
      }
      
      public function get object() : MovingRoomSceneObject
      {
         return target as MovingRoomSceneObject;
      }
   }
}
