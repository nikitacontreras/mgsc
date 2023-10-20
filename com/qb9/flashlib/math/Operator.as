package com.qb9.flashlib.math
{
   public class Operator
   {
       
      
      public function Operator()
      {
         super();
      }
      
      public static function add(param1:Number, param2:Number) : Number
      {
         return param1 + param2;
      }
      
      public static function multiply(param1:Number, param2:Number) : Number
      {
         return param1 * param2;
      }
      
      public static function notEqual(param1:Object, param2:Object) : Boolean
      {
         return param1 !== param2;
      }
      
      public static function lessThan(param1:Object, param2:Object) : Boolean
      {
         return param1 < param2;
      }
      
      public static function greaterThan(param1:Object, param2:Object) : Boolean
      {
         return param1 > param2;
      }
      
      public static function negate(param1:Number) : Number
      {
         return -param1;
      }
      
      public static function not(param1:Object) : Boolean
      {
         return !param1;
      }
      
      public static function subtract(param1:Number, param2:Number) : Number
      {
         return param1 - param2;
      }
      
      public static function divide(param1:Number, param2:Number) : Number
      {
         return param1 / param2;
      }
      
      public static function greaterEqual(param1:Object, param2:Object) : Boolean
      {
         return param1 >= param2;
      }
      
      public static function equal(param1:Object, param2:Object) : Boolean
      {
         return param1 === param2;
      }
      
      public static function lessEqual(param1:Object, param2:Object) : Boolean
      {
         return param1 <= param2;
      }
   }
}
