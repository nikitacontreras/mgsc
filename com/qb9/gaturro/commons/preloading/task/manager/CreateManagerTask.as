package com.qb9.gaturro.commons.preloading.task.manager
{
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class CreateManagerTask extends LoadingTask
   {
       
      
      private var managerClassName:String;
      
      public function CreateManagerTask()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         this.managerClassName = param1.managerClassName;
      }
      
      override public function start() : void
      {
         super.start();
         this.buildManager();
         taskComplete();
      }
      
      private function instantiate() : Object
      {
         var _loc1_:Class = getDefinitionByName(this.managerClassName) as Class;
         return new _loc1_();
      }
      
      private function buildManager() : void
      {
         var _loc1_:Object = this.instantiate();
         _sharedRespository.toContext = _loc1_;
      }
   }
}
