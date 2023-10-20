package com.qb9.gaturro.model.config.provider.model.impl
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.model.config.provider.definition.ProviderDefinition;
   import com.qb9.gaturro.model.config.provider.model.ProviderModel;
   
   public class SerenitoProviderModel extends ProviderModel
   {
      
      private static const FREQUENCY_SERVICE_PERIODICITY_ID:String = "SerenitoEmojisFrquencyDeliveryTime";
      
      private static const FREQUENCY_SERVICE_DAILY_ID:String = "SerenitoEmojisFrquencyDailyTime";
      
      private static const COUNTER_ID:String = "serenitoEmojisDailyCounter";
       
      
      private var counterManager:GaturroCounterManager;
      
      public function SerenitoProviderModel(param1:ProviderDefinition)
      {
         super(param1);
         this.setup();
      }
      
      public function stampDailyTime() : void
      {
      }
      
      public function resetDailyCounting() : void
      {
         this.counterManager.reset(COUNTER_ID);
      }
      
      override public function recordDelivery(param1:*, param2:int = 1) : void
      {
         super.recordDelivery(param1,param2);
         this.counterManager.increase(COUNTER_ID);
      }
      
      public function get constraint() : Object
      {
         return definition.hasNextConstraint;
      }
      
      private function setupCounterManager() : void
      {
         this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         this.counterManager.start(COUNTER_ID,COUNTER_ID);
      }
      
      public function stampTime() : void
      {
      }
      
      public function reachedDailyFrequency() : Boolean
      {
         return false;
      }
      
      public function getDailyDelivery() : int
      {
         return this.counterManager.getAmount(COUNTER_ID);
      }
      
      private function setup() : void
      {
         this.setupCounterManager();
      }
   }
}
