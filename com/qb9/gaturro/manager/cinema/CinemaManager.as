package com.qb9.gaturro.manager.cinema
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.model.config.cinema.CinemaConfig;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   
   public class CinemaManager implements IConfigHolder
   {
       
      
      private var _config:CinemaConfig;
      
      public function CinemaManager()
      {
         super();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as CinemaConfig;
      }
      
      public function getDefinition(param1:String) : CinemaMovieDefinition
      {
         return this._config.getDefinitionByGate(param1);
      }
      
      public function openCinema(param1:String, param2:Boolean = false) : void
      {
         logger.info("CinemaManager: openCinema > gate: " + param1);
         api.instantiateBannerModal("CinemaBanner",null,param1,param2);
      }
      
      public function isCountryAllowed(param1:String, param2:String) : Boolean
      {
         var _loc3_:CinemaMovieDefinition = this._config.getDefinitionByGate(param1);
         var _loc4_:String;
         return (Boolean(_loc4_ = String(_loc3_.countries[param2]))) && _loc4_.indexOf("-") < 0 || !_loc4_;
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this._config.hasDefinitionByGate(param1);
      }
   }
}
