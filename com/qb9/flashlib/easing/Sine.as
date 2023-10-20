package com.qb9.flashlib.easing
{
   internal class Sine
   {
       
      
      public function Sine()
      {
         super();
      }
      
      public static function easeOut(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return param3 * Math.sin(param1 / param4 * (Math.PI / 2)) + param2;
      }
      
      public static function easeIn(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return -param3 * Math.cos(param1 / param4 * (Math.PI / 2)) + param3 + param2;
      }
      
      public static function easeInOut(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return -param3 / 2 * (Math.cos(Math.PI * param1 / param4) - 1) + param2;
      }
   }
}
