package com.qb9.gaturro.commons.preloading.task.setup
{
   import com.qb9.gaturro.commons.preloading.PreloadingManager;
   import com.qb9.gaturro.commons.preloading.task.*;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTaskQueue;
   import com.qb9.gaturro.commons.preloading.task.config.CreateConfigTask;
   import com.qb9.gaturro.commons.preloading.task.config.LoadConfigTask;
   import com.qb9.gaturro.commons.preloading.task.factory.BuildFactoryTask;
   
   public class SetupPreloadingTask extends LoadingTaskQueue
   {
       
      
      private var configPath:String;
      
      private var sharedRepository:Object;
      
      public function SetupPreloadingTask(param1:String)
      {
         super();
         this.configPath = param1;
         this.setup();
      }
      
      override public function start() : void
      {
         super.start();
      }
      
      override protected function taskComplete() : void
      {
         var _loc1_:PreloadingManager = this.sharedRepository.manager as PreloadingManager;
         _loc1_.start();
         super.taskComplete();
      }
      
      private function setup() : void
      {
         this.sharedRepository = new Object();
         var _loc1_:LoadConfigTask = new LoadConfigTask();
         _loc1_.data = {"path":this.configPath};
         _loc1_.sharedRespository = this.sharedRepository;
         add(_loc1_);
         var _loc2_:CreateConfigTask = new CreateConfigTask();
         _loc2_.data = {"configClassName":"com.qb9.gaturro.commons.model.config.BaseClassAndSettingsConfig"};
         _loc2_.sharedRespository = this.sharedRepository;
         add(_loc2_);
         var _loc3_:BuildFactoryTask = new BuildFactoryTask();
         _loc3_.data = {"factoryClassName":"com.qb9.gaturro.commons.preloading.factory.PreloadingTaskFactory"};
         _loc3_.sharedRespository = this.sharedRepository;
         add(_loc3_);
         var _loc4_:BuildPreloadingManagerTask;
         (_loc4_ = new BuildPreloadingManagerTask()).sharedRespository = this.sharedRepository;
         add(_loc4_);
      }
   }
}
