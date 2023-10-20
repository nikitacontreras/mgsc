package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class ServerFull extends ErrorOccurred
   {
       
      
      public function ServerFull()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1014;
      }
      
      override public function get description() : String
      {
         return region.key("server_full_error");
      }
   }
}
