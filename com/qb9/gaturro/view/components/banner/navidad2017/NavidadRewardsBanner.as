package com.qb9.gaturro.view.components.banner.navidad2017
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class NavidadRewardsBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var coinsRewards:TextField;
      
      private var teamName:String;
      
      private var teamManager:TeamManager;
      
      private var _rewardData:GameMinigameReward;
      
      private var teamPoints:TextField;
      
      private var acceptBtn:MovieClip;
      
      private var flagHolder:MovieClip;
      
      public function NavidadRewardsBanner(param1:String = "", param2:String = "")
      {
         super("NavidadRewards","NavidadRewardsAsset");
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
         this.teamName = this._roomAPI.getProfileAttribute("team_halloween2017") as String;
      }
      
      private function setupView() : void
      {
         this.coinsRewards = view.getChildByName("coinsRewards") as TextField;
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         this.coinsRewards.text = this._rewardData.coins.toString();
         CatalogUtils.giveCoins("navidad",this._rewardData.coins);
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onConfirm);
         this._roomAPI.levelManager.addCompetitiveExp(10);
      }
      
      public function set data(param1:Object) : void
      {
         this._rewardData = param1 as GameMinigameReward;
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         close();
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      private function setup() : void
      {
         this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
      }
   }
}
