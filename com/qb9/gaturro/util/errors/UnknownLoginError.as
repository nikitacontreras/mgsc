package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class UnknownLoginError extends ErrorOccurred
   {
       
      
      public function UnknownLoginError()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1016;
      }
      
      override public function get description() : String
      {
         return region.key("unknown_login_error");
      }
   }
}
