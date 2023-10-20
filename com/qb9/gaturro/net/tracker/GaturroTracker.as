package com.qb9.gaturro.net.tracker
{
   import com.qb9.gaturro.globals.logger;
   import flash.external.ExternalInterface;
   
   public class GaturroTracker
   {
       
      
      private var canLog:Boolean;
      
      public function GaturroTracker()
      {
         super();
         this.init();
      }
      
      protected function get trackEventFunction() : String
      {
         return "trackEvent";
      }
      
      protected function get name() : String
      {
         return "Google analytics tracker";
      }
      
      protected function get customVarFunction() : String
      {
         return "trackSetCustomVar";
      }
      
      public function page(... rest) : void
      {
         this.call(this.trackPageFunction,"/" + rest.join("/"));
      }
      
      private function init() : void
      {
         this.canLog = ExternalInterface.available;
         if(this.canLog)
         {
            logger.debug(this.name + " was initialized successfully");
         }
         else
         {
            logger.info("Failed to initialize " + this.name);
         }
      }
      
      public function custom(param1:int, param2:String, param3:String) : void
      {
         this.call(this.customVarFunction,param1,param2,param3,1);
      }
      
      protected function get trackPageFunction() : String
      {
         return "trackPageview";
      }
      
      protected function get trackerObject() : String
      {
         return "window.pageTracker";
      }
      
      public function event(param1:String, param2:String, param3:String = null, param4:Number = NaN) : void
      {
         this.call(this.trackEventFunction,param1,param2,param3,isNaN(param4) ? null : param4);
      }
      
      private function call(param1:String, ... rest) : void
      {
         if(!this.canLog)
         {
            return;
         }
         rest.unshift(this.trackerObject + "._" + param1);
         ExternalInterface.call.apply(ExternalInterface,rest);
      }
   }
}
