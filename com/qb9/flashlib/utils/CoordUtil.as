package com.qb9.flashlib.utils
{
   import com.qb9.flashlib.math.QMath;
   
   public final class CoordUtil
   {
       
      
      public function CoordUtil()
      {
         super();
      }
      
      public static function angle(param1:Object, param2:Object) : Number
      {
         return QMath.rad2deg(radAngle(param1,param2));
      }
      
      public static function distance(param1:Object, param2:Object) : Number
      {
         return Math.sqrt(distance2(param1,param2));
      }
      
      public static function toASRot(param1:Number) : Number
      {
         return param1 * -1 + 270;
      }
      
      public static function fromASRot(param1:Number) : Number
      {
         return Math.abs(param1 - 270);
      }
      
      public static function distance2(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      public static function radAngle(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         return Math.atan2(-_loc4_,_loc3_);
      }
   }
}
