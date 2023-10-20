package com.qb9.gaturro.view.components.banner.peleaMagia
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.interaction.InteractionGuiModal;
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
   import flash.utils.setTimeout;
   
   public class PeleaMagiaCore extends InteractionGuiModal
   {
      
      public static const TEAM_B:String = "b";
      
      private static const KILL_SWICHT_SELECTION_IN_MS:Number = 4000;
      
      private static const KILL_SWICHT_IN_MS:Number = 10000;
      
      public static const ALLOWED_MAX_TIME_SERVER_BASE:Number = 15000;
      
      public static const TEAM_A:String = "a";
       
      
      private var _localAssetLoaded:Boolean;
      
      private var _enemyLives:Number = 2;
      
      private var _spellSmashingRemoteDATA:int;
      
      private var _team:String;
      
      private var _optionSelectedDataRemote:String;
      
      private var _gameOver:Boolean;
      
      private var _timer:Timer;
      
      private var send_timeoutID:uint;
      
      private var _startCountingServerTime:Number;
      
      private var _serverTime:Date;
      
      private var _optionSelectedDataLocal:String;
      
      private var _optionSelectedLocal:Boolean;
      
      private var _winner:String;
      
      private var _finalCountingServerTime:Number;
      
      private var _readyFriend:Boolean;
      
      private var _readyMe:Boolean;
      
      private var _serverTimeFinal:Number;
      
      private var _smashTimer:Timer;
      
      private var _smashingResult:int;
      
      private var _remoteAssetLoaded:Boolean;
      
      private var _optionSelectedRemote:Boolean;
      
      private var _enemyhalloweenTeam:String = "";
      
      private var _myLives:Number = 2;
      
      private var _view:com.qb9.gaturro.view.components.banner.peleaMagia.PeleaMagiaView;
      
      private var _spellSmashingLocalDATA:int;
      
      private var _timeToAnimate:Boolean;
      
      private var _normalFight:Boolean;
      
      private var _imFirst:Boolean;
      
      private var _alive:Boolean = false;
      
      private var _spellSmashing:Boolean;
      
      private var _myhalloweenTeam:String = "";
      
      private var _spellSmashingLocal:Boolean;
      
      private var myAccountId:String;
      
      private var _spellSmashingRemote:Boolean;
      
      private var _serverTimeInit:Number;
      
      public function PeleaMagiaCore(param1:GaturroRoom, param2:String, param3:Function, param4:String)
      {
         room = param1;
         prefix = param2;
         sendOperationFunc = param3;
         bannerName = param4;
         super(param1,param2,param3,param4);
         this.myAccountId = api.user.accountId;
         initPopup();
      }
      
      public function spellResolveWinner(param1:String, param2:String) : Boolean
      {
         if(param1 == "ataque0")
         {
            if(param2 == "ataque1")
            {
               return false;
            }
            return true;
         }
         if(param1 == "ataque1")
         {
            if(param2 == "ataque2")
            {
               return false;
            }
            return true;
         }
         if(param1 == "ataque2")
         {
            if(param2 == "ataque0")
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      protected function onReady() : void
      {
         if(avatarDataMe.avatarId > avatarDataMate.avatarId)
         {
            this.send("imFirst",this.myAccountId.toString());
         }
      }
      
      private function updateCurrentRound() : void
      {
         if(this._spellSmashingLocal && this._spellSmashingRemote)
         {
            if(this._spellSmashingLocalDATA > this._spellSmashingRemoteDATA)
            {
               asset.bannerMC.playerTwoStart["live" + this._enemyLives.toString()].gotoAndStop(2);
               --this._enemyLives;
            }
            else if(this._spellSmashingLocalDATA < this._spellSmashingRemoteDATA)
            {
               asset.bannerMC.playerOneStart["live" + this._myLives.toString()].gotoAndStop(2);
               --this._myLives;
            }
         }
         else if(this.spellResolveWinner(this._optionSelectedDataLocal,this._optionSelectedDataRemote))
         {
            asset.bannerMC.playerTwoStart["live" + this._enemyLives.toString()].gotoAndStop(2);
            --this._enemyLives;
         }
         else
         {
            asset.bannerMC.playerOneStart["live" + this._myLives.toString()].gotoAndStop(2);
            --this._myLives;
         }
         if(this._enemyLives < 0)
         {
            this._gameOver = true;
            this.onGameOver(this._team);
            api.trackEvent("FEATURES:HALLOWEEN2017:DUELOMAGIA:STATUS_PARTIDO","TERMINADO");
         }
         if(this._myLives < 0)
         {
            this._gameOver = true;
            this.onGameOver(this.getOpositeTeam());
            api.trackEvent("FEATURES:HALLOWEEN2017:DUELOMAGIA:STATUS_PARTIDO","TERMINADO");
         }
      }
      
      private function onReceiveReady(param1:int) : void
      {
         if(param1 == avatarDataMe.avatarId)
         {
            this._readyMe = true;
         }
         else
         {
            this._readyFriend = true;
         }
         if(this._readyMe && this._readyFriend)
         {
            this.onReady();
         }
      }
      
      private function startTimer() : void
      {
         this._startCountingServerTime = api.serverTime;
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         this._timer.reset();
         this._timer.start();
      }
      
      private function buildWinnerScreen(param1:String) : void
      {
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
            characterMe.gotoAndPlay("celebrate");
            characterMate.gotoAndPlay("rayos");
            api.playSound("halloween2017/festejo");
            asset.bannerMC.winner.avatar_1_reward.visible = true;
            asset.bannerMC.winner.winner_2.visible = false;
            asset.bannerMC.winner.avatar_2_reward.visible = false;
            api.addTeamPoints("entrenamiento",10);
         }
         else
         {
            characterMe.gotoAndPlay("rayos");
            characterMate.gotoAndPlay("celebrate");
            asset.bannerMC.winner.avatar_1_reward.visible = false;
            asset.bannerMC.winner.winner_1.visible = false;
            asset.bannerMC.winner.avatar_2_reward.visible = true;
         }
         asset.bannerMC.winner.match_type.text = "DUELO COMPETITIVO";
         asset.bannerMC.winner.avatar_1_score.team.gotoAndStop(this._myhalloweenTeam);
         asset.bannerMC.winner.avatar_2_score.team.gotoAndStop(this._enemyhalloweenTeam);
      }
      
      private function spellFighting() : void
      {
      }
      
      private function idleOptionSelected(param1:TimerEvent) : void
      {
         if(!this._gameOver)
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
            (asset.bannerMC.playing.ataque0 as MovieClip).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      override public function dispose() : void
      {
         this._view.dispose();
         api.unfreeze();
         super.dispose();
      }
      
      override protected function avatarsNames(param1:Avatar, param2:Avatar) : void
      {
         if(asset)
         {
            asset.bannerMC.waiting.avatar_1_name.text = param1.username;
            asset.bannerMC.waiting.avatar_2_name.text = param2.username;
            asset.bannerMC.waiting.avatar_1_flag.gotoAndStop(api.getProfileAttribute("team_halloween2017") as String);
            if(this._enemyhalloweenTeam != "")
            {
               asset.bannerMC.waiting.avatar_2_flag.gotoAndStop(this._enemyhalloweenTeam);
            }
         }
         if(Boolean(param1) && Boolean(param2) && Boolean(this._team))
         {
            asset.bannerMC.playerOneStart.player_name.text = param1.username;
            asset.bannerMC.playerTwoStart.player_name.text = param2.username;
            asset.bannerMC.winner.avatar_1_flag.gotoAndStop(this._myhalloweenTeam);
            asset.bannerMC.winner.avatar_2_flag.gotoAndStop(this._enemyhalloweenTeam);
            asset.bannerMC.winner.avatar_1_name.text = param1.username;
            asset.bannerMC.winner.avatar_2_name.text = param2.username;
            if(!this._team)
            {
            }
         }
         mateUsername = param2.username;
      }
      
      public function set timeToAnimate(param1:Boolean) : void
      {
         this._timeToAnimate = param1;
      }
      
      private function get lastInteractionInMS() : Number
      {
         if(this._serverTime)
         {
            if(this._startCountingServerTime != 0)
            {
               return this._serverTime.valueOf() - this._startCountingServerTime;
            }
            this._startCountingServerTime = this._serverTime.valueOf();
            return this._serverTime.valueOf() - this._startCountingServerTime;
         }
         return -1;
      }
      
      private function optionChosen(param1:MouseEvent) : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         if(!this._optionSelectedLocal)
         {
            asset.bannerMC.playing.visible = false;
            this.send("shooting",param1.target.name);
            trace(param1.target.name);
         }
      }
      
      override protected function avatarsImages(param1:Avatar, param2:Avatar) : void
      {
         characterMe = new Gaturro(new Holder(param1));
         characterMe.attrs.transport = " ";
         if(Boolean(asset.bannerMC.waiting.avatar1) && (asset.bannerMC.waiting.avatar1 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.waiting.avatar1.addChild(characterMe);
         }
         if(Boolean(asset.bannerMC.avatar1) && (asset.bannerMC.avatar1 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.avatar1.addChild(characterMe);
         }
         characterMate = new Gaturro(new Holder(param2));
         characterMate.attrs.transport = " ";
         if(Boolean(asset.bannerMC.waiting.avatar2) && (asset.bannerMC.waiting.avatar2 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.waiting.avatar2.addChild(characterMate);
         }
         if(Boolean(asset.bannerMC.avatar2) && (asset.bannerMC.avatar2 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.avatar2.addChild(characterMate);
         }
      }
      
      public function get spellSmashingRemoteDATA() : int
      {
         return this._spellSmashingRemoteDATA;
      }
      
      protected function sendAssetLoaded() : void
      {
         this.send("assetLoaded","");
      }
      
      public function get spellSmashingLocalDATA() : int
      {
         return this._spellSmashingLocalDATA;
      }
      
      public function updateAndShootAgain() : void
      {
         this.updateCurrentRound();
         asset.bannerMC.playing.visible = true;
         this._optionSelectedRemote = false;
         this._optionSelectedLocal = false;
         this._spellSmashingLocal = false;
         this._normalFight = false;
         this._spellSmashingRemote = false;
         this._spellSmashingLocalDATA = 0;
         this._spellSmashingRemoteDATA = 0;
         this.startTimer();
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
                  this._myhalloweenTeam = param4[0];
               }
               else
               {
                  this._enemyhalloweenTeam = param4[0];
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
               break;
            case "imReady":
               this.onReceiveReady(param2.avatarId);
               if(_loc5_)
               {
                  this._myhalloweenTeam = param4[0];
               }
               else
               {
                  this._enemyhalloweenTeam = param4[0];
                  asset.bannerMC.waiting.avatar_2_flag.gotoAndStop(this._enemyhalloweenTeam);
               }
               if(!_loc5_ && !this._remoteAssetLoaded)
               {
                  this.sendReady();
                  break;
               }
               break;
            case "quit":
               if(!_loc5_)
               {
                  this.onGameOver(this._team);
                  break;
               }
               break;
            case "spellSmashing":
               this.spellSmashingResult(_loc5_,param4);
               break;
            case "shooting":
               this.processShooting(_loc5_,param4);
               break;
            case "gameOver":
         }
      }
      
      private function startGame() : void
      {
         this._timer = new Timer(0,300);
         api.trackEvent("FEATURES:HALLOWEEN2017:DUELOMAGIA:STATUS_PARTIDO","EMPEZADO");
         this._alive = true;
         this.startTimer();
      }
      
      protected function get globalAssetLoaded() : Boolean
      {
         return this._localAssetLoaded && this._remoteAssetLoaded;
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
      
      private function spellSmashingResult(param1:Boolean, param2:Array) : void
      {
         asset.bannerMC.spellSmash.visible = false;
         if(param1)
         {
            this._spellSmashingLocal = true;
            this._spellSmashingLocalDATA = param2[0];
         }
         else
         {
            this._spellSmashingRemote = true;
            this._spellSmashingRemoteDATA = param2[0];
         }
         if(this._spellSmashingLocal && this._spellSmashingRemote)
         {
            this._spellSmashing = false;
         }
      }
      
      private function darPaqueteFigusRusia() : void
      {
         if(Boolean(this._team) && Boolean(this._winner) && this._team == this._winner)
         {
            setTimeout(function():void
            {
               api.instantiateBannerModal("HalloweenBoosterRewardBanner");
            },1000);
         }
      }
      
      public function get normalFight() : Boolean
      {
         return this._normalFight;
      }
      
      public function get optionSelectedDataLocal() : String
      {
         return this._optionSelectedDataLocal;
      }
      
      public function get timeToAnimate() : Boolean
      {
         return this._timeToAnimate;
      }
      
      public function getEnemyAvatarOnScene() : Gaturro
      {
         return (asset.bannerMC.avatar2 as MovieClip).getChildAt(0) as Gaturro;
      }
      
      public function set spellSmashing(param1:Boolean) : void
      {
         this._spellSmashing = param1;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._finalCountingServerTime = api.serverTime;
         var _loc2_:int = (this._finalCountingServerTime - this._startCountingServerTime) * (asset.bannerMC.playing.mcTimer as MovieClip).totalFrames / KILL_SWICHT_SELECTION_IN_MS;
         if(Math.abs(this._finalCountingServerTime - this._startCountingServerTime) > KILL_SWICHT_SELECTION_IN_MS)
         {
            this.idleOptionSelected(null);
         }
         asset.bannerMC.playing.mcTimer.gotoAndStop(_loc2_);
      }
      
      protected function getOpositeTeam() : String
      {
         return this._team == TEAM_A ? TEAM_B : TEAM_A;
      }
      
      private function addListen() : void
      {
         (asset.bannerMC.playing.ataque0 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.ataque1 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.ataque2 as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing.ataque0 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.ataque1 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.ataque2 as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing.ataque2 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.ataque0 as MovieClip).buttonMode = true;
         (asset.bannerMC.playing.ataque1 as MovieClip).buttonMode = true;
      }
      
      private function smashTime() : void
      {
         this._serverTimeInit = api.serverTime;
         this._smashTimer = new Timer(0,700);
         this._smashingResult = 0;
         this._smashTimer.addEventListener(TimerEvent.TIMER,this.serverTimeChecker);
         this._smashTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.completeSmashing);
         this._smashTimer.reset();
         this._smashTimer.start();
      }
      
      public function getMyAvatarOnScene() : Gaturro
      {
         return (asset.bannerMC.avatar1 as MovieClip).getChildAt(0) as Gaturro;
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
      
      private function update(param1:Event) : void
      {
      }
      
      private function countClicks(param1:MouseEvent) : void
      {
         ++this._smashingResult;
      }
      
      private function passportBonusCheck() : void
      {
         asset.bannerMC.playerOneStart.live3.visible = false;
         asset.bannerMC.playerTwoStart.live3.visible = false;
         if(avatarDataMe.isCitizen)
         {
            asset.bannerMC.playerOneStart.live3.visible = true;
            this._myLives = 3;
         }
         if(avatarDataMate.isCitizen)
         {
            asset.bannerMC.playerTwoStart.live3.visible = true;
            this._enemyLives = 3;
         }
      }
      
      private function spellSmashFight() : void
      {
         this._spellSmashing = true;
         this.smashTime();
         asset.addEventListener(MouseEvent.CLICK,this.countClicks);
      }
      
      private function onQuit(param1:MouseEvent) : void
      {
         asset.bannerMC.close.removeEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
         this.close();
      }
      
      override protected function displayElement(param1:DisplayObject) : void
      {
         super.displayElement(param1);
         addChild(param1);
         api.freeze();
         this._optionSelectedRemote = false;
         this._optionSelectedLocal = false;
         this._normalFight = false;
         this._spellSmashing = false;
         this.passportBonusCheck();
         complete();
         asset = MovieClip(param1);
         this._view = new com.qb9.gaturro.view.components.banner.peleaMagia.PeleaMagiaView(asset,this);
         this._view.init();
         this.avatarsNames(avatarDataMe,avatarDataMate);
         this.avatarsImages(avatarDataMe,avatarDataMate);
         this._serverTime = new Date(api.serverTime);
         this.sendAssetLoaded();
         this.addListen();
         asset.bannerMC.close.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
      }
      
      private function completeSmashing(param1:TimerEvent) : void
      {
         this._smashTimer.stop();
         this._smashTimer.removeEventListener(TimerEvent.TIMER,this.serverTimeChecker);
         this._smashTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.completeSmashing);
         this.send("spellSmashing",this._smashingResult.toString());
      }
      
      public function get optionSelectedDataRemote() : String
      {
         return this._optionSelectedDataRemote;
      }
      
      private function serverTimeChecker(param1:TimerEvent) : void
      {
         this._serverTimeFinal = api.serverTime;
         if(Math.abs(this._serverTimeFinal - this._serverTimeInit) > KILL_SWICHT_IN_MS)
         {
            this.completeSmashing(null);
         }
      }
      
      public function get spellSmashing() : Boolean
      {
         return this._spellSmashing;
      }
      
      private function processShooting(param1:Boolean, param2:Array) : void
      {
         this._timeToAnimate = true;
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
               this.spellSmashFight();
            }
            else
            {
               this._normalFight = true;
               if(this.spellResolveWinner(this._optionSelectedDataLocal,this._optionSelectedDataRemote))
               {
               }
            }
            this._view.startAnimate();
         }
      }
      
      protected function onGameOver(param1:String) : void
      {
         this._gameOver = true;
         this._winner = param1;
         this.buildWinnerScreen(param1);
         asset.bannerMC.winner.visible = true;
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
      
      protected function sendReady() : void
      {
         this.send("imReady",api.getProfileAttribute("team_halloween2017") as String);
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
      param1.attributes.transport = " ";
      _attributes = param1.attributes.clone(this);
   }
}
