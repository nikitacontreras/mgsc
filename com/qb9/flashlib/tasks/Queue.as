package com.qb9.flashlib.tasks
{
   public class Queue extends TaskContainer
   {
       
      
      public function Queue(... rest)
      {
         super(false,rest);
      }
      
      override public function add(param1:ITask) : void
      {
         super.add(param1);
         if(running && subtasks.length == 1)
         {
            this.startNext();
         }
      }
      
      override public function remove(param1:ITask) : void
      {
         var _loc2_:* = param1 === this.currentTask;
         super.remove(param1);
         if(running && _loc2_)
         {
            this.startNext();
         }
      }
      
      override public function start() : void
      {
         if(running)
         {
            return;
         }
         super.start();
         this.startNext();
      }
      
      protected function calculateConsumed(param1:uint, param2:uint) : uint
      {
         return param1;
      }
      
      override public function stop() : void
      {
         if(!running)
         {
            return;
         }
         super.stop();
         if(!empty && this.currentTask.running)
         {
            this.currentTask.stop();
         }
      }
      
      protected function startNext() : void
      {
         if(this.currentTask)
         {
            if(!this.currentTask.running)
            {
               this.currentTask.start();
            }
         }
         else
         {
            dispatchEvent(new QueueEvent(QueueEvent.EMPTY));
         }
      }
      
      override protected function updateSubtasks(param1:uint) : uint
      {
         var _loc2_:ITask = null;
         var _loc3_:int = int(param1);
         while(_loc3_ > 0 && !empty)
         {
            _loc2_ = this.currentTask;
            _loc3_ -= updateSubtask(_loc2_,_loc3_);
            if(_loc2_ == this.currentTask)
            {
               break;
            }
         }
         return this.calculateConsumed(param1,Math.max(_loc3_,0));
      }
      
      override public function clone() : ITask
      {
         return new Queue(cloneSubtasks());
      }
      
      protected function get currentTask() : ITask
      {
         return subtasks[0] as ITask;
      }
   }
}
