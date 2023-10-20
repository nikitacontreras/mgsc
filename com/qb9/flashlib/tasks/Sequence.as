package com.qb9.flashlib.tasks
{
   public class Sequence extends Queue
   {
       
      
      public function Sequence(... rest)
      {
         super(rest);
      }
      
      override public function clone() : ITask
      {
         return new Sequence(cloneSubtasks());
      }
      
      override protected function calculateConsumed(param1:uint, param2:uint) : uint
      {
         return param1 - param2;
      }
      
      override protected function startNext() : void
      {
         if(empty)
         {
            taskComplete();
         }
         else
         {
            super.startNext();
         }
      }
   }
}
