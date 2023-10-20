package com.qb9.flashlib.easing
{
   import com.qb9.flashlib.math.QMath;
   
   public class Linear
   {
       
      
      public function Linear()
      {
         super();
      }
      
      public static function step(param1:Number, param2:int, param3:Number = 0, param4:Number = 1) : Number
      {
         return QMath.clamp(param1 + (param4 - param3) / param2,param3,param4);
      }
      
      public static function ease(param1:Number, param2:Number = 0, param3:Number = 1, param4:Number = 1) : Number
      {
         return param3 * param1 / param4 + param2;
      }
      
      public static function lerp(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 1) : Number
      {
         return ease(param1 - param2,param3,param5 - param3,param4 - param2);
      }
   }
}
