package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class ConnectionFailed extends ErrorOccurred
   {
       
      
      public function ConnectionFailed()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1003;
      }
      
      override public function get description() : String
      {
         return region.key("connection_failed");
      }
   }
}
