package com.qb9.gaturro.whitelist
{
   public interface WhiteListVariableReplacer
   {
       
      
      function replaceForUser(param1:String) : String;
      
      function replaceFor(param1:Object, param2:String) : String;
   }
}
