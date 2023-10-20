package com.qb9.gaturro.view.gui.fishing
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModal;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.mambo.net.manager.NetworkManager;
   import flash.events.MouseEvent;
   
   public class FishingGuiModal extends BaseItemListGuiModal
   {
       
      
      private const baits:Array = [{"name":"fishes.bait"},{"name":"fishes.fish1"},{"name":"fishes.fish5"},{"name":"fishes.fish6"},{"name":"fishes.fish7"},{"name":"fishes.fish8"},{"name":"fishes.fish9"},{"name":"fishes.fish10"},{"name":"fishes.fish18"},{"name":"fishes.fish16"},{"name":"fishes.fish15"},{"name":"fishes.fish12"},{"name":"fishes.fish13"},{"name":"fishes.redFish"},{"name":"fishes.greenFish"},{"name":"fishes.yellowFish"},{"name":"fishes.blueFish"},{"name":"fishes.bigFish"},{"name":"acuarium.plankton"},{"name":"acuarium.algas"},{"name":"fishes.fish17"},{"name":"fishes.fish14"},{"name":"seaFishes.fish1"},{"name":"seaFishes.fish12"},{"name":"seaFishes.fish11"},{"name":"seaFishes.fish10"},{"name":"seaFishes.fish13"},{"name":"seaFishes.fish16"},{"name":"seaFishes.fish14"},{"name":"seaFishes.fish15"},{"name":"seaFishes.fish17"},{"name":"seaFishes.camaron"},{"name":"seaFishes.fish20"}];
      
      private var _objectApi:GaturroSceneObjectAPI;
      
      public function FishingGuiModal(param1:TaskContainer, param2:NetworkManager, param3:GaturroSceneObjectAPI)
      {
         super(param1,param2);
         this._objectApi = param3;
         this.loadBaitList(api);
      }
      
      private function notEnoughBaits() : void
      {
         this.asset.gotoAndStop("error");
         this.asset.cancel.visible = true;
         this.asset.cancel.addEventListener(MouseEvent.CLICK,this.clickOnClose);
      }
      
      private function loadBaitList(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.items = [];
         _loc2_ = 0;
         while(_loc2_ < this.baits.length)
         {
            if(this._objectApi.userHasItems(this.baits[_loc2_].name))
            {
               this.items.push(this.baits[_loc2_]);
            }
            _loc2_++;
         }
         init();
      }
      
      override protected function createItem(param1:int) : BaseItemListItemView
      {
         return this.createItemView(items[param1]);
      }
      
      private function clickOnClose(param1:MouseEvent) : void
      {
         api.setSession("bait",null);
         close();
      }
      
      override protected function createItemView(param1:Object) : BaseItemListItemView
      {
         return new FishinhGuiModalItemView(param1,api.avatarHowManyObject(param1.name));
      }
      
      override protected function action(param1:BaseItemListItemView) : void
      {
         api.setSession("bait",param1.itemName);
         close();
      }
      
      override public function dispose() : void
      {
         this.asset.cancel.removeEventListener(MouseEvent.CLICK,this.clickOnClose);
         super.dispose();
      }
      
      override protected function createConfirmation() : BaseItemListGuiModalConfirmation
      {
         return new FishingGuiModalConfirmation();
      }
   }
}
