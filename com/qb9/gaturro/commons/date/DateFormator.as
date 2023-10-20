package com.qb9.gaturro.commons.date
{
   import flash.utils.Dictionary;
   
   public class DateFormator
   {
      
      public static const FORMAT_YY_MM_DD_HH_MM:String = "YY:MM:DD:HH:mm";
      
      public static const MINUTES:String = "mm";
      
      public static const HOURS:String = "HH";
      
      public static const FORMAT_DD_HH_MM:String = "DD:HH:mm";
      
      public static const FORMAT_DD_MM_YY:String = "DD:MM:YY";
      
      public static const FORMAT_YY_MM_DD:String = "YY:MM:DD";
      
      public static const MONTHS:String = "MM";
      
      public static const YEARS:String = "YY";
      
      public static const SECONDS:String = "SS";
      
      public static const DAYS:String = "DD";
       
      
      private var _seconds:Number;
      
      private var dateMap:Dictionary;
      
      private var _hours:int;
      
      private var _months:int;
      
      private var _years:int;
      
      private var _minutes:Number;
      
      private var namesMap:Dictionary;
      
      private var _days:int;
      
      private var separatorMap:Dictionary;
      
      public function DateFormator(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:Number)
      {
         super();
         this._months = param2;
         this._years = param1;
         this._seconds = param6;
         this._minutes = param5;
         this._hours = param4;
         this._days = param3;
         this.setup();
      }
      
      public function getFormatted(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:Array = param1.split(":");
         var _loc3_:* = "";
         for each(_loc4_ in _loc2_)
         {
            if(this.dateMap[_loc4_])
            {
               _loc3_ = _loc3_ + this.dateMap[_loc4_] + " " + this.namesMap[_loc4_] + " ";
            }
         }
         return _loc3_;
      }
      
      private function setupNames() : void
      {
         this.namesMap = new Dictionary();
         this.namesMap[YEARS] = "Años";
         this.namesMap[MONTHS] = "Meses";
         this.namesMap[DAYS] = "Días";
         this.namesMap[HOURS] = "Horas";
         this.namesMap[MINUTES] = "Minutos";
         this.namesMap[SECONDS] = "Segundos";
      }
      
      public function get hours() : int
      {
         return this._hours;
      }
      
      private function setupTimeMap() : void
      {
         this.dateMap = new Dictionary();
         this.dateMap[YEARS] = this._years;
         this.dateMap[MONTHS] = this._months;
         this.dateMap[DAYS] = this._days;
         this.dateMap[HOURS] = this._hours;
         this.dateMap[MINUTES] = this._minutes;
         this.dateMap[SECONDS] = this._seconds;
      }
      
      public function getFormattedByBars(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc2_:Array = param1.split(":");
         var _loc3_:String = "";
         var _loc4_:int = 0;
         for each(_loc5_ in _loc2_)
         {
            _loc4_++;
            if(this.dateMap[_loc5_])
            {
               _loc3_ = _loc4_ < _loc2_.length ? _loc3_ + this.dateMap[_loc5_] + this.separatorMap[_loc5_] : _loc3_ + this.dateMap[_loc5_];
            }
         }
         return _loc3_;
      }
      
      public function get days() : int
      {
         return this._days;
      }
      
      public function get minutes() : Number
      {
         return this._minutes;
      }
      
      public function get years() : int
      {
         return this._years;
      }
      
      private function setupSeparator() : void
      {
         this.separatorMap = new Dictionary();
         this.separatorMap[YEARS] = "/";
         this.separatorMap[MONTHS] = "/";
         this.separatorMap[DAYS] = " ";
         this.separatorMap[HOURS] = ":";
         this.separatorMap[MINUTES] = ":";
         this.separatorMap[SECONDS] = "";
      }
      
      public function get months() : int
      {
         return this._months;
      }
      
      private function setup() : void
      {
         this.setupTimeMap();
         this.setupNames();
         this.setupSeparator();
      }
      
      public function get seconds() : Number
      {
         return this._seconds;
      }
   }
}
