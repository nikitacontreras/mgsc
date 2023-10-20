package com.qb9.flashlib.easing
{
   internal class Quint
   {
       
      
      public function Quint()
      {
         super();
      }
      
      public static function easeOut(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return param3 * ((param1 = param1 / param4 - 1) * param1 * param1 * param1 * param1 + 1) + param2;
      }
      
      public static function easeIn(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 * param1 * param1 * param1 + param2;
      }
      
      public static function easeInOut(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         if((param1 = param1 / (param4 / 2)) < 1)
         {
            return param3 / 2 * param1 * param1 * param1 * param1 * param1 + param2;
         }
         return param3 / 2 * ((param1 = param1 - 2) * param1 * param1 * param1 * param1 + 2) + param2;
      }
   }
}
