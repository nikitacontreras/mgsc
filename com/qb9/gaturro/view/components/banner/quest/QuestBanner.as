package com.qb9.gaturro.view.components.banner.quest
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.paginator.PaginatorFactory;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.quest.GaturroQuestController;
   import com.qb9.gaturro.view.components.repeater.NavegableRepeater;
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.implementation.quest.QuestItemRendererFactory;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.Sprite;
   
   public class QuestBanner extends InstantiableGuiModal implements IHasRoomAPI, IHasData
   {
      
      private static const ITEM_CONTAINER_NAME:String = "itemContainer";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var repeater:NavegableRepeater;
      
      private var news:IIterator;
      
      private var repeaterContainer:Sprite;
      
      private var questController:GaturroQuestController;
      
      private var questList:IIterator;
      
      private var actives:IIterator;
      
      private var itemContainer:Sprite;
      
      public function QuestBanner()
      {
         super("questBanner","questBannerAsset");
      }
      
      private function setupView() : void
      {
         this.repeaterContainer = view.getChildByName("repeaterContainer") as Sprite;
         this.itemContainer = this.repeaterContainer.getChildByName("itemContainer") as Sprite;
      }
      
      public function set data(param1:Object) : void
      {
         this.actives = param1.actives;
         this.news = param1.news;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function ready() : void
      {
         this.questController = Context.instance.getByType(GaturroQuestController) as GaturroQuestController;
         this.setupView();
         this.setupDataprovider();
         this.setupRepeater();
      }
      
      private function setupRepeater() : void
      {
         var _loc1_:NavegableRepeaterConfig = this.getRepeaterConfig();
         this.repeater = new NavegableRepeater(_loc1_);
         this.repeater.init();
      }
      
      private function getRepeaterConfig() : NavegableRepeaterConfig
      {
         var _loc1_:Sprite = this.repeaterContainer.getChildByName(ITEM_CONTAINER_NAME) as Sprite;
         var _loc2_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SMART_TYPE,this.questList.iterable,_loc1_,this.repeaterContainer,3);
         _loc2_.rows = 3;
         _loc2_.columns = 1;
         _loc2_.itemRendererFactory = new QuestItemRendererFactory(getDefinition("questItemRendererAsset") as Class,this);
         return _loc2_;
      }
      
      private function setupDataprovider() : void
      {
         this.questList = this.questController.getActiveList();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}
