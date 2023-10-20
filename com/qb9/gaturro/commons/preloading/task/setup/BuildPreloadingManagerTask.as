package com.qb9.gaturro.commons.preloading.task.setup
{
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.config.BaseClassAndSettingsConfig;
   import com.qb9.gaturro.commons.preloading.PreloadingManager;
   import com.qb9.gaturro.commons.preloading.factory.PreloadingTaskFactory;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   
   public class BuildPreloadingManagerTask extends LoadingTask
   {
       
      
      private var config:BaseClassAndSettingsConfig;
      
      private var factory:PreloadingTaskFactory;
      
      private var preloadManager:PreloadingManager;
      
      public function BuildPreloadingManagerTask()
      {
         super();
      }
      
      private function createPreloadigTasks() : void
      {
         var _loc2_:Object = null;
         var _loc3_:Task = null;
         var _loc1_:IIterator = this.config.getIterator();
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current() as Object;
            _loc3_ = this.factory.build(_loc2_.name) as Task;
            this.preloadManager.add(_loc3_);
         }
      }
      
      override public function start() : void
      {
         super.start();
         this.setup();
         this.createPreloadigTasks();
         taskComplete();
      }
      
      private function setup() : void
      {
         this.preloadManager = PreloadingManager.instance;
         this.factory = _sharedRespository.factory as PreloadingTaskFactory;
         this.config = _sharedRespository.config as BaseClassAndSettingsConfig;
         _sharedRespository.manager = this.preloadManager;
      }
   }
}
