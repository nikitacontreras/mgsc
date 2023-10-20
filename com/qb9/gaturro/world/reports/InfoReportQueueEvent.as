package com.qb9.gaturro.world.reports
{
   import flash.events.Event;
   
   public final class InfoReportQueueEvent extends Event
   {
      
      public static const HAS_ITEMS:String = "irqeHasItems";
       
      
      public function InfoReportQueueEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new InfoReportQueueEvent(type);
      }
   }
}
