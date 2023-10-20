package com.qb9.gaturro.world.zone
{
   import com.qb9.gaturro.globals.api;
   
   public class Timezone
   {
       
      
      public function Timezone()
      {
         super();
      }
      
      public function get seconds() : int
      {
         var _loc1_:Date = new Date(api.time);
         return _loc1_.getUTCSeconds();
      }
      
      public function get hours() : int
      {
         var _loc1_:Date = new Date(api.time);
         return _loc1_.getUTCHours();
      }
      
      public function get miliseconds() : int
      {
         var _loc1_:Date = new Date(api.time);
         return _loc1_.getUTCMilliseconds();
      }
      
      public function get isNight() : Boolean
      {
         var _loc1_:int = this.hours;
         return _loc1_ <= 6 || _loc1_ >= 20;
      }
      
      public function get minutes() : int
      {
         var _loc1_:Date = new Date(api.time);
         return _loc1_.getUTCMinutes();
      }
   }
}
