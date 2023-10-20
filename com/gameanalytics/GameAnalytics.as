package com.gameanalytics
{
   import com.gameanalytics.domain.GACore;
   import com.gameanalytics.utils.GADeviceUtil;
   import flash.display.LoaderInfo;
   import flash.events.EventDispatcher;
   
   public class GameAnalytics extends EventDispatcher
   {
      
      private static var core:GACore;
       
      
      public function GameAnalytics()
      {
         super();
      }
      
      public static function getUserId() : String
      {
         return core.getUserId();
      }
      
      public static function set DEBUG_MODE(param1:Boolean) : void
      {
         core.DEBUG_MODE = param1;
      }
      
      public static function getLogEvents(param1:Function) : void
      {
         core.addEventListener(GALogEvent.LOG,param1);
      }
      
      public static function get RUN_IN_EDITOR_MODE() : Boolean
      {
         return core.RUN_IN_EDITOR_MODE;
      }
      
      public static function getVersion() : String
      {
         return core.getVersion();
      }
      
      public static function isInitialized() : Boolean
      {
         return core.isInitialized();
      }
      
      public static function catchUnhandledExceptions(param1:LoaderInfo, param2:Boolean) : void
      {
         core.catchUnhandledExceptions(param1,param2);
      }
      
      public static function set RUN_IN_EDITOR_MODE(param1:Boolean) : void
      {
         core.RUN_IN_EDITOR_MODE = param1;
      }
      
      public static function newUserEvent(param1:String, param2:uint = 0, param3:uint = 0, param4:String = "", param5:String = "", param6:String = "", param7:String = "", param8:String = "", param9:String = "", param10:String = "", param11:String = "", param12:String = "") : void
      {
         core.newUserEvent(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
      }
      
      public static function init(param1:String, param2:String, param3:String, param4:String = null, param5:String = null) : void
      {
         core = new GACore(new GADeviceUtil());
         core.init(param1,param2,param3,param4,param5);
      }
      
      public static function get DEBUG_MODE() : Boolean
      {
         return core.DEBUG_MODE;
      }
      
      public static function sendData() : void
      {
         core.sendData();
      }
      
      public static function deleteAllEvents() : void
      {
         core.deleteAllEvents();
      }
      
      public static function newErrorEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN, param5:Number = NaN, param6:Number = NaN) : void
      {
         core.newErrorEvent(param1,param2,param3,param4,param5,param6);
      }
      
      public static function newBusinessEvent(param1:String, param2:uint, param3:String, param4:String = null, param5:Number = NaN, param6:Number = NaN, param7:Number = NaN) : void
      {
         core.newBusinessEvent(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function getSessionId() : String
      {
         return core.getSessionId();
      }
      
      public static function newDesignEvent(param1:String, param2:Number, param3:String = null, param4:Number = NaN, param5:Number = NaN, param6:Number = NaN) : void
      {
         core.newDesignEvent(param1,param2,param3,param4,param5,param6);
      }
      
      public function destroy() : void
      {
         core.destroy();
      }
   }
}
