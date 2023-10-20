package com.qb9.flashlib.tasks
{
   import flash.events.Event;
   
   public class QueueEvent extends Event
   {
      
      public static const EMPTY:String = "queueEmpty";
       
      
      public function QueueEvent(param1:String)
      {
         super(param1,false,true);
      }
   }
}
