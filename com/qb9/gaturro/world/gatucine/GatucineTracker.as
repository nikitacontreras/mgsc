package com.qb9.gaturro.world.gatucine
{
   import com.qb9.gaturro.net.tracker.GaturroTracker;
   import com.qb9.gaturro.world.gatucine.elements.GatucineEpisode;
   import com.qb9.gaturro.world.gatucine.elements.GatucineMovie;
   
   public class GatucineTracker extends GaturroTracker
   {
       
      
      public function GatucineTracker()
      {
         super();
      }
      
      public function pagePlay(param1:Object) : void
      {
         var _loc2_:GatucineEpisode = null;
         var _loc3_:GatucineMovie = null;
         if(param1 is GatucineEpisode)
         {
            _loc2_ = GatucineEpisode(param1);
            this.page("/series/reproduccion/" + _loc2_.trackerId + "/" + _loc2_.title);
         }
         else if(param1 is GatucineMovie)
         {
            _loc3_ = GatucineMovie(param1);
            this.page("/cine/reproduccion/" + _loc3_.trackerId + "/" + _loc3_.title);
         }
      }
      
      public function pageSeriesHome() : void
      {
         this.page("/series/home");
      }
      
      public function eventUpgradeClick() : void
      {
         this.event("pop-up-upgrade","click");
      }
      
      override protected function get name() : String
      {
         return "Gatucine Google analytics tracker";
      }
      
      public function eventError() : void
      {
         this.event("player","error");
      }
      
      public function eventEpisodeScroll(param1:String) : void
      {
         this.event("series-" + param1,"scroll");
      }
      
      public function pageSeriesUpgrade() : void
      {
         this.page("/series/pop-up-upgrade-servicio");
      }
      
      override protected function get trackerObject() : String
      {
         return "window.gatucinePageTracker";
      }
      
      public function eventCinemaScroll(param1:String) : void
      {
         this.event("cine-" + param1,"scroll");
      }
      
      public function pageEnterSerie(param1:String) : void
      {
         this.page("/series/navegacion/" + param1);
      }
      
      public function pageCinemaUpgrade() : void
      {
         this.page("/cine/pop-up-upgrade-servicio");
      }
      
      public function pageCriteria(param1:String) : void
      {
         this.page("/cine/genero/" + param1);
      }
      
      public function eventSeriesScroll() : void
      {
         this.event("series","scroll");
      }
      
      public function pageCinemaHome() : void
      {
         this.page("/cine/home");
      }
   }
}
