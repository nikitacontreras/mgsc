package com.qb9.gaturro.manager.provider.strategy.impl
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.item.ItemConfig;
   import com.qb9.gaturro.commons.model.item.ItemDefinition;
   import com.qb9.gaturro.commons.probability.ProbabilityProcessor;
   import com.qb9.gaturro.manager.provider.strategy.AbstractProviderStrategy;
   import com.qb9.gaturro.model.config.provider.model.ProviderModel;
   import com.qb9.gaturro.model.config.provider.model.impl.SerenitoProviderItemModel;
   import com.qb9.gaturro.model.config.provider.model.impl.SerenitoProviderModel;
   
   public class SerenitoEmojisProviderStrategy extends AbstractProviderStrategy
   {
       
      
      private var hasNextPendingConsulting:Boolean;
      
      private var hasNextResult:Boolean;
      
      private var itemConfig:ItemConfig;
      
      private var hasNextConstriaintID:String = "serenitoHasNextIdConstraint";
      
      private var probability:ProbabilityProcessor;
      
      public function SerenitoEmojisProviderStrategy(param1:ProviderModel)
      {
         super(param1);
         this.setup();
         this.tryResetDailyFrequency();
      }
      
      private function resetProbability() : void
      {
         var _loc3_:SerenitoProviderItemModel = null;
         this.probability.reset();
         var _loc1_:IIterator = this.serenitoModel.iterator;
         var _loc2_:int = this.getExecess(_loc1_);
         while(_loc1_.next())
         {
            _loc3_ = _loc1_.current() as SerenitoProviderItemModel;
            if(_loc3_.remaining > 0)
            {
               this.probability.addPercentile(_loc3_.probability + _loc2_,_loc3_);
            }
         }
      }
      
      override public function getNext() : *
      {
         var _loc1_:String = null;
         var _loc2_:SerenitoProviderItemModel = null;
         var _loc3_:ItemDefinition = null;
         if(this.hasNextPendingConsulting)
         {
            this.hasNext();
         }
         if(this.hasNextResult)
         {
            _loc2_ = this.probability.raffle();
            _loc3_ = this.itemConfig.getDefinitionByCode(_loc2_.item);
            _loc1_ = _loc3_.path;
            this.serenitoModel.stampTime();
            this.serenitoModel.recordDelivery(_loc2_.id);
            if(_loc2_.remaining <= 0)
            {
               this.resetProbability();
            }
         }
         this.hasNextPendingConsulting = true;
         return _loc1_;
      }
      
      override public function hasNext() : Boolean
      {
         this.tryResetDailyFrequency();
         this.hasNextResult = evalConstraint(this.hasNextConstriaintID);
         this.hasNextPendingConsulting = false;
         return this.hasNextResult;
      }
      
      private function get serenitoModel() : SerenitoProviderModel
      {
         return model as SerenitoProviderModel;
      }
      
      private function tryResetDailyFrequency() : void
      {
         if(this.serenitoModel.reachedDailyFrequency())
         {
            this.serenitoModel.resetDailyCounting();
         }
      }
      
      private function setupItemConfig() : void
      {
         this.itemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
      }
      
      public function getDailyDelivery() : int
      {
         return this.serenitoModel.getDailyDelivery();
      }
      
      private function setupProbability() : void
      {
         var _loc2_:SerenitoProviderItemModel = null;
         this.probability = new ProbabilityProcessor();
         var _loc1_:IIterator = this.serenitoModel.iterator;
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current() as SerenitoProviderItemModel;
            this.probability.addPercentile(_loc2_.probability,_loc2_);
         }
      }
      
      private function setupConstraint() : void
      {
         var _loc1_:Object = this.serenitoModel.constraint;
         activeConstraint(_loc1_,this.hasNextConstriaintID);
      }
      
      override protected function setup() : void
      {
         super.setup();
         this.setupConstraint();
         this.setupProbability();
         this.setupItemConfig();
      }
      
      private function getExecess(param1:IIterator) : int
      {
         var _loc2_:SerenitoProviderItemModel = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(param1.next())
         {
            _loc2_ = param1.current() as SerenitoProviderItemModel;
            if(_loc2_.remaining <= 0)
            {
               _loc3_ += _loc2_.probability;
            }
            else
            {
               _loc4_++;
            }
         }
         param1.reset();
         return int(_loc3_ / _loc4_);
      }
   }
}
