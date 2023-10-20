package com.qb9.flashlib.utils
{
   public class ObjectUtil
   {
       
      
      public function ObjectUtil()
      {
         super();
      }
      
      public static function isObject(param1:Object) : Boolean
      {
         return param1 && typeof param1 == "object";
      }
      
      public static function values(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            var _loc7_:*;
            _loc2_[_loc7_ = _loc3_++] = _loc4_;
         }
         return _loc2_;
      }
      
      public static function isEmpty(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         for(_loc2_ in _loc4_)
         {
            return false;
         }
         return true;
      }
      
      public static function keys(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         for(_loc4_ in param1)
         {
            var _loc7_:*;
            _loc2_[_loc7_ = _loc3_++] = _loc4_;
         }
         return _loc2_;
      }
      
      public static function copy(param1:Object, param2:Object = null, param3:Boolean = false) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(!param2)
         {
            param2 = {};
         }
         for(_loc4_ in param1)
         {
            _loc5_ = param2[_loc4_];
            _loc6_ = param1[_loc4_];
            if(param3 && isObject(_loc5_) && isObject(_loc6_))
            {
               copy(_loc6_,_loc5_,true);
            }
            else
            {
               param2[_loc4_] = _loc6_;
            }
         }
         return param2;
      }
      
      public static function find(param1:Object, param2:Object) : String
      {
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            if(param1[_loc3_] === param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function contains(param1:Object, param2:Object) : Boolean
      {
         return find(param1,param2) !== null;
      }
   }
}
