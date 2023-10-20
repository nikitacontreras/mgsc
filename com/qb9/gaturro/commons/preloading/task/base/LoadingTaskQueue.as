package com.qb9.gaturro.commons.preloading.task.base
{
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Queue;
   import com.qb9.flashlib.tasks.QueueEvent;
   
   public class LoadingTaskQueue extends Queue implements ILoadingTask
   {
       
      
      protected var _data:Object;
      
      protected var _sharedRespository:Object;
      
      public function LoadingTaskQueue()
      {
         super();
      }
      
      public function set sharedRespository(param1:Object) : void
      {
         this._sharedRespository = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      override protected function startNext() : void
      {
         if(currentTask)
         {
            if(!currentTask.running)
            {
               currentTask.start();
            }
         }
         else
         {
            dispatchEvent(new QueueEvent(QueueEvent.EMPTY));
            taskComplete();
         }
      }
      
      override public function update(param1:uint) : void
      {
      }
      
      override protected function updateSubtask(param1:ITask, param2:uint) : uint
      {
         return 0;
      }
   }
}
