package com.qb9.gaturro.preloading.task.quest
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.commons.quest.model.QuestConfig;
   import com.qb9.gaturro.commons.quest.model.QuestDefinition;
   import com.qb9.gaturro.commons.quest.model.deserializer.QuestDefinitionDeserializer;
   
   public class BuildQuestConfigTask extends LoadingTask
   {
       
      
      private var config:QuestConfig;
      
      private var settings:Settings;
      
      private var deserializer:QuestDefinitionDeserializer;
      
      public function BuildQuestConfigTask()
      {
         super();
      }
      
      private function desereailize() : void
      {
         var _loc1_:Object = null;
         var _loc2_:QuestDefinition = null;
         var _loc3_:String = null;
         for(_loc3_ in this.settings.definition)
         {
            _loc1_ = this.settings.definition[_loc3_];
            _loc2_ = this.deserializer.deserialize(_loc1_);
            this.config.addDefinition(_loc2_);
         }
      }
      
      override public function start() : void
      {
         super.start();
         this.setup();
         this.desereailize();
         taskComplete();
      }
      
      private function setup() : void
      {
         this.config = new QuestConfig();
         _sharedRespository.config = this.config;
         this.settings = _sharedRespository.settings;
         this.deserializer = new QuestDefinitionDeserializer();
         this.config.setCleanDefinition(this.settings.clean);
      }
   }
}
