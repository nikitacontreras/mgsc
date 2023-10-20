package com.qb9.flashlib.logs
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.ArrayUtil;
   import flash.utils.getQualifiedClassName;
   
   public class Logger implements IDisposable
   {
      
      private static var loggers:Object;
      
      public static const LOG_LEVEL_INFO:int = 20;
      
      public static const LOG_LEVEL_WARNING:int = 30;
      
      public static const LOG_LEVEL_NONE:int = 0;
      
      public static const LOG_LEVEL_ERROR:int = 40;
      
      public static const LOG_LEVEL_DEBUG:int = 10;
       
      
      private var _name:String;
      
      protected var appenders:Array;
      
      protected var _logLevel:int;
      
      public function Logger(param1:int = 10, param2:String = "")
      {
         super();
         this._logLevel = param1;
         this.appenders = [];
         this._name = param2;
      }
      
      private static function getLoggerName(param1:Object) : String
      {
         return param1 is String ? String(param1.toString()) : getQualifiedClassName(param1);
      }
      
      public static function removeLogger(param1:Object) : Logger
      {
         var _loc2_:String = getLoggerName(param1);
         var _loc3_:Logger = loggers[_loc2_];
         if(_loc3_)
         {
            delete loggers[_loc2_];
         }
         return _loc3_;
      }
      
      public static function getLogger(param1:Object) : Logger
      {
         var _loc2_:String = getLoggerName(param1);
         loggers = loggers || {};
         loggers[_loc2_] = loggers[_loc2_] || new Logger(LOG_LEVEL_DEBUG,_loc2_);
         return loggers[_loc2_];
      }
      
      public static function removeAllLoggers() : void
      {
         var _loc1_:Logger = null;
         for each(_loc1_ in loggers)
         {
            _loc1_.dispose();
         }
         loggers = {};
      }
      
      protected function log(param1:int, param2:String, param3:Array) : void
      {
         var _loc4_:IAppender = null;
         if(this._logLevel > param1)
         {
            return;
         }
         param3.unshift(param2);
         for each(_loc4_ in this.appenders)
         {
            _loc4_.append(param3,param1);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:IAppender = null;
         for each(_loc1_ in this.appenders)
         {
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).dispose();
            }
         }
         this.appenders = null;
      }
      
      public function addAppender(param1:IAppender) : void
      {
         this.appenders.push(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function info(... rest) : void
      {
         this.log(LOG_LEVEL_INFO,"[INFO]",rest);
      }
      
      public function error(... rest) : void
      {
         this.log(LOG_LEVEL_ERROR,"[ERROR]",rest);
      }
      
      public function changeLogLevel(param1:int) : void
      {
         this._logLevel = param1;
      }
      
      public function removeAppender(param1:IAppender) : IAppender
      {
         return ArrayUtil.removeElement(this.appenders,param1) as IAppender;
      }
      
      public function getLogLevel() : int
      {
         return this._logLevel;
      }
      
      public function debug(... rest) : void
      {
         this.log(LOG_LEVEL_DEBUG,"[DEBUG]",rest);
      }
      
      public function warning(... rest) : void
      {
         this.log(LOG_LEVEL_WARNING,"[WARNING]",rest);
      }
      
      public function getAppender(param1:Class) : IAppender
      {
         var _loc2_:IAppender = null;
         for each(_loc2_ in this.appenders)
         {
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}
