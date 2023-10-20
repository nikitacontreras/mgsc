package com.qb9.gaturro.user.cellPhone
{
   import flash.events.Event;
   
   public class CellPhoneEvent extends Event
   {
      
      public static const TRIGGER_ALARM:String = "TRIGGER_ALARM";
       
      
      public function CellPhoneEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return formatToString("CellPhoneEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new CellPhoneEvent(type,bubbles,cancelable);
      }
   }
}
