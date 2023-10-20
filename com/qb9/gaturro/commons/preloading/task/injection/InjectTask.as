package com.qb9.gaturro.commons.preloading.task.injection
{
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.globals.logger;
   
   public class InjectTask extends LoadingTask
   {
       
      
      private var holder:String;
      
      private var property:String;
      
      private var content:String;
      
      public function InjectTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.doTask();
      }
      
      private function doTask() : void
      {
         if(!(this.holder in _sharedRespository))
         {
            logger.debug("There is no element within the shared repositpry called= " + this.holder);
            throw new Error("There is no element within the shared repositpry called= " + this.holder);
         }
         if(!(this.content in _sharedRespository))
         {
            logger.debug("There is no element within the shared repositpry called= " + this.content);
            throw new Error("There is no element within the shared repositpry called= " + this.content);
         }
         var _loc1_:Object = _sharedRespository[this.holder];
         var _loc2_:Object = _sharedRespository[this.content];
         if(!(this.property in _loc1_))
         {
            logger.debug("There si no property within the holder called= " + this.property);
            throw new Error("There si no property within the holder called= " + this.property);
         }
         _loc1_[this.property] = _loc2_;
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.holder = param1.holder;
         this.content = param1.content;
         this.property = param1.property;
      }
   }
}
