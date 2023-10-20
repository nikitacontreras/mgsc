package com.qb9.gaturro.view.components.banner.asteroids
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class AsteroidsRewardsBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
       
      
      private var coinsRewards:TextField;
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var acceptBtn:MovieClip;
      
      private var _rewardData:Object;
      
      public function AsteroidsRewardsBanner()
      {
         super("AsteroidsRewards","asteroidsRewardsAsset");
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         close();
         setTimeout(api.openAsteroidsCatalog,500,"asteroids2018");
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      private function setupView() : void
      {
         this.coinsRewards = view.getChildByName("coinsRewards") as TextField;
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         if(this._rewardData)
         {
            this.coinsRewards.text = this._rewardData.score.toString();
         }
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onConfirm);
      }
      
      public function set data(param1:Object) : void
      {
         this._rewardData = param1;
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}
