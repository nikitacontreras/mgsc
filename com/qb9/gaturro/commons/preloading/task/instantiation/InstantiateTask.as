package com.qb9.gaturro.commons.preloading.task.instantiation
{
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class InstantiateTask extends LoadingTask
   {
       
      
      private var repositoryName:String;
      
      private var definition:String;
      
      public function InstantiateTask()
      {
         super();
      }
      
      private function doTask() : void
      {
         var _loc1_:Object = this.instantiate();
         _sharedRespository[this.repositoryName] = _loc1_;
      }
      
      private function instantiate() : Object
      {
         var _loc1_:Class = getDefinitionByName(this.definition) as Class;
         return new _loc1_();
      }
      
      override public function start() : void
      {
         super.start();
         this.doTask();
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.definition = param1.definition;
         this.repositoryName = param1.repositoryName;
      }
   }
}
