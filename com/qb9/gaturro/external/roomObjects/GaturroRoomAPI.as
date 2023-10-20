package com.qb9.gaturro.external.roomObjects
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.logs.Logger;
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.constraint.ConstraintManifest;
   import com.qb9.gaturro.external.base.BaseGaturroAPI;
   import com.qb9.gaturro.globals.achievements;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.cards;
   import com.qb9.gaturro.globals.gatucine;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.parties;
   import com.qb9.gaturro.globals.quest;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.socialNet;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.level.LevelManager;
   import com.qb9.gaturro.manager.cinema.CinemaManager;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.manager.movement.MovementManager;
   import com.qb9.gaturro.manager.team.Team;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.manager.team.feature.OlympicTeamManager;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.multiplayer.GaturroMultiplayerManager;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.net.requests.texts.textValidationActionRequest;
   import com.qb9.gaturro.service.catalog.CatalogCarouselService;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.pocket.PocketServiceManager;
   import com.qb9.gaturro.socialnet.SocialNet;
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.util.SeedRandom;
   import com.qb9.gaturro.util.TimeSpan;
   import com.qb9.gaturro.util.advertising.EPlanning;
   import com.qb9.gaturro.util.advertising.EPlanningEvent;
   import com.qb9.gaturro.util.flights.FlightInjectorManager;
   import com.qb9.gaturro.util.giftcodes.Campaign;
   import com.qb9.gaturro.util.giftcodes.CampaignFactory;
   import com.qb9.gaturro.view.gui.banner.BannerModalEvent;
   import com.qb9.gaturro.view.gui.fishing.FishingGuiModalEvent;
   import com.qb9.gaturro.view.gui.gift.GiftReceiverGuiModalEvent;
   import com.qb9.gaturro.view.gui.granja.CropTimerModalEvent;
   import com.qb9.gaturro.view.gui.granja.FarmRequest;
   import com.qb9.gaturro.view.gui.granja.GranjaLevelUpEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaModalEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaParcelaUnlockEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaSellingModalEvent;
   import com.qb9.gaturro.view.gui.granja.SiloModalEvent;
   import com.qb9.gaturro.view.gui.image.ImageModalEvent;
   import com.qb9.gaturro.view.gui.map.RankingModalEvent;
   import com.qb9.gaturro.view.gui.news.NewsPageFactory;
   import com.qb9.gaturro.view.gui.sell.SellItemGuiModalEvent;
   import com.qb9.gaturro.view.world.GaturroHomeView;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.avatars.GaturroUserAvatarView;
   import com.qb9.gaturro.view.world.avatars.SwimmingTiledGaturro.SwimmingGaturroAvatarView;
   import com.qb9.gaturro.view.world.misc.AntiGravityManager;
   import com.qb9.gaturro.view.world.movement.MovementsEnum;
   import com.qb9.gaturro.world.achievements.AchievManager;
   import com.qb9.gaturro.world.cards.CardsManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import com.qb9.gaturro.world.minigames.rewards.points.PointsMinigameReward;
   import com.qb9.gaturro.world.parties.PartiesManager;
   import com.qb9.gaturro.world.quest.QuestManager;
   import com.qb9.gaturro.world.zone.Timezone;
   import com.qb9.gaturro.world.zone.Weather;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.RoomChat;
   import com.qb9.mambo.net.library.Libraries;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mines.mobject.Mobject;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.printing.PrintJob;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public final class GaturroRoomAPI extends BaseGaturroAPI implements IDisposable, ICatalogInteractive
   {
       
      
      private var callbackPetState:Function;
      
      private var _fps:int;
      
      private var _gatupackRequest:PocketServiceManager;
      
      private var notificationManager:NotificationManager;
      
      private var eplanningDic:Dictionary;
      
      public var userTrapped:Boolean = false;
      
      private var shopImageLoader:Loader;
      
      private var idleObjects:Object;
      
      private var callbackGiftCode:Function;
      
      public var view:GaturroRoomView;
      
      private var timeAux:int;
      
      private var eventService:EventsService;
      
      private var _alreadyHas:Function;
      
      private var flyInjector:FlightInjectorManager;
      
      private var validateTextCallback:Function;
      
      private var sceneObjects:TwoWayLink;
      
      private var loadedConfigCallback:Function;
      
      private var constraintManager:ConstraintManager;
      
      private var _onFailure:Function;
      
      private var lastUserAchievements:String;
      
      public var canIRobTrolls:Boolean = false;
      
      private var cacheConfig:Dictionary;
      
      private var shopImageCallback:Function;
      
      private var _onCompleted:Function;
      
      public var levelManager:LevelManager;
      
      public var canIRobPapapas:Boolean = false;
      
      private var prevTime:int = 0;
      
      private var uSettings:UserSettings;
      
      private var _room:GaturroRoom;
      
      private var loadedConfigFile:Settings;
      
      public var sanValentinResult:int;
      
      private var _prodID:uint;
      
      private var lastGiftCode:String;
      
      public function GaturroRoomAPI(param1:GaturroRoom, param2:GaturroRoomView, param3:TwoWayLink)
      {
         this.eplanningDic = new Dictionary(true);
         super();
         this._room = param1;
         this.view = param2;
         this.sceneObjects = param3;
         this.startFPSCalculate();
         this.idleObjects = new Object();
         if(!Context.instance.hasByType(ConstraintManager))
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedManager);
         }
         else
         {
            this.setupConstraintManager();
         }
         this.setupLevelManager();
      }
      
      public function set showUsersNames(param1:Boolean) : void
      {
         this.view.showUserNames = param1;
      }
      
      public function setTutorialCoins() : int
      {
         trace("GaturroRoomAPI > setTutorialCoins > int(getProfileAttribute(coins))");
         setProfileAttribute("system_coins",3000);
         return 3000;
      }
      
      public function isCraftRewardMaterialAvailable(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         return _loc3_.isMaterialRewardAvailable(param1,param2);
      }
      
      public function repairRoom() : void
      {
         this.roomView.repairRoom();
      }
      
      private function requestCurrentShopPNG(param1:Event) : void
      {
         this.shopImageLoader = new Loader();
         this.shopImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.deliverCurrentShopImage);
         var _loc2_:URLRequest = new URLRequest(this._gatupackRequest.requestedData[0].path);
         var _loc3_:LoaderContext = new LoaderContext();
         _loc3_.checkPolicyFile = true;
         this.shopImageLoader.load(_loc2_,_loc3_);
      }
      
      private function onAddedManager(param1:ContextEvent) : void
      {
         if(param1.instanceType == ConstraintManager)
         {
            this.setupConstraintManager();
         }
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : void
      {
         tracker.event(param1,param2,param3,param4);
         Telemetry.getInstance().trackEvent(param1,param2,param3,param4);
         logger.info("API: track event: ",param1,param2,param3);
      }
      
      public function clothAvailableOnRoom(param1:Object, param2:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:CustomAttributeHolder = null;
         var _loc3_:Boolean = false;
         if(param1 is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(param1[_loc4_] == this.room.id)
               {
                  _loc3_ = true;
               }
               _loc4_++;
            }
         }
         else if(param1 is int)
         {
            if(param1 == this.room.id)
            {
               _loc3_ = true;
            }
         }
         if(!_loc3_)
         {
            api.setAvatarAttribute(param2,"");
            (_loc5_ = new Holder(this.userAvatar)).attributes[param2] = "";
            this.userAvatar.attributes.merge(_loc5_.attributes);
         }
      }
      
      private function setupConstraintManager() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedManager);
         this.constraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
         this.constraintManager.manifest = new ConstraintManifest();
      }
      
      public function avatarHowManyObject(param1:String) : int
      {
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         if(!user)
         {
            return _loc2_;
         }
         var _loc3_:Array = user.allItems as Array;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.name == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function isEventRunning() : Boolean
      {
         return this.isPartyRunning();
      }
      
      public function startUnityMinigame(param1:String, param2:Number = 0, param3:Coord = null, param4:Object = null) : void
      {
         setTimeout(this.room.startUnityMinigame,10,param1,param2,param3,param4);
      }
      
      public function codeCampaign(param1:String) : Campaign
      {
         if(param1 == "jumbo")
         {
            return CampaignFactory.codeCampaignJumbo();
         }
         return CampaignFactory.createCampaign(param1);
      }
      
      public function dispose() : void
      {
         var _loc1_:Object = null;
         this.stopFPSCalculate();
         this._room = null;
         this.sceneObjects = null;
         this.view = null;
         for each(_loc1_ in this.idleObjects)
         {
            if("dispose" in _loc1_)
            {
               _loc1_.dispose();
            }
         }
         this.idleObjects = null;
         this.callbackGiftCode = null;
         this.eplanningDic = null;
      }
      
      public function openPepionCatalog(param1:String) : void
      {
         this.room.openPepionCatalog(param1);
      }
      
      public function set userSettings(param1:UserSettings) : void
      {
         this.uSettings = param1;
      }
      
      public function craftRewardMaterialGranted(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         return _loc3_.isRewardMaterialGranted(param1,param2);
      }
      
      private function fpsTick(param1:Event) : void
      {
         this.timeAux = getTimer();
         this._fps = 1000 / (this.timeAux - this.prevTime);
         this.prevTime = getTimer();
      }
      
      public function get roomView() : GaturroRoomView
      {
         return this.view;
      }
      
      public function showPhotoNoPicapon() : void
      {
         this.view.showPhoto(new Bitmap(this.roomView.captureScene()));
      }
      
      public function registerSound(param1:String, param2:String = null) : void
      {
         if(!this.hasSound(param1))
         {
            audio.register(param1,param2).start();
         }
      }
      
      public function hasPassportType(param1:String) : Boolean
      {
         if(!api.user.isCitizen)
         {
            return false;
         }
         switch(param1)
         {
            case "boca":
               return this.accomplishById("bocaMember") || this.isVipBoca3Dias();
            case "river":
               return this.accomplishById("riverMember") || this.isVipRiver3Dias();
            default:
               return false;
         }
      }
      
      public function buyGranjaRoom() : void
      {
         (this.view as GaturroHomeView).triggerGranjaBuy();
      }
      
      public function get isCharcoActive() : Boolean
      {
         return Weather.isCharcoActive;
      }
      
      public function avatarViewCopy(param1:String) : Gaturro
      {
         var _loc2_:Avatar = this.room.avatarByUsername(param1);
         if(!_loc2_)
         {
            return null;
         }
         return new Gaturro(new Holder(_loc2_));
      }
      
      public function stopSound(param1:String) : void
      {
         if(this.hasSound(param1))
         {
            audio.stop(param1);
         }
      }
      
      public function isCraftMaterialReached(param1:int, param2:int) : Boolean
      {
         var _loc3_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         return _loc3_.isMaterialReached(param1,param2);
      }
      
      public function startExternalMinigame(param1:String, param2:Object = null) : void
      {
         if(param2 is String)
         {
            param2 = this.JSONDecode(String(param2));
         }
         setTimeout(this.room.startExternalMinigame,10,param1,param2);
      }
      
      public function showPhotoCameraWithFilter(param1:Boolean, param2:Array) : void
      {
         this.view.showPhotoCameraWithFilter(param1,param2);
      }
      
      public function playSound(param1:String, param2:int = 1) : void
      {
         if(!audio.music)
         {
            return;
         }
         if(!this.hasSound(param1))
         {
            this.registerSound(param1);
         }
         audio.addLazyPlay(param1);
      }
      
      public function get disposed() : Boolean
      {
         return this.sceneObjects === null;
      }
      
      public function get avatars() : Array
      {
         return filter(this.objects,this.isAvatar);
      }
      
      public function takeFromUser(param1:String, param2:int = 1) : void
      {
         var _loc3_:GaturroInventory = null;
         var _loc4_:InventorySceneObject = null;
         for each(_loc3_ in user.inventories)
         {
            for each(_loc4_ in _loc3_.items)
            {
               if(this.matches(_loc4_,param1))
               {
                  _loc3_.remove(_loc4_.id);
                  if(--param2 === 0)
                  {
                     return;
                  }
               }
            }
         }
      }
      
      public function hasEnoghCoins(param1:int) : Boolean
      {
         var _loc2_:int = int(getProfileAttribute("coins"));
         return _loc2_ - param1 >= 0;
      }
      
      private function writeTeamPosition(param1:Array) : void
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:Array = [this.getText("Bronce"),this.getText("Plata"),this.getText("Oro")];
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if((_loc8_ = String(param1[_loc4_].name)).indexOf("Gold") > -1)
            {
               _loc9_ = _loc8_.substr(0,_loc8_.indexOf("Gold"));
               _loc3_.push({
                  "name":_loc9_,
                  "points":param1[_loc4_].points
               });
            }
            _loc4_++;
         }
         _loc3_.sortOn("points",Array.NUMERIC);
         var _loc5_:String = this.getOlympicTeam();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].name == _loc5_)
            {
               setSession("posOlimpica",_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         switch(_loc3_[2].name)
         {
            case "megaElastico":
               _loc7_ = "MEGA ELÁSTICO";
               break;
            case "ultraRapido":
               _loc7_ = "ULTRA RÁPIDO";
               break;
            case "superAgil":
               _loc7_ = "SUPER ÁGIL";
         }
         setSession("winOlimpico",_loc7_);
      }
      
      public function showGranjaSellingModal(param1:FarmRequest) : void
      {
         this.view.dispatchEvent(new GranjaSellingModalEvent(GranjaSellingModalEvent.OPEN,api,param1));
      }
      
      public function get avatarEffect() : String
      {
         var _loc1_:Avatar = this.room.userAvatar;
         var _loc2_:Gaturro = new Gaturro(new Holder(_loc1_));
         return _loc2_.effect();
      }
      
      public function openAsteroidsCatalog(param1:String) : void
      {
         this.room.openAsteroidsCatalog(param1);
      }
      
      private function adLoaded(param1:EPlanningEvent) : void
      {
         var _loc2_:EPlanning = EPlanning(param1.currentTarget);
         var _loc3_:DisplayObjectContainer = DisplayObjectContainer(this.eplanningDic[_loc2_]);
         var _loc4_:DisplayObject = DisplayObject(param1.content);
         if(_loc3_)
         {
            _loc3_.addChild(_loc4_);
         }
         _loc2_.removeEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
         this.eplanningDic[_loc2_] = null;
      }
      
      public function isPartyRunning() : Boolean
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(this.eventService)
         {
            return this.eventService.eventRunning;
         }
         return false;
      }
      
      public function get isFlannyReady() : Boolean
      {
         return this.roomView.getFannyService().ableToSendReq();
      }
      
      public function unregisterSound(param1:String) : void
      {
         if(this.hasSound(param1))
         {
            audio.disposeSound(param1);
         }
      }
      
      public function testGoogleAnalytics() : void
      {
         logger.info("#################### Gaturro Room: testGoogleAnalytics ##############");
         setTimeout(this.room.testGoogleAnalytics,10);
      }
      
      public function openPascuasCatalog(param1:String) : void
      {
         this.room.openPascuasCatalog(param1);
      }
      
      public function setTextByLocate(param1:String) : String
      {
         return region.key("key");
      }
      
      public function startHtmlMMO() : void
      {
         setTimeout(this.room.startHtmlMMO,50);
      }
      
      public function get userAchievement() : String
      {
         return this.lastUserAchievements;
      }
      
      public function get achievs() : Array
      {
         return achievements.getList(this.lastUserAchievements);
      }
      
      public function giveInstantCloth(param1:String, param2:String) : void
      {
         this.setAvatarAttribute(param1,param2);
         var _loc3_:CustomAttributeHolder = new Holder(this.userAvatar);
         _loc3_.attributes[param1] = param2;
         this.userAvatar.attributes.merge(_loc3_.attributes);
      }
      
      public function get questManager() : QuestManager
      {
         return quest;
      }
      
      public function isVipBoca3Dias() : Boolean
      {
         var _loc1_:Number = getProfileAttribute("pasaporteBoca3Dias") as Number;
         var _loc2_:Date = new Date(_loc1_);
         _loc2_.date += 3;
         var _loc3_:Date = new Date(serverTime);
         return _loc3_ < _loc2_;
      }
      
      public function get serverName() : String
      {
         return server.serverName;
      }
      
      public function openCatalog(param1:String) : void
      {
         this.room.openCatalog(param1);
      }
      
      public function unfreeze() : void
      {
         if(!this.view)
         {
            logger.debug("api.unfreeze() error");
            return;
         }
         this.view.unfreeze();
      }
      
      public function requestEasterEgg(param1:Function) : void
      {
         api.libraries.fetch("pascuas2017/props.Huevo",this.fetchEasterEgg,param1);
      }
      
      public function deactivate(param1:String) : void
      {
         if(!this.constraintManager)
         {
            this.setupConstraintManager();
         }
         this.constraintManager.deactivate(param1);
      }
      
      public function teamPointsEz(param1:String, param2:String, param3:Function) : void
      {
         var it:IIterator;
         var teamDefinition:TeamDefinition = null;
         var feature:String = param1;
         var team:String = param2;
         var callback:Function = param3;
         var teamManager:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         if(!teamManager)
         {
            return;
         }
         it = teamManager.getTeamList(feature);
         while(it.next())
         {
            teamDefinition = it.current();
            if(teamDefinition.name == team)
            {
               teamManager.askForCertainTeamPoints(team,function(param1:Team):void
               {
                  callback(param1.points);
               });
            }
         }
      }
      
      public function getPartidas() : Array
      {
         if(this.flyInjector == null)
         {
            this.flyInjector = new FlightInjectorManager();
            return this.flyInjector.injectTravel();
         }
         return this.flyInjector.partidas;
      }
      
      public function showRanking(param1:String) : void
      {
         this.view.dispatchEvent(new RankingModalEvent(RankingModalEvent.OPEN,param1));
      }
      
      public function trackPage(... rest) : void
      {
         Telemetry.getInstance().trackScreen(rest[0]);
         tracker.page.apply(tracker,rest);
         logger.info("API: track page: ",rest);
      }
      
      public function cinemaAllowsCountry(param1:String) : Boolean
      {
         var _loc2_:CinemaManager = Context.instance.getByType(CinemaManager) as CinemaManager;
         return _loc2_.isCountryAllowed(param1,this.country);
      }
      
      public function giveUser(param1:String, param2:uint = 1, param3:String = null, param4:Object = null) : void
      {
         if(param3)
         {
            InventoryUtil.buyObject(this.userAvatar,param1,param3,param2,0);
         }
         else
         {
            InventoryUtil.acquireObject(this.userAvatar,param1,param2,0,"",param4);
         }
      }
      
      public function getEmojisScore() : Number
      {
         var _loc1_:uint = getSession("seremojiUserCount") as uint;
         var _loc2_:Number = Date.parse(settings.Seremojis.emojimetro.maxDate);
         var _loc3_:Number = Date.parse(settings.Seremojis.emojimetro.releaseDate);
         var _loc4_:Number = Number(settings.Seremojis.emojimetro.maxCount);
         var _loc5_:Number = _loc2_ - serverTime;
         var _loc6_:Number = _loc2_ - _loc3_;
         return _loc4_ - _loc5_ * _loc4_ / _loc6_ + _loc1_;
      }
      
      public function get achievManager() : AchievManager
      {
         return achievements;
      }
      
      public function setAvatarAttribute(param1:String, param2:Object) : void
      {
         this.userAvatar.attributes[param1] = param2;
      }
      
      public function showProgressModal(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.view.addProgressModal(param1,param2,param3,param4);
      }
      
      public function addOlympicTeamReward(param1:int, param2:Number) : void
      {
      }
      
      public function addEvent(param1:Object) : void
      {
         this.addParty(param1);
      }
      
      public function loadEplanning(param1:String, param2:DisplayObjectContainer) : Boolean
      {
         if(!EPlanning.isValidTag(param1))
         {
            return false;
         }
         var _loc3_:EPlanning = new EPlanning();
         _loc3_.addEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
         _loc3_.loadByTag(param1);
         this.eplanningDic[_loc3_] = param2;
         return true;
      }
      
      public function antiGravity() : void
      {
         if(!this.userAvatar)
         {
            return;
         }
         this.idleObjects.antiGravity = new AntiGravityManager(this.roomView,this.avatars,this);
      }
      
      public function getOlympicTeamManager() : OlympicTeamManager
      {
         return Context.instance.getByType(OlympicTeamManager) as OlympicTeamManager;
      }
      
      public function hasSound(param1:String) : Boolean
      {
         return audio.has(param1);
      }
      
      public function freeze() : void
      {
         if(!this.view)
         {
            logger.debug("api.freeze() error");
            return;
         }
         this.view.freeze();
      }
      
      public function startPocket() : void
      {
         setTimeout(this.room.startPocket,10);
      }
      
      public function get libraries() : Libraries
      {
         return libs;
      }
      
      public function getCinemaDefinition(param1:String) : CinemaMovieDefinition
      {
         var _loc2_:CinemaManager = Context.instance.getByType(CinemaManager) as CinemaManager;
         return _loc2_.getDefinition(param1);
      }
      
      public function fetchEasterEgg(param1:DisplayObject, param2:Function) : void
      {
         param2(param1);
      }
      
      public function switchOnSanValentin(param1:Number = 0) : void
      {
         var _loc2_:SeedRandom = null;
         _loc2_ = new SeedRandom(param1);
         this.sanValentinResult = _loc2_.integer(1,14);
         this.setAvatarAttribute(Gaturro.EFFECT_KEY,"sanValentin." + this.sanValentinResult);
      }
      
      public function get gatucineManager() : GatucineManager
      {
         return gatucine;
      }
      
      private function setupLevelManager() : void
      {
         if(Context.instance.hasByType(LevelManager))
         {
            this.levelManager = Context.instance.getByType(LevelManager) as LevelManager;
         }
         else
         {
            this.levelManager = new LevelManager();
            Context.instance.addByType(this.levelManager,LevelManager);
         }
      }
      
      public function unobserveConstraint(param1:String) : void
      {
         if(!this.constraintManager)
         {
            this.setupConstraintManager();
         }
         this.constraintManager.unobserve(param1);
      }
      
      public function foregroundParticles(param1:String, param2:int = 50, param3:Object = null) : void
      {
         this.view.particleEmit(param1,param2,param3);
      }
      
      public function changeRoom(param1:Number, param2:Coord) : void
      {
         if(!this.room)
         {
            return;
         }
         setTimeout(this.room.changeTo,10,new RoomLink(param2,param1));
      }
      
      public function get userViewCopy() : Gaturro
      {
         var _loc1_:Avatar = this.room.userAvatar;
         return new Gaturro(new Holder(_loc1_));
      }
      
      public function setText(param1:TextField, param2:String) : void
      {
         if(param1 != null && param2 != null)
         {
            region.setText(param1,param2);
         }
      }
      
      public function isVipRiver3Dias() : Boolean
      {
         var _loc1_:Number = getProfileAttribute("pasaporteRiver3Dias") as Number;
         var _loc2_:Date = new Date(_loc1_);
         _loc2_.date += 3;
         var _loc3_:Date = new Date(serverTime);
         return _loc3_ < _loc2_;
      }
      
      public function showSkinModal(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         var _loc5_:Object = null;
         if(!param4)
         {
            this.showModal(param1,param2,param3);
         }
         else
         {
            (_loc5_ = new Object()).text = param1;
            _loc5_.image = param2;
            _loc5_.title = param3;
            _loc5_.skin = param4;
            this.view.dispatchEvent(new BannerModalEvent(BannerModalEvent.INSTANTIATE,"SkinableAlertBanner",this,null,null,_loc5_));
         }
      }
      
      public function accomplishById(param1:String, param2:* = null) : Boolean
      {
         if(!this.constraintManager)
         {
            this.setupConstraintManager();
         }
         return this.constraintManager.accomplishById(param1,param2);
      }
      
      public function requestPanDulce(param1:Function) : void
      {
         api.libraries.fetch("navidad2017/props.PandulceComp",this.fetchEasterEgg,param1);
      }
      
      public function cleanCache() : void
      {
         this.libraries.cleanCache();
      }
      
      public function showPhotoCamera(param1:Boolean) : void
      {
         this.view.showPhotoCamera(param1);
      }
      
      public function get lastVigut() : String
      {
         var _loc1_:Array = settings.giftCodes.campaigns.VG.data.dates;
         if(_loc1_)
         {
            return _loc1_[_loc1_.length - 1].item;
         }
         return "not found";
      }
      
      public function getAvatarByName(param1:String) : Avatar
      {
         return this.room.avatarByUsername(param1);
      }
      
      public function showDialogBallomListImg(param1:Sprite, param2:int, param3:int, param4:Array) : void
      {
         this.view.addDialogBalloonImg(param1,param2,param3,param4);
      }
      
      public function getCurrentCarouselMessage(param1:String) : String
      {
         var _loc2_:CatalogCarouselService = this.getCatalogCarouselService();
         var _loc3_:String = _loc2_.getCurrentCatalogCarouselMessage(param1);
         return _loc3_.toUpperCase();
      }
      
      public function openURL(param1:String) : void
      {
         URLUtil.openURL(param1);
      }
      
      public function textMessageToGUI(param1:String) : void
      {
         this.roomView.messageToGUI(this.getText(param1));
      }
      
      public function fetch(param1:String, param2:Function) : void
      {
         this.libraries.fetch(param1,param2);
      }
      
      public function get cardsManager() : CardsManager
      {
         return cards;
      }
      
      public function showPhotoTripButton() : void
      {
         if(this.roomView.photoTripButton)
         {
            this.roomView.photoTripButton.makeVisible();
         }
      }
      
      public function get time() : Number
      {
         return server.time;
      }
      
      public function subscribeTeam(param1:String, param2:String) : void
      {
         var _loc3_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         if(!_loc3_)
         {
            return;
         }
         _loc3_.suscribeToTeam(param2,param1);
      }
      
      public function pauseBackgroundMusic() : void
      {
         audio.pauseRoomSounds();
      }
      
      private function getCatalogCarouselService() : CatalogCarouselService
      {
         var _loc1_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc1_ = new CatalogCarouselService();
            Context.instance.addByType(_loc1_,CatalogCarouselService);
         }
         else
         {
            _loc1_ = Context.instance.getByType(CatalogCarouselService) as CatalogCarouselService;
         }
         return _loc1_;
      }
      
      public function avatarHasObjectLike(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         if(!user)
         {
            return false;
         }
         var _loc2_:Array = user.allItems as Array;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name.indexOf(param1) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function picapon(param1:String) : void
      {
         var _loc2_:SocialNetMessage = SocialNet.getTextMessage(param1);
         socialNet.sendMessage(_loc2_);
         api.userAvatar.username;
      }
      
      public function get room() : GaturroRoom
      {
         return this._room;
      }
      
      public function addParty(param1:Object) : void
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(this.eventService)
         {
            this.eventService.createEvent(param1);
            this.eventService.billboardService.addEvent(param1,this.room);
         }
      }
      
      public function get isCitizen() : Boolean
      {
         return this.userAvatar.isCitizen;
      }
      
      public function showGiftModal() : void
      {
         this.setSession("giftChristmas","n");
         this.view.dispatchEvent(new GiftReceiverGuiModalEvent(GiftReceiverGuiModalEvent.OPEN));
      }
      
      private function validateTextActionResponse(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.VALIDATE_TEXT,this.validateTextActionResponse);
         var _loc2_:Boolean = param1.mobject.getBoolean("valid");
         logger.debug("validateTextActionResponse: " + _loc2_);
         if(this.validateTextCallback != null)
         {
            this.validateTextCallback(_loc2_);
         }
      }
      
      public function gotoRoom(param1:String, param2:String) : void
      {
         var _loc3_:Date = new Date(server.time);
         var _loc4_:Date = new Date(parseInt(param2));
         var _loc5_:int = TimeSpan.fromDates(_loc4_,_loc3_).totalMinutes;
         logger.debug(this,_loc5_);
         if(_loc5_ > 60)
         {
            this.showModal("la invitación expiró");
         }
         else
         {
            this.changeRoom(parseInt(param1),new Coord(5,5));
         }
         logger.debug(this,"room",param1);
         logger.debug(this,"time",param2);
      }
      
      public function get fps() : int
      {
         return this._fps;
      }
      
      public function changeRoomXY(param1:Number, param2:int = 0, param3:int = 0) : void
      {
         this.changeRoom(param1,new Coord(param2,param3));
      }
      
      public function showImageModal(param1:DisplayObject) : void
      {
         this.view.dispatchEvent(new ImageModalEvent(ImageModalEvent.OPEN,param1));
      }
      
      public function activate(param1:String) : void
      {
         if(!this.constraintManager)
         {
            this.setupConstraintManager();
         }
         this.constraintManager.activate(param1);
      }
      
      public function openSerenitoCatalog(param1:String) : void
      {
         this.room.openSerenitoCatalog(param1);
      }
      
      public function JSONDecode(param1:String) : Object
      {
         var r:Object = null;
         var s:String = param1;
         try
         {
            r = com.adobe.serialization.json.JSON.decode(s);
         }
         catch(e:Error)
         {
            r = null;
         }
         return r;
      }
      
      public function buildPackRequest(param1:Function = null, param2:Function = null, param3:Function = null) : void
      {
         this._prodID = this.getProdID();
         this._onCompleted = param1;
         this._onFailure = param2;
         this._alreadyHas = param3;
         var _loc4_:String = settings.services.gatupacks.url + "&u=" + user.username + "&p=" + this.getProdID().toString();
         this._gatupackRequest = new PocketServiceManager();
         this._gatupackRequest.buildRequest("POST",_loc4_);
         this._gatupackRequest.addEventListener(Event.COMPLETE,this.resultGatupacks);
      }
      
      public function moveToTile(param1:Coord) : void
      {
         this.room.moveToTile(param1);
      }
      
      public function petCreate(param1:String, param2:String, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0) : void
      {
         var _loc7_:int = Random.randint(1,10000);
         var _loc8_:Object;
         (_loc8_ = {})["name"] = param2;
         _loc8_[OwnedNpcFactory.OWNED_NPC_ID_ATTR] = _loc7_;
         if(param3 != 0)
         {
            _loc8_["color1"] = param3;
         }
         if(param4 != 0)
         {
            _loc8_["color2"] = param4;
         }
         if(param5 != 0)
         {
            _loc8_["color3"] = param5;
         }
         if(param6 != 0)
         {
            _loc8_["color4"] = param6;
         }
         InventoryUtil.acquireObject(this.userAvatar,param1,1,0,"",_loc8_);
         this.checkExistsPet(0,{
            "name":param1,
            "id":_loc7_
         });
      }
      
      public function setAvatarState(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Gaturro = this.userView.clip;
         if(param2)
         {
            _loc3_.gotoAndPlay(param1);
         }
         else
         {
            _loc3_.gotoAndStop(param1);
         }
      }
      
      public function gotoEvent() : void
      {
         this.gotoParty();
      }
      
      public function getOlympicTeam() : String
      {
         return "any";
      }
      
      public function shakeRoom(param1:int, param2:int) : void
      {
         this.view.startShake(param1,param2);
      }
      
      public function checkExistsPet(param1:int, param2:Object) : void
      {
         var _loc3_:GaturroInventorySceneObject = null;
         var _loc4_:Array = null;
         var _loc5_:GaturroInventorySceneObject = null;
         param1++;
         for each(_loc4_ in user.inventory(GaturroInventory.HOUSE).itemsGrouped)
         {
            if(_loc4_.length != 0)
            {
               if(_loc5_ = _loc4_[0] as GaturroInventorySceneObject)
               {
                  if(_loc5_.name == param2.name && _loc5_.attributes[OwnedNpcFactory.OWNED_NPC_ID_ATTR] && _loc5_.attributes[OwnedNpcFactory.OWNED_NPC_ID_ATTR] == param2.id)
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
         }
         if(_loc3_)
         {
            OwnedNpcFactory.activeOwnedNpc(this.room.userAvatar,_loc3_);
            return;
         }
         if(param1 > 20)
         {
            return;
         }
         setTimeout(this.checkExistsPet,1000,param1,param2);
      }
      
      public function get userAvatar() : UserAvatar
      {
         if(this.room)
         {
            return this.room.userAvatar;
         }
         return null;
      }
      
      public function onLoadConfig(param1:Event) : void
      {
         this.loadedConfigCallback(this.loadedConfigFile);
      }
      
      public function get partiesManager() : PartiesManager
      {
         return parties;
      }
      
      public function get socialNetApi() : SocialNet
      {
         return socialNet;
      }
      
      public function get swimmingUserView() : SwimmingGaturroAvatarView
      {
         return this.getView(this.room.userAvatar) as SwimmingGaturroAvatarView;
      }
      
      public function showParcelaUnlockModal(param1:GaturroSceneObjectAPI) : void
      {
         this.view.dispatchEvent(new GranjaParcelaUnlockEvent(GranjaParcelaUnlockEvent.OPEN,param1));
      }
      
      public function openReyesCatalog(param1:String) : void
      {
         this.room.openReyesCatalog(param1);
      }
      
      public function openIphoneNews(param1:String = "") : void
      {
         if(param1 != "")
         {
            api.setSession(NewsPageFactory.NEWS_PROFILE_KEY,param1);
         }
         this.roomView.openIphoneNews();
      }
      
      public function isPicaponEnabled() : Boolean
      {
         return SocialNet.enabled;
      }
      
      public function get objects() : Array
      {
         return this.room.sceneObjects;
      }
      
      public function get showUsersNames() : Boolean
      {
         return this.view.showUserNames;
      }
      
      public function get isStandalone() : Boolean
      {
         return true;
      }
      
      public function get userView() : GaturroUserAvatarView
      {
         return this.getView(this.room.userAvatar) as GaturroUserAvatarView;
      }
      
      public function openFeriaCatalog(param1:String) : void
      {
         this.room.openFeriaCatalog(param1);
      }
      
      public function getView(param1:RoomSceneObject) : DisplayObject
      {
         return this.sceneObjects.getItem(param1) as DisplayObject;
      }
      
      public function getAvatarAttribute(param1:String) : Object
      {
         return this.userAvatar.attributes[param1];
      }
      
      public function get userSettings() : UserSettings
      {
         return this.uSettings;
      }
      
      public function JSONEncode(param1:Object) : String
      {
         var r:String = null;
         var o:Object = param1;
         try
         {
            r = com.adobe.serialization.json.JSON.encode(o);
         }
         catch(e:Error)
         {
            r = null;
         }
         return r;
      }
      
      public function avatarHasObject(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         if(!user)
         {
            return false;
         }
         var _loc2_:Array = user.allItems as Array;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function showGranjaModal(param1:GaturroSceneObjectAPI) : void
      {
         this.view.dispatchEvent(new GranjaModalEvent(GranjaModalEvent.OPEN,param1));
      }
      
      public function antigravityOff() : void
      {
         var _loc1_:MovementManager = Context.instance.getByType(MovementManager) as MovementManager;
         _loc1_.stop();
      }
      
      public function openVipCatalog(param1:String) : void
      {
         this.room.openVipCatalog(param1);
      }
      
      public function createAvatarPartNames() : Dictionary
      {
         return AvatarBodyEnum.getList();
      }
      
      private function isAvatar(param1:RoomSceneObject) : Boolean
      {
         return param1 is Avatar;
      }
      
      public function getTeamPosition() : void
      {
         var _loc1_:OlympicTeamManager = Context.instance.getByType(OlympicTeamManager) as OlympicTeamManager;
         _loc1_.getMedalStanding(this.writeTeamPosition);
      }
      
      public function showAwardModal(param1:String, param2:String, param3:int = 1, param4:String = null, param5:String = "") : void
      {
         this.view.addAwardModal(param5,param1,param2,param3,param4);
      }
      
      public function addTeamPoints(param1:String, param2:int = 1) : void
      {
         var _loc3_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         if(!_loc3_)
         {
            return;
         }
         logger.info("**************************** TESTING WINNER 3/4");
         _loc3_.addPoints(param1,param2);
      }
      
      public function showCropTimeModal(param1:GaturroSceneObjectAPI, param2:GranjaBehavior) : void
      {
         this.view.dispatchEvent(new CropTimerModalEvent(CropTimerModalEvent.OPEN,api,param1,param2));
      }
      
      public function showPhoto(param1:Bitmap, param2:Boolean = true) : void
      {
         trace("GaturroRoomAPI > showPhoto > photo = [" + param1 + "]");
         this.view.showPhoto(param1,param2);
      }
      
      public function get multiplayerNetApi() : GaturroMultiplayerManager
      {
         return GaturroMultiplayerManager.instance;
      }
      
      private function matches(param1:InventorySceneObject, param2:String) : Boolean
      {
         return param2.slice(-1) === "*" ? param1.name.indexOf(param2.slice(0,-1)) === 0 : param1.name === param2;
      }
      
      public function requestCurrentShopImage(param1:Function) : void
      {
         this._gatupackRequest = new PocketServiceManager();
         this._gatupackRequest.buildRequest("POST","http://service.mundogaturro.com/?r=service/media/&t=ofertas_AR");
         this.shopImageCallback = param1;
         this._gatupackRequest.addEventListener(Event.COMPLETE,this.requestCurrentShopPNG);
      }
      
      public function isConstraintReady() : Boolean
      {
         return !!this.constraintManager ? true : false;
      }
      
      public function getSerenitoChallengeProgress() : int
      {
         var _loc1_:Number = Date.parse(settings.Seremojis.emojimetro.maxDate);
         var _loc2_:Number = Date.parse(settings.Seremojis.emojimetro.releaseDate);
         var _loc3_:Number = Number(settings.Seremojis.emojimetro.maxCount);
         var _loc4_:Number = _loc1_ - serverTime;
         var _loc5_:Number = _loc1_ - _loc2_;
         var _loc6_:int = 100 - _loc4_ * 100 / _loc5_;
         return 100 - _loc4_ * 100 / _loc5_;
      }
      
      public function craftIsRewardGranted(param1:int) : Boolean
      {
         var _loc2_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         return _loc2_.isRewardGranted(param1);
      }
      
      public function gotoParty() : void
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(this.eventService)
         {
            this.eventService.gotoEvent();
         }
      }
      
      public function isPartyOwnerAndActive() : Boolean
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(!this.eventService)
         {
            return false;
         }
         return this.eventService.imHost && this.eventService.eventRunning;
      }
      
      public function get config() : Object
      {
         return settings;
      }
      
      public function get log() : Logger
      {
         return logger;
      }
      
      public function loadCurrentCarouselIcon(param1:String, param2:Function) : void
      {
         var _loc3_:String = this.getCurrentCarouselIconName(param1);
         this.fetch(_loc3_,param2);
      }
      
      private function petAddedToInventory(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.petAddedToInventory);
         var _loc2_:Mobject = param1.mobject.getMobject("sceneObject");
         var _loc3_:String = _loc2_.getString("id");
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:InventorySceneObject = user.inventory(GaturroInventory.HOUSE).byId(Number(_loc3_));
         OwnedNpcFactory.activeOwnedNpc(this.room.userAvatar,GaturroInventorySceneObject(_loc4_));
      }
      
      public function get isDebug() : Boolean
      {
         return settings.debug.localMinigames;
      }
      
      public function startMinigame(param1:String, param2:Number = 0, param3:Coord = null) : void
      {
         setTimeout(this.room.startMinigame,10,param1,param2,param3);
      }
      
      public function get achievsLoaded() : Boolean
      {
         return achievements.getLoaded(this.lastUserAchievements);
      }
      
      public function givePoints(param1:String, param2:uint) : void
      {
         info("The game",param1,"awarded the user with",param2,"points");
         this.room.rewards.add(new PointsMinigameReward(param1,param2,0));
      }
      
      public function showSiloModal(param1:MovieClip) : void
      {
         this.view.dispatchEvent(new SiloModalEvent(SiloModalEvent.OPEN,api,param1));
      }
      
      public function get chat() : RoomChat
      {
         return this.room.chat;
      }
      
      public function getBalanceFromUser(param1:String) : int
      {
         var _loc3_:GaturroInventory = null;
         var _loc4_:InventorySceneObject = null;
         var _loc2_:int = 0;
         for each(_loc3_ in user.inventories)
         {
            for each(_loc4_ in _loc3_.items)
            {
               if(this.matches(_loc4_,param1))
               {
                  _loc2_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function sendMessage(param1:String, param2:Object) : void
      {
         var _loc3_:String = String(api.JSONEncode({
            "action":param1,
            "params":param2
         }));
         api.setAvatarAttribute("message",_loc3_);
      }
      
      public function eventHost() : String
      {
         return this.partyHost();
      }
      
      public function validateText(param1:String, param2:Function = null) : void
      {
         this.validateTextCallback = param2;
         net.sendAction(new textValidationActionRequest(param1));
         net.addEventListener(GaturroNetResponses.VALIDATE_TEXT,this.validateTextActionResponse);
      }
      
      public function consumeCoins(param1:int) : void
      {
         trace("GaturroRoomAPI > consumeCoins > int(getProfileAttribute(coins))" + int(getProfileAttribute("coins")));
         setProfileAttribute("system_coins",api.user.attributes.coins - param1);
         trace("GaturroRoomAPI > consumeCoins > int(getProfileAttribute(coins))" + int(getProfileAttribute("coins")));
      }
      
      public function get language() : String
      {
         return region.languageId;
      }
      
      public function petFollowMe(param1:RoomSceneObject) : void
      {
         net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.petAddedToInventory);
         var _loc2_:GaturroInventory = InventoryUtil.getInventory(param1);
         _loc2_.grab(param1.id);
      }
      
      public function sendFriendRequest(param1:String, param2:int) : void
      {
         user.community.sendFriendRequest(param1,param2);
         tracker.event(TrackCategories.BUDDIES,TrackActions.ADD_BUDDY);
      }
      
      public function showThinkBallomListImg(param1:Sprite, param2:int, param3:int, param4:Array) : void
      {
         this.view.addThinkBalloonImg(param1,param2,param3,param4);
      }
      
      public function showGiftChristmasModal() : void
      {
         this.setSession("giftChristmas","y");
         this.view.dispatchEvent(new GiftReceiverGuiModalEvent(GiftReceiverGuiModalEvent.OPEN));
      }
      
      public function moveToTileXY(param1:int = 5, param2:int = 5) : void
      {
         this.room.moveToTileXY(param1,param2);
      }
      
      public function openBocaCatalog(param1:String) : void
      {
         this.room.openBocaCatalog(param1);
      }
      
      public function isPetCloth(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(".");
         var _loc3_:String = Boolean(_loc2_) && _loc2_.length > 1 ? String(_loc2_[0]) : "";
         return _loc3_.indexOf("pet") > -1;
      }
      
      public function getCurrentCarouselIconName(param1:String) : String
      {
         var _loc2_:CatalogCarouselService = this.getCatalogCarouselService();
         return _loc2_.getCurrentCatalogCarouselIcon(param1);
      }
      
      public function showAchievementBannerModal(param1:String) : void
      {
         this.lastUserAchievements = param1;
         this.view.dispatchEvent(new BannerModalEvent(BannerModalEvent.OPEN,"achievements",this,null));
      }
      
      public function get isDesktop() : Boolean
      {
         return URLUtil.isDesktop();
      }
      
      public function get silcenceRoom() : Boolean
      {
         var _loc1_:Number = NaN;
         for each(_loc1_ in settings.silenceRooms)
         {
            if(_loc1_ == this.room.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get country() : String
      {
         return region.country;
      }
      
      public function instantiateBannerModal(param1:String, param2:GaturroSceneObjectAPI = null, param3:String = "", param4:Object = null) : void
      {
         param2 = !param2 ? new GaturroSceneObjectAPI(null,new Sprite(),this.room) : param2;
         logger.info("Banner > instantiateBannerModal > sceneAPI: " + param2 + " // bannerName: " + param1);
         this.view.dispatchEvent(new BannerModalEvent(BannerModalEvent.INSTANTIATE,param1,this,param2,param3,param4));
      }
      
      public function placeAvatarAt(param1:int, param2:int) : void
      {
         this.userAvatar.placeAt(new Coord(param1,param2));
      }
      
      public function showDialogBallomWithImg(param1:Sprite, param2:String, param3:String) : void
      {
         this.view.addDialogBalloonWithImg(param1,param2,param3);
      }
      
      public function inviteToEvent(param1:String) : void
      {
         this.inviteToParty(param1);
      }
      
      private function stopFPSCalculate() : void
      {
         this.view.removeEventListener(Event.ENTER_FRAME,this.fpsTick);
      }
      
      public function craftInventoryFreezeMap() : void
      {
         var _loc1_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         _loc1_.freezeInventoryMap();
      }
      
      public function fetchCurrentVigut(param1:Function) : void
      {
         libs.fetch(this.currentVigut,param1);
      }
      
      public function showBannerModal(param1:String, param2:GaturroSceneObjectAPI = null, param3:String = null) : void
      {
         param2 = !param2 ? new GaturroSceneObjectAPI(null,new Sprite(),this.room) : param2;
         this.view.dispatchEvent(new BannerModalEvent(BannerModalEvent.OPEN,param1,this,param2,param3));
      }
      
      public function getTeamPoints(param1:String, param2:Function) : void
      {
         var _loc3_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         if(!_loc3_)
         {
            return;
         }
         _loc3_.askForTeamList(param1,param2);
      }
      
      public function get networkManager() : NetworkManager
      {
         return net;
      }
      
      private function getProdID() : uint
      {
         if(this.country == "AR")
         {
            return 111654;
         }
         if(this.country == "UY")
         {
            return 111656;
         }
         if(this.country == "CO")
         {
            return 111657;
         }
         if(this.country == "CL")
         {
            return 111658;
         }
         if(this.country == "PE")
         {
            return 111659;
         }
         if(this.country == "MX")
         {
            return 111660;
         }
         if(this.country == "ES")
         {
            return 111661;
         }
         return 111655;
      }
      
      public function openNavidadCatalog(param1:String) : void
      {
         this.room.openNavidadCatalog(param1);
      }
      
      public function resumeBackgroundMusic() : void
      {
         audio.resume();
      }
      
      public function antigravityOn() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:RoomSceneObject = null;
         var _loc1_:MovementManager = Context.instance.getByType(MovementManager) as MovementManager;
         for each(_loc3_ in this.avatars)
         {
            _loc2_ = this.getView(_loc3_);
            (_loc2_ as GaturroAvatarView).setNotWalking();
            _loc1_.addMovement(MovementsEnum.GRAVITY_ROTATION,_loc2_);
            _loc1_.addMovement(MovementsEnum.GRAVITY_VERTICAL,_loc2_);
         }
         _loc1_.start();
      }
      
      public function printClip(param1:MovieClip) : void
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height);
         _loc2_.draw(param1);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         var _loc4_:Sprite;
         (_loc4_ = new Sprite()).addChild(_loc3_);
         var _loc5_:PrintJob;
         (_loc5_ = new PrintJob()).start();
         _loc5_.addPage(_loc4_);
         _loc5_.send();
      }
      
      public function resetCounter(param1:String) : void
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         _loc2_.reset(param1);
      }
      
      public function partyHost() : String
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(Boolean(this.eventService) && Boolean(this.eventService.eventData))
         {
            return this.eventService.eventData.host;
         }
         return "";
      }
      
      public function showModal(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         this.view.addInformationModal(param1,param2,param3,param4);
      }
      
      public function getText(param1:String) : String
      {
         if(param1 != null)
         {
            return region.getText(param1);
         }
         return param1;
      }
      
      public function get currentVigut() : String
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Array = null;
         var _loc7_:Date = null;
         var _loc1_:Date = new Date(api.time);
         var _loc2_:Date = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date);
         for each(_loc3_ in settings.giftCodes.campaigns.VG.data.dates)
         {
            _loc4_ = String(_loc3_.from).split("-");
            _loc5_ = new Date(int(_loc4_[2]),int(_loc4_[1]) - 1,int(_loc4_[0]));
            _loc6_ = String(_loc3_.to).split("-");
            _loc7_ = new Date(int(_loc6_[2]),int(_loc6_[1]) - 1,int(_loc6_[0]));
            if(_loc2_.time >= _loc5_.time && _loc2_.time < _loc7_.time)
            {
               return _loc3_.item;
            }
         }
         return "missing";
      }
      
      public function getCounterAmount(param1:String) : int
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc2_.getAmount(param1);
      }
      
      public function loadConfig(param1:String, param2:Function) : void
      {
         if(!this.cacheConfig)
         {
            this.cacheConfig = new Dictionary();
         }
         if(this.cacheConfig[param1])
         {
            param2(this.cacheConfig[param1]);
            return;
         }
         this.loadedConfigFile = new Settings();
         this.loadedConfigCallback = param2;
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc3_:String = URLUtil.getUrl("cfgs/" + param1);
         var _loc4_:LoadFile = new LoadFile(_loc3_,"json");
         this.loadedConfigFile.addFile(_loc4_);
         _loc4_.addEventListener(TaskEvent.COMPLETE,this.onLoadConfig);
         this.cacheConfig[param1] = this.loadedConfigFile;
         _loc4_.start();
      }
      
      public function showGranjaLevelUpModal(param1:int, param2:Object) : void
      {
         this.view.dispatchEvent(new GranjaLevelUpEvent(GranjaLevelUpEvent.OPEN,param1,param2));
      }
      
      public function isTypeGame(param1:String, param2:String) : Boolean
      {
         var _loc3_:Object = settings[param2 + "Games"];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function openRiverCatalog(param1:String) : void
      {
         this.room.openRiverCatalog(param1);
      }
      
      private function deliverCurrentShopImage(param1:Event) : void
      {
         var _loc2_:DisplayObject = this.shopImageLoader.content as DisplayObject;
         this.shopImageCallback(_loc2_);
      }
      
      public function openCinema(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:CinemaManager = Context.instance.getByType(CinemaManager) as CinemaManager;
         _loc3_.openCinema(param1,param2);
      }
      
      public function hasCinemaDefinition(param1:String) : Boolean
      {
         var _loc2_:CinemaManager = Context.instance.getByType(CinemaManager) as CinemaManager;
         return _loc2_.hasDefinition(param1);
      }
      
      public function craftInventoryHasStock(param1:int) : Boolean
      {
         var _loc2_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         return _loc2_.inventoryHasStock(param1);
      }
      
      public function showFishingModal(param1:GaturroSceneObjectAPI) : void
      {
         this.view.dispatchEvent(new FishingGuiModalEvent(FishingGuiModalEvent.OPEN,param1));
      }
      
      private function resultGatupacks(param1:Event) : void
      {
         this._gatupackRequest;
         if(Boolean(this._gatupackRequest.requestedData.data) && this._gatupackRequest.requestedData.data.message == "avatar saved")
         {
            if(this._onCompleted != null)
            {
               api.setProfileAttribute("gatupackMAY19",true);
               this._onCompleted();
            }
         }
         else if(Boolean(this._gatupackRequest.requestedData.data) && this._gatupackRequest.requestedData.data.message == "User already has a gift")
         {
            if(this._alreadyHas != null)
            {
               this._alreadyHas();
            }
         }
         else if(this._onFailure != null)
         {
            this._onFailure();
         }
      }
      
      public function openPetCatalog(param1:String, param2:String = null) : void
      {
         this.room.openPetCatalog(param1,param2);
      }
      
      public function get checkIsTutorial() : Boolean
      {
         return TutorialManager.isRoomTutoriable(this.room);
      }
      
      public function obseveConstraint(param1:String, param2:Function) : void
      {
         if(!this.constraintManager)
         {
            this.setupConstraintManager();
         }
         this.constraintManager.observe(param1,param2);
      }
      
      public function mergeAvatarAttribute(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc2_:CustomAttributes = new CustomAttributes();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.key] = _loc3_.value;
         }
         this.userAvatar.attributes.merge(_loc2_);
      }
      
      public function get roomOwnedByUser() : Boolean
      {
         return this._room.ownedByUser;
      }
      
      public function openMundialCatalog(param1:String) : void
      {
         this.room.openMundialCatalog(param1);
      }
      
      public function createAvatarDresser() : AvatarDresser
      {
         return new AvatarDresser();
      }
      
      public function inviteToParty(param1:String) : void
      {
         if(!this.eventService)
         {
            this.eventService = Context.instance.getByType(EventsService) as EventsService;
         }
         if(this.eventService)
         {
            this.eventService.inviteToEvent(param1);
         }
      }
      
      public function get weather() : String
      {
         return Weather.state;
      }
      
      public function get timezone() : Timezone
      {
         return new Timezone();
      }
      
      public function isEventOwnerAndActive() : Boolean
      {
         return this.isPartyOwnerAndActive();
      }
      
      public function get vigutData() : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Array = null;
         var _loc7_:Date = null;
         var _loc1_:Date = new Date(api.time);
         var _loc2_:Date = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date);
         for each(_loc3_ in settings.giftCodes.campaigns.VG.data.dates)
         {
            _loc4_ = String(_loc3_.from).split("-");
            _loc5_ = new Date(int(_loc4_[2]),int(_loc4_[1]) - 1,int(_loc4_[0]));
            _loc6_ = String(_loc3_.to).split("-");
            _loc7_ = new Date(int(_loc6_[2]),int(_loc6_[1]) - 1,int(_loc6_[0]));
            if(_loc2_.time >= _loc5_.time && _loc2_.time < _loc7_.time)
            {
               return _loc3_;
            }
         }
         return "missing";
      }
      
      public function showSellModal() : void
      {
         this.view.dispatchEvent(new SellItemGuiModalEvent(SellItemGuiModalEvent.OPEN));
      }
      
      private function startFPSCalculate() : void
      {
         this.view.addEventListener(Event.ENTER_FRAME,this.fpsTick);
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
