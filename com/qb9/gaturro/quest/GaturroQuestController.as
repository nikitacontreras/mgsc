package com.qb9.gaturro.quest
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.QuestEvent;
   import com.qb9.gaturro.commons.event.QuestSystemEvent;
   import com.qb9.gaturro.commons.quest.manager.AbstractQuestController;
   import com.qb9.gaturro.commons.quest.model.SystemQuestModel;
   import com.qb9.gaturro.commons.quest.view.AbstractSystemQuestView;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import flash.utils.setTimeout;
   
   public class GaturroQuestController extends AbstractQuestController
   {
       
      
      public function GaturroQuestController(param1:SystemQuestModel, param2:AbstractSystemQuestView)
      {
         super(param1,param2);
         this.setup();
      }
      
      override protected function onComplete(param1:QuestEvent) : void
      {
         super.onComplete(param1);
         var _loc2_:GaturroRoomAPI = Context.instance.getByType(GaturroRoomAPI) as GaturroRoomAPI;
         if(_loc2_)
         {
            setTimeout(_loc2_.textMessageToGUI,1200,"¡¡¡¡MISIÓN CUMPLIDA!!!!");
         }
      }
      
      private function onModelReady(param1:QuestSystemEvent) : void
      {
         if(!model.hasActiveQuests)
         {
            (view as GaturroQuestView).hideIcon();
         }
         else
         {
            (view as GaturroQuestView).showIcon();
         }
         model.removeEventListener(QuestSystemEvent.MODEL_READY,this.onModelReady);
      }
      
      private function setup() : void
      {
         model.addEventListener(QuestSystemEvent.MODEL_READY,this.onModelReady);
      }
   }
}
