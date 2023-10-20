package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.QuestEvent;
   import com.qb9.gaturro.quest.model.GaturroSystemQuestModel;
   
   public class QuestCompletedConstraint extends AbstractConstraint
   {
       
      
      private var questModel:GaturroSystemQuestModel;
      
      private var questCode:int;
      
      public function QuestCompletedConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroSystemQuestModel)
         {
            this.setupQuestModel();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
            changed();
         }
      }
      
      override public function dispose() : void
      {
         if(this.questModel)
         {
            this.questModel.removeEventListener(QuestEvent.COMPLETED,this.onQuestChanged);
         }
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         super.dispose();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = !!this.questModel ? this.questModel.isCompleted(this.questCode) : false;
         return doInvert(_loc2_);
      }
      
      private function setupQuestModel() : void
      {
         this.questModel = Context.instance.getByType(GaturroSystemQuestModel) as GaturroSystemQuestModel;
         if(!weak)
         {
            this.questModel.addEventListener(QuestEvent.COMPLETED,this.onQuestChanged);
         }
      }
      
      private function onQuestChanged(param1:QuestEvent) : void
      {
         if(param1.quest.code == this.questCode)
         {
            changed();
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.questCode = param1.questCode as int;
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(GaturroSystemQuestModel))
         {
            this.setupQuestModel();
         }
         else if(!weak)
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
   }
}
