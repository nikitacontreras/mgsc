package com.qb9.gaturro.preloading
{
   import com.qb9.gaturro.commons.preloading.PreloadingManifest;
   import com.qb9.gaturro.globals.logger;
   
   public class GaturroPreloadingManifest extends PreloadingManifest
   {
       
      
      public function GaturroPreloadingManifest()
      {
         super();
         logger.debug("Couldn\'t instatiate this class");
         throw new Error("Couldn\'t instatiate this class");
      }
      
      override protected function setupClasses() : void
      {
         trace(this,"> setupClasses");
      }
      
      override protected function setupTask() : void
      {
         trace(this,"> setupTask");
      }
   }
}
