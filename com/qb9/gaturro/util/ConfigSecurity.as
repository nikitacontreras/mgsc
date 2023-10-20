package com.qb9.gaturro.util
{
   import com.qb9.flashlib.security.SafeString;
   
   public class ConfigSecurity
   {
       
      
      public function ConfigSecurity()
      {
         super();
      }
      
      public static function createSafeString(param1:String) : SafeString
      {
         return new SafeString(param1.replace("~",""));
      }
      
      public static function safeStringMembers(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1)
         {
            if(param1 is Object)
            {
               for(_loc2_ in param1)
               {
                  if(param1[_loc2_] is String && checkMustSafe(param1[_loc2_]))
                  {
                     param1[_loc2_] = createSafeString(param1[_loc2_]);
                  }
                  else
                  {
                     safeStringMembers(param1[_loc2_]);
                  }
               }
            }
            else if(param1 is Array)
            {
               _loc3_ = param1 as Array;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(_loc3_[_loc4_] is String && checkMustSafe(String(_loc3_[_loc4_])))
                  {
                     _loc3_[_loc4_] = createSafeString(_loc3_[_loc4_]);
                  }
                  else
                  {
                     safeStringMembers(_loc3_[_loc4_]);
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      public static function checkMustSafe(param1:String) : Boolean
      {
         return param1.indexOf("~") == 0;
      }
   }
}
