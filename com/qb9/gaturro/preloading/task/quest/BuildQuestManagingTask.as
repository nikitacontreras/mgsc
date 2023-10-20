package com.qb9.gaturro.preloading.task.quest
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.commons.quest.model.SystemQuestModel;
   import com.qb9.gaturro.quest.GaturroQuestController;
   import com.qb9.gaturro.quest.GaturroQuestView;
   
   public class BuildQuestManagingTask extends LoadingTask
   {
       
      
      public function BuildQuestManagingTask()
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
         var _loc1_:SystemQuestModel = _sharedRespository.model;
         var _loc2_:GaturroQuestView = _sharedRespository.view;
         var _loc3_:GaturroQuestController = new GaturroQuestController(_loc1_,_loc2_);
         Context.instance.addByType(_loc3_,GaturroQuestController);
         _loc3_.init();
         _loc1_.init();
         _loc2_.controller = _loc3_;
      }
   }
}
