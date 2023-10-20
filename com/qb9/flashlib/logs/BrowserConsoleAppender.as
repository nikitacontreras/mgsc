package com.qb9.flashlib.logs
{
   import flash.external.ExternalInterface;
   
   public class BrowserConsoleAppender implements IAppender
   {
       
      
      private var stringify:Boolean;
      
      public function BrowserConsoleAppender(param1:Boolean = false)
      {
         super();
         this.stringify = param1;
      }
      
      public static function get available() : Boolean
      {
         return ExternalInterface.available;
      }
      
      public function append(param1:Array, param2:int) : void
      {
         if(!available)
         {
            return;
         }
         if(this.stringify)
         {
            param1 = [param1.join(" ")];
         }
         else
         {
            param1 = param1.concat();
         }
         param1.unshift("console." + this.getMethodName(param2));
         ExternalInterface.call.apply(null,param1);
      }
      
      private function getMethodName(param1:int) : String
      {
         switch(param1)
         {
            case Logger.LOG_LEVEL_NONE:
            default:
               return "log";
            case Logger.LOG_LEVEL_INFO:
               return "info";
            case Logger.LOG_LEVEL_DEBUG:
               return "debug";
            case Logger.LOG_LEVEL_WARNING:
               return "warn";
            case Logger.LOG_LEVEL_ERROR:
               return "error";
         }
      }
   }
}
