package com.qb9.gaturro.commons.preloading
{
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTaskQueue;
   import com.qb9.gaturro.globals.logger;
   import flash.errors.IllegalOperationError;
   
   public class PreloadingManager extends LoadingTaskQueue
   {
      
      private static var _instance:com.qb9.gaturro.commons.preloading.PreloadingManager;
       
      
      public function PreloadingManager()
      {
         super();
         if(_instance)
         {
            throw new IllegalOperationError("This is a Singleton instance. You Shouldn\'t instatiate by your own. Use \'instance\' static property.");
         }
         _instance = this;
      }
      
      public static function get instance() : com.qb9.gaturro.commons.preloading.PreloadingManager
      {
         if(_instance)
         {
         }
         return _instance;
      }
      
      final override public function update(param1:uint) : void
      {
      }
      
      override public function start() : void
      {
         logger.debug(this + " > start > STARTED");
         super.start();
      }
      
      override protected function startNext() : void
      {
         if(currentTask)
         {
            logger.debug(this + " > startNext > STARTED task = ",currentTask);
         }
         super.startNext();
      }
      
      final override protected function updateSubtasks(param1:uint) : uint
      {
         return 0;
      }
      
      final override protected function updateSubtask(param1:ITask, param2:uint) : uint
      {
         return 0;
      }
      
      override protected function taskComplete() : void
      {
         super.taskComplete();
         logger.debug(this + " > taskComplete > COMPLETED");
      }
   }
}
