package com.qb9.gaturro.commons.quest.factory
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.commons.quest.model.QuestConfig;
   import com.qb9.gaturro.commons.quest.model.QuestDefinition;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   
   public class QuestFactory implements IConfigHolder
   {
       
      
      private var _questConfig:QuestConfig;
      
      public function QuestFactory()
      {
         super();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._questConfig = param1 as QuestConfig;
      }
      
      protected function getInstance(param1:QuestDefinition) : QuestModel
      {
         return new QuestModel(param1);
      }
      
      public function build(param1:int) : QuestModel
      {
         var _loc2_:QuestDefinition = this._questConfig.getDefinition(param1);
         return this.getInstance(_loc2_);
      }
   }
}
