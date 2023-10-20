package com.qb9.gaturro.external.roomObjects
{
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.library.Libraries;
   
   public interface ICatalogInteractive
   {
       
      
      function get libraries() : Libraries;
      
      function get room() : GaturroRoom;
   }
}
