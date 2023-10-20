package com.qb9.gaturro.quest.model
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.quest.model.QuestDefinition;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   
   public class GaturroQuestModel extends QuestModel
   {
       
      
      private var _counterDefinition:com.qb9.gaturro.quest.model.CounterQuestDefinition;
      
      private var counterManager:GaturroCounterManager;
      
      private var _endDateDefinition:com.qb9.gaturro.quest.model.EndDateQuestDefinition;
      
      public function GaturroQuestModel(param1:QuestDefinition)
      {
         super(param1);
         this.setup();
      }
      
      public function get counterKey() : String
      {
         return this._counterDefinition.hasDefinition ? this._counterDefinition.key : "";
      }
      
      private function setup() : void
      {
         this.setupEndDateModel();
         this.setupCounterModel();
         this.setupCounterManager();
      }
      
      public function get counterName() : String
      {
         return this._counterDefinition.hasDefinition ? this._counterDefinition.name : "";
      }
      
      public function get endDate() : Date
      {
         return this._endDateDefinition.date;
      }
      
      private function setupCounterModel() : void
      {
         var _loc1_:Object = this.getConstraintDef(definition.accomplishmentConstraint,"Counter");
         this._counterDefinition = new com.qb9.gaturro.quest.model.CounterQuestDefinition(_loc1_);
      }
      
      private function setupEndDateModel() : void
      {
         var _loc1_:Object = this.getConstraintDef(definition.activationConstraint,"EndDate");
         if(_loc1_)
         {
            this._endDateDefinition = new com.qb9.gaturro.quest.model.EndDateQuestDefinition(_loc1_);
         }
      }
      
      private function setupCounterManager() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onCounterManagerAdded);
         }
      }
      
      public function get counterDefinition() : com.qb9.gaturro.quest.model.CounterQuestDefinition
      {
         return this._counterDefinition;
      }
      
      private function getConstraintDef(param1:Object, param2:String) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(param1.type == param2)
         {
            return param1.data;
         }
         if(param1.hasOwnProperty("list"))
         {
            _loc4_ = param1.list;
            for each(_loc5_ in _loc4_)
            {
               _loc3_ = this.getConstraintDef(_loc5_,param2);
               if(_loc3_)
               {
                  return _loc3_;
               }
            }
            return null;
         }
         return null;
      }
      
      public function get counterAmount() : int
      {
         return this._counterDefinition.hasDefinition ? this._counterDefinition.amount : 0;
      }
      
      private function onCounterManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onCounterManagerAdded);
         }
      }
      
      public function get counterCount() : int
      {
         return this._counterDefinition.hasDefinition ? this.counterManager.getAmount(this._counterDefinition.name) : 0;
      }
      
      public function get endDateDefinition() : com.qb9.gaturro.quest.model.EndDateQuestDefinition
      {
         return this._endDateDefinition;
      }
   }
}
