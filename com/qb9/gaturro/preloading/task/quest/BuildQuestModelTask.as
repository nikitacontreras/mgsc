package com.qb9.gaturro.preloading.task.quest
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.commons.quest.factory.QuestFactory;
   import com.qb9.gaturro.commons.quest.model.QuestConfig;
   import com.qb9.gaturro.quest.model.GaturroSystemQuestModel;
   
   public class BuildQuestModelTask extends LoadingTask
   {
       
      
      public function BuildQuestModelTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.setup();
         taskComplete();
      }
      
      private function setup() : void
      {
         var _loc1_:QuestConfig = _sharedRespository.config as QuestConfig;
         var _loc2_:QuestFactory = _sharedRespository.factory as QuestFactory;
         var _loc3_:GaturroSystemQuestModel = new GaturroSystemQuestModel(_loc1_,_loc2_);
         Context.instance.addByType(_loc3_,GaturroSystemQuestModel);
         _sharedRespository.model = _loc3_;
      }
   }
}
