package com.qb9.gaturro.view.components.banner.quest
{
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class InitializationQuestBanner extends InstantiableGuiModal implements IHasRoomAPI, IHasData
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var questQuest:QuestModel;
      
      public function InitializationQuestBanner()
      {
         super("initializationQuestBanner","initializationQuestBannerAsset");
      }
      
      private function setupView() : void
      {
         var _loc1_:MovieClip = view.getChildByName("imageContainer") as MovieClip;
         var _loc2_:TextField = view.getChildByName("titleText") as TextField;
         var _loc3_:TextField = view.getChildByName("descriptionText") as TextField;
         _loc2_.text = this.questQuest.initializationPopup.title;
         _loc3_.text = this.questQuest.initializationPopup.description;
         this._roomAPI.libraries.fetch(this.questQuest.initializationPopup.image,this.onImageFetch,_loc1_);
         var _loc4_:MovieClip;
         (_loc4_ = view.getChildByName("toShowcaseBtn") as MovieClip).addEventListener(MouseEvent.CLICK,this.closeByEvent);
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function closeByEvent(param1:MouseEvent) : void
      {
         close();
      }
      
      private function onImageFetch(param1:DisplayObject, param2:Object) : void
      {
         param2.addChild(param1);
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
