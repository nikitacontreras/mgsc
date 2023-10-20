package com.qb9.gaturro.util
{
   public final class TimingUtil
   {
      
      private static const TIME_PER_CHAR:uint = 900;
       
      
      public function TimingUtil()
      {
         super();
      }
      
      public static function getReadDelay(param1:String) : uint
      {
         return Math.sqrt(param1.length) * TIME_PER_CHAR;
      }
   }
}
