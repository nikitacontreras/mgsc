package com.qb9.gaturro.view.gui.coins
{
   import assets.CoinsAndRankMC;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.socialNet;
   import com.qb9.gaturro.socialnet.SocialNet;
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.map.MapGuiModal;
   import com.qb9.gaturro.view.gui.socialnet.SocialNetButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class AcquiredCoinsGuiModal extends BaseGuiModal
   {
       
      
      private var coins:uint;
      
      private var sendScoreButton:SocialNetButton;
      
      private var betterScore:Boolean = false;
      
      private var gui:Gui;
      
      private var asset:MovieClip;
      
      private var score:Number;
      
      private var game:String;
      
      private var room:GaturroRoom;
      
      public function AcquiredCoinsGuiModal(param1:GameMinigameReward, param2:GaturroRoom, param3:Gui)
      {
         super();
         this.room = param2;
         this.gui = param3;
         this.coins = param1.coins;
         this.game = param1.game;
         this.score = param1.sessionScore;
         this.betterScore = param1.betterScore;
         this.init();
      }
      
      private function showRank(param1:Event) : void
      {
         this.gui.addModal(new MapGuiModal(this.room.userAvatar.isCitizen,this.room,this.game));
      }
      
      override protected function get openSound() : String
      {
         return "moneditas";
      }
      
      private function publishScore() : void
      {
         var _loc1_:Object = {};
         _loc1_.score = this.score.toString();
         _loc1_.game_name = region.getText(region.key(this.game));
         _loc1_.game_id = this.game;
         var _loc2_:SocialNetMessage = SocialNet.getScoreMessage(_loc1_);
         socialNet.sendMessage(_loc2_);
         this.close();
      }
      
      private function replay(param1:Event) : void
      {
         this.room.startMinigame(this.game);
      }
      
      private function init() : void
      {
         var _loc2_:int = 0;
         this.asset = new CoinsAndRankMC();
         this.asset.rankiing.visible = !ArrayUtil.contains(settings.minigames.noRanking,this.game);
         if(Boolean(api.user.club.contest.active) && Boolean(api.user.club.hasClub) && Boolean(api.user.club.contest.isMeritableGame(this.game)))
         {
            api.user.club.contest.addMeritPoints(this.coins,this.game);
            this.asset.meritBadge.meritAmount.text = region.getText(this.coins.toString());
         }
         else if(Boolean(api.user.club.contest.active) && Boolean(api.user.club.contest.isMeritableGame(this.game)))
         {
            this.asset.meritBadge.txtTop.text = region.getText("");
            this.asset.meritBadge.txtBottom.text = region.getText("");
            this.asset.meritBadge.meritAmount.text = region.getText("");
            this.asset.meritBadge.noClubText.text = region.getText("¡ÚNETE A UN CLUB PARA GANAR MÉRITOS!");
         }
         else
         {
            this.asset.meritBadge.visible = false;
         }
         if(this.score > 0 && socialNet.enabled)
         {
            this.asset.sessionScoreText.visible = true;
            this.asset.sessionScoreText2.visible = true;
            this.asset.sessionScore.visible = true;
            this.asset.sessionScore.text = this.score.toString();
            this.asset.publishScore.visible = true;
            this.asset.rankingsBg.visible = true;
            if(this.betterScore)
            {
               this.asset.sessionScoreText.text = region.getText("¡HAS SUPERADO TU PUNTUACIÓN!");
            }
            else
            {
               this.asset.sessionScoreText.text = region.getText("HAS OBTENIDO UN NUEVO PUNTAJE");
            }
            this.asset.publishScore.visible = socialNet.setttingEnabled;
            this.sendScoreButton = new SocialNetButton(region.getText("PUBLICAR"),this.asset.publishScore,this.publishScore);
            socialNet.testService(this.sendScoreButton.activate,this.sendScoreButton.deactivate);
         }
         else
         {
            this.asset.sessionScoreText.visible = false;
            this.asset.sessionScoreText2.visible = false;
            this.asset.sessionScore.visible = false;
            this.asset.publishScore.visible = false;
            this.asset.rankingsBg.visible = false;
         }
         if(this.score > 0)
         {
            api.levelManager.addCompetitiveExp(10);
         }
         var _loc1_:Boolean = server.minigameData != null && server.minigameData[this.game] != null && server.minigameData[this.game]["donations"] != null;
         this.asset.unicef.visible = _loc1_;
         if(api.isTypeGame(this.game,"feria"))
         {
            this.asset.currencyAsset.gotoAndStop("feria");
            this.asset.coins_text.text = "TICKETS";
            this.asset.rankiing.visible = false;
            _loc2_ = api.getProfileAttribute("feria") as int;
            _loc2_ += this.coins;
            api.setProfileAttribute("feria",_loc2_);
         }
         this.asset.field.text = this.coins.toString();
         region.setText(this.asset.replay.field,"VOLVER A JUGAR");
         this.asset.replay.addEventListener(MouseEvent.CLICK,this.replay);
         this.asset.replay.visible = !ArrayUtil.contains(settings.minigames.noReplay,this.game);
         region.setText(this.asset.rankiing.field,"VER RANKING");
         this.asset.rankiing.addEventListener(MouseEvent.CLICK,this.showRank);
         region.setText(this.asset.ready.text,"LISTO");
         this.asset.ready.addEventListener(MouseEvent.CLICK,_close);
         addChild(this.asset);
      }
      
      override public function dispose() : void
      {
         if(disposed)
         {
            return;
         }
         this.asset.replay.removeEventListener(MouseEvent.CLICK,this.replay);
         this.asset.ready.removeEventListener(MouseEvent.CLICK,_close);
         this.asset.rankiing.removeEventListener(MouseEvent.CLICK,this.showRank);
         if(this.asset.publishScore)
         {
            this.asset.publishScore.removeEventListener(MouseEvent.CLICK,this.publishScore);
         }
         if(this.sendScoreButton)
         {
            this.sendScoreButton.dispose();
         }
         this.sendScoreButton = null;
         this.asset = null;
         this.room = null;
         super.dispose();
      }
   }
}
