package com.qb9.gaturro.commons.quest.manager
{
   import com.qb9.gaturro.commons.event.QuestEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.commons.quest.model.SystemQuestModel;
   import com.qb9.gaturro.commons.quest.view.AbstractSystemQuestView;
   
   public class AbstractQuestController
   {
       
      
      protected var view:AbstractSystemQuestView;
      
      protected var model:SystemQuestModel;
      
      public function AbstractQuestController(param1:SystemQuestModel, param2:AbstractSystemQuestView)
      {
         super();
         this.view = param2;
         this.model = param1;
      }
      
      protected function onDeactivate(param1:QuestEvent) : void
      {
         this.view.deactivate(param1.quest);
      }
      
      public function getNewsList() : IIterator
      {
         return this.model.newsQuestList;
      }
      
      protected function grantReward(param1:QuestModel) : void
      {
      }
      
      private function setupModel() : void
      {
         this.model.addEventListener(QuestEvent.ACTIVATED,this.onActivate);
         this.model.addEventListener(QuestEvent.DEACTIVATED,this.onDeactivate);
         this.model.addEventListener(QuestEvent.COMPLETED,this.onComplete);
      }
      
      public function init() : void
      {
         this.setupModel();
      }
      
      protected function onComplete(param1:QuestEvent) : void
      {
         this.view.complete(param1.quest);
      }
      
      protected function onActivate(param1:QuestEvent) : void
      {
         this.view.activate(param1.quest);
      }
      
      public function getActiveList() : IIterator
      {
         return this.model.activeQuestList;
      }
   }
}
