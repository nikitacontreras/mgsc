package com.qb9.gaturro.quest.factory
{
   import com.qb9.gaturro.commons.quest.factory.QuestFactory;
   import com.qb9.gaturro.commons.quest.model.QuestDefinition;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.quest.model.GaturroQuestModel;
   
   public class GaturroQuestFactory extends QuestFactory
   {
       
      
      public function GaturroQuestFactory()
      {
         super();
      }
      
      override protected function getInstance(param1:QuestDefinition) : QuestModel
      {
         return new GaturroQuestModel(param1);
      }
   }
}
