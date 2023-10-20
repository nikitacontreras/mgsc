package com.qb9.gaturro.commons.preloading.factory
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.model.config.BaseClassAndSettingsConfig;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.commons.preloading.task.base.ILoadingTask;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTaskContainer;
   import flash.utils.getDefinitionByName;
   
   public class PreloadingTaskFactory implements IConfigHolder
   {
       
      
      private var _config:BaseClassAndSettingsConfig;
      
      public function PreloadingTaskFactory()
      {
         super();
      }
      
      private function buildRecursively(param1:TaskContainer, param2:Array, param3:Object) : void
      {
         var _loc4_:ILoadingTask = null;
         var _loc5_:Object = null;
         for each(_loc5_ in param2)
         {
            if((_loc4_ = this.instantiateTask(_loc5_.type)) is LoadingTaskContainer)
            {
               this.buildRecursively(_loc4_ as TaskContainer,_loc5_.list,param3);
            }
            else if(_loc5_.hasOwnProperty("data"))
            {
               _loc4_.data = _loc5_.data;
            }
            _loc4_.sharedRespository = param3;
            param1.add(_loc4_);
         }
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as BaseClassAndSettingsConfig;
      }
      
      public function build(param1:String) : ILoadingTask
      {
         var _loc2_:Object = this._config.getDefinition(param1);
         var _loc3_:Object = new Object();
         var _loc4_:ILoadingTask = this.instantiateTask(_loc2_.type);
         if(_loc2_.hasOwnProperty("data"))
         {
            _loc4_.data = _loc2_.data;
         }
         if(_loc2_.hasOwnProperty("list"))
         {
            this.buildRecursively(_loc4_ as TaskContainer,_loc2_.list,_loc3_);
         }
         _loc4_.sharedRespository = _loc3_;
         return _loc4_;
      }
      
      private function instantiateTask(param1:String) : ILoadingTask
      {
         var _loc2_:String = this._config.getClassDefinition(param1);
         var _loc3_:Class = getDefinitionByName(_loc2_) as Class;
         if(!_loc3_)
         {
            trace("Does not exist a subclass of Task for a type [" + param1 + "] and the definition = [" + _loc2_ + "].");
            return null;
         }
         return new _loc3_();
      }
   }
}

import flash.errors.IllegalOperationError;

class TaskManifest
{
    
   
   public function TaskManifest()
   {
      super();
      throw new IllegalOperationError("This class shouldn\'t be instantiated");
   }
   
   private function setup() : void
   {
   }
}
