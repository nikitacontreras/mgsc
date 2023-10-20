package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class ConnectionLost extends ErrorOccurred
   {
       
      
      public function ConnectionLost()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1000;
      }
      
      override public function get description() : String
      {
         return region.key("connection_lost");
      }
   }
}
