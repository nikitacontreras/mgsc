package com.qb9.gaturro.commons.preloading.task.base
{
   import com.qb9.flashlib.tasks.ITask;
   
   public interface ILoadingTask extends ITask
   {
       
      
      function set sharedRespository(param1:Object) : void;
      
      function set data(param1:Object) : void;
   }
}
