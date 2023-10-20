package com.qb9.gaturro.commons.preloading.task.factory
{
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class BuildFactoryTask extends LoadingTask
   {
       
      
      private var factoryClassName:String;
      
      public function BuildFactoryTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.buildFactory();
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.factoryClassName = param1.factoryClassName;
      }
      
      private function instantiate() : Object
      {
         var _loc1_:Class = getDefinitionByName(this.factoryClassName) as Class;
         return new _loc1_();
      }
      
      private function buildFactory() : void
      {
         var _loc1_:Object = this.instantiate();
         if(_loc1_ is IConfigHolder)
         {
            _loc1_.config = _sharedRespository.config;
         }
         _sharedRespository.factory = _loc1_;
      }
   }
}
