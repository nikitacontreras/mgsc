package com.qb9.gaturro.commons.preloading
{
   import com.qb9.gaturro.globals.logger;
   
   public class PreloadingManifest
   {
       
      
      public function PreloadingManifest()
      {
         super();
         logger.debug("Couldn\'t instatiate this class");
         throw new Error("Couldn\'t instatiate this class");
      }
      
      protected function setupClasses() : void
      {
      }
      
      protected function setupTask() : void
      {
      }
   }
}
