package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class IncompatibleBrowser extends ErrorOccurred
   {
       
      
      public function IncompatibleBrowser()
      {
         super();
      }
      
      override public function get codeError() : int
      {
         return 1015;
      }
      
      override public function get description() : String
      {
         return region.key("EL NAVEGADOR QUE ESTÁS UTILIZANDO NO ES COMPATIBLE");
      }
   }
}
