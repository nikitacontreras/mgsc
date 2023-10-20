package com.qb9.gaturro.manager.passport
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.model.config.passport.BetterWithPassportConfig;
   import com.qb9.gaturro.model.config.passport.BetterWithPassportDefinition;
   
   public class BetterWithPassportManager implements IConfigHolder
   {
       
      
      private var _config:BetterWithPassportConfig;
      
      public function BetterWithPassportManager()
      {
         super();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as BetterWithPassportConfig;
      }
      
      public function openModal(param1:String) : void
      {
         var _loc2_:BetterWithPassportDefinition = this._config.getDefinitionByType(param1);
         api.instantiateBannerModal("BetterWithPassportBanner",null,null,_loc2_);
      }
      
      public function hasFeature(param1:String) : Boolean
      {
         var _loc2_:BetterWithPassportDefinition = this._config.getDefinitionByType(param1);
         return Boolean(_loc2_);
      }
      
      public function isAvailable(param1:String) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:BetterWithPassportDefinition = this._config.getDefinitionByType(param1);
         if(!api.user.isCitizen && Boolean(_loc2_))
         {
            return api.serverTime >= _loc2_.dateObject.getTime() ? true : false;
         }
         return true;
      }
   }
}
