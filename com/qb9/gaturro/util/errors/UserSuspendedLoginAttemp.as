package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class UserSuspendedLoginAttemp extends ErrorOccurred
   {
       
      
      public function UserSuspendedLoginAttemp()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1011;
      }
      
      override public function get description() : String
      {
         return region.key("user_suspended_error");
      }
   }
}
