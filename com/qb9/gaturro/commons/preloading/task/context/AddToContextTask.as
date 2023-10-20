package com.qb9.gaturro.commons.preloading.task.context
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class AddToContextTask extends LoadingTask
   {
       
      
      private var className:String;
      
      private var sharedInstance:String;
      
      public function AddToContextTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.addToContext();
         taskComplete();
      }
      
      private function addToContext() : void
      {
         var _loc1_:Object = (!!this.sharedInstance ? _sharedRespository[this.sharedInstance] : _sharedRespository.toContext) as Object;
         var _loc2_:Class = getDefinitionByName(this.className) as Class;
         if(!_loc2_)
         {
            throw new Error("The type is null");
         }
         if(!_loc1_)
         {
            throw new Error("The instance to store is null");
         }
         Context.instance.addByType(_loc1_,_loc2_);
      }
      
      override public function set data(param1:Object) : void
      {
         this.className = param1.className;
         this.sharedInstance = param1.sharedInstance;
      }
   }
}
