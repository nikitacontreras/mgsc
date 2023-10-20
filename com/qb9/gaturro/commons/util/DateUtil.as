package com.qb9.gaturro.commons.util
{
   import com.qb9.gaturro.commons.date.DateFormator;
   
   public class DateUtil
   {
      
      public static const DAY_IN_MILLISECONDS:Number = 24 * 60 * 60 * 1000;
      
      public static const YEAR_IN_MILLISECONDS:Number = 365 * 24 * 60 * 60 * 1000;
      
      public static const SECONDS_IN_MILLISECONDS:int = 1000;
      
      public static const MONTH_IN_MILLISECONDS:Number = 30 * 24 * 60 * 60 * 1000;
      
      public static const HOUR_IN_MILLISECONDS:Number = 60 * 60 * 1000;
      
      public static const MINUTES_IN_MILLISECONDS:int = 60 * 1000;
       
      
      public function DateUtil()
      {
         super();
      }
      
      public static function getFormattedDate(param1:Date) : DateFormator
      {
         return getFormatorFromMilliseconds(param1.getTime());
      }
      
      public static function minutesToMiliseconds(param1:int) : Number
      {
         return param1 * 60 * 1000;
      }
      
      public static function getRelativeFormatordDate(param1:Date) : DateFormator
      {
         return new DateFormator(param1.fullYear,param1.month + 1,param1.date,param1.hours,param1.minutes,param1.seconds);
      }
      
      public static function getFormatorFromMilliseconds(param1:Number) : DateFormator
      {
         var _loc2_:int = param1 / YEAR_IN_MILLISECONDS;
         var _loc3_:Number = param1 % YEAR_IN_MILLISECONDS;
         var _loc4_:int = param1 / MONTH_IN_MILLISECONDS;
         _loc3_ = param1 % MONTH_IN_MILLISECONDS;
         var _loc5_:int = param1 / DAY_IN_MILLISECONDS;
         _loc3_ = param1 % DAY_IN_MILLISECONDS;
         var _loc6_:int = _loc3_ / HOUR_IN_MILLISECONDS;
         _loc3_ %= HOUR_IN_MILLISECONDS;
         var _loc7_:int = _loc3_ / MINUTES_IN_MILLISECONDS;
         _loc3_ %= MINUTES_IN_MILLISECONDS;
         var _loc8_:int = _loc3_ / SECONDS_IN_MILLISECONDS;
         return new DateFormator(_loc2_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      public static function milisecondsToMinutes(param1:Number) : int
      {
         return param1 / 60 / 1000;
      }
   }
}
