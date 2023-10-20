package com.qb9.gaturro.commons.event
{
   import flash.events.Event;
   
   public class RepeaterEvent extends Event
   {
      
      public static const CREATION_COMPLETE:String = "creationComplete";
       
      
      public function RepeaterEvent(param1:String)
      {
         super(param1,true);
      }
      
      override public function toString() : String
      {
         return formatToString("RepeaterEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new RepeaterEvent(type);
      }
   }
}
