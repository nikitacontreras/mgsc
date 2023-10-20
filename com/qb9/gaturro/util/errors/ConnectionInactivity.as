package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class ConnectionInactivity extends ErrorOccurred
   {
       
      
      public function ConnectionInactivity()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1001;
      }
      
      override public function get description() : String
      {
         return region.key("connection_inactivity");
      }
   }
}
