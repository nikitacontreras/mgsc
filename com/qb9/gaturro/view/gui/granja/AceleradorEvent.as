package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import flash.events.Event;
   
   public class AceleradorEvent extends Event
   {
      
      public static const OPEN:String = "AceleradorEvent";
       
      
      private var _behavior:GranjaBehavior;
      
      public function AceleradorEvent(param1:String, param2:GranjaBehavior)
      {
         super(param1);
         this._behavior = param2;
      }
      
      public function get behavior() : GranjaBehavior
      {
         return this._behavior;
      }
      
      override public function clone() : Event
      {
         return new AceleradorEvent(type,this._behavior);
      }
   }
}
