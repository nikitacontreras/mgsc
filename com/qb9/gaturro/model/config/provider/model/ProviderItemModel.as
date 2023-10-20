package com.qb9.gaturro.model.config.provider.model
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.model.config.provider.definition.ProviderItemDefinition;
   
   public class ProviderItemModel
   {
      
      private static const COUNTER_ID_PREFIX:String = "providerCounter_";
       
      
      private var _deliveredCount:int;
      
      private var counterManager:GaturroCounterManager;
      
      private var _definition:ProviderItemDefinition;
      
      private var counterId:String;
      
      public function ProviderItemModel(param1:ProviderItemDefinition)
      {
         super();
         this._definition = param1;
         this.setupCounter();
      }
      
      public function recordDelivery(param1:int = 1) : void
      {
         this._deliveredCount += param1;
         this.counterManager.increase(this.counterId,param1);
      }
      
      public function get deliveredCount() : int
      {
         return this._deliveredCount;
      }
      
      public function get remaining() : int
      {
         return this._definition.amount - this.deliveredCount;
      }
      
      public function get definition() : ProviderItemDefinition
      {
         return this._definition;
      }
      
      public function get id() : *
      {
         return this._definition.id;
      }
      
      private function setupCounter() : void
      {
         this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         this.counterId = COUNTER_ID_PREFIX + this._definition.id;
         this.counterManager.start(this.counterId,this.counterId);
         this._deliveredCount = this.counterManager.getAmount(this.counterId);
      }
   }
}
