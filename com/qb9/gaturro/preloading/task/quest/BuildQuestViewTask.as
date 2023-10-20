package com.qb9.gaturro.preloading.task.quest
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.quest.GaturroQuestView;
   
   public class BuildQuestViewTask extends LoadingTask
   {
       
      
      public function BuildQuestViewTask()
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
         var _loc1_:GaturroQuestView = new GaturroQuestView();
         _sharedRespository.view = _loc1_;
         Context.instance.addByType(_loc1_,GaturroQuestView);
      }
   }
}
