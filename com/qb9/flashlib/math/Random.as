package com.qb9.flashlib.math
{
   public class Random
   {
       
      
      public function Random()
      {
         super();
      }
      
      public static function randrange(param1:Number, param2:Number) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      public static function randint(param1:int, param2:int) : int
      {
         return Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
      }
   }
}
