package com.qb9.gaturro.world.core
{
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.ClassUtil;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.requests.house.BuyRoomActionRequest;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.service.pocket.PocketServiceManager;
   import com.qb9.gaturro.socialnet.GaturroRoomChat;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.cellPhone.apps.AppPodometro;
   import com.qb9.gaturro.view.gui.home.ShowRoomBuildingTimeEvent;
   import com.qb9.gaturro.view.minigames.MinigameView;
   import com.qb9.gaturro.view.world.interaction.InteractionManager;
   import com.qb9.gaturro.whitelist.RoomWhiteListVariableReplacer;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogEvent;
   import com.qb9.gaturro.world.catalog.CurrencyCatalogEvent;
   import com.qb9.gaturro.world.catalog.PetCatalogEvent;
   import com.qb9.gaturro.world.collection.CatalogList;
   import com.qb9.gaturro.world.collection.NpcScriptList;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.core.elements.*;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.gaturro.world.core.events.ActivityEvent;
   import com.qb9.gaturro.world.core.events.AvatarHomeEvent;
   import com.qb9.gaturro.world.minigames.rewards.RewardManager;
   import com.qb9.gaturro.world.tiling.GaturroPathFinder;
   import com.qb9.gaturro.world.tiling.GaturroTileGrid;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.events.SceneObjectEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.ChatEvent;
   import com.qb9.mambo.net.chat.ChatMessage;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.queue.ServerLoginData;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.path.Path;
   import com.qb9.mambo.world.path.PathFinder;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   import config.ItemControl;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public final class GaturroRoom extends Room
   {
      
      private static const HOME_COORD:Coord = Coord.create(17,6);
      
      private static const NPC_SHOWING_MAX_DISTANCE:uint = 5;
      
      public static const PROPOSE_INVITE:String = "PROPOSE_INVITE";
      
      private static const HOUSE_ROOM_UNDER_CONSTRUCTION:String = "HOUSE_ROOM_UNDER_CONSTRUCTION";
      
      private static const HOUSE_ROOM_UNDER_CONSTRUCTION_TIME:String = "HOUSE_ROOM_UNDER_CONSTRUCTION_TIME";
       
      
      private var ownedNpcs:Dictionary;
      
      private var scripts:NpcScriptList;
      
      private var _pocketRequest:PocketServiceManager;
      
      private var _chat:GaturroRoomChat;
      
      protected var _houses:Array;
      
      private var catalogs:CatalogList;
      
      private var _userHistory:Array;
      
      private var showing:Dictionary;
      
      private var _whitelist:WhiteListNode;
      
      private var _rewards:RewardManager;
      
      private var _variables:RoomWhiteListVariableReplacer;
      
      public function GaturroRoom(param1:User, param2:NetworkManager, param3:RewardManager, param4:WhiteListNode, param5:NpcScriptList)
      {
         this._userHistory = [];
         this.showing = new Dictionary(true);
         this.ownedNpcs = new Dictionary(true);
         this._houses = new Array();
         super(param1,param2);
         this.scripts = param5;
         this._whitelist = param4;
         this._rewards = param3;
         waitToReposition = true;
      }
      
      private function removeOwnedNpcFor(param1:Avatar) : void
      {
         var _loc2_:OwnedNpcRoomSceneObject = null;
         if(Boolean(param1) && param1 in this.ownedNpcs)
         {
            _loc2_ = this.ownedNpcs[param1];
            delete this.ownedNpcs[param1];
            removeSceneObject(_loc2_.id);
         }
      }
      
      private function showCurrencyCatalog(param1:Catalog, param2:Object = null) : void
      {
         if(param1)
         {
            dispatchEvent(new CurrencyCatalogEvent(CurrencyCatalogEvent.OPEN,param1,param2.currency));
         }
      }
      
      private function addStep(param1:Event) : void
      {
         AppPodometro.addSteps(1);
      }
      
      private function isSinglePlayerRoom(param1:int) : Boolean
      {
         if(param1 == 51683118)
         {
            return true;
         }
         if(param1 == 51682000)
         {
            return true;
         }
         if(param1 == 51683000)
         {
            return true;
         }
         if(param1 == 51690158)
         {
            return true;
         }
         if(param1 == 51690159)
         {
            return true;
         }
         if(param1 == 51690187)
         {
            return true;
         }
         return false;
      }
      
      public function openReyesCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"reyes"});
      }
      
      public function openFeriaCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"feria"});
      }
      
      public function get isRoofRoom() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._houses.length)
         {
            if(this._houses[_loc1_].roomNum == 11 && this.id == this._houses[_loc1_].roomId)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function startUnityMinigame(param1:String, param2:Number = 0, param3:Coord = null, param4:Object = null) : void
      {
         var _loc5_:String = null;
         if(ExternalInterface.available)
         {
            _loc5_ = !!settings.debug.localMinigames ? MinigameView.LOCAL_URL : String(settings.connection.minigamesHTMLURL);
            _loc5_ = (_loc5_ = StringUtil.format(_loc5_,param1)).replace("Game.swf","");
            ExternalInterface.addCallback("sendToMMO",this.receivedFromJavaScript);
            if(param4)
            {
               param4.isDevlop = !settings.debug.fannysProd;
            }
            ExternalInterface.call("open_unity_game",param1,_loc5_,api.user.username,param4);
         }
      }
      
      public function changeRoomById(param1:int, param2:int = 0, param3:int = 0) : void
      {
         this.changeTo(new RoomLink(new Coord(param2,param3),param1));
      }
      
      private function receivedFromJavaScript(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         if(ExternalInterface.available)
         {
            if(param1.evt === "close")
            {
               logger.debug(param1.gameName);
               if(Boolean(param1.gameName) && param1.gameName == "html5asteroids")
               {
                  api.setSession("asteroids",param1.score);
                  api.trackEvent("MINIGAMES:ASTEROIDS_HTML5:SCORE",param1.score);
                  _loc2_ = api.getSession("minigameTimeStamp") as Number;
                  _loc2_ = api.serverTime - _loc2_;
                  logger.debug("EL JUGADOR DURÓ: " + _loc2_ + " milisegundos");
                  api.trackEvent("MINIGAMES:ASTEROIDS:GAME_LENGTH",_loc2_.toString());
                  api.instantiateBannerModal("AsteroidsRewardsBanner",null,null,param1);
               }
               else if(Boolean(param1.gameName) && param1.gameName == "fulbejo")
               {
                  if(param1.winner)
                  {
                     api.trackEvent("MINIGAMES:FULBEJO:WINNER",param1.winner);
                     this.isUserAwarded(param1.winner);
                  }
               }
               logger.info(param1.cls + " " + param1.fn);
               if(Boolean(param1.cls) && Boolean(param1.fn))
               {
                  api.view.broadcastMessageToContainer(api.view,param1.cls,param1.fn,param1.args);
               }
               ExternalInterface.call("close_game");
               ExternalInterface.addCallback("sendToMMO",null);
            }
         }
      }
      
      override protected function createUserAvatar(param1:CustomAttributes) : UserAvatar
      {
         var _loc2_:UserAvatar = new GaturroUserAvatar(param1,grid,user);
         _loc2_.addEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.checkShowingNpcs);
         _loc2_.addEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.addStep);
         _loc2_.addEventListener(MovingRoomSceneObjectEvent.STOPPED_MOVING,this.checkShowingNpcs);
         return _loc2_;
      }
      
      public function openPepionCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"pepiones"});
      }
      
      public function get rewards() : RewardManager
      {
         return this._rewards;
      }
      
      public function openVipCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"newVip"});
      }
      
      public function get isHome() : Boolean
      {
         return this.name.indexOf("_HOME") >= 0;
      }
      
      public function getCatalogData(param1:String, param2:Function) : void
      {
         this.catalogs.fetch(param1,param2);
      }
      
      override public function dispose() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         removeEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.captureName);
         removeEventListener(RoomEvent.SCENE_OBJECT_REMOVED,this.removeOwnedNpcFromEvent);
         for(_loc1_ in avatars)
         {
            _loc2_ = avatars[_loc1_];
            if(_loc2_ is UserAvatar)
            {
               _loc2_.removeEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.checkShowingNpcs);
               _loc2_.removeEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.addStep);
               _loc2_.removeEventListener(MovingRoomSceneObjectEvent.STOPPED_MOVING,this.checkShowingNpcs);
            }
         }
         this.chat.removeEventListener(ChatEvent.RECEIVED_KEY,this.translateKey);
         this.chat.removeEventListener(ChatEvent.SENT_KEY,this.translateKey);
         net.removeEventListener(GaturroNetResponses.BUY_ROOM,this.buyRoomResponse);
         this.ownedNpcs = null;
         super.dispose();
         this._rewards = null;
         this._whitelist = null;
         this.chat.dispose();
         this._chat = null;
         this.variables.dispose();
         this._variables = null;
         this.catalogs.dispose();
         this.catalogs = null;
         this.showing = null;
      }
      
      private function translateKey(param1:ChatEvent) : void
      {
         var _loc2_:ChatMessage = param1.message;
         var _loc3_:WhiteListNode = this.whitelist.getByKey(_loc2_.key);
         var _loc4_:Avatar = avatarById(_loc2_.avatarId);
         if(!_loc3_ || !_loc4_)
         {
            return;
         }
         _loc2_.message = this.variables.replaceFor(_loc4_,region.getText(_loc3_.text));
         this.chat.dispatchEvent(new ChatEvent(param1.type === ChatEvent.RECEIVED_KEY ? ChatEvent.RECEIVED : ChatEvent.SENT,_loc2_));
      }
      
      public function startExternalMinigame(param1:String, param2:Object = null) : void
      {
         var _loc3_:String = null;
         if(ExternalInterface.available)
         {
            _loc3_ = !!settings.debug.localMinigames ? MinigameView.LOCAL_URL : String(settings.connection.minigamesHTMLURL);
            _loc3_ = StringUtil.format(_loc3_,param1);
            _loc3_ = _loc3_.replace("Game.swf","");
            api.setSession("minigameTimeStamp",api.serverTime);
            ExternalInterface.addCallback("sendToMMO",this.receivedFromJavaScript);
            ExternalInterface.call("open_game",param1,_loc3_,api.user.username,param2);
         }
      }
      
      public function removeSceneObjectById(param1:Number) : void
      {
         removeSceneObject(param1);
      }
      
      private function loadHouseRooms(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         for each(_loc4_ in param1.split(";"))
         {
            _loc2_ = int(_loc4_.split(",")[0]);
            _loc3_ = String(_loc4_.split(",")[1]);
            this._houses.push({
               "roomNum":_loc2_,
               "roomId":_loc3_
            });
         }
         if((_loc5_ = int(this.gUser.getSession(GaturroRoom.HOUSE_ROOM_UNDER_CONSTRUCTION))) >= 1)
         {
            _loc6_ = false;
            for each(_loc7_ in this._houses)
            {
               if(_loc7_.roomNum == _loc5_)
               {
                  _loc6_ = true;
               }
            }
            if(!_loc6_)
            {
               _loc8_ = int(this.gUser.getSession(GaturroRoom.HOUSE_ROOM_UNDER_CONSTRUCTION_TIME));
               this._houses.push({
                  "roomNum":_loc5_,
                  "roomId":"T" + _loc8_.toString()
               });
            }
         }
      }
      
      public function avatarsByCoord(param1:int, param2:int) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Avatar = null;
         var _loc3_:Array = [];
         for(_loc4_ in avatars)
         {
            if((_loc5_ = avatars[_loc4_]) is Avatar)
            {
               if((_loc6_ = Avatar(_loc5_)).coord.x == param1 && _loc6_.coord.y == param2)
               {
                  if(!ArrayUtil.contains(_loc3_,_loc6_))
                  {
                     _loc3_.push(_loc6_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function get whitelist() : WhiteListNode
      {
         return this._whitelist;
      }
      
      private function roomFiltersUsers(param1:Mobject) : Boolean
      {
         var _loc2_:CustomAttributes = new CustomAttributes();
         _loc2_.buildFromMobject(param1);
         if(_loc2_.roomType == "bossRoom")
         {
            return true;
         }
         return false;
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         addEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.captureName);
         addEventListener(RoomEvent.SCENE_OBJECT_REMOVED,this.removeOwnedNpcFromEvent);
         this.chat.addEventListener(ChatEvent.RECEIVED_KEY,this.translateKey,false,-1);
         this.chat.addEventListener(ChatEvent.SENT_KEY,this.translateKey,false,-1);
      }
      
      public function visit(param1:String) : void
      {
         this.changeTo(new RoomLink(HOME_COORD,param1));
      }
      
      public function getRoomId(param1:int) : int
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._houses)
         {
            if(_loc2_.roomNum == param1)
            {
               if(_loc2_.roomId.substr(0,1) == "T")
               {
                  return -1;
               }
               return _loc2_.roomId == 0 ? -1 : int(_loc2_.roomId);
            }
         }
         return -1;
      }
      
      private function removeOwnedNpcFromEvent(param1:RoomEvent) : void
      {
         this.removeOwnedNpcFor(param1.sceneObject as Avatar);
      }
      
      public function startMinigame(param1:String, param2:Number = 0, param3:Coord = null) : void
      {
         if(!param3)
         {
            param3 = Coord.create(size.width / 2,size.height / 2);
         }
         var _loc4_:RoomLink = new RoomLink(param3,param2);
         dispatchEvent(new ActivityEvent(ActivityEvent.START_MINIGAME,param1,_loc4_));
         var _loc5_:NotificationManager;
         (_loc5_ = Context.instance.getByType(NotificationManager) as NotificationManager).brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.START_MINIGAME,{"mninigame":param1}));
      }
      
      override protected function initHelpers() : void
      {
         super.initHelpers();
         this._chat = new GaturroRoomChat(net,user,this);
         this._variables = new RoomWhiteListVariableReplacer(this);
         this.catalogs = new CatalogList(net);
      }
      
      private function isNpc(param1:RoomSceneObject) : Boolean
      {
         return param1 is NpcRoomSceneObject;
      }
      
      public function get userHistory() : Array
      {
         return this._userHistory.concat();
      }
      
      override public function changeTo(param1:RoomLink) : void
      {
         var _loc2_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc2_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.ROOM_CHANGED_PREPARATION,{"room":param1.roomId}));
         super.changeTo(param1);
      }
      
      private function onAddedNotoficationManager(param1:ContextEvent) : void
      {
         var _loc2_:NotificationManager = null;
         if(param1.instanceType == NotificationManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedNotoficationManager);
            if(id > 0)
            {
               _loc2_ = Context.instance.getByType(NotificationManager) as NotificationManager;
               _loc2_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.ROOM_CHANGED,{"room":id}));
            }
         }
      }
      
      private function showCatalog(param1:Catalog, param2:Object = null) : void
      {
         if(param1)
         {
            dispatchEvent(new CatalogEvent(CatalogEvent.OPEN,param1));
         }
      }
      
      override protected function createUnknownSceneObject(param1:CustomAttributes, param2:Mobject) : RoomSceneObject
      {
         var _loc3_:RoomSceneObject = null;
         var _loc4_:Boolean = false;
         if(param1.behavior)
         {
            if(_loc4_ = param2.getBoolean("ownedNPC"))
            {
               return this.addMateNPC(param1,param2);
            }
            return new NpcRoomSceneObject(param1,grid,this.scripts);
         }
         if(param1.banner)
         {
            return new BannerRoomSceneObject(param1,grid);
         }
         if(param1.image)
         {
            return new ImageRoomSceneObject(param1,grid);
         }
         if(param1.minigame)
         {
            return new MinigameRoomSceneObject(param1,grid);
         }
         if(param1.queue)
         {
            return new QueueRoomSceneObject(param1,grid);
         }
         if(param1.holder)
         {
            return new HolderRoomSceneObject(param1,grid);
         }
         if(param1.catalog)
         {
            _loc3_ = new VendorRoomSceneObject(param1,grid);
            _loc3_.addEventListener(SceneObjectEvent.ACTIVATED,this.openCatalogFromSceneObject);
            return _loc3_;
         }
         if(param1.decoration)
         {
            return new HouseDecorationRoomSceneObject(param1,grid);
         }
         if(param1.isHomeInteractive)
         {
            return new HomeInteractiveRoomSceneObject(param1,grid,ownerName == user.username);
         }
         return new GaturroRoomSceneObject(param1,grid);
      }
      
      public function removeOwnedNpcByAvatar(param1:Avatar) : void
      {
         var _loc2_:OwnedNpcRoomSceneObject = OwnedNpcRoomSceneObject(this.ownedNpcs[param1]);
         if(_loc2_)
         {
            this.ownedNpcs[param1] = null;
            removeSceneObject(_loc2_.id);
         }
      }
      
      override protected function addAvatar(param1:Avatar) : void
      {
         super.addAvatar(param1);
         if(param1.username == user.username)
         {
            Context.instance.addByType(param1,UserAvatar);
         }
      }
      
      public function startHtmlMMO() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("open_HTML5_MMO",settings.connection.HTML5_url);
         }
         else
         {
            trace("NOT ON WEB");
         }
      }
      
      public function openAsteroidsCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"asteroids"});
      }
      
      public function openPascuasCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"chocomonedas"});
      }
      
      public function proposeInvite(param1:Number, param2:String) : void
      {
         dispatchEvent(new QEvent(PROPOSE_INVITE,{
            "roomId":param1,
            "text":param2
         }));
      }
      
      override public function tileSelected(param1:Tile) : void
      {
         var _loc2_:Coord = null;
         var _loc3_:Coord = null;
         var _loc4_:Path = null;
         super.tileSelected(param1);
         if(userAvatar != null)
         {
            _loc2_ = userAvatar.coord;
            _loc3_ = param1.coord;
            _loc4_ = pathCreator.getPath(_loc2_,_loc3_);
         }
      }
      
      public function testGoogleAnalytics() : void
      {
         logger.info("#################### Gaturro Room: testGoogleAnalytics ##############");
         ExternalInterface.call("testGoogleAnalytics","test_event","TEST_CATEGORY","TEST_LABEL");
      }
      
      public function getUserOwnedNpc() : OwnedNpcRoomSceneObject
      {
         return this.ownedNpcs[this.userAvatar] as OwnedNpcRoomSceneObject;
      }
      
      public function openCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCatalog);
      }
      
      private function filterOtherUsers(param1:Mobject) : void
      {
         var _loc5_:Mobject = null;
         var _loc6_:String = null;
         var _loc2_:Array = param1.getMobjectArray("sceneObjects");
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if((_loc6_ = (_loc5_ = _loc2_[_loc4_]).getString("name")) == "avatar")
            {
               if(this.isUserAvatar(_loc5_))
               {
                  _loc3_.push(_loc5_);
               }
            }
            else
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         param1.setMobjectArray("sceneObjects",_loc3_);
      }
      
      public function proposeInteraction(param1:String, param2:String) : void
      {
         dispatchEvent(new QEvent(InteractionManager.INIT_INTERACTION_EVENT,{
            "type":param1,
            "username":param2
         }));
      }
      
      public function get variables() : RoomWhiteListVariableReplacer
      {
         return this._variables;
      }
      
      private function openCatalogFromSceneObject(param1:SceneObjectEvent) : void
      {
         var _loc2_:VendorRoomSceneObject = param1.target as VendorRoomSceneObject;
         this.openCatalog(_loc2_.catalogName);
      }
      
      public function get isFarmRoom() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._houses.length)
         {
            if(this._houses[_loc1_].roomNum == 10 && this.id == this._houses[_loc1_].roomId)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function openBocaCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"boca"});
      }
      
      public function get chat() : GaturroRoomChat
      {
         return this._chat;
      }
      
      public function initTutorialRoom() : void
      {
      }
      
      override protected function addSceneObject(param1:Mobject) : void
      {
         var _loc2_:String = param1.getString("name");
         if(this.isHome && ItemControl.isProhibitedInHome(_loc2_))
         {
            return;
         }
         if(param1.getString("name") == "avatar" && this.isSinglePlayerRoom(id))
         {
            if(!this.isUserAvatar(param1))
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         var _loc3_:NotificationManager = null;
         this.filterByCountry(param1);
         if(this.roomFiltersUsers(param1))
         {
            this.filterOtherUsers(param1);
         }
         super.buildFromMobject(param1);
         var _loc2_:String = param1.getString("houses");
         if(Boolean(_loc2_) && _loc2_ != "")
         {
            this.loadHouseRooms(_loc2_);
         }
         if(Context.instance.hasByType(NotificationManager))
         {
            _loc3_ = Context.instance.getByType(NotificationManager) as NotificationManager;
            _loc3_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.ROOM_CHANGED,{"room":id}));
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedNotoficationManager);
         }
      }
      
      public function startPocket() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("sendToMMO",this.receivedFromJavaScript);
            ExternalInterface.call("open_pocket",{"token":MMO.pocketId});
         }
      }
      
      override protected function getNewTileGrid() : TileGrid
      {
         return new GaturroTileGrid();
      }
      
      public function startMultiplayer(param1:ServerLoginData) : void
      {
         dispatchEvent(new ActivityEvent(ActivityEvent.START_MULTIPLAYER,param1));
      }
      
      public function openNavidadCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"navidad"});
      }
      
      private function filterByCountry(param1:Mobject) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Mobject = null;
         var _loc7_:CustomAttributes = null;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc2_:Array = param1.getMobjectArray("sceneObjects");
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = true;
            _loc6_ = _loc2_[_loc4_];
            (_loc7_ = new CustomAttributes()).buildFromMobject(_loc6_);
            if("countries" in _loc7_)
            {
               if(_loc9_ = (_loc8_ = _loc7_["countries"].split(",")).shift() == "only" ? true : false)
               {
                  _loc5_ = false;
                  if(ArrayUtil.contains(_loc8_,region.country))
                  {
                     _loc5_ = true;
                  }
               }
               else if(ArrayUtil.contains(_loc8_,region.country))
               {
                  _loc5_ = false;
               }
            }
            if(_loc5_)
            {
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         param1.setMobjectArray("sceneObjects",_loc3_);
      }
      
      public function leaveHouse(param1:Event = null) : void
      {
         setTimeout(dispatchEvent,10,new AvatarHomeEvent(AvatarHomeEvent.LEAVE));
      }
      
      public function get npcs() : Array
      {
         return filter(super.sceneObjects,this.isNpc);
      }
      
      public function get houseRooms() : Array
      {
         return this._houses;
      }
      
      private function addMateNPC(param1:CustomAttributes, param2:Mobject) : RoomSceneObject
      {
         var _loc3_:String = param2.getString("owner");
         var _loc4_:Avatar;
         if(!(_loc4_ = this.avatarByUsername(_loc3_)))
         {
            return null;
         }
         var _loc5_:Object;
         if((Boolean(_loc5_ = this.ownedNpcs[_loc4_])) && _loc5_ is OwnedNpcRoomSceneObject)
         {
            this.removeOwnedNpcByAvatar(_loc4_);
         }
         var _loc6_:OwnedNpcRoomSceneObject = new OwnedNpcRoomSceneObject(_loc4_,param1,grid,this.scripts);
         this.ownedNpcs[_loc4_] = _loc6_;
         return _loc6_;
      }
      
      override protected function createPathFinder() : PathFinder
      {
         return new GaturroPathFinder(grid,true,350);
      }
      
      public function buyRoomRequest(param1:int) : void
      {
         trace("ROOM NUMBER: " + param1);
         Telemetry.getInstance().trackEvent("Comercio","RoomCasa:compra:" + param1.toString());
         net.addEventListener(GaturroNetResponses.BUY_ROOM,this.buyRoomResponse);
         net.sendAction(new BuyRoomActionRequest(param1));
         this.gUser.setSession(GaturroRoom.HOUSE_ROOM_UNDER_CONSTRUCTION,param1);
      }
      
      private function get gUser() : GaturroUser
      {
         return user as GaturroUser;
      }
      
      private function isUserAvatar(param1:Mobject) : Boolean
      {
         var _loc2_:Mobject = param1.getMobject("avatar");
         var _loc3_:String = _loc2_.getString("username");
         if(user.username != _loc3_)
         {
            return false;
         }
         return true;
      }
      
      public function openRiverCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"river"});
      }
      
      private function showPetCatalog(param1:Catalog, param2:Object = null) : void
      {
         if(param1)
         {
            dispatchEvent(new PetCatalogEvent(PetCatalogEvent.OPEN_PET_CATALOG,param1,param2.petType));
         }
      }
      
      private function buyRoomResponse(param1:NetworkManagerEvent) : void
      {
         if(net)
         {
            net.removeEventListener(GaturroNetResponses.BUY_ROOM,this.buyRoomResponse);
         }
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:int = _loc2_.getInteger("time");
         var _loc4_:int = int(_loc2_.getFloat("coins"));
         this.user.attributes.coins = _loc4_;
         dispatchEvent(new ShowRoomBuildingTimeEvent(ShowRoomBuildingTimeEvent.SHOW,_loc3_));
         this.gUser.setSession(GaturroRoom.HOUSE_ROOM_UNDER_CONSTRUCTION_TIME,_loc3_);
      }
      
      private function isUserAwarded(param1:Object) : void
      {
         var _loc2_:String = api.getAvatarAttribute("superClasico2018TEAM") as String;
         var _loc3_:int = 1;
         logger.info("**************************** TESTING WINNER 0/4: winner : " + param1 as String);
         if(api.user.username == param1 as String)
         {
            api.levelManager.addCompetitiveExp(50);
            logger.info("**************************** TESTING WINNER 1/4: TEAM : " + _loc2_);
            if(_loc2_)
            {
               if(api.isCitizen)
               {
                  _loc3_ = 2;
               }
               if(api.hasPassportType("boca"))
               {
                  _loc3_ = 10;
               }
               if(api.hasPassportType("river"))
               {
                  _loc3_ = 4;
               }
               logger.info("**************************** TESTING WINNER 2/4: " + param1 + "  TEAN: " + _loc2_ + "  points: " + _loc3_.toString());
               trace("**************************** TESTING WINNER: " + param1 + "  TEAN: " + _loc2_ + "  points: " + _loc3_.toString());
               api.addTeamPoints(_loc2_.toLowerCase(),_loc3_);
               api.showModal("SUMASTE " + _loc3_ + " PARA TU EQUIPO","superclasico/props." + _loc2_.toLowerCase() + "Emblema");
            }
         }
      }
      
      override public function get sceneObjects() : Array
      {
         return super.sceneObjects.concat(ObjectUtil.values(this.ownedNpcs));
      }
      
      public function openPetCatalog(param1:String, param2:String = null) : void
      {
         this.catalogs.fetch(param1,this.showPetCatalog,{"petType":param2});
      }
      
      public function get isAtticRoom() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._houses.length)
         {
            if(this._houses[_loc1_].roomNum == 12 && this.id == this._houses[_loc1_].roomId)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function openMundialCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"figumonedas"});
      }
      
      override protected function whenInitialSceneObjectsAreLoaded(param1:Array) : void
      {
         super.whenInitialSceneObjectsAreLoaded(param1);
         this.checkShowingNpcs();
      }
      
      private function checkShowingNpcs(param1:MovingRoomSceneObjectEvent = null) : void
      {
         var _loc3_:NpcRoomSceneObject = null;
         var _loc4_:* = false;
         var _loc5_:Object = null;
         if(!userAvatar)
         {
            return;
         }
         var _loc2_:Coord = userAvatar.coord;
         for each(_loc3_ in this.npcs)
         {
            _loc4_ = _loc2_.distance(_loc3_.coord) <= NPC_SHOWING_MAX_DISTANCE;
            if((_loc5_ = this.showing[_loc3_.id]) !== _loc4_)
            {
               this.showing[_loc3_.id] = _loc4_;
               _loc3_.dispatchEvent(new GaturroRoomSceneObjectEvent(_loc4_ ? GaturroRoomSceneObjectEvent.SHOWING : GaturroRoomSceneObjectEvent.NOT_SHOWING,_loc3_));
            }
         }
      }
      
      private function captureName(param1:RoomEvent) : void
      {
         var _loc2_:RoomSceneObject = param1.sceneObject;
         if(ClassUtil.isOfClass(_loc2_,Avatar))
         {
            ArrayUtil.addUnique(this._userHistory,Avatar(_loc2_).username);
         }
      }
      
      public function openSerenitoCatalog(param1:String) : void
      {
         this.catalogs.fetch(param1,this.showCurrencyCatalog,{"currency":"tapitas"});
      }
      
      public function getOwnedNpcFor(param1:Avatar) : OwnedNpcRoomSceneObject
      {
         return this.ownedNpcs[param1] as OwnedNpcRoomSceneObject;
      }
      
      public function getThisRoomNum() : int
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._houses)
         {
            if(_loc1_.roomId == this.id)
            {
               return int(_loc1_.roomNum);
            }
         }
         return -1;
      }
   }
}
