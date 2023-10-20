package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class SessionExpiredError extends ErrorOccurred
   {
       
      
      public function SessionExpiredError()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1010;
      }
      
      override public function get description() : String
      {
         return region.key("session_expired_error");
      }
   }
}
