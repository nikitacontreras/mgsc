package com.qb9.gaturro.world.gatucine.elements
{
   public class GatucineSerieSeason extends GatucineHeader
   {
       
      
      protected var dataEpisodes:Array;
      
      public function GatucineSerieSeason()
      {
         this.dataEpisodes = new Array();
         super();
      }
      
      public function get episodes() : Array
      {
         return this.dataEpisodes;
      }
      
      public function addEpisode(param1:GatucineEpisode) : void
      {
         this.dataEpisodes.push(param1);
      }
      
      public function destroyEpisodes() : void
      {
         this.dataEpisodes = new Array();
      }
   }
}
