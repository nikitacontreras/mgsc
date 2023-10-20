package com.qb9.flashlib.tasks
{
   public class Wait extends TimeBasedTask
   {
       
      
      public function Wait(param1:int)
      {
         super(param1);
      }
      
      override public function clone() : ITask
      {
         return new Wait(duration);
      }
   }
}
