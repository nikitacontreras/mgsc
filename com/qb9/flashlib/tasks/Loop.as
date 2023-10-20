package com.qb9.flashlib.tasks
{
   import com.qb9.flashlib.lang.assert;
   
   public class Loop extends Queue
   {
       
      
      private var backupTask:com.qb9.flashlib.tasks.ITask;
      
      public var remainingLoops:uint;
      
      public function Loop(param1:com.qb9.flashlib.tasks.ITask, param2:int = -1)
      {
         super();
         autoStartAddedTasks = true;
         this.backupTask = param1.clone();
         this.remainingLoops = param2;
      }
      
      override protected function startNext() : void
      {
         if(this.remainingLoops != 0)
         {
            if(empty)
            {
               add(this.backupTask.clone());
               super.startNext();
            }
            assert(subtasks.length <= 1);
         }
         else
         {
            this.taskComplete();
         }
      }
      
      override public function dispose() : void
      {
         this.backupTask.dispose();
         super.dispose();
      }
      
      override public function clone() : com.qb9.flashlib.tasks.ITask
      {
         return new Loop(this.backupTask,this.remainingLoops);
      }
      
      override protected function onSubTaskComplete(param1:TaskEvent) : void
      {
         if(this.remainingLoops > 0)
         {
            --this.remainingLoops;
         }
         super.onSubTaskComplete(param1);
      }
   }
}
