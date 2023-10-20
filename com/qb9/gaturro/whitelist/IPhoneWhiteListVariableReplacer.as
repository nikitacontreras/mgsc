package com.qb9.gaturro.whitelist
{
   public final class IPhoneWhiteListVariableReplacer extends BaseWhiteListVariableReplacer implements WhiteListVariableReplacer
   {
       
      
      private var forUser:Boolean;
      
      public function IPhoneWhiteListVariableReplacer()
      {
         super({"username":this.userName});
      }
      
      private function userName() : String
      {
         return source as String;
      }
      
      public function replaceForUser(param1:String) : String
      {
         return replaceFor(EMPTY_VAR,param1);
      }
   }
}
