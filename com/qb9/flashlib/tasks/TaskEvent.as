package com.qb9.flashlib.tasks
{
   import com.qb9.flashlib.events.QEvent;
   import flash.events.Event;
   
   public class TaskEvent extends QEvent
   {
      
      public static const UPDATE:String = "taskUpdate";
      
      public static const STARTED:String = "taskStarted";
      
      public static const COMPLETE:String = "taskComplete";
      
      public static const STOPPED:String = "taskStopped";
       
      
      public function TaskEvent(param1:String, param2:* = null)
      {
         super(param1,param2);
      }
      
      override public function clone() : Event
      {
         return new TaskEvent(type,data);
      }
   }
}
