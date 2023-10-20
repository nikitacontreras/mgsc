package com.qb9.gaturro.view.world
{
   import assets.*;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.audio.GaturroAudioPlayer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.GaturroLibraries;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.service.events.roomviews.GatubersRoomView;
   import com.qb9.gaturro.service.events.roomviews.PartyRoomView;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.view.minigames.MinigameView;
   import com.qb9.gaturro.view.minigames.MultiplayerMinigameView;
   import com.qb9.gaturro.view.screens.GaturroLoadingScreen;
   import com.qb9.gaturro.view.world.rooms.PistaPatinRoomView;
   import com.qb9.gaturro.view.world.rooms.PruebasRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.GaturroWorld;
   import com.qb9.gaturro.world.minigames.Minigame;
   import com.qb9.gaturro.world.minigames.MultiplayerMinigame;
   import com.qb9.gaturro.world.minigames.events.MinigameEvent;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.view.loading.BaseLoadingScreen;
   import com.qb9.mambo.view.world.WorldView;
   import com.qb9.mambo.world.core.Room;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class GaturroWorldView extends WorldView
   {
      
      public static const READY_GAME_EVENT:String = "READY_GAME_EVENT";
       
      
      private var timeOutId:uint;
      
      private var loadingData:Object;
      
      private var tasks:TaskRunner;
      
      private var minigame:MinigameView;
      
      private var audio:GaturroAudioPlayer;
      
      private var roomChangeDelay:int = 0;
      
      private var userSettingsBtn:MovieClip;
      
      public function GaturroWorldView(param1:GaturroWorld, param2:GaturroLoadingScreen)
      {
         this.loading = param2;
         super(param1);
         this.init();
      }
      
      private function disposeMinigame(param1:Event = null) : void
      {
         var e:Event = param1;
         if(this.minigame)
         {
            SoundMixer.stopAll();
            this.minigame.dispose();
            DisplayUtil.remove(this.minigame);
            this.minigame = null;
            this.audio.resume();
            setTimeout(function():void
            {
               SoundMixer.soundTransform = new SoundTransform(audio.masterVolume);
            },1000);
         }
      }
      
      private function initEvents() : void
      {
         world.addEventListener(MinigameEvent.CREATED,this.createMinigame);
      }
      
      public function checkHelpForNewie() : void
      {
         if(Boolean(settings.tutorial.enabled) || Boolean(settings.tutorial.autoLauch))
         {
            return;
         }
         if(!api.user.attributes.quest || api.user.attributes.quest == "")
         {
            api.setProfileAttribute("quest","read");
            this.timeOutId = setTimeout(this.showHelp,2000);
         }
      }
      
      private function init() : void
      {
         this.initEvents();
         this.tasks = new TaskRunner(this);
         this.tasks.start();
         this.audio = audio;
         this.audio.setTasks(this.tasks);
         libs = new GaturroLibraries(this);
      }
      
      override protected function disposeRoom(param1:Event = null) : void
      {
         super.disposeRoom(param1);
      }
      
      private function showHelp(param1:Event = null) : void
      {
         clearTimeout(this.timeOutId);
         if(api.room.isFarmRoom)
         {
            api.showBannerModal("tutorialGranjaBLOG");
         }
         else
         {
            api.showBannerModal("tutorial",null);
         }
      }
      
      override public function dispose() : void
      {
         this.audio.dispose();
         this.audio = null;
         this.disposeMinigame();
         this.tasks.dispose();
         this.tasks = null;
         libs.dispose();
         libs = null;
         super.dispose();
      }
      
      override protected function whenRoomIsReady(param1:Event) : void
      {
         super.whenRoomIsReady(param1);
         this.dispatchEvent(new Event(READY_GAME_EVENT));
         this.checkHelpForNewie();
      }
      
      private function createMinigame(param1:MinigameEvent) : void
      {
         var _loc2_:Boolean = this.audio.music;
         var _loc3_:Minigame = param1.minigame;
         _loc3_.addEventListener(MinigameEvent.STARTED,disposeLoading);
         _loc3_.addEventListener(MinigameEvent.FINISHED,this.disposeMinigame);
         this.minigame = _loc3_ is MultiplayerMinigame ? new MultiplayerMinigameView(_loc3_) : new MinigameView(_loc3_);
         addChildAt(this.minigame,0);
         this.audio.pauseRoomSounds();
         var _loc4_:UserSettings = Context.instance.getByType(UserSettings) as UserSettings;
         logger.debug(this,"has Music",_loc4_.getValue(UserSettings.MUSIC_KEY));
         if(!_loc2_)
         {
            logger.debug(this,"sound to 0");
            SoundMixer.soundTransform = new SoundTransform(0);
         }
         setLoading();
      }
      
      private function get gWorld() : GaturroWorld
      {
         return world as GaturroWorld;
      }
      
      override protected function createLoadingScreen() : BaseLoadingScreen
      {
         this.loadingData = {};
         this.loadingData.nextRoom = (world as GaturroWorld).nextRoom;
         var _loc1_:Boolean = !!api ? !api.isDesktop : false;
         return new GaturroLoadingScreen(_loc1_,this.loadingData);
      }
      
      private function changeQuality(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         stage.quality = String(param1.data);
      }
      
      override protected function createRoomView(param1:Room) : DisplayObject
      {
         var _loc2_:String = String(param1.attributes.ambience);
         var _loc3_:String = String(param1.attributes.tracks);
         this.audio.addRoomSounds(_loc2_,!!_loc3_ ? _loc3_.split(",") : []);
         var _loc4_:GaturroRoom = param1 as GaturroRoom;
         var _loc5_:InfoReportQueue = this.gWorld.reports;
         var _loc6_:GaturroMailer = this.gWorld.mailer;
         var _loc7_:WhiteListNode = this.gWorld.iphoneWhitelist;
         if(TutorialManager.isRoomTutoriable(_loc4_))
         {
            if(param1.ownedByUser)
            {
               return new GaturroTutorialHomeView(_loc4_,_loc5_,_loc6_,_loc7_);
            }
            return new GaturroTutorialRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.isFarmRoom)
         {
            return new GaturroHomeGranjaView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.isRoofRoom)
         {
            return new GaturroHomeRoofView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "bossRoom")
         {
            return new GaturroBossRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "barEspacial")
         {
            return new GaturroSpaceBarRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "gatoons")
         {
            return new GaturroGatoonsRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "camugataEntrance")
         {
            return new GaturroCamugataFightRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "hospital")
         {
            return new HospitalRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "proposal")
         {
            return new ProposalRoomView(_loc4_.attributes.proposalFeature,_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "parqueDiversiones")
         {
            return new ParqueDiversionesRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "loveTunnel")
         {
            return new LoveTunnelRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "tunelFantastico")
         {
            return new FantasticTunnelRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "noria")
         {
            return new NoriaRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "caminataLunar")
         {
            return new CaminataLunarRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "escenarioVip")
         {
            return new EscenarioRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "backstageVip")
         {
            return new BackstageRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "party")
         {
            return new PartyRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "partyTest")
         {
            return new PartyRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "antro2017")
         {
            return new AntroRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "salaEnsayo")
         {
            return new SalaEnsayoRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "cineGatuber")
         {
            return new CineGatuberRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "convencionGatuber")
         {
            return new ConvencionGatuberRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "roomGatube")
         {
            return new GatubersRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "serenito2017")
         {
            return new SerenitoRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "pistaHielo")
         {
            return new PistaPatinRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "pruebas")
         {
            return new PruebasRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "torneo2017")
         {
            return new TorneoRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "guerraNieve")
         {
            return new GaturroGuerraDeNieveRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "estacionSubte")
         {
            return new EstacionSubteRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "subway")
         {
            return new SubwayRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "cableway")
         {
            return new CablewayRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "cablewayStation")
         {
            return new CablewayStationRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "bocaBus")
         {
            return new BocaBusRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "swimmingPool")
         {
            return new SwimmingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "atlantisSwimming")
         {
            return new SwimmingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_,true);
         }
         if(_loc4_.attributes.roomType == "alwaysDancing")
         {
            return new DancingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "surfing")
         {
            return new SurfingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "islandBridge")
         {
            return new IslandBridgeRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "easter")
         {
            return new EasterRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "easterMatch")
         {
            return new EasterMatchingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "hairdressing")
         {
            return new HairDressingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "superClasico")
         {
            return new SuperClasicoRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "doorBreaking")
         {
            return new DoorBreakingRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "CamuGata")
         {
            return new CamuGataRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "regalosBoss")
         {
            return new RegalosBossRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "campamentoNoche")
         {
            return new CampamentoNocheRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "nursery")
         {
            return new NoScrollRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "noScrol")
         {
            return new NoScrollRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "singleplayer")
         {
            return new SinglePlayerRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "proyectoGatuber")
         {
            return new ProyectoGatuberRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.hasOwner)
         {
            return new GaturroHomeView(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         if(_loc4_.attributes.roomType == "test")
         {
            return new TestRoomView(_loc4_,this.tasks,_loc5_,_loc6_,_loc7_);
         }
         return new GaturroRoomView(_loc4_,_loc5_,_loc6_,_loc7_);
      }
   }
}
