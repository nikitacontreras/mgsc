package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class ConnectionTimeout extends ErrorOccurred
   {
       
      
      public function ConnectionTimeout()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1002;
      }
      
      override public function get description() : String
      {
         return region.key("connection_timeout");
      }
   }
}
