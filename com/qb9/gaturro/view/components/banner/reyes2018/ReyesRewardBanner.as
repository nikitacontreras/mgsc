package com.qb9.gaturro.view.components.banner.reyes2018
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ReyesRewardBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
       
      
      private var teamPoints:TextField;
      
      private var coinsRewards:TextField;
      
      private var teamName:String;
      
      private var _data:Object;
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var acceptBtn:MovieClip;
      
      private var flagHolder:MovieClip;
      
      private var _rewardData:Object;
      
      public function ReyesRewardBanner(param1:String = "", param2:String = "")
      {
         super("reyesRewards","reyesRewardsAsset");
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         close();
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      private function setupView() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         this.coinsRewards = view.getChildByName("coinsRewards") as TextField;
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         this.flagHolder = view.getChildByName("flagHolder") as MovieClip;
         if(this._rewardData)
         {
            this.coinsRewards.text = this._rewardData.coins.toString();
         }
         if(this._rewardData.coins > 0)
         {
            _loc1_ = Math.random();
            trace(_loc1_);
            if(_loc1_ > 0.5)
            {
               api.giveUser("reyes2017/props.agua");
               this.flagHolder.gotoAndStop(1);
            }
            else
            {
               api.giveUser("reyes2017/props.pasto");
               this.flagHolder.gotoAndStop(2);
            }
            _loc2_ = api.getProfileAttribute("coins") as int;
            _loc2_ += this._rewardData.coins;
            api.setProfileAttribute("system_coins",_loc2_);
            api.levelManager.addCompetitiveExp(10);
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
