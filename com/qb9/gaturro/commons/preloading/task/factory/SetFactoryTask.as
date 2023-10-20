package com.qb9.gaturro.commons.preloading.task.factory
{
   import com.qb9.gaturro.commons.factory.IFactoryHolder;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.globals.logger;
   
   public class SetFactoryTask extends LoadingTask
   {
       
      
      private var sharedPropertyName:String;
      
      public function SetFactoryTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.setFactory();
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.sharedPropertyName = param1.factoryHolder.toString();
      }
      
      private function setFactory() : void
      {
         var _loc1_:IFactoryHolder = _sharedRespository[this.sharedPropertyName];
         if(!_loc1_)
         {
            logger.debug("The indicated factory holder doesn\'t exist within the shared object");
            throw new Error("The indicated factory holder doesn\'t exist within the shared object");
         }
         if(!_sharedRespository.factory)
         {
            logger.debug("The required factory doesn\'t exist within the shared object");
            throw new Error("The required factory doesn\'t exist within the shared object");
         }
         _loc1_.factory = _sharedRespository.factory;
      }
   }
}
