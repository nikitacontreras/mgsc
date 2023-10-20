package com.qb9.gaturro.manager.provider.strategy
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.manager.provider.strategy.impl.SerenitoEmojisProviderStrategy;
   import com.qb9.gaturro.model.config.provider.ProviderConfig;
   import com.qb9.gaturro.model.config.provider.definition.ProviderDefinition;
   import com.qb9.gaturro.model.config.provider.model.ProviderModel;
   import com.qb9.gaturro.model.config.provider.model.ProviderModelFactory;
   import flash.utils.Dictionary;
   
   public class ProviderStrategyFactory implements IConfigHolder
   {
       
      
      private var _modelFactory:ProviderModelFactory;
      
      private var _config:ProviderConfig;
      
      private var map:Dictionary;
      
      public function ProviderStrategyFactory()
      {
         super();
         this.setup();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as ProviderConfig;
      }
      
      private function getStrategy(param1:ProviderModel) : AbstractProviderStrategy
      {
         var _loc2_:String = param1.definition.strategy;
         var _loc3_:Class = this.map[_loc2_];
         return new _loc3_(param1);
      }
      
      public function build(param1:String) : AbstractProviderStrategy
      {
         var _loc2_:ProviderDefinition = this._config.getProviderDefinition(param1);
         var _loc3_:ProviderModel = this._modelFactory.build(_loc2_);
         return this.getStrategy(_loc3_);
      }
      
      public function set modelFactory(param1:ProviderModelFactory) : void
      {
         this._modelFactory = param1;
      }
      
      private function setup() : void
      {
         this.map = new Dictionary();
         this.map["SerenitoEmojisProviderStrategy"] = SerenitoEmojisProviderStrategy;
      }
   }
}
