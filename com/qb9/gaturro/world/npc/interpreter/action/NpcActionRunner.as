package com.qb9.gaturro.world.npc.interpreter.action
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.achievements;
   import com.qb9.gaturro.globals.gatucine;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.socialNet;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.manager.passport.BetterWithPassportManager;
   import com.qb9.gaturro.manager.provider.ProviderManager;
   import com.qb9.gaturro.model.config.crafting.model.CraftingModuleModel;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.service.catalog.CatalogCarouselService;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.socialnet.SocialNet;
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import com.qb9.gaturro.view.gui.combat.CombatEvent;
   import com.qb9.gaturro.view.gui.contextual.ContextualMenuManager;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.npc.NpcUtility;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.npc.interpreter.NpcInterpreterError;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehavior;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public final class NpcActionRunner implements IDisposable
   {
       
      
      private var craftManager:CraftingManager;
      
      private var npcContext:NpcContext;
      
      private var actions:Object;
      
      public function NpcActionRunner(param1:NpcContext)
      {
         this.actions = {
            "inventory.add":this.addItems,
            "inventory.addOptions":this.addItemWithOptions,
            "inventory.remove":this.removeItems,
            "inventory.takeEmojis":this.takeEmojis,
            "inventory.setAmount":this.setAmount,
            "dressBot.remove":this.removeItemToDress,
            "user.move":this.moveAvatar,
            "user.attr":this.setAvatarAttribute,
            "user.profileAttr":this.setProfileAttribute,
            "user.state":this.setAvatarState,
            "user.effect":this.setAvatarEffect,
            "user.lookRight":this.lookRight,
            "user.lookLeft":this.lookLeft,
            "user.action":this.setAvatarAction,
            "user.emote":this.setAvatarEmote,
            "user.house":this.takeToHome,
            "user.onattr":this.onUserAttr,
            "user.costume":this.userCostume,
            "modal.show":this.showModal,
            "modal.showSkinable":this.showSkinModal,
            "modal.progress":this.showProgress,
            "modal.progressByItem":this.showProgressByItem,
            "modalTimeout.show":this.showModalTimeOut,
            "modal.resell":this.showSellModal,
            "modal.gift":this.showGiftModal,
            "modal.giftChristmas":this.showGiftChristmasModal,
            "modal.banner":this.showBannerModal,
            "modal.instanceBanner":this.instanceBannerModal,
            "modal.ranking":this.showRanking,
            "modal.customParty":this.showPartiesModal,
            "modal.award":this.showAwardModal,
            "modal.capture":this.showCaptureModal,
            "modal.betterPassaport":this.betterPassportModal,
            "open.news":this.openIphoneNews,
            "queue.join":this.joinQueue,
            "self.state":this.display,
            "self.attr":this.setSelfAttribute,
            "self.incAttr":this.incSelfAttribute,
            "self.enabled":this.selfEnabled,
            "self.visible":this.selfVisible,
            "self.moveTo":this.moveTo,
            "self.teleportTo":this.teleportTo,
            "self.stop":this.stopMoving,
            "self.onattr":this.onNpcAttr,
            "self.setAttr":this.setNpcAttr,
            "self.flip":this.flip,
            "self.flop":this.flop,
            "room.message":this.roomSendMessage,
            "sound.stop":this.stopSound,
            "sound.play":this.playSound,
            "sound.stopBackground":this.stopBackgroundMusic,
            "sound.resumeBackground":this.resumeBackgroundMusic,
            "track.page":this.trackPage,
            "track.event":this.trackEvent,
            "room.change":this.changeRoom,
            "room.ladder":this.changeLadder,
            "room.shake":this.shakeRoom,
            "room.particle":this.roomParticles,
            "room.random":this.changeRoomRandom,
            "dialog.img":this.showDialogBallonWithImg,
            "dialog.imageList":this.showDialogBallonListImg,
            "think.imageList":this.showtThinkBallonListImg,
            "repair.room":this.repairRoom,
            "trigger.BGFunc":this.triggerBackgroundFunc,
            "bg.callFunc":this.bgFunc,
            "change.background":this.changeBgroundDeco,
            "call.function":this.callFunction,
            "room.combat":this.roomCombat,
            "set.dateSession":this.setDateSession,
            "serenito.pixelador":this.serePixelClothes,
            "showPhotTripButton":this.showPhotoTripButton,
            "party.visit":this.partyVisit,
            "party.stopBG":this.partyStopBG,
            "party.resumeBG":this.partyResumeBG,
            "check.arbolState":this.checkArbolState,
            "gotcha":this.gotcha,
            "team.writePosicion":this.writeTeamPosition,
            "dropGift.ownerPlaces":this.dropGiftOwnerPlaces,
            "dropGift.ownerTakes":this.dropGiftOwnerTakes,
            "dropGift.visitorPlaces":this.dropGiftVisitorPlaces,
            "dropGift.setAsset":this.dropGiftSetAsset,
            "counter.increase":this.counterIncrease,
            "counter.decrease":this.counterDecrease,
            "counter.storeAmount":this.storeCounterInVar,
            "counter.amount":this.counterGetAmount,
            "funnys.give":this.giveFunnysPet,
            "funnys.setPetMC":this.setFunnyPet,
            "funnys.open":this.openFlannys,
            "open.shop":this.openShop,
            "contextualMenu.open":this.openContextualMenu,
            "crafting.increase":this.craftingIncrease,
            "notification.custom":this.notificationCustom,
            "antigravity.on":this.antigravityOn,
            "provider.next":this.providerGetNext,
            "provider.giveItem":this.providerGiveItem,
            "carousel.currentName":this.carouselGetCurrentName,
            "carousel.load":this.carouselLoad,
            "carousel.open":this.carouselOpenCurrent,
            "reward.coin":this.awardCoins,
            "launch.html5":this.launchExternalHTML5,
            "launch.html5_mmo":this.launchHTML5_mmo,
            "seretubers.givePlaca":this.seretuberGivePlaca,
            "easter.findConejo":this.easterFindConejo,
            "easter.solvePremio":this.entregaPremioRompehuevo,
            "easter.sushi":this.easterSushi,
            "team.addPoints":this.addExpToTeam,
            "levelup.social":this.addSocialExp,
            "levelup.explorer":this.addExplorerExp,
            "levelup.competitive":this.addCompetitiveExp,
            "purchase.navidad":this.resolvePurchaseNavidad,
            "navidad.scored":this.addScoreNavidad,
            "pepionCatalog":this.openPepionCatalog,
            "reyesCatalog":this.openReyesCatalog,
            "serenitoCatalog":this.openSerenitoCatalog,
            "navidadCatalog":this.openNavidadCatalog,
            "bocaCatalog":this.openBocaCatalog,
            "riverCatalog":this.openRiverCatalog,
            "feriaCatalog":this.openFeriaCatalog,
            "pascuasCatalog":this.openPascuasCatalog,
            "mundialCatalog":this.openMundialCatalog,
            "vipCatalog":this.openVipCatalog,
            "catalog":this.openCatalog,
            "petCatalog":this.openPetCatalog,
            "getUserPetName":this.getActualUserPetName,
            "find":this.find,
            "set":this.setVariable,
            "setCharAt":this.setCharAt,
            "getCharAt":this.getCharAt,
            "copy":this.copyVariable,
            "inc":this.incVariable,
            "dec":this.decVariable,
            "save":this.save,
            "on":this.on,
            "after":this.after,
            "goto":this.goto,
            "minigame":this.startMinigame,
            "log":this.log,
            "ach":this.achiev,
            "modal.photo":this.showPhotoCamera,
            "picapon.joinTeam":this.picaponJoinTeamChallenge,
            "waitSession":this.waitValue,
            "gatucine.selectSeries":this.gatucineSelectSeries
         };
         super();
         this.npcContext = param1;
      }
      
      private function shakeRoom(param1:Number = 500, param2:Number = 2) : void
      {
         trace("NpcActionRunner ...");
         this.roomAPI.shakeRoom(param1,param2);
      }
      
      private function openIphoneNews(param1:String) : void
      {
         this.roomAPI.openIphoneNews(param1);
      }
      
      private function addItemWithOptions(param1:String, param2:int = 1, param3:String = null, param4:String = null) : void
      {
         var attrsObj:Object = null;
         var type:String = param1;
         var amount:int = param2;
         var catalog:String = param3;
         var attrs:String = param4;
         if(catalog == " " || catalog == "null")
         {
            catalog = null;
         }
         if(attrs)
         {
            try
            {
               attrsObj = this.roomAPI.JSONDecode(attrs);
            }
            catch(e:Error)
            {
               roomAPI.log.error("MAL FORMATO DEL JSON EN NPC FILE.");
            }
         }
         this.roomAPI.giveUser(type,amount,catalog,attrsObj);
      }
      
      private function partyVisit() : void
      {
         var _loc1_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         if(_loc1_)
         {
            _loc1_.gotoEvent();
         }
         logger.info(this,"partyVisit()");
      }
      
      private function teleportTo(param1:uint, param2:uint) : void
      {
         this.api.teleportTo(Coord.create(param1,param2));
      }
      
      private function joinQueue(param1:String, param2:String = null, param3:int = 0) : void
      {
         this.api.openQueue(param1,param2,param3);
      }
      
      private function repairRoom() : void
      {
         this.roomAPI.repairRoom();
      }
      
      private function openFlannys() : void
      {
         var _loc1_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc1_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc1_ = new BubbleFlannysService();
            _loc1_.init();
            Context.instance.addByType(_loc1_,BubbleFlannysService);
         }
         var _loc2_:Object = new Object();
         _loc2_.userName = this.api.user.username;
         _loc2_.token = _loc1_.funnysToken;
         this.roomAPI.startUnityMinigame("fluffyflaffy",0,null,_loc2_);
      }
      
      private function addExplorerExp(param1:int) : void
      {
         this.roomAPI.levelManager.addExplorerExp(param1);
      }
      
      private function showSellModal() : void
      {
         this.roomAPI.showSellModal();
      }
      
      private function addCompetitiveExp(param1:int) : void
      {
         this.roomAPI.levelManager.addCompetitiveExp(param1);
      }
      
      private function copyVariable(param1:String, param2:String) : void
      {
         this.setVariable(param1,this.npcContext.getVariable(param2));
      }
      
      private function roomParticles(param1:String, param2:int = 50, param3:int = 0, param4:int = 1, param5:int = 1) : void
      {
         this.roomAPI.foregroundParticles(param1,param2,{
            "directionX":param3,
            "directionY":param4,
            "rotation":param5
         });
      }
      
      private function instanceBannerModal(param1:String, param2:String = null) : void
      {
         this.roomAPI.instantiateBannerModal(param1,this.api,param2);
      }
      
      private function openReyesCatalog(param1:String) : void
      {
         this.roomAPI.openReyesCatalog(param1);
      }
      
      private function error(... rest) : void
      {
         logger.warning(["NpcScript",rest.join(" ")].join(" > "));
      }
      
      private function openFeriaCatalog(param1:String) : void
      {
         this.roomAPI.openFeriaCatalog(param1);
      }
      
      private function get api() : GaturroSceneObjectAPI
      {
         return this.npcContext.api;
      }
      
      private function launchExternalHTML5(param1:String, param2:Object = null) : void
      {
         this.roomAPI.startExternalMinigame(param1,param2);
      }
      
      private function trackEvent(param1:String, param2:String, param3:String = null) : void
      {
         this.roomAPI.trackEvent(param1,param2,param3);
      }
      
      private function getCharAt(param1:int, param2:String) : String
      {
         var _loc3_:Object = this.npcContext.getVariable(param2);
         var _loc4_:String;
         if(!(_loc4_ = String(_loc3_)))
         {
            this.error("Cannot get the variable in ",param2," because it is not defined");
            return "-1";
         }
         param1--;
         return _loc4_.charAt(param1);
      }
      
      private function openPepionCatalog(param1:String) : void
      {
         this.roomAPI.openPepionCatalog(param1);
      }
      
      private function onUserCostumeFetch(param1:DisplayObject, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:AvatarDresser = null;
         var _loc9_:Object = null;
         var _loc3_:MovieClip = param1 as MovieClip;
         if(_loc3_.clothes)
         {
            _loc4_ = _loc3_.clothes;
            _loc5_ = {};
            _loc6_ = [];
            for(_loc7_ in _loc4_)
            {
               _loc9_ = {
                  "name":_loc4_[_loc7_],
                  "part":_loc7_,
                  "pack":param2.assetPack
               };
               _loc6_.push(_loc9_);
            }
            _loc5_.parts = _loc6_;
            (_loc8_ = new AvatarDresser()).dressUser(_loc5_);
         }
      }
      
      private function giveFunnysPet() : void
      {
         var _loc1_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc1_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc1_ = new BubbleFlannysService();
            _loc1_.init();
            Context.instance.addByType(_loc1_,BubbleFlannysService);
         }
         _loc1_.giveFunny(this.onCompleteGiveFunny);
      }
      
      private function openVipCatalog(param1:String) : void
      {
         this.roomAPI.openVipCatalog(param1);
      }
      
      private function flop() : void
      {
         this.api.flop();
      }
      
      private function setCharAt(param1:int, param2:String, param3:Object) : void
      {
         var _loc4_:Object = this.npcContext.getVariable(param2);
         var _loc5_:String;
         if(!(_loc5_ = String(_loc4_)))
         {
            this.error("Cannot set the variable in ",param2," because it is not defined");
            return;
         }
         param1--;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            if(_loc6_ == param1)
            {
               if(_loc5_.charAt(_loc6_) == param3)
               {
                  this.error("The value in ",param2," was already ",param3);
                  return;
               }
            }
            _loc6_++;
         }
         var _loc7_:RegExp = new RegExp("(.{" + param1 + "}).(.*)");
         var _loc8_:String = _loc5_.replace(_loc7_,"$1" + param3 + "$2");
         this.npcContext.setVariable(param2,_loc8_);
      }
      
      private function moveTo(param1:uint, param2:uint) : void
      {
         this.api.moveTo(Coord.create(param1,param2));
      }
      
      private function showAwardModal(param1:String, param2:String, param3:int = 1, param4:String = null) : void
      {
         this.roomAPI.showAwardModal(region.getText(param1),param2,param3,param4 != null ? String(region.getText(param4)) : param4,this.behavior.scriptName);
      }
      
      public function dispose() : void
      {
         this.npcContext = null;
      }
      
      private function showDelayedBanner(param1:Object, param2:int) : void
      {
         var materials:Object = param1;
         var time:int = param2;
         setTimeout(function():void
         {
            instanceBannerModal("ThreeKingsCommunicationBanner",roomAPI.JSONEncode(materials));
         },time);
      }
      
      private function writeTeamPosition() : void
      {
         this.roomAPI.getTeamPosition();
      }
      
      private function stopBackgroundMusic() : void
      {
         this.roomAPI.pauseBackgroundMusic();
      }
      
      private function partyResumeBG() : void
      {
         var _loc1_:String = this.roomAPI.getSession("partyMusic") as String;
         this.roomAPI.playSound(_loc1_);
      }
      
      private function matches(param1:InventorySceneObject, param2:String) : Boolean
      {
         return param2.slice(-1) === "*" ? param1.name.indexOf(param2.slice(0,-1)) === 0 : param1.name === param2;
      }
      
      private function playSound(param1:String, param2:int = 1) : void
      {
         this.roomAPI.playSound(param1,param2);
      }
      
      private function stopSound(param1:String) : void
      {
         this.roomAPI.stopSound(param1);
      }
      
      private function get roomAPI() : GaturroRoomAPI
      {
         return this.npcContext.roomAPI;
      }
      
      private function openContextualMenu(param1:String) : void
      {
         var _loc2_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         _loc2_.addMenu(param1,this.npcContext.api.view);
      }
      
      private function notificationCustom(param1:String) : void
      {
         var _loc2_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc2_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.CUSTOM,{"key":param1}));
      }
      
      private function log(... rest) : void
      {
         this.npcContext.info(rest.join(" "));
      }
      
      private function lookLeft() : void
      {
         this.setAvatarAttribute(Gaturro.EFFECT_KEY,"lookLeft");
      }
      
      private function providerGetNext(param1:String) : String
      {
         var _loc2_:ProviderManager = Context.instance.getByType(ProviderManager) as ProviderManager;
         return _loc2_.getNext(param1);
      }
      
      private function checkValue(param1:String, param2:String, param3:String) : void
      {
         if(String(user.getSession(param2)) == param3)
         {
            this.behavior.goToState(param1);
         }
         else
         {
            setTimeout(this.checkValue,1,param1,param2,param3);
         }
      }
      
      private function showProgress(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.roomAPI.showProgressModal(region.getText(param1),param2,param3,param4);
      }
      
      private function startMinigame(param1:String, param2:Number = 0, param3:String = null) : void
      {
         this.behavior.lock();
         var _loc4_:Coord = !!param3 ? Coord.fromArray(param3.split(",")) : null;
         this.roomAPI.startMinigame(param1,param2,_loc4_);
      }
      
      private function partyStopBG() : void
      {
         var _loc1_:String = this.roomAPI.getSession("partyMusic") as String;
         this.roomAPI.stopSound(_loc1_);
      }
      
      private function changeRoomRandom() : void
      {
         var _loc1_:Array = [25369,25370,25371,25373,25374,25375,25376,25377,25378,26580,31739,31755,31820,32540,32950,33168,33745,33764,33767,33769,33770,33860,34642,35342,37747,38292,38318,38341];
         this.changeRoom(_loc1_[int(Math.random() * _loc1_.length)],"5,5");
      }
      
      private function carouselOpenCurrent(param1:String) : void
      {
         var _loc2_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc2_ = new CatalogCarouselService();
            Context.instance.addByType(_loc2_,CatalogCarouselService);
         }
         else
         {
            _loc2_ = Context.instance.getByType(CatalogCarouselService) as CatalogCarouselService;
         }
         var _loc3_:String = _loc2_.getCurrentCatalogName(param1);
         this.openCatalog(_loc3_);
      }
      
      private function craftingIncrease(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:CraftingManager;
         (_loc4_ = Context.instance.getByType(CraftingManager) as CraftingManager).increase(param1,param2,param3);
      }
      
      private function get behavior() : NpcBehavior
      {
         return this.npcContext.behavior;
      }
      
      private function addExpToTeam(param1:String, param2:int) : void
      {
         this.roomAPI.addTeamPoints(param1,param2);
      }
      
      private function setDateSession(param1:String) : void
      {
         this.api.setSession(param1,this.api.serverTime);
      }
      
      private function callFunction(param1:String, param2:Object = null) : void
      {
         this.api.callFunction(param1,param2);
      }
      
      private function setAmount(param1:String, param2:String) : void
      {
         var _loc4_:GaturroInventory = null;
         var _loc5_:InventorySceneObject = null;
         var _loc3_:int = 0;
         for each(_loc4_ in user.inventories)
         {
            for each(_loc5_ in _loc4_.items)
            {
               if(this.matches(_loc5_,param1))
               {
                  _loc3_++;
               }
            }
         }
         this.setVariable(param2,_loc3_);
      }
      
      private function resolvePurchaseNavidad() : void
      {
         var result:* = undefined;
         result = this.roomAPI.getProfileAttribute("puntosNavidad2018");
         result - 5;
         setTimeout(function():void
         {
            roomAPI.setProfileAttribute("puntosNavidad2018",result);
         },300);
      }
      
      private function selfEnabled(param1:Boolean = true) : void
      {
         this.api.setEnabled(param1);
      }
      
      private function openPascuasCatalog(param1:String) : void
      {
         this.roomAPI.openPascuasCatalog(param1);
      }
      
      private function counterIncrease(param1:String, param2:int = 1) : void
      {
         var _loc3_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         _loc3_.increase(param1,param2);
      }
      
      private function openShop() : void
      {
         this.roomAPI.trackEvent("PASAPORTE:SORTEO_IPHONE","opens_shop");
         this.roomAPI.openURL("http://www.mundogaturro.com/shop");
      }
      
      private function takeToHome() : void
      {
         this.roomAPI.room.visit(this.roomAPI.userAvatar.username);
      }
      
      private function onUserAttr(param1:String, param2:String) : void
      {
         this.on(NpcBehaviorEvent.AVATAR_ATTR_PREFFIX + param1,param2);
      }
      
      private function goto(param1:String, ... rest) : void
      {
         if(rest.length)
         {
            param1 = ArrayUtil.choice(rest.concat(param1)) as String;
         }
         this.behavior.goToState(param1);
      }
      
      private function carouselLoad() : void
      {
         var _loc1_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc1_ = new CatalogCarouselService();
            Context.instance.addByType(_loc1_,CatalogCarouselService);
         }
      }
      
      private function checkArbolState() : void
      {
         var _loc1_:IIterator = null;
         var _loc2_:CraftingModuleModel = null;
         var _loc3_:MovieClip = null;
         if(!this.craftManager)
         {
            this.craftManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         }
         if(this.craftManager)
         {
            _loc1_ = this.craftManager.getMaterialList(101);
            _loc1_.next();
            _loc2_ = _loc1_.current() as CraftingModuleModel;
            _loc3_ = this.api.view.getChildAt(0) as MovieClip;
            if(_loc3_)
            {
               _loc3_.gotoAndStop("state_" + _loc2_.requirement.count);
            }
         }
      }
      
      private function takeEmojis() : void
      {
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:InventorySceneObject = null;
         var _loc10_:uint = 0;
         var _loc1_:GaturroInventory = this.roomAPI.user.inventory(GaturroInventory.BAG) as GaturroInventory;
         var _loc3_:uint = 0;
         var _loc4_:int = getTimer();
         var _loc5_:int = 1;
         while(_loc5_ <= 5)
         {
            _loc6_ = "serenito2017/props.emoji" + _loc5_.toString();
            if((_loc7_ = _loc1_.byTypeFast(_loc6_)).length > 0)
            {
               if(!_loc2_)
               {
                  _loc2_ = _loc6_;
               }
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = _loc7_[_loc8_];
                  _loc1_.remove(_loc9_.id);
                  _loc8_++;
               }
               _loc3_ += _loc7_.length;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            this.setAvatarAction("showObjectUp.serenito2017/props.quest003");
            this.roomAPI.textMessageToGUI("¡AGREGASTE " + _loc3_ + " SEREMOJIS!");
            _loc10_ = uint(this.roomAPI.getSession("seremojiUserCount") as uint || 0);
            this.api.setSession("seremojiUserCount",_loc10_ + _loc3_);
            this.roomAPI.trackEvent("FEATURES:SERENITO2017:EMOJIMETRO:USER",this.roomAPI.user.username);
            this.roomAPI.trackEvent("FEATURES:SERENITO2017:EMOJIMETRO:AMOUNT",_loc3_.toString());
         }
      }
      
      private function setSelfAttribute(param1:String, param2:Object) : void
      {
         this.api.setAttribute(param1,param2);
      }
      
      private function openCatalog(param1:String) : void
      {
         this.roomAPI.openCatalog(param1);
      }
      
      private function addScoreNavidad() : void
      {
         var result:* = undefined;
         result = this.roomAPI.getProfileAttribute("puntosNavidad2018");
         result += 1;
         setTimeout(function():void
         {
            roomAPI.setProfileAttribute("puntosNavidad2018",result);
         },600);
         if(this.roomAPI && this.roomAPI.roomView && Boolean(this.roomAPI.roomView.gui))
         {
            this.roomAPI.roomView.gui.showPrize();
         }
      }
      
      private function showModalTimeOut(param1:String, param2:String = null, param3:String = null) : void
      {
         this.roomAPI.showModal(region.getText(param1),param2,null,param3);
      }
      
      private function incSelfAttribute(param1:String, param2:Object) : void
      {
         var _loc3_:int = this.api.getAttribute(param1) as int;
         this.api.setAttribute(param1,_loc3_ + param2);
      }
      
      private function flip() : void
      {
         this.api.flip();
      }
      
      private function setProfileAttribute(param1:String, param2:Object) : void
      {
         this.roomAPI.setProfileAttribute(param1,param2);
      }
      
      private function setAvatarAction(param1:Object) : void
      {
         this.setAvatarAttribute(Gaturro.ACTION_KEY,param1);
      }
      
      private function showRanking(param1:String) : void
      {
         this.roomAPI.showRanking(param1);
      }
      
      private function incVariable(param1:String, param2:int = 1) : void
      {
         var _loc3_:int = this.npcContext.getVariable(param1) as int;
         this.setVariable(param1,_loc3_ + param2);
      }
      
      private function save(param1:String = null) : void
      {
         var _loc2_:String = String(param1 || this.behavior.state.name);
         if(this.roomAPI.getProfileAttribute(this.npcContext.stateKey) !== _loc2_)
         {
            this.roomAPI.setProfileAttribute(this.npcContext.stateKey,_loc2_);
         }
      }
      
      private function showGiftChristmasModal() : void
      {
         this.roomAPI.showGiftChristmasModal();
      }
      
      private function setAvatarAttribute(param1:String, param2:Object) : void
      {
         this.roomAPI.setAvatarAttribute(param1,param2);
      }
      
      private function openBocaCatalog(param1:String) : void
      {
         this.roomAPI.openBocaCatalog(param1);
      }
      
      private function selfVisible(param1:Boolean = true) : void
      {
         this.api.setVisible(param1);
      }
      
      private function serePixelClothes() : void
      {
         var _loc1_:String = this.roomAPI.getProfileAttribute("quest2") as String;
         if(_loc1_.indexOf("serenito.trajePixelado") == -1)
         {
            return;
         }
         var _loc2_:Inventory = this.roomAPI.user.inventory("visualizer");
         var _loc3_:Array = _loc2_.byType(_loc1_);
         if(_loc3_.length == 0)
         {
            this.roomAPI.giveUser(_loc1_);
         }
         this.roomAPI.libraries.fetch(_loc1_,this.onSerenitoFetch);
      }
      
      private function showDialogBallonWithImg(param1:String, param2:String) : void
      {
         this.roomAPI.showDialogBallomWithImg(this.api.view,region.getText(param1),param2);
      }
      
      private function moveAvatar(param1:Number, param2:Number) : void
      {
         this.roomAPI.moveToTileXY(param1,param2);
      }
      
      public function run(param1:NpcStatement) : void
      {
         var _loc2_:String = param1.reserved;
         if(_loc2_ in this.actions)
         {
            this.actions[_loc2_].apply(this,param1.getArguments(this.npcContext));
            return;
         }
         throw new NpcInterpreterError("No action named \"" + _loc2_ + "\" was found");
      }
      
      private function dropGiftSetAsset() : void
      {
         var _loc1_:String = this.api.getAttribute("materials") as String;
         var _loc2_:Object = this.roomAPI.JSONDecode(_loc1_) || {};
         var _loc3_:MovieClip = this.api.view.getChildAt(0) as MovieClip;
         var _loc4_:MovieClip = _loc3_.getChildByName("agua") as MovieClip;
         var _loc5_:MovieClip = _loc3_.getChildByName("pasto") as MovieClip;
         var _loc6_:MovieClip = _loc3_.getChildByName("gift") as MovieClip;
         if(Boolean(_loc2_) && Boolean(_loc2_.agua))
         {
            _loc4_.gotoAndStop("agua");
         }
         else
         {
            _loc4_.gotoAndStop(1);
         }
         if(Boolean(_loc2_) && Boolean(_loc2_.pasto))
         {
            _loc5_.gotoAndStop("pasto");
         }
         else
         {
            _loc5_.gotoAndStop(1);
         }
         if(_loc2_ && _loc2_.ready && Boolean(_loc6_))
         {
            _loc6_.visible = true;
         }
         else
         {
            _loc6_.visible = false;
         }
      }
      
      private function gotcha() : void
      {
         this.roomAPI.trackEvent("HACKING:ROOMS:NAVIDAD",user.username + "_" + this.roomAPI.room.id);
      }
      
      private function trackPage(... rest) : void
      {
         this.roomAPI.trackPage.apply(this.roomAPI,rest);
      }
      
      private function onNpcAttr(param1:String, param2:String) : void
      {
         this.on(NpcBehaviorEvent.NPC_ATTR_PREFFIX + param1,param2);
      }
      
      private function achiev(param1:String) : void
      {
         achievements.achieveNow(param1);
      }
      
      private function userCostume(param1:String) : void
      {
         var _loc2_:String = String(param1.split(".")[0]);
         this.roomAPI.libraries.fetch(param1,this.onUserCostumeFetch,{"assetPack":_loc2_});
      }
      
      private function removeItems(param1:uint, param2:String) : void
      {
         this.api.takeFromUser(param2,param1);
         var _loc3_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc3_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.NPC_TAKES,{
            "type":param2,
            "amount":param1
         }));
      }
      
      private function decVariable(param1:String, param2:int = 1) : void
      {
         this.incVariable(param1,-param2);
      }
      
      private function addItems(param1:uint, param2:String, param3:String = null) : void
      {
         this.api.giveUser(param2,param1,param3);
         var _loc4_:NotificationManager;
         (_loc4_ = Context.instance.getByType(NotificationManager) as NotificationManager).brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.NPC_GIVES,{
            "type":param2,
            "amount":param1
         }));
      }
      
      private function dropGiftOwnerPlaces() : void
      {
         var _loc1_:String = this.api.getAttribute("materials") as String;
         var _loc2_:Object = this.roomAPI.JSONDecode(_loc1_) || {};
         var _loc3_:GaturroInventory = this.roomAPI.user.inventory(GaturroInventory.BAG) as GaturroInventory;
         if(_loc2_ && !_loc2_.pasto && _loc3_.hasAnyOf("reyes2017/props.pasto"))
         {
            this.removeItems(1,"reyes2017/props.pasto");
            _loc2_.pasto = 1;
            this.setAvatarAction("showObjectUp.reyes2017/props.pasto");
            this.api.setAttributePersist("materials",this.roomAPI.JSONEncode(_loc2_));
            this.notificationCustom("reyesPasto");
            this.showDelayedBanner(_loc2_,3000);
            return;
         }
         if(_loc2_ && !_loc2_.agua && _loc3_.hasAnyOf("reyes2017/props.agua"))
         {
            this.removeItems(1,"reyes2017/props.agua");
            _loc2_.agua = 1;
            this.setAvatarAction("showObjectUp.reyes2017/props.agua");
            this.api.setAttributePersist("materials",this.roomAPI.JSONEncode(_loc2_));
            this.notificationCustom("reyesAgua");
            this.showDelayedBanner(_loc2_,3000);
            return;
         }
         this.showDelayedBanner(_loc2_,1);
      }
      
      private function onCompleteGiveFunny(param1:Event = null) : void
      {
         var bubbleFlanysServie:BubbleFlannysService = null;
         var e:Event = param1;
         (this.api.view.getChildAt(0) as MovieClip).gotoAndPlay(0);
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            bubbleFlanysServie = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            bubbleFlanysServie = new BubbleFlannysService();
            bubbleFlanysServie.init();
            Context.instance.addByType(bubbleFlanysServie,BubbleFlannysService);
         }
         (this.api.view.getChildAt(0) as MovieClip).idle.visible = false;
         (this.api.view.getChildAt(0) as MovieClip).anim.visible = true;
         (this.api.view.getChildAt(0) as MovieClip).anim.gotoAndPlay(0);
         setTimeout(function():void
         {
            roomAPI.instantiateBannerModal("FannysRewardBanner");
         },1300);
      }
      
      private function openNavidadCatalog(param1:String) : void
      {
         this.roomAPI.openNavidadCatalog(param1);
      }
      
      private function showCaptureModal(param1:Boolean) : void
      {
         this.roomAPI.showPhotoCamera(param1);
      }
      
      private function awardCoins(param1:int) : void
      {
         var _loc2_:int = this.roomAPI.getProfileAttribute("coins") as int;
         _loc2_ += param1;
         this.roomAPI.setProfileAttribute("system_coins",_loc2_);
      }
      
      private function showPartiesModal() : void
      {
         this.roomAPI.showBannerModal("parties",this.api);
      }
      
      private function storeCounterInVar(param1:String, param2:String) : void
      {
         this.setVariable(param2,this.counterGetAmount(param1));
      }
      
      private function bgFunc(param1:String, param2:Object = null) : void
      {
         this.roomAPI.roomView.callOnBGround(param1,param2);
      }
      
      private function resumeBackgroundMusic() : void
      {
         this.roomAPI.resumeBackgroundMusic();
      }
      
      private function changeRoom(param1:Number, param2:String = null) : void
      {
         var _loc3_:Coord = !!param2 ? Coord.fromArray(param2.split(",")) : null;
         this.roomAPI.changeRoom(param1,_loc3_);
      }
      
      private function launchHTML5_mmo() : void
      {
         this.roomAPI.startHtmlMMO();
      }
      
      private function roomCombat(param1:String) : void
      {
         this.roomAPI.roomView.dispatchEvent(new CombatEvent(param1,this.api));
      }
      
      private function showModal(param1:String, param2:String = null, param3:String = null) : void
      {
         this.roomAPI.showModal(region.getText(param1),param2,param3 != null ? String(region.getText(param3)) : param3);
      }
      
      private function showDialogBallonListImg(param1:String, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:Array = param1.split(" ");
         this.roomAPI.showDialogBallomListImg(this.api.view,param2,param3,_loc4_);
      }
      
      private function betterPassportModal(param1:String) : void
      {
         var _loc2_:BetterWithPassportManager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         _loc2_.openModal(param1);
      }
      
      public function showSkinModal(param1:String, param2:String = "", param3:String = "", param4:String = "") : void
      {
         this.roomAPI.showSkinModal(region.getText(param1),param2,param3 != null ? String(region.getText(param3)) : param3,param4);
      }
      
      private function setFunnyPet() : void
      {
         var _loc1_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc1_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc1_ = new BubbleFlannysService();
            _loc1_.init();
            Context.instance.addByType(_loc1_,BubbleFlannysService);
         }
         (this.api.view.getChildAt(0) as MovieClip).anim.visible = false;
         (this.api.view.getChildAt(0) as MovieClip).idle.visible = true;
      }
      
      private function find(param1:String, param2:uint = 0) : void
      {
         var _loc3_:Array = this.roomAPI.objects;
         ArrayUtil.removeElement(_loc3_,this.api.object);
         var _loc4_:RoomSceneObject;
         var _loc5_:Number = !!(_loc4_ = InternalFindHandler.find(_loc3_,param1,param2)) ? _loc4_.id : 0;
         if(_loc4_ is NpcRoomSceneObject)
         {
            if((_loc4_ as NpcRoomSceneObject).behaviorState == "disabled")
            {
               return;
            }
         }
         this.npcContext.setVariable(NpcScript.LAST_FIND,_loc5_);
      }
      
      private function showPhotoCamera(param1:Boolean = false) : void
      {
         this.roomAPI.showPhotoCamera(param1);
      }
      
      private function showBannerModal(param1:String, param2:String = null) : void
      {
         this.roomAPI.showBannerModal(param1,this.api,param2);
      }
      
      private function lookRight() : void
      {
         this.setAvatarAttribute(Gaturro.EFFECT_KEY,"lookRight");
      }
      
      private function setNpcAttr(param1:String, param2:String) : void
      {
         var _loc3_:Object = this.api.getAttribute(param1);
         this.setVariable(param2,_loc3_);
      }
      
      private function counterDecrease(param1:String, param2:int = 1) : void
      {
         var _loc3_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         _loc3_.decrease(param1,param2);
      }
      
      private function display(param1:String, param2:Boolean = false) : void
      {
         this.api.setState(param1,param2);
      }
      
      private function gatucineSelectSeries() : void
      {
         gatucine.selectTv();
      }
      
      private function removeItemToDress(param1:String, param2:String) : void
      {
         var _loc3_:InventorySceneObject = this.api.takeFromUserWithItem(param1,1);
         var _loc4_:Object = {
            "hats":_loc3_.attributes.hats.split(".")[1],
            "leg":_loc3_.attributes.leg.split(".")[1],
            "foot":_loc3_.attributes.foot.split(".")[1],
            "cloth":_loc3_.attributes.cloth.split(".")[1],
            "arm":_loc3_.attributes.arm.split(".")[1]
         };
         var _loc5_:String = this.roomAPI.JSONEncode(_loc4_);
         this.api.setAttributePersist(param2,_loc5_);
         this.api.object.dispatchEvent(new Event(NpcUtility.CHANGE_DRESS));
      }
      
      private function easterSushi() : void
      {
         var _loc1_:Array = ["easter.fish1","easter.fish5","easter.fish6","easter.fish7","easter.fish8","easter.fish9","easter.fish10","easter.fish12","easter.fish13"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(this.api.userHasItems(_loc1_[_loc2_]))
            {
               this.api.takeFromUser(_loc1_[_loc2_]);
               this.addItems(1,"food.sushi");
               this.showModal("UN DELICIOSO SUSHI","food.sushi");
               CatalogUtils.giveCoins("chocomonedas",this.roomAPI.user.isCitizen ? 3 : 1);
               if(this.roomAPI.user.isCitizen)
               {
                  setTimeout(this.roomAPI.setAvatarAttribute,1500,"effect","head.pascuas2018/props.moneda3_on");
               }
               else
               {
                  setTimeout(this.roomAPI.setAvatarAttribute,1500,"effect","head.pascuas2018/props.moneda1_on");
               }
               return;
            }
            _loc2_++;
         }
      }
      
      private function roomSendMessage(param1:String) : void
      {
         this.setAvatarAttribute("message",this.npcContext.name + ":" + param1);
      }
      
      private function easterFindConejo() : void
      {
         var _loc1_:Array = ["pascuas2018/props.conejo1","pascuas2018/props.conejo2","pascuas2018/props.conejo3","pascuas2018/props.conejo4","pascuas2018/props.conejo5","pascuas2018/props.conejo6","pascuas2018/props.conejo7"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(this.api.userHasItems(_loc1_[_loc2_]))
            {
               this.api.takeFromUser(_loc1_[_loc2_]);
               this.roomAPI.setAvatarAttribute("action","showObject." + _loc1_[_loc2_]);
               this.roomAPI.setSession("currentConejo2018",_loc1_[_loc2_]);
               setTimeout(this.roomAPI.setAvatarAttribute,800,"action","stand");
               return;
            }
            _loc2_++;
         }
      }
      
      private function setAvatarEffect(param1:Object) : void
      {
         this.setAvatarAttribute(Gaturro.EFFECT_KEY,param1);
      }
      
      private function antigravityOn() : void
      {
         this.roomAPI.antigravityOn();
      }
      
      private function addSocialExp(param1:int) : void
      {
         this.roomAPI.levelManager.addSocialExp(param1);
      }
      
      private function showPhotoTripButton() : void
      {
         this.roomAPI.showPhotoTripButton();
      }
      
      private function counterGetAmount(param1:String) : int
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc2_.getAmount(param1);
      }
      
      private function providerGiveItem(param1:String) : void
      {
         var _loc2_:String = this.providerGetNext(param1);
         this.roomAPI.trackEvent("FEATURES:SERENITO2017:NPC:entrega_emoji",_loc2_);
         this.showAwardModal("OBTUVISTE UN EMOJI",_loc2_);
      }
      
      private function openRiverCatalog(param1:String) : void
      {
         this.roomAPI.openRiverCatalog(param1);
      }
      
      private function picaponJoinTeamChallenge(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:SocialNetMessage = SocialNet.getJoinedChallengeMessage(param1,param2,param3);
         socialNet.sendMessage(_loc4_);
      }
      
      private function getActualUserPetName() : String
      {
         return "mulita";
      }
      
      private function after(param1:Number, param2:String) : void
      {
         this.behavior.startTimeout(param2,param1 * 1000);
      }
      
      private function setAvatarEmote(param1:Object) : void
      {
         this.setAvatarAttribute(Gaturro.EMOTE_KEY,param1);
      }
      
      private function on(param1:String, param2:String) : void
      {
         this.behavior.setEvent(param1,param2);
      }
      
      private function onSerenitoFetch(param1:DisplayObject) : void
      {
         var _loc3_:String = null;
         var _loc2_:MovieClip = param1 as MovieClip;
         if(_loc2_.clothes)
         {
            for(_loc3_ in _loc2_.clothes)
            {
               this.roomAPI.giveInstantCloth(_loc3_,"serenito." + _loc2_.clothes[_loc3_]);
            }
         }
      }
      
      private function dropGiftVisitorPlaces() : void
      {
         this.instanceBannerModal("GiftBanner");
      }
      
      private function entregaPremioRompehuevo() : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc1_:String = this.api.getSession("currentConejo2018") as String;
         this.roomAPI.takeFromUser(_loc1_);
         if(Math.random() > 0.5)
         {
            this.roomAPI.setAvatarAttribute("effect","head.easter2015.efectoChocolate_on");
            CatalogUtils.giveCoins("chocomonedas",this.roomAPI.user.isCitizen ? 3 : 1);
            if(this.roomAPI.user.isCitizen)
            {
               setTimeout(this.roomAPI.setAvatarAttribute,1500,"effect","head.pascuas2018/props.moneda3_on");
            }
            else
            {
               setTimeout(this.roomAPI.setAvatarAttribute,1500,"effect","head.pascuas2018/props.moneda1_on");
            }
         }
         else
         {
            _loc2_ = ["havanna.conejo1","havanna.conejo2","havanna.conejo5","havanna.conejo6","easterCostumes.gorroConejo1","easter.canasta3","havanna.conejo1","havanna.conejo2","havanna.conejo5","havanna.conejo6","easterCostumes.gorroConejo1","easter.canasta3","havanna.conejo1","havanna.conejo2","havanna.conejo5","havanna.conejo6","easterCostumes.gorroConejo1","easter.canasta3","easterCostumes.remeraConejo1","easterCostumes.jeanConejo1","easterCostumes.botaConejo1","easterCostumes.gorroConejo2","easterCostumes.remeraConejo2","easterCostumes.jeanConejo2","easterCostumes.botaConejo2","easterCostumes.gorroConejo3","easterCostumes.remeraConejo3","easterCostumes.jeanConejo3","easterCostumes.botaConejo3","easterCostumes.gorroConejo4","easterCostumes.remeraConejo4","easterCostumes.jeanConejo4","easterCostumes.botaConejo4","easterCostumes.gorroConejo1","easter.canasta3","easterCostumes.remeraConejo1","easterCostumes.jeanConejo1","easterCostumes.botaConejo1","easterCostumes.gorroConejo2","easterCostumes.remeraConejo2","easterCostumes.jeanConejo2","easterCostumes.botaConejo2","easterCostumes.gorroConejo3","easterCostumes.remeraConejo3","easterCostumes.jeanConejo3","easterCostumes.botaConejo3","easterCostumes.gorroConejo4","easterCostumes.remeraConejo4","easterCostumes.jeanConejo4","easterCostumes.botaConejo4","gatumemes2018/wears.gota"];
            _loc3_ = uint(int(Math.random() * _loc2_.length));
            this.addItems(1,_loc2_[_loc3_]);
            this.showModal("¡EL CONEJO TENÍA PREMIO!",_loc2_[_loc3_]);
         }
      }
      
      private function openPetCatalog(param1:String, param2:String = null) : void
      {
         this.roomAPI.openPetCatalog(param1,param2);
      }
      
      private function changeBgroundDeco(param1:String, param2:String, param3:String = "") : void
      {
         var _loc4_:MovieClip = null;
         var _loc6_:DisplayObject = null;
         var _loc5_:int = 0;
         while(_loc5_ < this.roomAPI.roomView.numChildren)
         {
            if((_loc6_ = this.roomAPI.roomView.getChildAt(_loc5_)).name == param1)
            {
               trace(getQualifiedClassName(_loc6_));
               _loc4_ = _loc6_ as MovieClip;
            }
            _loc5_++;
         }
         if(Boolean(_loc4_) && Boolean(_loc4_[param2]))
         {
            if(!param3)
            {
               _loc4_[param2].gotoAndStop("on");
            }
            else
            {
               _loc4_[param2][param3]();
            }
         }
      }
      
      private function showGiftModal() : void
      {
         this.roomAPI.showGiftModal();
      }
      
      private function seretuberGivePlaca() : void
      {
         var _loc1_:Array = ["LAUTYDL","BYVALENGATUBER","ZORZ","PIOLAVAGOTEVES","DIGUANGTPLAY","YULIAAXD","MUNIECATOR","DAISYCASH010M","MIAAMESYTT","TAPION164","ALANCHURRO","ANABELL3290","LABELLAGATA11111","MROVERE2"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(this.roomAPI.user.username == _loc1_[_loc2_])
            {
               this.showAwardModal("PLACA DESAFÍO SERETUBERS","seretubers2017/deco.placaSeretubers" + (_loc2_ + 1));
            }
            _loc2_++;
         }
      }
      
      private function triggerBackgroundFunc(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.roomAPI.roomView.numChildren)
         {
            if((_loc5_ = this.roomAPI.roomView.getChildAt(_loc3_)).name == "layer2")
            {
               _loc2_ = _loc5_ as MovieClip;
            }
            _loc3_++;
         }
         if(Boolean(_loc2_) && _loc2_.privateWall_container.numChildren > 0)
         {
            (_loc4_ = _loc2_.privateWall_container.getChildAt(0))[param1]();
         }
      }
      
      private function showtThinkBallonListImg(param1:String, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:Array = param1.split(" ");
         this.roomAPI.showThinkBallomListImg(this.api.view,param2,param3,_loc4_);
      }
      
      private function openMundialCatalog(param1:String) : void
      {
         this.roomAPI.openMundialCatalog(param1);
      }
      
      private function carouselGetCurrentName(param1:String) : String
      {
         var _loc2_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc2_ = new CatalogCarouselService();
            Context.instance.addByType(_loc2_,CatalogCarouselService);
         }
         else
         {
            _loc2_ = Context.instance.getByType(CatalogCarouselService) as CatalogCarouselService;
         }
         return _loc2_.getCurrentCatalogName(param1);
      }
      
      private function stopMoving() : void
      {
         this.api.stopMoving();
      }
      
      private function changeLadder() : void
      {
      }
      
      private function openSerenitoCatalog(param1:String) : void
      {
         this.roomAPI.openSerenitoCatalog(param1);
      }
      
      private function setAvatarState(param1:String, param2:Boolean = true) : void
      {
         this.roomAPI.setAvatarState(param1,param2);
      }
      
      private function dropGiftOwnerTakes() : void
      {
         var _loc1_:String = this.api.getAttribute("materials") as String;
         var _loc2_:Object = this.roomAPI.JSONDecode(_loc1_) || {};
         this.instanceBannerModal("ThreeKingsCommunicationBanner",this.roomAPI.JSONEncode(_loc2_));
      }
      
      private function showProgressByItem(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc7_:Array = null;
         var _loc5_:GaturroInventory = this.roomAPI.user.inventory(param3) as GaturroInventory;
         var _loc6_:int = 0;
         if(_loc5_)
         {
            if(_loc7_ = _loc5_.byType(param2))
            {
               _loc6_ = _loc7_.length > int(param4) ? int(param4) : int(_loc7_.length);
            }
         }
         param1 += "\n" + _loc6_ + " de " + param4;
         this.roomAPI.showProgressModal(region.getText(param1),param2,String(_loc6_),param4);
      }
      
      private function waitValue(param1:String, ... rest) : void
      {
         var _loc3_:String = String(rest[0]);
         var _loc4_:String = String(rest[1]);
         this.checkValue(param1,_loc3_,_loc4_);
      }
      
      private function setVariable(param1:String, param2:Object) : void
      {
         this.npcContext.setVariable(param1,param2);
      }
   }
}
