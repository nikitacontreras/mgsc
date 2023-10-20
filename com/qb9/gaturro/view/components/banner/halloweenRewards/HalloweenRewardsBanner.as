package com.qb9.gaturro.view.components.banner.halloweenRewards
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class HalloweenRewardsBanner extends InstantiableGuiModal implements IHasData, IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var coinsRewards:TextField;
      
      private var teamName:String;
      
      private var teamManager:TeamManager;
      
      private var _rewardData:GameMinigameReward;
      
      private var teamPoints:TextField;
      
      private var acceptBtn:MovieClip;
      
      private var flagHolder:MovieClip;
      
      public function HalloweenRewardsBanner()
      {
         super("halloweenRewards","HalloweenRewardsAsset");
         this.setup();
      }
      
      private function setupView() : void
      {
         this.teamPoints = view.getChildByName("teamPoints") as TextField;
         this.coinsRewards = view.getChildByName("coinsRewards") as TextField;
         this.flagHolder = view.getChildByName("flagHolder") as MovieClip;
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         if(this._rewardData)
         {
            this.teamPoints.text = this._rewardData.sessionScore.toString();
            this.coinsRewards.text = this._rewardData.coins.toString();
            this.givePoints();
         }
         else if(this._rewardData == null)
         {
            this.genericReward();
         }
         this.flagHolder.gotoAndStop(this.teamName);
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onConfirm);
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
      
      private function genericReward() : void
      {
         this.teamPoints.text = "+10";
         this.coinsRewards.text = "+100";
         this.teamManager.addPoints(this.teamName,10);
         this._roomAPI.levelManager.addCompetitiveExp(10);
         var _loc1_:int = this._roomAPI.getProfileAttribute("coins") as int;
         _loc1_ += 100;
         this._roomAPI.setProfileAttribute("system_coins",_loc1_);
      }
      
      private function givePoints() : void
      {
         this.teamManager.addPoints(this.teamName,this._rewardData.sessionScore);
         var _loc1_:int = this._roomAPI.getProfileAttribute("coins") as int;
         _loc1_ += this._rewardData.coins;
         this._roomAPI.setProfileAttribute("system_coins",_loc1_);
         this._roomAPI.levelManager.addCompetitiveExp(10);
      }
      
      private function setup() : void
      {
         this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
         this.teamName = this._roomAPI.getProfileAttribute("team_halloween2017") as String;
      }
   }
}
