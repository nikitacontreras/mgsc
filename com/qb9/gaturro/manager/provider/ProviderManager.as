package com.qb9.gaturro.manager.provider
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.provider.strategy.AbstractProviderStrategy;
   import com.qb9.gaturro.manager.provider.strategy.ProviderStrategyFactory;
   import flash.utils.Dictionary;
   
   public class ProviderManager
   {
       
      
      private var strategyList:Dictionary;
      
      private var _factory:ProviderStrategyFactory;
      
      public function ProviderManager()
      {
         super();
         this.strategyList = new Dictionary();
      }
      
      private function getStrategy(param1:String) : AbstractProviderStrategy
      {
         var _loc2_:AbstractProviderStrategy = this.strategyList[param1];
         if(!_loc2_)
         {
            _loc2_ = this._factory.build(param1);
            this.strategyList[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function set factory(param1:ProviderStrategyFactory) : void
      {
         this._factory = param1;
      }
      
      public function getNext(param1:String) : *
      {
         var _loc2_:AbstractProviderStrategy = this.getStrategy(param1);
         var _loc3_:* = _loc2_.getNext();
         api.trackEvent("PROVIDER:INTERACTION:" + param1,"getNext");
         return _loc3_;
      }
      
      public function hasMore(param1:String) : Boolean
      {
         var _loc2_:AbstractProviderStrategy = this.getStrategy(param1);
         var _loc3_:Boolean = _loc2_.hasNext();
         api.trackEvent("PROVIDER:INTERACTION:" + param1,"hasMore",_loc3_.toString());
         return _loc3_;
      }
   }
}
