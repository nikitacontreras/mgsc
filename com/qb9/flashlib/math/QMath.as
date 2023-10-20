package com.qb9.flashlib.math
{
   import com.qb9.flashlib.lang.fold;
   
   public class QMath
   {
       
      
      public function QMath()
      {
         super();
      }
      
      public static function deg2rad(param1:Number) : Number
      {
         return Math.PI * param1 / 180;
      }
      
      public static function rad2deg(param1:Number) : Number
      {
         return 180 * param1 / Math.PI;
      }
      
      public static function sum(param1:Array) : Number
      {
         return fold(param1,Operator.add,0) as Number;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 < param2 ? param2 : (param1 > param3 ? param3 : param1);
      }
      
      public static function clamprot(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param3 - param2;
         while(param1 < param2)
         {
            param1 += _loc4_;
         }
         while(param1 > param3)
         {
            param1 -= _loc4_;
         }
         return param1;
      }
      
      public static function sign(param1:Number) : int
      {
         return param1 > 0 ? 1 : (param1 < 0 ? -1 : 0);
      }
   }
}
