package com.qb9.gaturro.editor
{
   import com.qb9.flashlib.input.Console;
   import com.qb9.flashlib.input.Hotkey;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.stageData;
   import com.qb9.gaturro.net.security.files.FileControlTesting;
   import com.qb9.gaturro.quest.model.GaturroSystemQuestModel;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.net.manager.NetworkManager;
   import flash.utils.Dictionary;
   
   public final class ConsoleEditor implements IDisposable
   {
       
      
      private var actions:com.qb9.gaturro.editor.NetActionManager;
      
      private var console:Console;
      
      private var hotKey:Hotkey;
      
      private var net:NetworkManager;
      
      public function ConsoleEditor(param1:Console, param2:com.qb9.gaturro.editor.NetActionManager, param3:NetworkManager)
      {
         super();
         this.console = param1;
         this.actions = param2;
         this.net = param3;
         this.init();
      }
      
      public function fileControlCheckBanners() : void
      {
         FileControlTesting.check(this.console,"banners");
      }
      
      private function setupHotkeys() : void
      {
         this.hotKey = new Hotkey(this.console);
         this.hotKey.add("F2",this.actions.reloadRoom);
         this.hotKey.add("F3",this.actions.reloadServer);
      }
      
      private function serverHost() : String
      {
         var _loc1_:Object = settings.connection;
         return _loc1_.address + ":" + _loc1_.port;
      }
      
      private function showInviter(param1:String, param2:String) : void
      {
         api.setAvatarAttribute(Gaturro.EFFECT2_KEY,param1 + ":" + param2);
      }
      
      private function init() : void
      {
         this.r("scene.add",this.actions.addSceneObject);
         this.r("scene.portal",this.actions.addPortal);
         this.r("scene.byId",this.actions.sceneObjectById);
         this.r("scene.attr",this.actions.sceneAttr);
         this.r("scene.move",this.actions.sceneMove);
         this.r("scene.resize",this.actions.sceneResize);
         this.r("scene.rename",this.actions.sceneRename);
         this.r("scene.blocks",this.actions.sceneBlocks);
         this.r("scene.destroy",this.actions.sceneDestroy);
         this.r("scene.replace",this.actions.sceneReplace);
         this.r("scene.batchDestroy",this.actions.sceneBatchDestroy);
         this.r("scene.all",this.actions.sceneAll);
         this.r("scene.at",this.actions.sceneAt);
         this.r("scene.npcState",this.actions.getCurrentNpcState);
         this.r("room.id",this.actions.roomId);
         this.r("room.name",this.actions.roomName);
         this.r("room.size",this.actions.roomSize);
         this.r("room.attr",this.actions.roomAttr);
         this.r("room.change",this.actions.changeRoom);
         this.r("room.go",this.actions.changeRoomByName);
         this.r("room.reload",this.actions.reloadRoom);
         this.r("room.coord",this.actions.roomCoord);
         this.r("room.interaction",this.actions.interaction);
         this.r("room.showView",this.actions.freeze);
         this.r("room.showView",this.actions.unfreeze);
         this.r("room.hub",this.actions.roomHub);
         this.r("room.shake",this.actions.shake);
         this.r("room.showCamera",this.actions.showCamera);
         this.r("room.test",this.actions.changeToTestRoom);
         this.r("user.id",this.actions.userId);
         this.r("user.name",this.actions.userName);
         this.r("user.coord",this.actions.userCoord);
         this.r("user.sceneObjectId",this.actions.userSceneObjectId);
         this.r("user.attr",this.actions.userAttr);
         this.r("user.isCitizen",this.actions.userIsCitizen);
         this.r("user.passportDate",this.actions.passportDate);
         this.r("user.block",this.actions.userBlock);
         this.r("user.unblock",this.actions.userUnblock);
         this.r("user.cloth",this.actions.userCloth);
         this.r("user.costume",this.actions.userCostume);
         this.r("user.setTime",this.serverSetTime);
         this.r("user.sessionCount",this.actions.sessionCount);
         this.r("inventory.items",this.actions.inventoryItems);
         this.r("inventory.add",this.actions.inventoryAdd);
         this.r("inventory.removeAll",this.actions.inventoryRemoveAll);
         this.r("inventory.file",this.actions.inventoryFile);
         this.r("inventory.empty",this.actions.inventoryEmpty);
         this.r("avatar.byId",this.actions.avatarById);
         this.r("avatar.byName",this.actions.avatarByName);
         this.r("avatar.attributes",this.actions.avatarAttributes);
         this.r("avatar.all",this.actions.avatarAll);
         this.r("home.go",this.actions.goHome);
         this.r("minigame.start",this.actions.startMinigame);
         this.r("minigame",this.actions.startMinigame);
         this.r("minigame.html5",api.startExternalMinigame);
         this.r("minigame.unity",api.startUnityMinigame);
         this.r("test.GA",api.testGoogleAnalytics);
         this.r("minigame.pocket",api.startPocket);
         this.r("mmoHTML.start",api.startHtmlMMO);
         this.r("minigame.local",this.localMinigames);
         this.r("tile.block",this.actions.blockTile);
         this.r("tile.unblock",this.actions.unblockTile);
         this.r("tile.toggle",this.toggleTiles);
         this.r("net.login",this.actions.login);
         this.r("net.logout",this.actions.logout);
         this.r("chat.invite",this.actions.chatInvite);
         this.r("chat.global",this.actions.globalChat);
         this.r("profile.coins",this.actions.profileCoins);
         this.r("profile.attr",this.actions.profileAttr);
         this.r("profile.winPoints",this.actions.profileWinCoins);
         this.r("session.attr",this.actions.sessionAttr);
         this.r("server.time",this.serverTime);
         this.r("server.date",this.serverDate);
         this.r("server.host",this.serverHost);
         this.r("server.reload",this.actions.reloadServer);
         this.r("server.name",this.serverName);
         this.r("system.quality",this.systemQuality);
         this.r("system.frameRate",this.systemFramerate);
         this.r("lan.id",this.actions.lanId);
         this.r("lan.test",this.actions.lanTest);
         this.r("lan.change",this.actions.lanChange);
         this.r("country.id",this.actions.countryId);
         this.r("country.change",this.actions.countryChange);
         this.r("translationsLog.in",this.actions.logonTranslations);
         this.r("translationsLog.out",this.actions.logoffTranslations);
         this.r("eplanning.enabled",this.actions.eplanning);
         this.r("eplanning.state",this.actions.eplanningState);
         this.r("open.banner",this.actions.openBanner);
         this.r("modal.banner",this.actions.openBanner);
         this.r("modal.instanceBanner",this.actions.instanceBanner);
         this.r("modal.betterWithPassaport",this.actions.betterWithPassport);
         this.r("open.catalog",this.actions.openCatalog);
         this.r("open.vipCatalog",api.openVipCatalog);
         this.r("catalog",this.actions.openCatalog);
         this.r("catalog.select",this.actions.catalogCarouselSelect);
         this.r("catalog.deff",this.actions.catalogCarouselGetDeff);
         this.r("multiplayer.create",this.actions.multiplayerCreate);
         this.r("multiplayer.stressTest",this.actions.multiplayerTestStress);
         this.r("multiplayer.list",this.actions.multiplayerList);
         this.r("multiplayer.participe",this.actions.multiplayerParticipe);
         this.r("multiplayer.init",this.actions.multiplayerInit);
         this.r("cellPhone.app.add",this.actions.cellPhoneAppAdd);
         this.r("cellPhone.app.remove",this.actions.cellPhoneAppRemove);
         this.r("performanceControl.enabled",this.performance);
         this.r("cards.add",this.actions.cardsAdd);
         this.r("tutorial.start",this.actions.tutorialStart);
         this.r("filecontrol.checkAssets",this.fileControlCheckAssets);
         this.r("filecontrol.checkNpc",this.fileControlCheckNpc);
         this.r("filecontrol.checkBanners",this.fileControlCheckBanners);
         this.r("filecontrol.checkConfigs",this.fileControlCheckConfigs);
         this.r("gatucine.test",this.actions.gatucineTest);
         this.r("team.addPoints",this.actions.addPointsTeamManager);
         this.r("team.getListPoints",this.actions.getTeamListPoints);
         this.r("team.getPoints",this.actions.getPoints);
         this.r("team.getMyTeamPoints",this.actions.getMyTeamPoints);
         this.r("team.suscribe",this.actions.suscribeTeam);
         this.r("constraint.isAccomplished",this.actions.isAccomplished);
         this.r("counter.info",this.actions.counterInfo);
         this.r("counter.reset",this.actions.counterReset);
         this.r("counter.increase",this.actions.counterIncrease);
         this.r("craft.increase",this.actions.craftIncrease);
         this.r("craft.reset",this.actions.craftReset);
         this.r("quest.reset",this.actions.questReset);
         this.r("quest.complete",this.actions.questAddCompleted);
         this.r("quest.getCompleted",this.getCompletedQuestList);
         this.r("quest.getActive",this.getActiveQuestList);
         this.r("aProvider.hasMore",this.actions.providerHasMore);
         this.r("aProvider.getNext",this.actions.providerGetNext);
         this.r("antigravity.on",this.actions.antigravityOn);
         this.r("events.mocap",this.actions.mocap);
         this.r("events.clean",this.actions.disposeEvent);
         this.r("events.go",api.gotoEvent);
         this.r("boca.tournament.forceClean",this.actions.bocaLeaderboardForceClean);
         this.r("fede.tools",this.fedeTools);
         this.r("fede.tools.inviter",this.showInviter);
         this.r("fede.tools.invokeMayhem",this.invokeMayhem);
         this.r("user.setting",this.actions.userSetting);
         this.r("music.interprete",this.actions.musicInterprete);
         this.r("music.playCurrent",this.actions.musicPlayCurrent);
         this.r("music.pause",this.actions.pauseBackgroundMusic);
         this.r("music.resume",this.actions.resumeBackgroundMusic);
         this.r("loginPocket",this.callLogingPocket);
         this.r("clean.cache",this.cleanCache);
         this.r("reset",this.actions.applayMacro);
         this.r("r",this.actions.applayMacro);
         this.r("macro",this.actions.readMacro);
         this.r("m",this.actions.readMacro);
         this.r("export.room",this.actions.exportRoom);
         this.r("export.avatar",this.actions.exportAvatar);
         this.r("export.so",this.actions.exportSo);
         this.r("levelup.explorer",this.addExplorerExp);
         this.r("levelup.comp",this.addCompExp);
         this.r("levelup.social",this.addSocExp);
         this.r("levelup.reset",api.levelManager.resetLevels);
         this.r("gui.message",api.textMessageToGUI);
         this.setupHotkeys();
      }
      
      private function serverDate() : String
      {
         return server.date.toString();
      }
      
      private function callLogingPocket(param1:String, param2:String) : void
      {
         var _loc3_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc3_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc3_ = new BubbleFlannysService();
            Context.instance.addByType(_loc3_,BubbleFlannysService);
         }
         _loc3_.clonEinit(param1,param2);
      }
      
      private function serverSetTime(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc2_:Date = new Date(server.time);
         trace(server.time,new Date(server.time));
         var _loc3_:Array = param1.split("-");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = Number(_loc4_);
            if(isNaN(_loc5_))
            {
               trace("Incorrect time format. Use DD-MM-YYYY as in 10-11-1986");
               return;
            }
         }
         switch(_loc3_.length)
         {
            case 3:
               _loc2_.setFullYear(Number(_loc3_[2]));
            case 2:
               _loc2_.setMonth(Number(_loc3_[1]) - 1);
            case 1:
               _loc2_.setDate(Number(_loc3_[0]));
         }
         trace("Old > ",server.time,new Date(server.time));
         server.time = _loc2_.time;
         trace("New > ",server.time,new Date(server.time));
      }
      
      private function toggleTiles() : void
      {
         var _loc1_:Object = settings.debug;
         _loc1_.showTiles = !_loc1_.showTiles;
         this.actions.reloadRoom();
      }
      
      public function fileControlCheckNpc() : void
      {
         FileControlTesting.check(this.console,"npc");
      }
      
      public function getActiveQuestList() : String
      {
         var _loc4_:String = null;
         var _loc1_:GaturroSystemQuestModel = Context.instance.getByType(GaturroSystemQuestModel) as GaturroSystemQuestModel;
         var _loc2_:Dictionary = _loc1_.getActiveQuests();
         var _loc3_:String = "";
         for(_loc4_ in _loc2_)
         {
            _loc3_ += _loc4_ + ": " + _loc1_.getQuest(int(_loc4_)) + "\n";
         }
         return _loc3_;
      }
      
      private function addSocExp(param1:int) : void
      {
         api.levelManager.addSocialExp(param1);
      }
      
      private function localMinigames(... rest) : Boolean
      {
         if(rest.length)
         {
            settings.debug.localMinigames = !!rest[0];
         }
         return !!settings.debug.localMinigames;
      }
      
      private function invokeMayhem() : void
      {
         api.setAvatarAttribute("message",api.user.username + ":modEvent");
      }
      
      private function systemFramerate(param1:Number = 0) : Number
      {
         if(param1)
         {
            stageData.frameRate = param1;
         }
         return stageData.frameRate;
      }
      
      public function dispose() : void
      {
         this.actions = null;
         this.console = null;
         this.net = null;
         this.hotKey.dispose();
         this.hotKey = null;
      }
      
      private function systemQuality(param1:String = null) : String
      {
         if(param1)
         {
            stageData.quality = param1;
         }
         return stageData.quality;
      }
      
      public function fileControlCheckAssets() : void
      {
         FileControlTesting.check(this.console,"assets");
      }
      
      private function addCompExp(param1:int) : void
      {
         api.levelManager.addCompetitiveExp(param1);
      }
      
      private function serverName() : String
      {
         return server.serverName;
      }
      
      private function serverTime() : Number
      {
         return server.time;
      }
      
      public function fileControlCheckConfigs() : void
      {
         FileControlTesting.check(this.console,"config");
      }
      
      private function r(param1:String, param2:Function) : void
      {
         this.console.register(param1,param2);
      }
      
      private function performance(param1:Boolean) : void
      {
         settings.avatar.performance.enabled = param1;
      }
      
      public function getCompletedQuestList() : String
      {
         var _loc4_:String = null;
         var _loc1_:GaturroSystemQuestModel = Context.instance.getByType(GaturroSystemQuestModel) as GaturroSystemQuestModel;
         var _loc2_:Dictionary = _loc1_.getCompletedQuests();
         var _loc3_:String = "";
         for(_loc4_ in _loc2_)
         {
            _loc3_ += _loc4_ + ": " + _loc1_.getQuest(int(_loc4_)) + "\n";
         }
         return _loc3_;
      }
      
      private function cleanCache(param1:Boolean) : void
      {
         settings.cache.packs = param1;
      }
      
      private function fedeTools(param1:String) : void
      {
         switch(param1)
         {
            case "setBoca":
               api.setProfileAttribute("pasaporteBoca3Dias",api.serverTime);
               break;
            case "setRiver":
               api.setProfileAttribute("pasaporteRiver3Dias",api.serverTime);
         }
      }
      
      private function addExplorerExp(param1:int) : void
      {
         api.levelManager.addExplorerExp(param1);
      }
   }
}
