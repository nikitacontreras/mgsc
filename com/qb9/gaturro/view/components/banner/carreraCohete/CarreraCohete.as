package com.qb9.gaturro.view.components.banner.carreraCohete
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.util.SeedRandom;
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
   
   public class CarreraCohete extends InteractionGuiModal
   {
      
      public static const TEAM_B:String = "b";
      
      private static const KILL_SWICHT_METEORITO_IN_MS:Number = 14000;
      
      private static const KILL_SWICHT_IN_MS:Number = 10000;
      
      public static const ALLOWED_MAX_TIME_SERVER_BASE:Number = 15000;
      
      private static const KILL_SWICHT_SELECTION_IN_MS:Number = 1500;
      
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
      
      private var _seed:uint;
      
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
      
      private var _view:com.qb9.gaturro.view.components.banner.carreraCohete.CarreraCoheteView;
      
      private var _spellSmashingLocalDATA:int;
      
      private var _timeToAnimate:Boolean;
      
      private var _normalFight:Boolean;
      
      private var _timer2:Timer;
      
      private var _imFirst:Boolean;
      
      private var _alive:Boolean = false;
      
      private var _spellSmashing:Boolean;
      
      private var _myhalloweenTeam:String = "";
      
      private var _random:SeedRandom;
      
      private var _spellSmashingLocal:Boolean;
      
      private var myAccountId:String;
      
      private var _sprintDuration:Number = 2500;
      
      private var _spellSmashingRemote:Boolean;
      
      private var _serverTimeInit:Number;
      
      public function CarreraCohete(param1:GaturroRoom, param2:String, param3:Function, param4:String)
      {
         room = param1;
         prefix = param2;
         sendOperationFunc = param3;
         bannerName = param4;
         super(param1,param2,param3,param4);
         this.myAccountId = api.user.accountId;
         initPopup();
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
      
      private function startTimer() : void
      {
         this._startCountingServerTime = api.serverTime;
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         this._timer.reset();
         this._timer.start();
      }
      
      public function resultOfMeteorito(param1:int) : void
      {
         if(!this._optionSelectedLocal)
         {
            this.sendShooting(this.meteoroToScore(param1));
            this.endTimer2();
         }
      }
      
      private function updateCurrentRound() : void
      {
         if(!this._gameOver)
         {
            if(this._view.winnerAvatar1)
            {
               this.onGameOver(this._team);
               this._gameOver = true;
               this._view.endMeteorito();
               asset.bannerMC.playing.visible = false;
               asset.bannerMC.helpAccel.visible = false;
            }
            else if(this._view.winnerAvatar2)
            {
               this.onGameOver(this.getOpositeTeam());
               this._gameOver = true;
               this._view.endMeteorito();
               asset.bannerMC.playing.visible = false;
               asset.bannerMC.helpAccel.visible = false;
            }
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
      
      private function sendShooting(param1:String) : void
      {
         this.send("shooting",param1);
      }
      
      protected function onReady() : void
      {
         if(avatarDataMe.avatarId > avatarDataMate.avatarId)
         {
            this.send("imFirst",this.myAccountId.toString());
         }
      }
      
      private function meteoroToScore(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "miss2";
            case 1:
               return "regular";
            case 2:
               return "good";
            case 3:
               return "very_good";
            case 4:
               return "perfect";
            default:
               return "";
         }
      }
      
      private function buildWinnerScreen(param1:String) : void
      {
         var _loc2_:int = 0;
         if(asset.bannerMC.winner.avatar1)
         {
            asset.bannerMC.winner.avatar1.addChild(characterMe);
         }
         if(asset.bannerMC.winner.avatar2)
         {
            asset.bannerMC.winner.avatar2.addChild(characterMate);
         }
         api.playSound("misionEspacial2017/finCarrera");
         asset.addEventListener(Event.ENTER_FRAME,this.outtro);
         asset.bannerMC.fxAvatar1.visible = false;
         asset.bannerMC.fxAvatar2.visible = false;
         if(this._team == param1)
         {
            characterMate.gotoAndPlay("rayos");
            api.playSound("win");
            asset.bannerMC.winner.showPoints.gotoAndStop("win");
            _loc2_ = (api.getProfileAttribute("puntosEspaciales") as int) + 1;
            api.setProfileAttribute("puntosEspaciales",_loc2_);
            api.levelManager.addCompetitiveExp(20);
         }
         else
         {
            asset.bannerMC.winner.showPoints.gotoAndStop("lose");
            api.playSound("lose");
            characterMe.gotoAndPlay("rayos");
         }
      }
      
      private function spellFighting() : void
      {
      }
      
      private function idleOptionSelected(param1:TimerEvent) : void
      {
         if(!this._gameOver)
         {
            this.endTimer();
            asset.bannerMC.playing.visible = false;
            asset.bannerMC.helpAccel.visible = false;
            this.KSsendShooting();
         }
      }
      
      override public function dispose() : void
      {
         if(this._view)
         {
            this._view.dispose();
         }
         asset.removeEventListener(Event.ENTER_FRAME,this.outtro);
         asset.removeEventListener(Event.ENTER_FRAME,this.update);
         api.unfreeze();
         super.dispose();
      }
      
      private function endTimer() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.idleOptionSelected);
         this._timer.stop();
         this._timer.reset();
      }
      
      public function get gameOver() : Boolean
      {
         return this._gameOver;
      }
      
      override protected function avatarsNames(param1:Avatar, param2:Avatar) : void
      {
         if(asset)
         {
            asset.bannerMC.user_name_gui_1.textMC.text = param1.username;
            asset.bannerMC.user_name_gui_2.textMC.text = param2.username;
         }
         if(Boolean(param1) && Boolean(param2) && Boolean(this._team))
         {
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
      
      private function labelToScore(param1:String) : int
      {
         api.playSound("snake_nivel");
         switch(param1)
         {
            case "perfect":
               return 100;
            case "very_good":
               return 75;
            case "good":
               return 60;
            case "regular":
               return 50;
            case "miss":
               return 30;
            case "miss2":
               return 0;
            default:
               return 0;
         }
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
      
      private function endTimer2() : void
      {
         this._timer2.removeEventListener(TimerEvent.TIMER,this.onTimer2);
         this._timer2.stop();
         this._timer2.reset();
      }
      
      private function optionChosen(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         this.endTimer();
         if(!this._optionSelectedLocal)
         {
            _loc2_ = (param1.target.mcTimer as MovieClip).currentLabel;
            asset.bannerMC.playing.visible = false;
            asset.bannerMC.helpAccel.visible = false;
            this.sendShooting(_loc2_);
         }
      }
      
      private function onTimer2(param1:TimerEvent) : void
      {
         this._finalCountingServerTime = api.serverTime;
         if(Math.abs(this._finalCountingServerTime - this._startCountingServerTime) > KILL_SWICHT_METEORITO_IN_MS)
         {
            this.resultOfMeteorito(0);
         }
      }
      
      private function speedUpGame() : void
      {
         asset.bannerMC.playing.visible = true;
         asset.bannerMC.helpAccel.visible = true;
      }
      
      override protected function avatarsImages(param1:Avatar, param2:Avatar) : void
      {
         characterMe = new Gaturro(new Holder(param1));
         if(Boolean(asset.bannerMC.avatar1) && (asset.bannerMC.avatar1 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.avatar1.addChild(characterMe);
         }
         else
         {
            (asset.bannerMC.avatar1 as MovieClip).removeChildAt(0);
            asset.bannerMC.avatar1.addChild(characterMe);
         }
         characterMate = new Gaturro(new Holder(param2));
         if(Boolean(asset.bannerMC.avatar2) && (asset.bannerMC.avatar2 as MovieClip).numChildren == 0)
         {
            asset.bannerMC.avatar2.addChild(characterMate);
         }
         else
         {
            (asset.bannerMC.avatar2 as MovieClip).removeChildAt(0);
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
         this.selectGameToplay();
         this._optionSelectedRemote = false;
         this._optionSelectedLocal = false;
         this._spellSmashingLocal = false;
         this._normalFight = false;
         this._spellSmashingRemote = false;
         this._spellSmashingLocalDATA = 0;
         this._spellSmashingRemoteDATA = 0;
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
                  this.avatarsImages(avatarDataMe,avatarDataMate);
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
      
      private function KSsendShooting(param1:String = "miss2") : void
      {
         if(!this._optionSelectedLocal)
         {
            this.send("shooting",param1);
         }
      }
      
      private function startGame() : void
      {
         this._timer = new Timer(0,400);
         this._timer2 = new Timer(0,1000000);
         api.trackEvent("FEATURES:CARRERAESPACIAL2017:CARRERAS","EMPEZADO");
         this._alive = true;
         this._view.setupShips();
         this.startTimer();
         this.introTheGame();
         this.speedUpGame();
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
      
      private function idleOptionSelected2(param1:TimerEvent) : void
      {
         if(this._gameOver)
         {
         }
      }
      
      private function startTimer2() : void
      {
         this._startCountingServerTime = api.serverTime;
         this._timer2.addEventListener(TimerEvent.TIMER,this.onTimer2);
         this._timer2.reset();
         this._timer2.start();
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
      
      private function outtro(param1:Event) : void
      {
         if(this._winner == this._team)
         {
            asset.bannerMC.avatar2.scaleX = asset.bannerMC.avatar2.scaleY = asset.bannerMC.avatar2.scaleY * 0.99;
            asset.bannerMC.avatar2.rotation += 0.2;
            if(asset.bannerMC.avatar2.scaleX < 0.01)
            {
            }
         }
         else
         {
            asset.bannerMC.avatar1.scaleX = asset.bannerMC.avatar1.scaleY = asset.bannerMC.avatar1.scaleY * 0.99;
            asset.bannerMC.avatar1.rotation += 0.2;
            if(asset.bannerMC.avatar1.scaleX < 0.01)
            {
            }
         }
         asset.bannerMC.outroFlag.x -= 15;
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
      
      private function meteorosGame() : void
      {
         this._view.meteorosComming();
      }
      
      public function set spellSmashing(param1:Boolean) : void
      {
         this._spellSmashing = param1;
      }
      
      protected function getOpositeTeam() : String
      {
         return this._team == TEAM_A ? TEAM_B : TEAM_A;
      }
      
      private function addListen() : void
      {
         (asset.bannerMC.playing as MovieClip).mouseChildren = false;
         (asset.bannerMC.playing as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,this.optionChosen);
         (asset.bannerMC.playing as MovieClip).buttonMode = true;
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
      
      private function update(param1:Event) : void
      {
         if(!this._gameOver)
         {
            this.updateCurrentRound();
         }
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
         this._view = new com.qb9.gaturro.view.components.banner.carreraCohete.CarreraCoheteView(asset,this);
         this._view.init();
         this.avatarsNames(avatarDataMe,avatarDataMate);
         this._serverTime = new Date(api.serverTime);
         this.sendAssetLoaded();
         this.addListen();
         api.playSound("atico2017/musicaAtico");
         this._seed = avatarDataMe.id + avatarDataMate.id;
         this._random = new SeedRandom(this._seed);
         asset.bannerMC.playing.visible = false;
         asset.bannerMC.helpAccel.visible = false;
         asset.addEventListener(Event.ENTER_FRAME,this.update);
         asset.bannerMC.close.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
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
      
      private function countClicks(param1:MouseEvent) : void
      {
         ++this._smashingResult;
      }
      
      private function selectGameToplay() : void
      {
         if(!this._gameOver)
         {
            this._serverTimeInit = api.serverTime;
            if(this._random.boolean())
            {
               this.startTimer();
               this.speedUpGame();
            }
            else
            {
               this.startTimer2();
               this.meteorosGame();
            }
         }
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
            this._view.speedUpP1 = this.labelToScore(this._optionSelectedDataLocal);
            this._view.speedUpP2 = this.labelToScore(this._optionSelectedDataRemote);
            asset.bannerMC.fxAvatar1.visible = true;
            asset.bannerMC.fxAvatar2.visible = true;
            asset.bannerMC.fxAvatar1.gotoAndStop(this._optionSelectedDataLocal);
            asset.bannerMC.fxAvatar2.gotoAndStop(this._optionSelectedDataRemote);
            asset.bannerMC.fxAvatar2.mc.gotoAndPlay(0);
            asset.bannerMC.fxAvatar1.mc.gotoAndPlay(0);
            if(this._optionSelectedDataLocal != "miss" && this._optionSelectedDataLocal != "miss2")
            {
               api.playSound("misionEspacial2017/agujaAcelerador");
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
         api.trackEvent("FEATURES:CARRERAESPACIAL2017:CARRERAS","TERMINADO");
      }
      
      private function introTheGame() : void
      {
         asset.bannerMC.startIntro.gotoAndPlay(0);
         asset.bannerMC.startIntro2.gotoAndPlay(0);
      }
      
      override public function close() : void
      {
         if(!this._gameOver)
         {
            this._gameOver = true;
            this.send("quit","");
         }
         super.close();
      }
      
      protected function sendReady() : void
      {
         this.send("imReady","");
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
