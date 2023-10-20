package com.qb9.gaturro.util
{
   public class TimeSpan
   {
      
      public static const MILLISECONDS_IN_MINUTE:Number = 60000;
      
      public static const MILLISECONDS_IN_DAY:Number = 86400000;
      
      public static const MILLISECONDS_IN_SECOND:Number = 1000;
      
      public static const MILLISECONDS_IN_HOUR:Number = 3600000;
       
      
      private var _totalMilliseconds:Number;
      
      public function TimeSpan(param1:Number)
      {
         super();
         this._totalMilliseconds = Math.floor(param1);
      }
      
      public static function fromMinutes(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * MILLISECONDS_IN_MINUTE);
      }
      
      public static function fromHours(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * MILLISECONDS_IN_HOUR);
      }
      
      public static function fromDays(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * MILLISECONDS_IN_DAY);
      }
      
      public static function fromSeconds(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * MILLISECONDS_IN_SECOND);
      }
      
      public static function fromDates(param1:Date, param2:Date) : TimeSpan
      {
         return new TimeSpan(param2.time - param1.time);
      }
      
      public static function fromMilliseconds(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1);
      }
      
      public function add(param1:Date) : Date
      {
         var _loc2_:Date = new Date(param1.time);
         _loc2_.milliseconds += this.totalMilliseconds;
         return _loc2_;
      }
      
      public function get totalDays() : Number
      {
         return this._totalMilliseconds / MILLISECONDS_IN_DAY;
      }
      
      public function get minutes() : int
      {
         return int(this._totalMilliseconds / MILLISECONDS_IN_MINUTE) % 60;
      }
      
      public function get totalMinutes() : Number
      {
         return this._totalMilliseconds / MILLISECONDS_IN_MINUTE;
      }
      
      public function get totalHours() : Number
      {
         return this._totalMilliseconds / MILLISECONDS_IN_HOUR;
      }
      
      public function get hours() : int
      {
         return int(this._totalMilliseconds / MILLISECONDS_IN_HOUR) % 24;
      }
      
      public function get milliseconds() : int
      {
         return int(this._totalMilliseconds) % 1000;
      }
      
      public function get totalMilliseconds() : Number
      {
         return this._totalMilliseconds;
      }
      
      public function get days() : int
      {
         return int(this._totalMilliseconds / MILLISECONDS_IN_DAY);
      }
      
      public function get totalSeconds() : Number
      {
         return this._totalMilliseconds / MILLISECONDS_IN_SECOND;
      }
      
      public function get seconds() : int
      {
         return int(this._totalMilliseconds / MILLISECONDS_IN_SECOND) % 60;
      }
   }
}
