package com.qb9.gaturro.view.components.repeater.item.implementation.quest
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.commons.date.DateFormator;
   import com.qb9.gaturro.commons.util.DateUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.quest.model.GaturroQuestModel;
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class QuestItemRenderer extends BaseItemRenderer
   {
       
      
      private var assetProvider:IAssetProvider;
      
      private var remainingText:TextField;
      
      private var iconContainer:Sprite;
      
      private var descriptionText:TextField;
      
      private var total:int;
      
      private var count:int;
      
      private var interactiveArea:SimpleButton;
      
      private var countText:TextField;
      
      private var quest:GaturroQuestModel;
      
      private var remainingTime:Number;
      
      private var titleText:TextField;
      
      private var gotoButton:SimpleButton;
      
      public function QuestItemRenderer(param1:Class, param2:IAssetProvider)
      {
         super(param1);
         this.assetProvider = param2;
      }
      
      private function setupItemAsButton() : void
      {
         this.interactiveArea = view.getChildByName("interactiveArea") as SimpleButton;
         var _loc1_:* = this.quest.initializationPopup != null;
         if(_loc1_)
         {
            this.interactiveArea.addEventListener(MouseEvent.CLICK,this.onClickItem);
         }
         else
         {
            this.interactiveArea.visible = false;
         }
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.quest = GaturroQuestModel(data);
         this.iconContainer = view.getChildByName("iconContainer") as Sprite;
         this.titleText = view.getChildByName("titleText") as TextField;
         this.descriptionText = view.getChildByName("descriptionText") as TextField;
         this.countText = view.getChildByName("countText") as TextField;
         this.remainingText = view.getChildByName("remainingText") as TextField;
         this.setupContent();
      }
      
      override public function refresh(param1:Object = null) : void
      {
         if(param1 != null)
         {
            this.setupContent();
         }
         super.refresh(param1);
      }
      
      private function setupIcon() : void
      {
         var _loc1_:Sprite = this.getIcon();
         this.iconContainer.addChild(_loc1_);
      }
      
      override public function dispose() : void
      {
         this.iconContainer = null;
         this.interactiveArea.removeEventListener(MouseEvent.CLICK,this.onClickItem);
         this.gotoButton.removeEventListener(MouseEvent.CLICK,this.onClickGo);
         super.dispose();
      }
      
      private function localizedText(param1:String) : String
      {
         return !!param1 ? String(region.getText(param1)) : param1;
      }
      
      private function setupTitle() : void
      {
         this.titleText.text = this.localizedText(this.quest.title);
      }
      
      private function onClickItem(param1:MouseEvent) : void
      {
         api.instantiateBannerModal(this.quest.initializationPopup.banner,null,"",this.quest);
      }
      
      private function setupGoButton() : void
      {
         this.gotoButton = view.getChildByName("gotoButton") as SimpleButton;
         var _loc1_:Boolean = Boolean(this.quest.goToRoomData) && Boolean(this.quest.goToRoomData.room);
         this.gotoButton.visible = _loc1_;
         if(_loc1_)
         {
            this.gotoButton.addEventListener(MouseEvent.CLICK,this.onClickGo);
         }
      }
      
      private function onClickGo(param1:MouseEvent) : void
      {
         if(this.quest.goToRoomData.room == -1)
         {
            api.room.visit(api.userAvatar.username);
         }
         else if(this.quest.goToRoomData.room > 0)
         {
            api.changeRoomXY(this.quest.goToRoomData.room,this.quest.goToRoomData.gotoX,this.quest.goToRoomData.gotoY);
         }
      }
      
      private function setupCount() : void
      {
         this.countText.visible = this.quest.counterDefinition.hasDefinition;
         if(this.quest.counterDefinition.hasDefinition)
         {
            this.countText.text = this.quest.counterCount + "/" + this.quest.counterAmount;
         }
      }
      
      private function getIcon() : Sprite
      {
         return this.assetProvider.getInstanceByName(this.quest.iconClassName) as Sprite;
      }
      
      private function setupContent() : void
      {
         this.setupTitle();
         this.setupDescription();
         this.setupIcon();
         this.setupGoButton();
         this.setupItemAsButton();
      }
      
      private function setupRemainingTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:DateFormator = null;
         this.remainingText.visible = this.quest.endDateDefinition.hasDefinition;
         if(this.quest.endDateDefinition.hasDefinition)
         {
            _loc1_ = Number(server.time);
            _loc2_ = this.quest.endDate.getTime() - _loc1_;
            _loc3_ = DateUtil.getFormatorFromMilliseconds(_loc2_);
            if(_loc2_ < 86400000)
            {
               this.remainingText.text = _loc3_.getFormatted(DateFormator.HOURS);
            }
            else
            {
               this.remainingText.text = _loc3_.getFormatted(DateFormator.DAYS);
            }
         }
      }
      
      private function setupDescription() : void
      {
         this.descriptionText.text = this.localizedText(this.quest.description);
      }
   }
}
