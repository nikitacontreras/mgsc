package com.qb9.flashlib.logs
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   import flash.utils.getTimer;
   
   public class FloggerAppender implements IAppender, IDisposable
   {
      
      private static const ERROR_STATUS:String = "error";
      
      private static const ERROR_TIMEOUT:uint = 5000;
       
      
      private var connectionName:String;
      
      private var errorStamp:int;
      
      private var connection:LocalConnection;
      
      public function FloggerAppender(param1:String = "_flash_logger")
      {
         this.errorStamp = -ERROR_TIMEOUT;
         super();
         this.connectionName = param1;
         this.init();
      }
      
      private function checkStatus(param1:StatusEvent) : void
      {
         if(param1.level === ERROR_STATUS)
         {
            this.failed();
         }
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
               return "warning";
            case Logger.LOG_LEVEL_ERROR:
               return "error";
         }
      }
      
      private function init() : void
      {
         this.connection = new LocalConnection();
         this.connection.allowDomain("*");
         this.connection.allowInsecureDomain("*");
         this.connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.ignore);
         this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.ignore);
         this.connection.addEventListener(StatusEvent.STATUS,this.checkStatus);
      }
      
      private function ignore(param1:Event) : void
      {
      }
      
      public function append(param1:Array, param2:int) : void
      {
         var msg:Array = param1;
         var level:int = param2;
         if(getTimer() - this.errorStamp < ERROR_TIMEOUT)
         {
            return;
         }
         try
         {
            this.connection.send(this.connectionName,this.getMethodName(level),msg.join(" "));
         }
         catch(err:Error)
         {
            failed();
         }
      }
      
      private function failed() : void
      {
         this.errorStamp = getTimer();
      }
      
      public function dispose() : void
      {
         this.connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.ignore);
         this.connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.ignore);
         this.connection.removeEventListener(StatusEvent.STATUS,this.checkStatus);
         this.connection = null;
      }
   }
}
