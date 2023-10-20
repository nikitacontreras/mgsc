package com.qb9.gaturro.commons.preloading.task.context
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class CreatAndAddToContextTask extends LoadingTask
   {
       
      
      private var typeClassName:String;
      
      private var definitionClassName:String;
      
      public function CreatAndAddToContextTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.buildAndCreate();
         taskComplete();
      }
      
      private function buildAndCreate() : void
      {
         var _loc1_:Object = this.getInstance();
         _sharedRespository.instance = _loc1_;
         this.addToContext(_loc1_);
      }
      
      private function getInstance() : Object
      {
         var _loc1_:Class = getDefinitionByName(this.definitionClassName) as Class;
         return new _loc1_();
      }
      
      override public function set data(param1:Object) : void
      {
         this.definitionClassName = param1.definitionClassName;
         this.typeClassName = param1.typeClassName;
      }
      
      private function addToContext(param1:Object) : void
      {
         var _loc2_:String = !!this.typeClassName ? this.typeClassName : this.definitionClassName;
         var _loc3_:Class = getDefinitionByName(_loc2_) as Class;
         Context.instance.addByType(param1,_loc3_);
      }
   }
}
