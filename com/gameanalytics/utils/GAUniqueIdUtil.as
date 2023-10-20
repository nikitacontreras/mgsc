package com.gameanalytics.utils
{
   public class GAUniqueIdUtil
   {
       
      
      public function GAUniqueIdUtil()
      {
         super();
      }
      
      public static function createUnuqueId() : String
      {
         var _loc2_:Number = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".length - 1;
         var _loc3_:* = "";
         var _loc4_:Number = 0;
         while(_loc4_ < 35)
         {
            if(_loc4_ == 8 || _loc4_ == 13 || _loc4_ == 18 || _loc4_ == 23)
            {
               _loc3_ += "-";
            }
            else
            {
               _loc3_ += "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".charAt(Math.floor(Math.random() * _loc2_));
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
