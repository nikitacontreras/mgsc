package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class InvalidCredentials extends ErrorOccurred
   {
       
      
      public function InvalidCredentials()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1012;
      }
      
      override public function get description() : String
      {
         return region.key("invalid_credentials_error");
      }
   }
}
