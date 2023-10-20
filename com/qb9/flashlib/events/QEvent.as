package com.qb9.flashlib.events
{
   import flash.events.Event;
   
   public class QEvent extends Event
   {
       
      
      public var data;
      
      public function QEvent(param1:String, param2:* = null)
      {
         super(param1,false,true);
         this.data = param2 == null ? {} : param2;
      }
      
      override public function clone() : Event
      {
         return new QEvent(type,this.data);
      }
   }
}
