package com.qb9.gaturro.commons.preloading.task.base
{
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Task;
   
   public class LoadingTask extends Task implements ILoadingTask
   {
       
      
      protected var _data:Object;
      
      protected var _sharedRespository:Object;
      
      public function LoadingTask()
      {
         super();
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      final override public function update(param1:uint) : void
      {
      }
      
      public function set sharedRespository(param1:Object) : void
      {
         this._sharedRespository = param1;
      }
      
      final override protected function updateSubtask(param1:ITask, param2:uint) : uint
      {
         return 0;
      }
   }
}
