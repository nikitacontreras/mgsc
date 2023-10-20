package com.qb9.gaturro.commons.preloading.task.config
{
   import com.qb9.gaturro.commons.model.config.IConfigSettings;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class CreateConfigTask extends LoadingTask
   {
       
      
      private var configClassName:String;
      
      public function CreateConfigTask()
      {
         super();
      }
      
      private function buildConfig() : void
      {
         var _loc1_:IConfigSettings = this.instantiate();
         _loc1_.settings = _sharedRespository.settings;
         _sharedRespository.config = _loc1_;
      }
      
      override public function set data(param1:Object) : void
      {
         this.configClassName = param1.configClassName;
      }
      
      override public function start() : void
      {
         super.start();
         this.buildConfig();
         taskComplete();
      }
      
      private function instantiate() : IConfigSettings
      {
         var _loc1_:Class = getDefinitionByName(this.configClassName) as Class;
         return new _loc1_();
      }
   }
}
