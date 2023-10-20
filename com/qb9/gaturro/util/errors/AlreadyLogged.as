package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class AlreadyLogged extends ErrorOccurred
   {
       
      
      public function AlreadyLogged()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1013;
      }
      
      override public function get description() : String
      {
         return region.key("already_logged_error");
      }
   }
}
