package com.qb9.gaturro.commons.preloading.task.config
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.globals.logger;
   
   public class SetConfigTask extends LoadingTask
   {
       
      
      private var holderName:String;
      
      public function SetConfigTask()
      {
         super();
      }
      
      private function setConfig() : void
      {
         var _loc1_:IConfig = _sharedRespository.config;
         var _loc2_:IConfigHolder = _sharedRespository[this.holderName] as IConfigHolder;
         if(!_sharedRespository[this.holderName])
         {
            logger.debug("There is no instance with the name= " + this.holderName);
            throw new Error("There is no instance with the name= " + this.holderName);
         }
         if(!_loc2_)
         {
            logger.debug("The config holder if no IConfigHolder instance");
            throw new Error("The config holder if no IConfigHolder instance");
         }
         _loc2_.config = _loc1_;
      }
      
      override public function start() : void
      {
         super.start();
         this.setConfig();
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.holderName = param1.holder;
      }
   }
}
