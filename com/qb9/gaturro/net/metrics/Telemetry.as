package com.qb9.gaturro.net.metrics
{
   import com.gameanalytics.GameAnalytics;
   import com.qb9.gaturro.globals.logger;
   
   public class Telemetry
   {
      
      private static var instance:com.qb9.gaturro.net.metrics.Telemetry = null;
      
      public static const CUSTOM_DIMENSION_GENDER:int = 1;
      
      public static const CUSTOM_DIMENSION_PASSPORT:int = 2;
      
      public static const CUSTOM_DIMENSION_SERVER:int = 3;
      
      public static var log:Boolean = false;
       
      
      public function Telemetry()
      {
         super();
      }
      
      public static function getInstance() : com.qb9.gaturro.net.metrics.Telemetry
      {
         if(instance == null)
         {
            instance = new com.qb9.gaturro.net.metrics.Telemetry();
         }
         return instance;
      }
      
      public function init(param1:TelemetryConfig) : void
      {
         GameAnalytics.init(param1.GameAnalytics_secretKey,param1.GameAnalytics_gameKey,param1.AppVersion);
      }
      
      public function setCustomDimension(param1:int, param2:String) : void
      {
      }
      
      public function trackScreen(param1:String, param2:String = null) : void
      {
         if(!param2)
         {
            param2 = param1;
         }
         logger.debug("Tracking Screen: " + param1);
         GameAnalytics.newDesignEvent("Screen:" + param1,0);
         if(log)
         {
            logger.debug(this,"trackScreen " + param1);
         }
      }
      
      public function setUserId(param1:String) : void
      {
      }
      
      public function trackError(param1:String, param2:String) : void
      {
         if(log)
         {
            logger.debug(this,"trackError " + param2 + ", " + param1);
         }
         GameAnalytics.newErrorEvent(param2,param1);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = "", param4:int = 0) : void
      {
      }
   }
}
