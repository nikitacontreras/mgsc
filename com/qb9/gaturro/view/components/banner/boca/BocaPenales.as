package com.qb9.gaturro.view.components.banner.boca
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.stageData;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.util.SeedRandom;
   import com.qb9.gaturro.util.advertising.EPlanningAdImage;
   import com.qb9.gaturro.view.components.banner.boca.utils.PapelitosSpawner;
   import com.qb9.gaturro.view.gui.interaction.InteractionGuiModal;
   import com.qb9.gaturro.view.gui.interaction.utils.FutbolScoreManager;
   import com.qb9.gaturro.view.world.TorneoRoomView;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.interaction.Interaction;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BocaPenales extends InteractionGuiModal
   {
      
      public static const TEAM_B:String = "b";
      
      private static const GRID_STATE_ERROR:int = 3;
      
      public static const PENALES_WON_EVENT:String = "PENALES_WON_EVENT";
      
      public static const USER_ATTR_PENALES:String = "penalesWins";
      
      private static const USERS_CHOOSING:String = "USERS_CHOOSING";
      
      private static const USERS_READY:String = "USERS_READY";
      
      private static const GRID_STATE_CURRENT:int = 4;
      
      public static const CLOSE_OPERATION_EVENT:String = "CLOSE_OPERATION_EVENT";
      
      private static const GRID_STATE_GOL:int = 2;
      
      public static const TEAM_A:String = "a";
       
      
      private var _avatarState:String;
      
      private var _buddyName:Object;
      
      private var _localAssetLoaded:Boolean;
      
      private var counterManager:GaturroCounterManager;
      
      private var _prize:int = 0;
      
      private var quitTimeout:uint;
      
      private var _myAccountId:Object;
      
      private var _buddyAccountId:Object;
      
      private var _oneTimeWin:Boolean = false;
      
      private var _score_team_a:int = 0;
      
      private var _score_team_b:int = 0;
      
      private var _papelitosSpawner:PapelitosSpawner;
      
      private var _team:String;
      
      private var _optionSelectedDataRemote:String;
      
      private var _remoteID:Number;
      
      private var timer:Timer;
      
      private var _timer:Timer;
      
      private var _seed:uint = 15897439;
      
      private var _optionSelectedDataLocal:String;
      
      private var _ballState:String;
      
      private var _gameOver:Boolean;
      
      private var _readyMe:Boolean;
      
      private var send_timeoutID:uint;
      
      private var _readyFriend:Boolean;
      
      private var _optionSelectedLocal:Boolean;
      
      private var _remoteAssetLoaded:Boolean;
      
      private var _rusiaWin:Boolean = false;
      
      private var _optionSelectedRemote:Boolean;
      
      private var _currentState:String = "";
      
      private var _avatarAnimationFinished:Boolean;
      
      private var _settings:Object;
      
      private var _round:int;
      
      private var _scoreManager:FutbolScoreManager;
      
      private var _timeToAnimate:Boolean;
      
      private var _myID:Number;
      
      private var _imFirst:Boolean;
      
      private var _coins_per_round:int = 5;
      
      private const TIME_OUT:int = 15000;
      
      private var _shooting:Boolean;
      
      private var _ballAnimationFinished:Boolean;
      
      private var myAccountId:String;
      
      private var _random:SeedRandom;
      
      private var _goalKeeping:Boolean;
      
      private var _playingGolAnimation:Boolean;
      
      private var _maxHeightSizeTimer:Number;
      
      private var _goal:Boolean;
      
      private var _max_prize:int = 50;
      
      public function BocaPenales(param1:GaturroRoom, param2:String, param3:Function, param4:String)
      {
         room = param1;
         prefix = param2;
         sendOperationFunc = param3;
         bannerName = param4;
         super(param1,param2,param3,param4);
         this.myAccountId = api.user.accountId;
         initPopup();
      }
      
      private function startTimer() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         this._timer.reset();
         this._timer.start();
      }
      
      private function onReceiveReady(param1:int) : void
      {
         if(param1 == avatarDataMe.avatarId)
         {
            this._readyMe = true;
            asset.bannerMC.playerOneStart.gotoAndStop(2);
         }
         else
         {
            this._readyFriend = true;
            asset.bannerMC.playerTwoStart.gotoAndStop(2);
         }
         if(this._readyMe && this._readyFriend)
         {
            this.onReady();
         }
      }
      
      override public function close() : void
      {
         this.darPaqueteFigusRusia();
         if(!this._gameOver)
         {
            this._gameOver = true;
            this.send("quit","");
         }
         super.close();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         param1.target.gotoAndStop("over");
         if(param1.target)
         {
            if(this._shooting)
            {
               param1.target.localized_over.guante.visible = false;
               param1.target.localized_over.ballover.visible = true;
            }
            else
            {
               param1.target.localized_over.guante.visible = true;
               param1.target.localized_over.ballover.visible = false;
            }
         }
      }
      
      private function processShooting(param1:Boolean, param2:Array) : void
      {
         this._timeToAnimate = true;
         this._ballState = "";
         this._avatarState = "";
         this._goal = false;
         if(param1)
         {
            this._optionSelectedLocal = true;
            this._optionSelectedDataLocal = param2[0];
         }
         else
         {
            this._optionSelectedRemote = true;
            this._optionSelectedDataRemote = param2[0];
         }
         if(this._optionSelectedLocal && this._optionSelectedRemote)
         {
            if(this._optionSelectedDataLocal == this._optionSelectedDataRemote)
            {
               api.playSound("boca/pelota_pegada");
               trace("*****ATAJO");
               if(this._goalKeeping)
               {
                  this._avatarState = "kp";
                  this._ballState = "kp";
                  asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataRemote);
                  asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                  asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataLocal);
                  asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
               }
               else
               {
                  this._avatarState = "kp";
                  this._ballState = "kp";
                  asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataLocal);
                  asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                  asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataRemote);
                  asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
               }
            }
            else
            {
               this._goal = true;
               if(this._shooting && this._random.boolean(settings.PenaltyGameSettings.goalChance[this._optionSelectedDataLocal]))
               {
                  trace("*****GOOOOOL MIO");
                  this._avatarState = "miss";
                  this._ballState = "gol";
                  asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataLocal);
                  asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                  asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataRemote);
                  asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
               }
               else if(!this._shooting && this._random.boolean(settings.PenaltyGameSettings.goalChance[this._optionSelectedDataRemote]))
               {
                  this._avatarState = "miss";
                  this._ballState = "gol";
                  trace("*****GOOOOOL DEL OTRO");
                  asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataRemote);
                  asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                  asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataLocal);
                  asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
               }
               else
               {
                  trace("*****MISS");
                  asset.bannerMC.missMessage.visible = true;
                  this._goal = false;
                  this._avatarState = "miss";
                  this._ballState = "miss";
                  api.playSound("boca/gol_errado");
                  if(this._shooting)
                  {
                     asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataLocal);
                     asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                     asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataRemote);
                     asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
                  }
                  else
                  {
                     asset.bannerMC.ball.gotoAndStop(this._optionSelectedDataRemote);
                     asset.bannerMC.ball.mc.gotoAndPlay(this._ballState);
                     asset.bannerMC.avatar.gotoAndStop(this._optionSelectedDataLocal);
                     asset.bannerMC.avatar.mc.gotoAndPlay(this._avatarState);
                  }
               }
            }
            asset.addEventListener(Event.ENTER_FRAME,this.update);
         }
      }
      
      protected function onReady() : void
      {
         if(avatarDataMe.avatarId > avatarDataMate.avatarId)
         {
            this.send("imFirst",this.myAccountId.toString());
         }
      }
      
      private function resolveAnimation() : void
      {
      }
      
      private function timeoutClose() : void
      {
      }
      
      override public function dispose() : void
      {
         clearTimeout(this.send_timeoutID);
         api.unfreeze();
         super.dispose();
      }
      
      private function buildWinnerScreen(param1:String) : void
      {
         var _loc2_:int = 0;
         asset.bannerMC.winner.avatar_1_name.text = avatarDataMe.username;
         asset.bannerMC.winner.avatar_2_name.text = avatarDataMate.username;
         asset.bannerMC.winner.avatar_1_score.text = this._scoreManager.getTeamScore(this._team);
         asset.bannerMC.winner.avatar_2_score.text = this._scoreManager.getTeamScore(this.getOpositeTeam());
         if(asset.bannerMC.winner.avatar1)
         {
            asset.bannerMC.winner.avatar1.addChild(characterMe);
         }
         if(asset.bannerMC.winner.avatar2)
         {
            asset.bannerMC.winner.avatar2.addChild(characterMate);
         }
         if(this._team == param1)
         {
            this.onWinSaveAttr();
            api.playSound("festejo");
            characterMe.gotoAndPlay("celebrate");
            characterMate.gotoAndPlay("rayos");
            avatarDataMe.attributes[Gaturro.ACTION_KEY] = "celebrate";
            api.setAvatarAttribute(Gaturro.ACTION_KEY,"celebrate");
            asset.bannerMC.winner.avatar_1_result.text = "GANADOR";
            asset.bannerMC.winner.avatar_2_result.text = "";
            asset.bannerMC.winner.win1.text.text = this._prize.toString();
            asset.bannerMC.winner.win2.visible = false;
            asset.bannerMC.winner.winner_2.visible = false;
            this.onWinnedRusiaGame();
            if(!this.checkLastPlayerYouPlayedWith())
            {
               asset.bannerMC.winner.win1.visible = false;
            }
            _loc2_ = api.getProfileAttribute("coins") as int;
            _loc2_ += this._prize;
            api.setProfileAttribute("system_coins",_loc2_);
         }
         else
         {
            characterMate.gotoAndPlay("celebrate");
            characterMe.gotoAndPlay("rayos");
            api.playSound("lose");
            avatarDataMate.attributes[Gaturro.ACTION_KEY] = "celebrate";
            asset.bannerMC.winner.avatar_1_result.text = "";
            asset.bannerMC.winner.avatar_2_result.text = "GANADOR";
            asset.bannerMC.winner.win2.text.text = this._prize.toString();
            asset.bannerMC.winner.win1.visible = false;
            asset.bannerMC.winner.winner_1.visible = false;
         }
      }
      
      private function callInteractionEvent(param1:String, param2:Array) : void
      {
         var _loc3_:Avatar = null;
         var _loc4_:Avatar = null;
         if(bannerName != "" && param1 in asset)
         {
            switch(param1)
            {
               case "initInteraction":
                  _loc3_ = room.avatarByUsername(user.username);
                  _loc4_ = room.avatarByUsername(mateUsername);
                  Object(asset)[param1](_loc3_,_loc4_);
                  break;
               default:
                  Object(asset)[param1](param2[0]);
            }
         }
      }
      
      override protected function avatarsNames(param1:Avatar, param2:Avatar) : void
      {
         if(asset)
         {
            asset.bannerMC.waiting.avatar_1_name.text = param1.username;
            asset.bannerMC.waiting.avatar_2_name.text = param2.username;
         }
         if(Boolean(param1) && Boolean(param2) && Boolean(this._team))
         {
            asset.bannerMC.playerOneStart.player_name.text = param1.username;
            asset.bannerMC.playerTwoStart.player_name.text = param2.username;
            if(this._team)
            {
               asset.bannerMC.grid["player_name_" + this._team].text = param1.username;
               asset.bannerMC.grid["player_name_" + this.getOpositeTeam()].text = param2.username;
            }
         }
         mateUsername = param2.username;
      }
      
      private function optionChosen(param1:MouseEvent) : void
      {
         asset.bannerMC.message.visible = false;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         if(!this._optionSelectedLocal)
         {
            asset.bannerMC.playing.visible = false;
            this.send("shooting",param1.target.name);
            trace(param1.target.name);
         }
      }
      
      private function checkIfFakeWin() : Boolean
      {
         if(this._prize > 10)
         {
            return false;
         }
         return true;
      }
      
      private function showMessage(param1:String) : void
      {
         asset.bannerMC.message.visible = true;
         asset.bannerMC.message.mc.text.text = param1;
         asset.bannerMC.message.gotoAndPlay(0);
      }
      
      private function idleOptionSelected(param1:TimerEvent) : void
      {
         if(!this._gameOver)
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
            (asset.bannerMC.playing.center1 as MovieClip).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      override protected function avatarsImages(param1:Avatar, param2:Avatar) : void
      {
         characterMe = new Gaturro(new Holder(param1));
         if(asset.bannerMC.waiting.avatar1)
         {
            asset.bannerMC.waiting.avatar1.addChild(characterMe);
         }
         characterMate = new Gaturro(new Holder(param2));
         if(asset.bannerMC.waiting.avatar2)
         {
            asset.bannerMC.waiting.avatar2.addChild(characterMate);
         }
      }
      
      private function onAddedCounter(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedCounter);
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
      }
      
      protected function initViewBanner() : void
      {
         asset.bannerMC.playing.visible = false;
         asset.bannerMC.winner.visible = false;
         asset.bannerMC.message.visible = false;
         asset.bannerMC.spawner.visible = false;
         asset.bannerMC.golMessage.visible = false;
         asset.bannerMC.missMessage.visible = false;
         asset.bannerMC.golView.space.center1.visible = false;
         asset.bannerMC.golView.space.center2.visible = false;
         asset.bannerMC.golView.space.left1.visible = false;
         asset.bannerMC.golView.space.left2.visible = false;
         asset.bannerMC.golView.space.right1.visible = false;
         asset.bannerMC.golView.space.right2.visible = false;
         asset.bannerMC.close.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
      }
      
      private function updateScore(param1:Boolean, param2:String, param3:Boolean) : void
      {
         var _loc4_:String = param2;
         if(!param3)
         {
            _loc4_ = param2 == TEAM_A ? TEAM_B : TEAM_A;
         }
         if(param1)
         {
            asset.bannerMC.grid["score_" + _loc4_ + "_" + this._round].gotoAndStop(2);
         }
         else
         {
            asset.bannerMC.grid["score_" + _loc4_ + "_" + this._round].gotoAndStop(3);
         }
         if(_loc4_ == TEAM_A)
         {
            if(param1)
            {
               ++this._score_team_a;
               asset.bannerMC.grid["score_a"].text = this._score_team_a;
            }
            --this._scoreManager.penalty_remaining_a;
            this._scoreManager.team_a = this._score_team_a;
         }
         else if(_loc4_ == TEAM_B)
         {
            if(param1)
            {
               ++this._score_team_b;
               asset.bannerMC.grid["score_b"].text = this._score_team_b;
            }
            --this._scoreManager.penalty_remaining_b;
            this._scoreManager.team_b = this._score_team_b;
         }
         ++this._round;
      }
      
      protected function sendAssetLoaded() : void
      {
         this.send("assetLoaded","");
      }
      
      private function updateAndShootAgain() : void
      {
         this.updateScore(this._goal,this._team,this._shooting);
         this.updateCurrentRound();
         var _loc1_:String = this._scoreManager.isGG();
         if(_loc1_ != null)
         {
            trace("************* WINNER: --------/" + _loc1_.toUpperCase() + "/-----------");
            api.trackEvent("BOCA:PENALES:STATUS_PARTIDO","TERMINADO");
            this.onGameOver(_loc1_);
            return;
         }
         this.startTimer();
         this._ballState = "";
         this._avatarState = "";
         (asset.bannerMC.ball.mc as MovieClip).gotoAndStop(0);
         (asset.bannerMC.avatar.mc as MovieClip).gotoAndStop(0);
         (asset.bannerMC.avatar as MovieClip).gotoAndStop(0);
         asset.bannerMC.playing.visible = true;
         this._optionSelectedRemote = false;
         this._optionSelectedLocal = false;
         this._playingGolAnimation = false;
         this._shooting = !this._shooting;
         this._goalKeeping = !this._goalKeeping;
         if(this._shooting)
         {
            this.showMessage("¡TE TOCA PATEAR!");
         }
         else
         {
            this.showMessage("¡TE TOCA ATAJAR!");
         }
      }
      
      override public function executeOperation(param1:String, param2:Avatar, param3:Avatar, param4:Array) : void
      {
         var _loc5_:Boolean = param2.avatarId == avatarDataMe.avatarId ? true : false;
         trace(param1,param2,param3,param4);
         trace(">>>>>>OPERATION: " + param1 + " <-----LOCAL OPERATION?: " + _loc5_);
         switch(param1)
         {
            case Interaction.PROPOSAL:
            case "click":
               break;
            case "assetLoaded":
               if(_loc5_)
               {
                  this._localAssetLoaded = true;
               }
               else
               {
                  this._remoteAssetLoaded = true;
               }
               if(this.globalAssetLoaded)
               {
                  this.sendReady();
                  break;
               }
               break;
            case "imFirst":
               this._imFirst = _loc5_ ? true : false;
               if(asset)
               {
                  asset.bannerMC.waiting.visible = false;
               }
               this.getTeam();
               this.startGame();
               this.avatarsNames(avatarDataMe,avatarDataMate);
               this.updateCurrentRound();
               break;
            case "imReady":
               this.onReceiveReady(param2.avatarId);
               if(!_loc5_ && !this._remoteAssetLoaded)
               {
                  this.sendReady();
                  break;
               }
               break;
            case "execute":
               break;
            case "quit":
               if(!_loc5_)
               {
                  this.onGameOver(this._team);
                  break;
               }
               break;
            case "shooting":
               this.processShooting(_loc5_,param4);
               break;
            case "gameOver":
         }
      }
      
      protected function startGame() : void
      {
         asset.bannerMC.playerOneStart.visible = false;
         asset.bannerMC.playerTwoStart.visible = false;
         asset.bannerMC.avatar.gotoAndStop(0);
         this._prize = 0;
         api.trackEvent("BOCA:PENALES:STATUS_PARTIDO","EMPEZADO");
         this._playingGolAnimation = false;
         if(this._imFirst)
         {
            this._shooting = true;
            this.showMessage("¡TE TOCA PATEAR!");
         }
         else
         {
            this._goalKeeping = true;
            this.showMessage("¡TE TOCA ATAJAR!");
         }
         asset.bannerMC.playing.visible = true;
         (asset.bannerMC.playing.left1 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.left1 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.left2 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.left2 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.center1 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.center1 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.center2 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.center2 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.right1 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.right1 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.right2 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.right2 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.left1 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.left2 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.center1 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.center2 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.right1 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.right2 as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         (asset.bannerMC.playing.left1 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.left2 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.center1 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.center2 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.right1 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.right2 as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         (asset.bannerMC.playing.right2 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.right1 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.center1 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.center2 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.left1 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.left2 as MovieClip).buttonMode = true;
         this._timer = new Timer(0,this._settings.timeToChoose.valueInMS);
         this.startTimer();
      }
      
      protected function get globalAssetLoaded() : Boolean
      {
         return this._localAssetLoaded && this._remoteAssetLoaded;
      }
      
      private function tryInteractionEvent(param1:String, param2:int, ... rest) : void
      {
         if(asset)
         {
            this.callInteractionEvent(param1,rest);
         }
         else
         {
            param2--;
            if(param2 > 0)
            {
               setTimeout(this.tryInteractionEvent,100,param1,param2,rest);
            }
         }
      }
      
      override public function send(param1:String, param2:String) : void
      {
         if(param1 == "quit")
         {
            super.send(param1,param2);
         }
         else
         {
            this.send_timeoutID = setTimeout(super.send,1000,param1,param2);
         }
      }
      
      private function darPaqueteFigusRusia() : void
      {
         if(this.checkIfFakeWin() || !this.checkLastPlayerYouPlayedWith())
         {
            return;
         }
         if(this._rusiaWin)
         {
            if(!this._oneTimeWin)
            {
               this._oneTimeWin = true;
               api.setSession("lastUserPlayed",mateUsername);
               api.levelManager.addCompetitiveExp(20);
               setTimeout(function():void
               {
                  api.instantiateBannerModal("BoosterRewardBanner");
               },1000);
            }
         }
      }
      
      private function registerPlayers(param1:Object, param2:Object) : void
      {
         this._buddyName = param2.username;
         this._buddyAccountId = param2.avatarId;
         this._myAccountId = param1.avatarId;
      }
      
      private function onWinnedRusiaGame() : void
      {
         var _loc1_:int = 0;
         if(prefix == "PT")
         {
            _loc1_ = api.getAvatarAttribute("rusiaPenales") as int;
            _loc1_++;
            api.setAvatarAttribute("rusiaPenales",_loc1_);
            this._rusiaWin = true;
         }
      }
      
      private function onWinSaveAttr() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.checkIfFakeWin())
         {
            return;
         }
         if(api.roomView is TorneoRoomView)
         {
            _loc1_ = new Date();
            _loc2_ = this.counterManager.getAmount(USER_ATTR_PENALES);
            _loc3_ = api.getProfileAttribute(TorneoRoomView.USER_LEADERBOARD_ATTR) as int;
            _loc4_ = _loc1_.day;
            if(_loc3_ == _loc4_)
            {
               this.counterManager.increase(USER_ATTR_PENALES);
            }
            else
            {
               this.counterManager.reset(USER_ATTR_PENALES);
               api.setProfileAttribute(TorneoRoomView.USER_LEADERBOARD_ATTR,_loc4_);
            }
         }
      }
      
      private function duelTimedOut() : void
      {
         if(!this._readyFriend)
         {
            this.close();
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         param1.target.gotoAndStop("idle");
      }
      
      private function checkLastPlayerYouPlayedWith() : Boolean
      {
         var _loc1_:String = api.getSession("lastUserPlayed") as String;
         if(_loc1_ == mateUsername)
         {
            return false;
         }
         return true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = (param1.target.repeatCount - param1.target.currentCount) * (asset.bannerMC.playing.mcTimer as MovieClip).totalFrames / param1.target.repeatCount;
         asset.bannerMC.playing.mcTimer.gotoAndStop(_loc2_);
      }
      
      protected function getOpositeTeam() : String
      {
         return this._team == TEAM_A ? TEAM_B : TEAM_A;
      }
      
      override protected function whenTheBannerIsComplete(param1:Event) : void
      {
         var _loc2_:String = URLUtil.getUrl(relativeName);
         var _loc3_:String = URLUtil.versionedPath(_loc2_);
         var _loc4_:String = URLUtil.versionedFileName(_loc3_);
         this.displayElement(wLoader.content);
      }
      
      private function cleanScore() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            if(asset.bannerMC.grid["score_" + this._team + "_" + _loc1_] != null)
            {
               _loc2_ = asset.bannerMC.grid["score_" + this._team + "_" + _loc1_];
            }
            else
            {
               _loc2_ = asset.bannerMC.grid["score_" + this.getOpositeTeam() + "_" + _loc1_];
            }
            if(_loc2_)
            {
               _loc2_.gotoAndStop(0);
            }
            _loc1_++;
         }
         this._round = 0;
      }
      
      private function onQuit(param1:MouseEvent) : void
      {
         asset.bannerMC.close.removeEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
         this.close();
      }
      
      private function update(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         if(this._timeToAnimate)
         {
            if(Boolean(asset) && Boolean(asset.bannerMC))
            {
               if(!this._ballAnimationFinished && (asset.bannerMC.ball.mc as MovieClip).currentLabel == this._ballState + "_last")
               {
                  if(this._goal)
                  {
                     if(Boolean(asset.bannerMC) && !this._playingGolAnimation)
                     {
                        this._playingGolAnimation = true;
                        if(this._shooting)
                        {
                           asset.bannerMC.golView.space[this._optionSelectedDataLocal].visible = true;
                           asset.bannerMC.golView.space[this._optionSelectedDataLocal].gotoAndPlay(0);
                           api.playSound("boca/gol_convertido01");
                           api.playSound("boca/pelota_red");
                        }
                        else
                        {
                           asset.bannerMC.golView.space[this._optionSelectedDataRemote].visible = true;
                           asset.bannerMC.golView.space[this._optionSelectedDataRemote].gotoAndPlay(0);
                           api.playSound("boca/gol_contra");
                           api.playSound("boca/pelota_red");
                        }
                        asset.bannerMC.arco.goal.gotoAndPlay(0);
                        asset.bannerMC.golMessage.visible = true;
                     }
                     _loc2_ = this.getOptionSelectedBaseOnShooting();
                     _loc3_ = asset.bannerMC.golView.space[_loc2_];
                     if(asset.bannerMC.golView.space[_loc2_].currentFrame == asset.bannerMC.golView.space[_loc2_].totalFrames)
                     {
                        asset.bannerMC.golView.space[this.getOptionSelectedBaseOnShooting()].visible = false;
                        this._ballAnimationFinished = true;
                        asset.bannerMC.golMessage.visible = false;
                     }
                  }
                  else
                  {
                     this._ballAnimationFinished = true;
                  }
               }
               if(!this._avatarAnimationFinished && (asset.bannerMC.avatar.mc as MovieClip).currentLabel == this._avatarState + "_last")
               {
                  asset.bannerMC.avatar.mc.gotoAndStop(asset.bannerMC.avatar.mc.currentFrame);
                  asset.bannerMC.missMessage.visible = false;
                  this._avatarAnimationFinished = true;
               }
               trace("_ballAnimationFinished: " + this._ballAnimationFinished + "_avatarAnimationFinished: " + this._avatarAnimationFinished);
               if(this._timeToAnimate && this._ballAnimationFinished && this._avatarAnimationFinished)
               {
                  this._timeToAnimate = false;
                  this._avatarAnimationFinished = false;
                  this._ballAnimationFinished = false;
                  asset.removeEventListener(Event.ENTER_FRAME,this.update);
                  this.updateAndShootAgain();
                  trace("************* shoot again");
               }
            }
         }
      }
      
      private function getTeam() : void
      {
         if(this._imFirst)
         {
            this._team = TEAM_A;
         }
         else
         {
            this._team = TEAM_B;
         }
         trace("MY TEAM: " + this._team + " ; imfirst :" + this._imFirst);
      }
      
      private function setupCounter() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedCounter);
         }
      }
      
      private function getOptionSelectedBaseOnShooting() : String
      {
         if(this._shooting)
         {
            return this._optionSelectedDataLocal;
         }
         return this._optionSelectedDataRemote;
      }
      
      override protected function displayElement(param1:DisplayObject) : void
      {
         super.displayElement(param1);
         addChild(param1);
         this._settings = settings.PenaltyGameSettings;
         this._optionSelectedRemote = false;
         this._optionSelectedLocal = false;
         trace("DISPLAYED CONTENT: TRUE");
         if(param1 is EPlanningAdImage)
         {
            x = stageData.width / 2 - width / 2;
            y = stageData.height / 2 - height / 2;
         }
         else
         {
            x = stageData.width / 2;
            y = stageData.height / 2;
         }
         api.freeze();
         api.setAvatarAttribute("action","jueguito.mundialClothes2.pelota3");
         addEventListener(MouseEvent.CLICK,handleCloseClicks);
         complete();
         asset = MovieClip(param1);
         this.initViewBanner();
         this._scoreManager = new FutbolScoreManager();
         this.avatarsNames(avatarDataMe,avatarDataMate);
         this.avatarsImages(avatarDataMe,avatarDataMate);
         this._seed = avatarDataMe.id + avatarDataMate.id;
         this._random = new SeedRandom(this._seed);
         this.sendAssetLoaded();
         this.setupCounter();
      }
      
      protected function onGameOver(param1:String) : void
      {
         this._gameOver = true;
         asset.bannerMC.spawner.visible = true;
         this.buildWinnerScreen(param1);
         asset.bannerMC.winner.visible = true;
         api.setSession("penalesBoca",1);
      }
      
      override public function initInteraction(param1:String) : void
      {
         this.mateUsername = param1;
         cleanTimer();
      }
      
      protected function sendReady() : void
      {
         this.send("imReady","");
      }
      
      private function updateCurrentRound() : void
      {
         if(this._prize < this._max_prize)
         {
            this._prize += this._coins_per_round;
         }
         if(this._round >= 10)
         {
            this.cleanScore();
         }
         if(asset.bannerMC.grid["score_" + this._team + "_" + this._round])
         {
            asset.bannerMC.grid["score_" + this._team + "_" + this._round].gotoAndStop(4);
         }
         else
         {
            asset.bannerMC.grid["score_" + this.getOpositeTeam() + "_" + this._round].gotoAndStop(4);
         }
      }
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.Avatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:Avatar)
   {
      super();
      _attributes = param1.attributes.clone(this);
   }
}
