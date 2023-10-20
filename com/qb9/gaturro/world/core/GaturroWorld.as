package com.qb9.gaturro.world.core
{
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.world.achievements.AchievManager;
   import com.qb9.gaturro.world.cards.CardsManager;
   import com.qb9.gaturro.world.collection.NpcScriptList;
   import com.qb9.gaturro.world.core.events.ActivityEvent;
   import com.qb9.gaturro.world.core.events.AvatarHomeEvent;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.minigames.Minigame;
   import com.qb9.gaturro.world.minigames.MinigameUserData;
   import com.qb9.gaturro.world.minigames.MultiplayerMinigame;
   import com.qb9.gaturro.world.minigames.events.MinigameEvent;
   import com.qb9.gaturro.world.minigames.rewards.RewardManager;
   import com.qb9.gaturro.world.minigames.rewards.inventory.events.InventoryRewardEvent;
   import com.qb9.gaturro.world.minigames.rewards.items.events.ItemRewardEvent;
   import com.qb9.gaturro.world.minigames.rewards.points.events.GameRewardEvent;
   import com.qb9.gaturro.world.parties.PartiesManager;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.gaturro.world.reports.InfoReportType;
   import com.qb9.mambo.net.chat.ChatEvent;
   import com.qb9.mambo.net.chat.GlobalChat;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.enums.ChangeRoomActionRequestErrors;
   import com.qb9.mambo.net.enums.WarnPlayerReasons;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.chat.WhiteListDataRequest;
   import com.qb9.mambo.net.requests.home.LeaveHomeActionRequest;
   import com.qb9.mambo.net.requests.room.LeaveRoomActionRequest;
   import com.qb9.mambo.net.requests.room.ReturnToRoomActionRequest;
   import com.qb9.mambo.net.requests.server.KeepAliveActionRequest;
   import com.qb9.mambo.net.requests.server.ServerDataRequest;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.World;
   import com.qb9.mambo.world.core.events.WorldEvent;
   import com.qb9.mines.mobject.Mobject;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public final class GaturroWorld extends World
   {
      
      private static const ROOM_WHITELIST:String = "whiteList";
      
      private static const IPHONE_WHITELIST:String = "mobileWhiteList";
      
      private static const TO_MINUTES:uint = 60 * 1000;
      
      private static const PET_NOT_ALLOWED:String = "PET_NOT_ALLOWED";
       
      
      private var _reports:InfoReportQueue;
      
      private var keepAliveId:int;
      
      private var scripts:NpcScriptList;
      
      private var rewards:RewardManager;
      
      private var roomWhitelist:WhiteListNode;
      
      private var _mailer:GaturroMailer;
      
      private var minigame:Minigame;
      
      private var returnLink:RoomLink;
      
      private var _iphoneWhitelist:WhiteListNode;
      
      private var notifications:GlobalChat;
      
      public var nextRoom:int;
      
      private var inactivityId:int;
      
      public function GaturroWorld(param1:User, param2:NetworkManager)
      {
         super(param1,param2);
      }
      
      override protected function setLoading() : void
      {
         if(this.minigame)
         {
            dispatch(WorldEvent.LOADING);
            this.minigame = null;
         }
         else
         {
            super.setLoading();
         }
      }
      
      private function addRewardedItem(param1:InventoryRewardEvent) : void
      {
         InventoryUtil.buyObject(room.userAvatar,param1.reward.itemName,param1.reward.catalog);
      }
      
      private function reportReyesRewards(param1:GameRewardEvent) : void
      {
         this.reports.queue(InfoReportType.REYES_2018,param1.reward.message,param1.reward);
      }
      
      private function whenWhiteListIsReady(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         if(!this.roomWhitelist)
         {
            this.roomWhitelist = new WhiteListNode();
            this.roomWhitelist.buildFromMobject(_loc2_);
            net.sendAction(new WhiteListDataRequest(IPHONE_WHITELIST));
         }
         else
         {
            this._iphoneWhitelist = new WhiteListNode();
            this.iphoneWhitelist.buildFromMobject(_loc2_);
            super.init();
         }
      }
      
      override protected function init() : void
      {
         net.addEventListener(NetworkManagerEvent.SERVER_DATA,this.whenServerDataIsReceived);
         net.addEventListener(NetworkManagerEvent.ACTION_SENT,this.refreshTimeout);
         net.addEventListener(NetworkManagerEvent.PLAYER_WARNED,this.whenPlayerIsWarned);
         net.addEventListener(NetworkManagerEvent.SERVER_MESSAGE,this.queueServerMessage);
         net.sendAction(new ServerDataRequest());
         this.rewards = new RewardManager(net);
         this.rewards.addEventListener(GameRewardEvent.AWARDED,this.reportAwardedCoins);
         this.rewards.addEventListener(GameRewardEvent.AWARDED_HALLOWEEN,this.reportHalloweenRewards);
         this.rewards.addEventListener(GameRewardEvent.AWARDED_NAVIDAD,this.reportNavidadRewards);
         this.rewards.addEventListener(GameRewardEvent.AWARDED_REYES,this.reportReyesRewards);
         this.rewards.addEventListener(ItemRewardEvent.AWARDED,this.saveLastAward);
         this.rewards.addEventListener(InventoryRewardEvent.AWARDED,this.addRewardedItem);
         this.scripts = new NpcScriptList();
         this._reports = new InfoReportQueue();
         this._mailer = new GaturroMailer(net);
         socialNet.mailer = this._mailer;
         this.keepAliveId = setInterval(this.sendKeepAlive,this.keepAliveInterval);
         this.activateInactivityTimeout();
         this.notifications = new GlobalChat(net,user);
         this.notifications.addEventListener(ChatEvent.RECEIVED,this.addNotification);
         this.notifications.addEventListener(ChatEvent.SENT,this.addNotification);
         achievements = new AchievManager();
         achievements.init();
         cards = new CardsManager();
         cards.init();
         parties = new PartiesManager(this.mailer);
         gatucine = new GatucineManager();
         gatucine.init();
      }
      
      override protected function whenTheRoomChanges(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         super.whenTheRoomChanges(param1);
         if(param1.success)
         {
            return;
         }
         var _loc4_:String = param1.mobject.getString("errorCode");
         switch(_loc4_)
         {
            case ChangeRoomActionRequestErrors.NO_FREE_TILE:
               _loc2_ = InfoReportType.ROOM;
               _loc3_ = String(region.key("no_free_tile"));
               break;
            case ChangeRoomActionRequestErrors.USER_IN_ANOTHER_SERVER:
               _loc2_ = InfoReportType.ROOM;
               _loc3_ = String(region.key("user_in_another_server"));
               break;
            case ChangeRoomActionRequestErrors.ROOM_NOT_EXIST:
               _loc2_ = InfoReportType.ROOM;
               _loc3_ = String(region.key("room_not_exist"));
               break;
            case ChangeRoomActionRequestErrors.USER_NOT_EXIST:
               _loc2_ = InfoReportType.USER;
               _loc3_ = String(region.key("user_not_exist"));
               break;
            case ChangeRoomActionRequestErrors.USER_OFFLINE:
               _loc2_ = InfoReportType.USER;
               _loc3_ = String(region.key("user_offline"));
               break;
            case PET_NOT_ALLOWED:
               _loc2_ = InfoReportType.PET;
               _loc3_ = String(region.key("pet_not_allowed"));
               break;
            case ChangeRoomActionRequestErrors.NOT_INVITED:
               _loc2_ = InfoReportType.ROOM;
               _loc3_ = String(region.key("not_invited"));
               break;
            default:
               _loc2_ = InfoReportType.ERROR;
               _loc3_ = String(region.key("generic_error"));
         }
         this.reports.queue(_loc2_,_loc3_);
      }
      
      private function refreshTimeout(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:String = _loc2_.getString("request");
         if(_loc3_ !== "KeepAliveActionRequest" && _loc3_ !== "UpdateCustomAttributeDataRequest")
         {
            this.activateInactivityTimeout();
         }
      }
      
      private function startMultiplayer(param1:ActivityEvent) : void
      {
         this.startMinigame(new MultiplayerMinigame(param1.login,this.makeUserData(),room.id),param1.returnLink);
      }
      
      private function get inactivityTimeout() : uint
      {
         return this.connectionData.inactivityTimeout * TO_MINUTES;
      }
      
      private function reportNavidadRewards(param1:GameRewardEvent) : void
      {
         this.reports.queue(InfoReportType.NAVIDAD_2017,param1.reward.message,param1.reward);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         clearInterval(this.keepAliveId);
         this.clearInactivityTimeout();
         net.removeEventListener(NetworkManagerEvent.SERVER_DATA,this.whenServerDataIsReceived);
         net.removeEventListener(NetworkManagerEvent.WHITE_LIST_DATA,this.whenWhiteListIsReady);
         net.removeEventListener(NetworkManagerEvent.PLAYER_WARNED,this.whenPlayerIsWarned);
         net.removeEventListener(NetworkManagerEvent.SERVER_MESSAGE,this.queueServerMessage);
         achievements.dispose();
         achievements = null;
         this.scripts.dispose();
         this.scripts = null;
         this.rewards.dispose();
         this.rewards = null;
         this.reports.dispose();
         this._reports = null;
         this.mailer.dispose();
         this._mailer = null;
         this.notifications.dispose();
         this.notifications = null;
         if(this.minigame)
         {
            this.minigame.dispose();
         }
         this.minigame = null;
      }
      
      private function sendKeepAlive() : void
      {
         net.sendAction(new KeepAliveActionRequest());
      }
      
      public function get iphoneWhitelist() : WhiteListNode
      {
         return this._iphoneWhitelist;
      }
      
      private function makeUserData() : MinigameUserData
      {
         return new MinigameUserData(user as GaturroUser,room.userAvatar.attributes.clone(),GaturroRoom(room).getUserOwnedNpc());
      }
      
      private function get connectionData() : Object
      {
         return settings.connection;
      }
      
      public function get mailer() : GaturroMailer
      {
         return this._mailer;
      }
      
      private function get keepAliveInterval() : uint
      {
         return this.connectionData.keepAliveInterval * TO_MINUTES;
      }
      
      override protected function loadRoomData() : void
      {
         if(this.returnLink)
         {
            net.sendAction(new ReturnToRoomActionRequest());
         }
         this.returnLink = null;
         super.loadRoomData();
      }
      
      private function addNotification(param1:ChatEvent) : void
      {
      }
      
      private function leaveHome(param1:Event) : void
      {
         this.setLoading();
         net.sendAction(new LeaveHomeActionRequest());
      }
      
      public function get reports() : InfoReportQueue
      {
         return this._reports;
      }
      
      private function clearInactivityTimeout() : void
      {
         clearTimeout(this.inactivityId);
      }
      
      private function queueServerMessage(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:String = _loc2_.getString("message");
         var _loc4_:String = String(_loc2_.getString("type") || InfoReportType.INFORMATION);
         this.reports.queue(_loc4_,_loc3_);
      }
      
      private function whenMinigameFinishes(param1:MinigameEvent) : void
      {
         var _loc2_:Minigame = param1.minigame;
         foreach(_loc2_.rewards,this.rewards.add);
         _loc2_.dispose();
         if(this.returnLink.roomId)
         {
            this.changeToRoom(this.returnLink);
         }
         else
         {
            this.loadRoomData();
         }
         this.activateInactivityTimeout();
      }
      
      override protected function roomLoaded(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.setSession(RewardManager.LAST_REWARD,null);
         super.roomLoaded(param1);
         this.rewards.parseRewards();
         if(!room.hasOwner)
         {
            _loc2_ = room.id.toString();
            _loc3_ = room.name;
         }
         else if(room.ownedByUser)
         {
            _loc2_ = TrackActions.MY_HOME;
            _loc3_ = null;
         }
         else
         {
            _loc2_ = TrackActions.OTHER_HOME;
            _loc3_ = null;
         }
         tracker.page(TrackActions.INTO_ROOM,_loc2_);
         Telemetry.getInstance().trackScreen("roomId:" + _loc2_);
         Telemetry.getInstance().trackScreen("roomName:" + _loc3_);
         Telemetry.getInstance().trackScreen("byServer:" + server.serverName + ":roomId:" + _loc2_);
         tracker.event(TrackCategories.ROOMS,TrackActions.ENTER_ROOM,_loc2_);
      }
      
      private function startMinigame(param1:Minigame, param2:RoomLink) : void
      {
         disposeRoom();
         net.sendAction(new LeaveRoomActionRequest());
         this.returnLink = param2 || new RoomLink();
         this.clearInactivityTimeout();
         this.minigame = param1;
         this.minigame.addEventListener(MinigameEvent.FINISHED,this.whenMinigameFinishes);
         dispatchEvent(new MinigameEvent(MinigameEvent.CREATED,this.minigame));
      }
      
      override public function changeToRoom(param1:RoomLink) : void
      {
         this.nextRoom = param1.roomId;
         super.changeToRoom(param1);
      }
      
      private function whenPlayerIsWarned(param1:NetworkManagerEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:String = _loc2_.getString("reason");
         tracker.event(TrackCategories.MODERATION,TrackActions.USER_WAS_WARNED,_loc3_);
         switch(_loc3_)
         {
            case WarnPlayerReasons.SUSPENSION:
               _loc4_ = String(region.key("moderation_warning_suspension"));
               break;
            case WarnPlayerReasons.BAD_WORDS:
               _loc4_ = String(region.key("moderation_warning_bad_word"));
               break;
            case WarnPlayerReasons.PRIVACY:
               _loc4_ = String(region.key("moderation_warning_privacy"));
         }
         this.reports.queue(InfoReportType.ERROR,_loc4_);
      }
      
      private function startSinglePlayer(param1:ActivityEvent) : void
      {
         api.trackEvent("MINIGAMES:GAMES",param1.name);
         this.startMinigame(new Minigame(param1.name,this.makeUserData(),room.id),param1.returnLink);
      }
      
      private function setSession(param1:String, param2:Object) : void
      {
         GaturroUser(user).setSession(param1,param2);
      }
      
      private function activateInactivityTimeout() : void
      {
         this.clearInactivityTimeout();
         this.inactivityId = setTimeout(this.clientTimeoutReached,this.inactivityTimeout);
      }
      
      private function clientTimeoutReached() : void
      {
         net.logout();
      }
      
      private function saveLastAward(param1:ItemRewardEvent) : void
      {
         this.setSession(RewardManager.LAST_REWARD,param1.reward.itemName);
      }
      
      private function reportHalloweenRewards(param1:GameRewardEvent) : void
      {
         this.reports.queue(InfoReportType.HALLOWEEN_2017,param1.reward.message,param1.reward);
      }
      
      private function whenServerDataIsReceived(param1:NetworkManagerEvent) : void
      {
         server.buildFromMobject(param1.mobject);
         net.addEventListener(NetworkManagerEvent.WHITE_LIST_DATA,this.whenWhiteListIsReady);
         net.sendAction(new WhiteListDataRequest(ROOM_WHITELIST));
      }
      
      override protected function createRoom() : Room
      {
         var _loc1_:GaturroRoom = new GaturroRoom(user,net,this.rewards,this.roomWhitelist,this.scripts);
         _loc1_.addEventListener(ActivityEvent.START_MINIGAME,this.startSinglePlayer);
         _loc1_.addEventListener(ActivityEvent.START_MULTIPLAYER,this.startMultiplayer);
         _loc1_.addEventListener(AvatarHomeEvent.LEAVE,this.leaveHome);
         return _loc1_;
      }
      
      private function reportAwardedCoins(param1:GameRewardEvent) : void
      {
         this.reports.queue(InfoReportType.COINS,param1.reward.message,param1.reward);
      }
   }
}
