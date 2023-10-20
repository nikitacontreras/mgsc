package com.qb9.flashlib.tasks
{
   public class Parallel extends TaskContainer
   {
       
      
      public function Parallel(... rest)
      {
         super(true,rest);
      }
      
      protected function checkComplete() : void
      {
         if(this.subtasks.length == 0)
         {
            this.taskComplete();
         }
      }
      
      override public function clone() : ITask
      {
         return new Parallel(cloneSubtasks());
      }
      
      override public function start() : void
      {
         super.start();
         this.checkComplete();
      }
      
      override protected function onSubTaskComplete(param1:TaskEvent) : void
      {
         super.onSubTaskComplete(param1);
         this.checkComplete();
      }
   }
}
