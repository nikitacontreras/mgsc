package com.qb9.gaturro.view.components.banner.quest
{
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   
   public class CompletionQuestBanner extends InstantiableGuiModal implements IHasRoomAPI, IHasData
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var questQuest:QuestModel;
      
      public function CompletionQuestBanner()
      {
         super("completionQuestBanner","completionQuestBannerAsset");
      }
      
      private function setupView() : void
      {
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this.questQuest = param1 as QuestModel;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
