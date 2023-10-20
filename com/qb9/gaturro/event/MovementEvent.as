package com.qb9.gaturro.event
{
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.events.Event;
   
   public class MovementEvent extends Event
   {
      
      public static const FINISHED:String = "FINISHED";
       
      
      private var _movement:AbstractMovement;
      
      public function MovementEvent(param1:String, param2:AbstractMovement)
      {
         super(param1);
         this._movement = param2;
      }
      
      override public function toString() : String
      {
         return formatToString("MovementEvent","type","movement");
      }
      
      override public function clone() : Event
      {
         return new MovementEvent(type,this.movement);
      }
      
      public function get movement() : AbstractMovement
      {
         return this._movement;
      }
   }
}
