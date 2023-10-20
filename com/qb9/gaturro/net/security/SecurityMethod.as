package com.qb9.gaturro.net.security
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.security.Rijndael;
   
   public class SecurityMethod extends Rijndael
   {
       
      
      public function SecurityMethod()
      {
         super();
      }
      
      public function createValidationDigest(param1:String) : Object
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc2_.getTime();
         var _loc4_:* = this.prepare(user.username) + _loc3_.toString();
         while(_loc4_.length % 16 != 0)
         {
            _loc4_ += "0";
         }
         var _loc5_:String = this.encrypt(_loc4_,param1,"");
         var _loc6_:String = _loc4_.substr(user.username.length);
         return {
            "digestNum":_loc6_,
            "digestHash":_loc5_
         };
      }
      
      private function prepare(param1:String) : String
      {
         while(param1.indexOf("Ñ",0) >= 0)
         {
            param1 = param1.replace("Ñ","N");
         }
         return param1;
      }
   }
}
