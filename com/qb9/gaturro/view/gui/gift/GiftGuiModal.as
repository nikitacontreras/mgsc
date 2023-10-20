package com.qb9.gaturro.view.gui.gift
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.objects.GiveObjectActionRequest;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModal;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.collection.CatalogList;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mines.mobject.Mobject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public final class GiftGuiModal extends BaseItemListGuiModal
   {
       
      
      private var done:Boolean = false;
      
      private var CATALOG_NAME:String = "gifts";
      
      private var lastPrice:Number;
      
      private var receiver:String;
      
      public function GiftGuiModal(param1:TaskContainer, param2:NetworkManager, param3:String)
      {
         super(param1,param2);
         this.isChristmas = api.getSession("giftChristmas") == "y";
         this.receiver = param3;
         this.getGiftList();
      }
      
      private function clickOnClose(param1:MouseEvent) : void
      {
         close();
      }
      
      private function getGiftList() : void
      {
         if(api.getSession("giftChristmas") == "y")
         {
            this.CATALOG_NAME = "navidad2017_decoracion_blue";
         }
         var _loc1_:CatalogList = new CatalogList(net);
         _loc1_.fetch(this.CATALOG_NAME,this.onGiftList);
      }
      
      private function notEnoughMoney() : void
      {
         this.asset.gotoAndStop("error");
         this.asset.cancel.visible = true;
         this.asset.cancel.addEventListener(MouseEvent.CLICK,this.clickOnClose);
      }
      
      private function onGiftList(param1:Catalog, param2:Object = null) : void
      {
         this.items = param1.items;
         init();
      }
      
      override protected function createItem(param1:int) : BaseItemListItemView
      {
         return this.createItemView(items[param1]);
      }
      
      private function giveResponse(param1:NetworkManagerEvent) : void
      {
         var _loc4_:String = null;
         if(net)
         {
            net.removeEventListener(GaturroNetResponses.GIVE_OBJECT,this.giveResponse);
         }
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Boolean = Boolean(_loc2_.getFloat("success"));
         if(_loc3_)
         {
            user.attributes.coins -= this.lastPrice;
         }
         if(api.getSession("giftChristmas") == "y" && !this.done)
         {
            if((_loc4_ = String(api.getProfileAttribute("giftPoints"))) == null || _loc4_ == "" || _loc4_ == "null")
            {
               _loc4_ = "0";
            }
            if(_loc4_.indexOf("_") >= 1)
            {
               _loc4_ = String(_loc4_.split("_")[0]);
            }
            _loc4_ = (int(_loc4_) + 1).toString();
            api.setProfileAttribute("giftPoints",_loc4_ + "_X");
         }
         this.done = true;
      }
      
      override protected function createItemView(param1:Object) : BaseItemListItemView
      {
         return new GiftGuiModalItemView(param1);
      }
      
      override protected function createConfirmation() : BaseItemListGuiModalConfirmation
      {
         return new GiftGuiModalConfirmation(this.receiver,isChristmas);
      }
      
      override protected function action(param1:BaseItemListItemView) : void
      {
         var _loc2_:Number = Number(user.attributes.coins);
         if(_loc2_ < param1.itemPrice)
         {
            this.notEnoughMoney();
            return;
         }
         var _loc3_:MovieClip = MovieClip(param1.asset);
         var _loc4_:Boolean = "blocks" in _loc3_ && Boolean(_loc3_.blocks);
         var _loc5_:CustomAttributes = new CustomAttributes();
         if("attributes" in _loc3_)
         {
            _loc5_.mergeObject(_loc3_.attributes);
         }
         var _loc6_:GaturroInventory = InventoryUtil.getInventoryFromAttributes(_loc5_);
         net.sendAction(new GiveObjectActionRequest(this.receiver,param1.itemName,param1.itemPrice,this.CATALOG_NAME,_loc4_,_loc5_.toArray(),_loc6_.name));
         tracker.event(TrackCategories.MARKET,TrackActions.GIVES_GIFT,param1.itemName,param1.itemPrice);
         var _loc7_:Array = param1.itemName.split(".");
         var _loc8_:String = (_loc8_ = (_loc8_ = TrackActions.GIVES_GIFT) + (_loc7_[0] != null ? ":" + _loc7_[0] : TrackActions.NO_PACK)) + (_loc7_[1] != null ? ":" + _loc7_[1] : TrackActions.NO_NAME);
         Telemetry.getInstance().trackEvent(TrackCategories.MARKET,_loc8_,"",param1.itemPrice);
         close();
         this.lastPrice = param1.itemPrice;
         net.addEventListener(GaturroNetResponses.GIVE_OBJECT,this.giveResponse);
      }
      
      override public function dispose() : void
      {
         this.receiver = null;
         this.asset.cancel.removeEventListener(MouseEvent.CLICK,this.clickOnClose);
         super.dispose();
      }
   }
}
