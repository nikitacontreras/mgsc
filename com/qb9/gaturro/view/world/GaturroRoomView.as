package com.qb9.gaturro.view.world
{
   import assets.*;
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.flashlib.geom.Vector2D;
   import com.qb9.flashlib.input.*;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.tasks.*;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.editor.ConsoleEditor;
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.editor.gui.GuiEditor;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.external.roomObjects.InteractiveRoomSceneObject;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.quest.GaturroQuestView;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.gui.EventsGui;
   import com.qb9.gaturro.service.events.gui.InvitationBallon;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.socialnet.messages.GaturroChatMessage;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.view.camera.CameraSwitcher;
   import com.qb9.gaturro.view.camera.TiledLayer;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.achievements.GuiAchievementButton;
   import com.qb9.gaturro.view.gui.actions.GuiActionsButton;
   import com.qb9.gaturro.view.gui.actions.GuiDancingModal;
   import com.qb9.gaturro.view.gui.actions.PhotoTripButton;
   import com.qb9.gaturro.view.gui.avatars.AvatarsGuiModal;
   import com.qb9.gaturro.view.gui.avatars.AvatarsGuiModalEvent;
   import com.qb9.gaturro.view.gui.award.AwardModal;
   import com.qb9.gaturro.view.gui.bag.GuiBag;
   import com.qb9.gaturro.view.gui.banner.BannerGuiModal;
   import com.qb9.gaturro.view.gui.banner.BannerModalEvent;
   import com.qb9.gaturro.view.gui.banner.ModalFactory;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.gaturro.view.gui.catalog.CatalogModal;
   import com.qb9.gaturro.view.gui.chat.GuiChat;
   import com.qb9.gaturro.view.gui.closet.GuiCloset;
   import com.qb9.gaturro.view.gui.coins.AcquiredCoinsGuiModal;
   import com.qb9.gaturro.view.gui.combat.CombatEvent;
   import com.qb9.gaturro.view.gui.combat.CombatManager;
   import com.qb9.gaturro.view.gui.contextual.ContextualMenuManager;
   import com.qb9.gaturro.view.gui.emoticons.GuiEmoticons;
   import com.qb9.gaturro.view.gui.fishing.*;
   import com.qb9.gaturro.view.gui.gift.GiftGuiModal;
   import com.qb9.gaturro.view.gui.gift.GiftGuiModalEvent;
   import com.qb9.gaturro.view.gui.gift.GiftReceiverGuiModal;
   import com.qb9.gaturro.view.gui.gift.GiftReceiverGuiModalEvent;
   import com.qb9.gaturro.view.gui.granja.CropTimerModal;
   import com.qb9.gaturro.view.gui.granja.CropTimerModalEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaLevelUpEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaLevelUpModal;
   import com.qb9.gaturro.view.gui.granja.GranjaModal;
   import com.qb9.gaturro.view.gui.granja.GranjaModalEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaParcelaUnlock;
   import com.qb9.gaturro.view.gui.granja.GranjaParcelaUnlockEvent;
   import com.qb9.gaturro.view.gui.granja.GranjaSellingModal;
   import com.qb9.gaturro.view.gui.granja.GranjaSellingModalEvent;
   import com.qb9.gaturro.view.gui.granja.SiloModal;
   import com.qb9.gaturro.view.gui.granja.SiloModalEvent;
   import com.qb9.gaturro.view.gui.home.GuiHouseMap;
   import com.qb9.gaturro.view.gui.home.HouseEntranceEvent;
   import com.qb9.gaturro.view.gui.home.HouseEntranceGuiModal;
   import com.qb9.gaturro.view.gui.image.ImageGuiModal;
   import com.qb9.gaturro.view.gui.image.ImageModalEvent;
   import com.qb9.gaturro.view.gui.info.InformationModal;
   import com.qb9.gaturro.view.gui.info.InformationModalEvent;
   import com.qb9.gaturro.view.gui.info.PassportWarningModal;
   import com.qb9.gaturro.view.gui.iphone2.GuiIPhone2Button;
   import com.qb9.gaturro.view.gui.map.GuiMap;
   import com.qb9.gaturro.view.gui.map.MapGuiModal;
   import com.qb9.gaturro.view.gui.map.RankingModalEvent;
   import com.qb9.gaturro.view.gui.messages.GuiMessage;
   import com.qb9.gaturro.view.gui.moderatorTip.ModeratorTipModal;
   import com.qb9.gaturro.view.gui.profile.GuiProfile;
   import com.qb9.gaturro.view.gui.progress.ProgressModal;
   import com.qb9.gaturro.view.gui.sell.SellItemGuiModal;
   import com.qb9.gaturro.view.gui.sell.SellItemGuiModalEvent;
   import com.qb9.gaturro.view.gui.socialnet.CaptureSceneModal;
   import com.qb9.gaturro.view.gui.socialnet.ShowPhotoModal;
   import com.qb9.gaturro.view.gui.whitelist.GuiWhiteListButton;
   import com.qb9.gaturro.view.minigames.QueueModal;
   import com.qb9.gaturro.view.minigames.QueueModalEvent;
   import com.qb9.gaturro.view.world.alert.AlertEvent;
   import com.qb9.gaturro.view.world.alert.AlertManager;
   import com.qb9.gaturro.view.world.avatars.*;
   import com.qb9.gaturro.view.world.chat.BalloonManager;
   import com.qb9.gaturro.view.world.chat.ChatViewEvent;
   import com.qb9.gaturro.view.world.cursor.Cursor;
   import com.qb9.gaturro.view.world.elements.*;
   import com.qb9.gaturro.view.world.elements.behaviors.ActivableView;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.gaturro.view.world.elements.behaviors.RollableView;
   import com.qb9.gaturro.view.world.events.CreateOwnedNpcEvent;
   import com.qb9.gaturro.view.world.events.GaturroRoomViewEvent;
   import com.qb9.gaturro.view.world.interaction.InteractionManager;
   import com.qb9.gaturro.view.world.misc.UsernameDisplayManager;
   import com.qb9.gaturro.view.world.npc.NpcUtility;
   import com.qb9.gaturro.view.world.tiling.GaturroTileView;
   import com.qb9.gaturro.world.catalog.CatalogEvent;
   import com.qb9.gaturro.world.catalog.CurrencyCatalogEvent;
   import com.qb9.gaturro.world.catalog.PetCatalogEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.gaturro.world.core.elements.*;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.gaturro.world.hiddenObjects.HiddenObjects;
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import com.qb9.gaturro.world.reports.*;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.*;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.view.world.RoomView;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.Portal;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mines.mobject.Mobject;
   import com.wispagency.display.Loader;
   import com.wispagency.display.LoaderInfo;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class GaturroRoomView extends RoomView
   {
      
      private static const DEFAULT_BG:String = "zeroZone";
      
      private static var firstTimeInSession:Boolean = true;
      
      private static const BACKGROUNDS_BASE:String = "backgrounds/";
      
      private static const GATURRO_NAME:String = "gaturro";
       
      
      private var _foundRoom:Boolean;
      
      private var hiddenObjects:HiddenObjects;
      
      private var selectedFilter:GlowFilter;
      
      public var combatManager:CombatManager;
      
      private var queueModal:QueueModal;
      
      private var balloons:BalloonManager;
      
      private var avatars:Object;
      
      private var guiMessage:GuiMessage;
      
      private var reparado:Boolean;
      
      private var MAX_BADWORDS:int = 5;
      
      protected var lastTile:TileView;
      
      private var bgName:String;
      
      private var _roomsVisitedAttr:Object;
      
      private const INVITE_PREFIX:String = "INVITE";
      
      public var bubbleFlanysServie:BubbleFlannysService;
      
      private var guiEditor:GuiEditor;
      
      private var lastStep:Boolean = false;
      
      private var alerts:AlertManager;
      
      private var mailer:Mailer;
      
      private var bounds:int;
      
      private var BADWORDS_TEXT:String = ". . .";
      
      private var guiIPhoneButton:GuiIPhone2Button;
      
      private var actions:NetActionManager;
      
      private var hotkey:Hotkey;
      
      private var usernameDisplay:UsernameDisplayManager;
      
      protected var disposables:Array;
      
      private var frontTileLayer:Sprite;
      
      private var iphoneWhitelist:WhiteListNode;
      
      private var _contSlotRoom:int;
      
      private var screenShoot:Bitmap;
      
      protected var background:DisplayObjectContainer;
      
      public var gui:Gui;
      
      protected var layers:Array;
      
      public var infoLayer:Sprite;
      
      protected var _bubbleSO:NpcRoomSceneObjectView;
      
      protected var interactionManager:InteractionManager;
      
      private var npcUtility:NpcUtility;
      
      public var emoticonsGUI:GuiEmoticons;
      
      protected var cursor:Cursor;
      
      private var console:Console;
      
      private var particleArray:Array;
      
      private var tileData:Object;
      
      private var direction:Number = -1;
      
      private var layersPositions:Array;
      
      private var iShaking:Boolean = false;
      
      public var photoTripButton:PhotoTripButton;
      
      private var modalFactory:ModalFactory;
      
      private var consoleEditor:Object;
      
      public var guiDancingModal:GuiDancingModal;
      
      public var showUserNames:Boolean = true;
      
      private var reports:InfoReportQueue;
      
      private var amp:Number;
      
      public function GaturroRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:Mailer, param4:WhiteListNode)
      {
         this.layers = [];
         this.avatars = {};
         this.disposables = [];
         this.screenShoot = new Bitmap(new BitmapData(800,600));
         this.particleArray = [];
         this.selectedFilter = new GlowFilter(Color.WHITE,1,6,6,5);
         this.layersPositions = [];
         super(param1);
         this.reports = param2;
         this.mailer = param3;
         this.iphoneWhitelist = param4;
      }
      
      protected function whenMouseChangesPosition(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:TileView = getTileViewFromEvent(param1);
         if(!_loc3_)
         {
            if(this.cursor)
            {
               this.cursor.visible = false;
            }
            return this.rolloutLastTile();
         }
         if(_loc3_ !== this.lastTile)
         {
            this.whenTileIsHovered(_loc3_);
         }
         if(param1.target is InvitationBallon)
         {
            this.cursor.pointer = Cursor.HAND;
         }
      }
      
      private function openCropTimerModal(param1:CropTimerModalEvent) : void
      {
         this.gui.addModal(new CropTimerModal(param1.api,param1.objectAPI,param1.behavior));
      }
      
      private function onContextualManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == ContextualMenuManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onContextualManagerAdded);
            this.setContextualMenu();
         }
      }
      
      public function broadcastMessage(param1:String, param2:String, ... rest) : void
      {
         var _loc4_:DisplayObjectContainer = this as DisplayObjectContainer;
         this.broadcastMessageToContainer(_loc4_,param1,param2,rest);
      }
      
      private function fannysBtn() : void
      {
         var _loc1_:BubbleFlannysService = this.getFannyService();
         this.gui.fannysBtn.addEventListener(MouseEvent.CLICK,this.openFannys);
         this.gui.fannysBtn.visible = _loc1_.ableToSendReq();
         this.gui.fannysBtn.buttonMode = true;
      }
      
      public function repairRoom() : void
      {
         if(this.reparado)
         {
            return;
         }
         var _loc1_:MovieClip = this.background as MovieClip;
         if(_loc1_ && _loc1_.layer2 && Boolean(_loc1_.layer2.roto))
         {
            _loc1_.layer2.roto.visible = false;
            this.reparado = true;
         }
      }
      
      protected function initGui() : void
      {
         var _loc5_:GaturroQuestView = null;
         this.gui.addEventListener(Event.COMPLETE,this.tryToDequeueReport);
         addChild(this.gui);
         var _loc1_:UserAvatar = room.userAvatar;
         var _loc2_:Gaturro = this.userView.clip;
         var _loc3_:GaturroRoom = this.gRoom;
         this.guiStuff(_loc3_,_loc1_);
         logger.debug("UI creation start");
         var _loc4_:int = getTimer();
         this.disposables.push(new GuiActionsButton(this.gui,_loc1_),this.createGuiEmoticons(_loc1_),new GuiProfile(this.gui,_loc1_,user.profile as GaturroProfile,_loc2_,tasks),new GuiWhiteListButton(this.gui,_loc3_,tasks),new GuiAchievementButton(this.gui,_loc3_,tasks),this.createHomeGuiButton(),this.createMapHomeButtons(),new GuiBag(this.gui,_loc3_,tasks),new GuiMap(this.gui,_loc3_),this.iphoneButton());
         this.fannysBtn();
         this.addDetectiveBtn();
         this.addMundialBtn();
         this.addHalloweenBtn();
         this.addXmasBtn();
         this.addSettingsBtn();
         if(!this.gui.chatDisabled)
         {
            this.disposables.push(new GuiChat(this.gui,this.chat));
         }
         logger.debug("UI creation ends. takes:" + (getTimer() - _loc4_) / 1000 + " seconds");
         this.initAlertManager();
         if(Context.instance.hasByType(GaturroQuestView))
         {
            (_loc5_ = Context.instance.getByType(GaturroQuestView) as GaturroQuestView).setup();
         }
      }
      
      private function openQueueModal(param1:QueueModalEvent) : void
      {
         if(this.queueModal)
         {
            return;
         }
         var _loc2_:Sprite = param1.target as Sprite;
         var _loc3_:Sprite = DisplayUtil.getByName(_loc2_,"queue_ph") as Sprite || _loc2_;
         var _loc4_:Sprite = this.frontTileLayer;
         this.queueModal = new QueueModal(param1.name,param1.singlePlayerGame,param1.id);
         this.queueModal.addEventListener(Event.CLOSE,this.closeQueueModal);
         this.queueModal.addEventListener(QueueModalEvent.QUEUE_IS_READY,this.whenQueueIsReady);
         this.queueModal.addEventListener(QueueModalEvent.SINGLE_PLAYER,this.whenQueueIsReady);
         _loc4_.addChild(this.queueModal);
         this.queueModal.x = DisplayUtil.offsetX(_loc3_,_loc4_);
         this.queueModal.y = DisplayUtil.offsetY(_loc3_,_loc4_);
      }
      
      private function addDetectiveBtn() : void
      {
         if(false)
         {
            this.gui.albumDetectiveBtn.buttonMode = true;
            this.gui.albumDetectiveBtn.addEventListener(MouseEvent.CLICK,this.openAlbumDetective);
         }
         else
         {
            this.gui.albumDetectiveBtn.visible = false;
         }
         if(api.getProfileAttribute("detective19_final"))
         {
            this.gui.albumDetectiveBtn.visible = false;
         }
      }
      
      private function addHalloweenBtn() : void
      {
         this.gui.albumHalloween2018Btn.visible = false;
      }
      
      override public function dispose() : void
      {
         var _loc2_:IDisposable = null;
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         if(disposed)
         {
            return;
         }
         removeEventListener(MouseEvent.MOUSE_MOVE,this.whenMouseChangesPosition);
         removeEventListener(ChatViewEvent.SAY,this.whenNpcSaysSomething);
         removeEventListener(InformationModalEvent.SHOW,this.showInformationModal);
         removeEventListener(AlertEvent.BAD,this.handleAlerts);
         removeEventListener(AlertEvent.GOOD,this.handleAlerts);
         removeEventListener(HouseEntranceEvent.ACTIVATE,this.openHouseEntranceModal);
         removeEventListener(GaturroRoomSceneObjectEvent.TRY_TO_GRAB,this.whenTryingToGrab);
         removeEventListener(QueueModalEvent.OPEN,this.openQueueModal);
         removeEventListener(GiftGuiModalEvent.OPEN,this.openGiftPopup);
         removeEventListener(GiftReceiverGuiModalEvent.OPEN,this.openGiftReceiverPopup);
         removeEventListener(SellItemGuiModalEvent.OPEN,this.openSellPopup);
         removeEventListener(BannerModalEvent.OPEN,this.showBannerModal);
         removeEventListener(ImageModalEvent.OPEN,this.showImageModal);
         removeEventListener(AvatarsGuiModalEvent.OPEN,this.showAvatarsModal);
         removeEventListener(RankingModalEvent.OPEN,this.showRanking);
         room.userAvatar.removeEventListener(CustomAttributesEvent.CHANGED,this.checkAvatarChanges);
         this.balloons = null;
         this.lastTile = null;
         if(this.actions)
         {
            this.actions.dispose();
         }
         this.actions = null;
         if(this.consoleEditor)
         {
            this.consoleEditor.dispose();
         }
         this.consoleEditor = null;
         if(this.guiEditor)
         {
            this.guiEditor.dispose();
         }
         this.guiEditor = null;
         this.console = null;
         if(this.hotkey)
         {
            this.hotkey.dispose();
         }
         this.hotkey = null;
         this.npcUtility.roomDisposed();
         Context.instance.removeByType(GaturroRoomAPI);
         Context.instance.removeByType(Gui);
         var _loc1_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         if(_loc1_)
         {
            _loc1_.reset();
         }
         this.gui.settings.removeEventListener(MouseEvent.CLICK,this.openSettings);
         if(this.gui)
         {
            this.gui.fannysBtn.removeEventListener(MouseEvent.CLICK,this.openFannys);
            this.gui.removeEventListener(Event.COMPLETE,this.tryToDequeueReport);
            this.gui.dispose();
         }
         this.gui = null;
         for each(_loc2_ in this.disposables)
         {
            _loc2_.dispose();
         }
         this.disposables = null;
         this.layers = null;
         this.background = null;
         _loc3_ = 0;
         while(_loc3_ < this.particleArray.length)
         {
            this.particleArray[_loc3_].removeEventListener(Event.ENTER_FRAME,this.onParticleEnterFrame);
            _loc3_++;
         }
         this.particleArray = null;
         if(this.usernameDisplay)
         {
            this.usernameDisplay.dispose();
         }
         this.usernameDisplay = null;
         if(this.alerts)
         {
            this.alerts.dispose();
         }
         this.alerts = null;
         if(this.reports)
         {
            this.reports.removeEventListener(InfoReportQueueEvent.HAS_ITEMS,this.tryToDequeueReport);
         }
         this.reports = null;
         var _loc4_:EventsService;
         if(_loc4_ = Context.instance.getByType(EventsService) as EventsService)
         {
            _loc4_.removeEventListener(EventsService.PARTY_CREATED,this.addPartyGui);
            _loc4_.removeEventListener(EventsService.IS_OVER,this.onEventOver);
         }
         room.removeEventListener(CatalogEvent.OPEN,this.openCatalog);
         room.removeEventListener(PetCatalogEvent.OPEN_PET_CATALOG,this.openPetCatalog);
         room.removeEventListener(CurrencyCatalogEvent.OPEN,this.openCurrencyCatalog);
         room.removeEventListener(InformationModalEvent.SHOW,this.showInformationModal);
         room.removeEventListener(InteractionManager.INIT_INTERACTION_EVENT,this.proposeInteraction);
         room.removeEventListener(GaturroRoom.PROPOSE_INVITE,this.proposeInvite);
         this.interactionManager.dispose();
         this.interactionManager = null;
         if(this.guiMessage)
         {
            this.guiMessage = null;
         }
         super.dispose();
         this.cursor = null;
         for each(_loc5_ in this.avatars)
         {
            if(_loc5_ is GaturroAvatarView)
            {
               GaturroAvatarView(_loc5_).removeEventListener(CreateOwnedNpcEvent.NAME,this.createOwnedNpc);
            }
         }
         this.avatars = null;
         this.layers = null;
         this.frontTileLayer = null;
         api.dispose();
         api = null;
      }
      
      protected function whenTileIsHovered(param1:TileView) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         this.rolloutLastTile();
         this.lastTile = param1;
         for each(_loc3_ in this.getChildren(param1))
         {
            _loc4_ = this.whenObjectHovered(_loc3_);
            if(!_loc2_)
            {
               _loc2_ = _loc4_;
            }
         }
         this.checkCursorState(_loc2_);
      }
      
      private function showAvatarsModal(param1:AvatarsGuiModalEvent) : void
      {
         var _loc2_:Avatar = sceneObjects.getItem(param1.avatar) as Avatar;
         if(_loc2_)
         {
            this.gui.addModal(new AvatarsGuiModal(_loc2_,this.gRoom));
         }
         else
         {
            logger.warning("Could not find the Avatar when opening its profile");
         }
      }
      
      private function openAlbumMundial(param1:MouseEvent) : void
      {
         api.trackEvent("FEATURES:MUNDIAL_2018:ALBUM:ABRE_GUI","true");
         api.instantiateBannerModal("AlbumMundial2018");
      }
      
      private function openGiftPopup(param1:GiftGuiModalEvent) : void
      {
         this.gui.addModal(new GiftGuiModal(tasks,net,param1.receiver));
      }
      
      private function addMessage(param1:ChatEvent) : void
      {
         var _loc4_:GaturroUserAvatar = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc2_:GaturroChatMessage = param1.message as GaturroChatMessage;
         var _loc3_:GaturroAvatarView = this.avatars[_loc2_.sender];
         _loc4_ = room.userAvatar as GaturroUserAvatar;
         if(_loc3_ && _loc2_.message)
         {
            if(_loc2_.message.charAt(0) == "@")
            {
               if(_loc2_.message.substr(0,this.INVITE_PREFIX.length + 1) == "@" + this.INVITE_PREFIX)
               {
                  _loc6_ = Number(_loc2_.message.split(";")[1]);
                  _loc7_ = String(_loc2_.message.split(";")[2]);
                  this.balloons.proposeInvite(_loc6_,_loc7_,_loc3_);
               }
               else
               {
                  this.interactionManager.receivedOp(_loc2_);
               }
            }
            else
            {
               if(_loc2_.badwords)
               {
                  _loc2_.message = this.BADWORDS_TEXT;
               }
               this.interactionManager.say(this.balloons,_loc2_.sender,_loc2_.message);
               this.balloons.say(_loc3_,_loc2_.message);
            }
         }
      }
      
      private function addPartyGui(param1:Event = null) : void
      {
         var _loc2_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         var _loc3_:EventsGui = new EventsGui(_loc2_);
         if(this.gui)
         {
            this.gui.dance_ph.addChild(_loc3_);
            _loc3_.configMenu(this);
         }
      }
      
      private function iphoneButton() : BaseGuiModalOpener
      {
         this.guiIPhoneButton = new GuiIPhone2Button(this.gui,tasks,this.mailer,GaturroRoom(room),this,this.iphoneWhitelist);
         return this.guiIPhoneButton;
      }
      
      private function closeQueueModal(param1:Event) : void
      {
         this.queueModal.dispose();
         this.queueModal.removeEventListener(Event.CLOSE,this.closeQueueModal);
         this.queueModal.removeEventListener(QueueModalEvent.QUEUE_IS_READY,this.whenQueueIsReady);
         DisplayUtil.remove(this.queueModal);
         this.queueModal = null;
      }
      
      private function setupContextualMenu() : void
      {
         if(Context.instance.hasByType(ContextualMenuManager))
         {
            this.setContextualMenu();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onContextualManagerAdded);
         }
      }
      
      override protected function disposeChild(param1:DisplayObject) : void
      {
         if(param1 && param1 is IDisposable === false && "dispose" in param1)
         {
            Object(param1).dispose();
         }
         if(this.combatManager)
         {
            this.combatManager.dispose();
         }
         if(this.guiDancingModal)
         {
            this.guiDancingModal.dispose();
         }
         if(this.photoTripButton)
         {
            this.photoTripButton.dispose();
         }
         super.disposeChild(param1);
      }
      
      public function showPhotoCameraWithFilter(param1:Boolean, param2:Array) : void
      {
         this.gui.addModal(new CaptureSceneModal(this,param1,param2));
      }
      
      private function showPassportWarningModal() : void
      {
         if(api.getSession("warningShown"))
         {
            return;
         }
         this.gui.addModal(new PassportWarningModal());
      }
      
      private function openHouseEntranceModal(param1:HouseEntranceEvent) : void
      {
         this.gui.addModal(new HouseEntranceGuiModal(this.gRoom));
      }
      
      protected function getRelativeBkgUrl() : String
      {
         this.bgName = this.getBgName();
         return BACKGROUNDS_BASE + this.bgName + ".swf";
      }
      
      private function whenBackgroundLoaded(param1:Event) : void
      {
         var _loc2_:com.wispagency.display.LoaderInfo = LoaderInfo(param1.target);
         logger.debug("whenBackgroundLoaded: ");
         this.background = DisplayObjectContainer(_loc2_.content);
         if(this.background)
         {
            this.loadingFinished();
            this.finalInit();
            if("acquireAPI" in this.background)
            {
               Object(this.background).acquireAPI(api);
            }
         }
         else
         {
            setTimeout(this.finalInit,1000);
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this.gui.loading.visible = false;
         addEventListener(MouseEvent.MOUSE_MOVE,this.whenMouseChangesPosition);
         addEventListener(ChatViewEvent.SAY,this.whenNpcSaysSomething);
         addEventListener(InformationModalEvent.SHOW,this.showInformationModal);
         addEventListener(HouseEntranceEvent.ACTIVATE,this.openHouseEntranceModal);
         addEventListener(GaturroRoomSceneObjectEvent.TRY_TO_GRAB,this.whenTryingToGrab);
         addEventListener(QueueModalEvent.OPEN,this.openQueueModal);
         this.reports.addEventListener(InfoReportQueueEvent.HAS_ITEMS,this.tryToDequeueReport);
         room.addEventListener(CatalogEvent.OPEN,this.openCatalog);
         room.addEventListener(PetCatalogEvent.OPEN_PET_CATALOG,this.openPetCatalog);
         room.addEventListener(CurrencyCatalogEvent.OPEN,this.openCurrencyCatalog);
         room.addEventListener(InformationModalEvent.SHOW,this.showInformationModal);
         addEventListener(AvatarsGuiModalEvent.OPEN,this.showAvatarsModal);
         addEventListener(BannerModalEvent.OPEN,this.showBannerModal);
         addEventListener(ImageModalEvent.OPEN,this.showImageModal);
         addEventListener(GiftGuiModalEvent.OPEN,this.openGiftPopup);
         addEventListener(GiftReceiverGuiModalEvent.OPEN,this.openGiftReceiverPopup);
         addEventListener(FishingGuiModalEvent.OPEN,this.openFishingPopup);
         addEventListener(SellItemGuiModalEvent.OPEN,this.openSellPopup);
         addEventListener(GranjaModalEvent.OPEN,this.openGranjaModal);
         addEventListener(GranjaLevelUpEvent.OPEN,this.openGranjalevelUpModal);
         addEventListener(SiloModalEvent.OPEN,this.openSiloModal);
         addEventListener(CropTimerModalEvent.OPEN,this.openCropTimerModal);
         addEventListener(GranjaSellingModalEvent.OPEN,this.openGranjaSellingModal);
         addEventListener(GranjaParcelaUnlockEvent.OPEN,this.openGranjaParcelaUnlock);
         addEventListener(CombatEvent.START,this.combatStart);
         addEventListener(CombatEvent.STOP,this.combatStop);
         addEventListener(RankingModalEvent.OPEN,this.showRanking);
         addEventListener(BannerModalEvent.INSTANTIATE,this.onInstatiateModal);
         room.addEventListener(InteractionManager.INIT_INTERACTION_EVENT,this.proposeInteraction);
         room.addEventListener(GaturroRoom.PROPOSE_INVITE,this.proposeInvite);
         room.userAvatar.addEventListener(CustomAttributesEvent.CHANGED,this.checkAvatarChanges);
      }
      
      private function openGranjaSellingModal(param1:GranjaSellingModalEvent) : void
      {
         this.gui.addModal(new GranjaSellingModal(param1.api,param1.request));
      }
      
      public function broadcastMessageToContainer(param1:DisplayObjectContainer, param2:String, param3:String, param4:Array) : void
      {
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc5_:int = 0;
         while(_loc5_ < param1.numChildren)
         {
            if(_loc6_ = param1.getChildAt(_loc5_) as DisplayObjectContainer)
            {
               _loc7_ = false;
               _loc8_ = getQualifiedClassName(_loc6_);
               _loc9_ = getQualifiedSuperclassName(_loc6_);
               if(getQualifiedClassName(_loc6_) === param2 || getQualifiedSuperclassName(_loc6_) === param2)
               {
                  if(param3 in _loc6_)
                  {
                     Object(_loc6_)[param3].apply(_loc6_,param4);
                     _loc7_ = true;
                  }
               }
               if(!_loc7_)
               {
                  this.broadcastMessageToContainer(_loc6_,param2,param3,param4);
               }
            }
            _loc5_++;
         }
      }
      
      private function getAttr() : void
      {
         this._roomsVisitedAttr = api.getProfileAttribute("roomsVisited__" + this._contSlotRoom);
         if(this._roomsVisitedAttr != null && (this._roomsVisitedAttr as String).length > 230)
         {
            ++this._contSlotRoom;
            this.getAttr();
         }
      }
      
      protected function openCatalog(param1:CatalogEvent) : void
      {
         if(this.gui.modal is CatalogModal)
         {
            return;
         }
         var _loc2_:CatalogModal = new CatalogModal(param1.catalog,net,tasks,this.gRoom);
         this.gui.addModal(_loc2_);
      }
      
      public function unfreeze() : void
      {
         var _loc1_:int = 0;
         if(this.screenShoot.parent != null)
         {
            removeChild(this.screenShoot);
         }
         if(this.layers == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.layers.length)
         {
            this.layers[_loc1_].visible = true;
            _loc1_++;
         }
      }
      
      private function showRanking(param1:RankingModalEvent) : void
      {
         var _loc2_:Boolean = this.gRoom.userAvatar.isCitizen;
         this.gui.addModal(new MapGuiModal(_loc2_,this.gRoom,param1.gameName));
      }
      
      public function blockGuiFor(param1:int) : void
      {
         this.gui.blockFor(param1);
      }
      
      override protected function whenAddedToStage() : void
      {
         if(api)
         {
            api.dispose();
            api = null;
         }
         api = new GaturroRoomAPI(this.gRoom,this,sceneObjects);
         this.userSettings();
         Context.instance.addByType(api,GaturroRoomAPI);
         this.gui = new Gui();
         Context.instance.addByType(this.gui,Gui);
         super.whenAddedToStage();
         this.loadBg();
         this.loadBounds();
         this.usernameDisplay = new UsernameDisplayManager();
         tileLayer.addChild(this.usernameDisplay);
         this.initChat();
         this.interactionManager = new InteractionManager(GaturroRoom(this.room),this.avatars,this.balloons,this.gui);
         achievements.changeRoom(GaturroRoom(this.room));
         this.temporalFeatures();
         this.createModalFactory();
         this.setupContextualMenu();
         this.getBubbleFlanysService();
         this.bubbleFlanysServie.getChanceFunny();
      }
      
      override protected function createFloor() : void
      {
         tileLayer.y = settings._tiles_.normal.layerY;
      }
      
      protected function visitingRooms() : void
      {
         this._contSlotRoom = 0;
         this.hasVisitThisRoom();
         this._contSlotRoom = 0;
         if(this._foundRoom)
         {
            return;
         }
         if(!this._foundRoom && room.ownerName == null)
         {
            this.getAttr();
            api.levelManager.addExplorerExp(5);
            if(this._roomsVisitedAttr == null)
            {
               this._roomsVisitedAttr = room.id.toString() + ";";
            }
            else
            {
               this._roomsVisitedAttr += room.id.toString() + ";";
            }
            api.setProfileAttribute("roomsVisited__" + this._contSlotRoom,this._roomsVisitedAttr);
         }
      }
      
      public function proposeInteraction(param1:QEvent) : void
      {
         var _loc2_:String = String(param1.data.type);
         var _loc3_:String = String(param1.data.username);
         this.interactionManager.initProposeInteraction(_loc2_,_loc3_);
      }
      
      override protected function whenReady() : void
      {
      }
      
      private function hasVisitThisRoom() : void
      {
         var _loc2_:Object = api.getProfileAttribute("roomsVisited__" + this._contSlotRoom);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Array = String(_loc2_).split(";");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == room.id.toString())
            {
               this._foundRoom = true;
            }
            _loc4_++;
         }
         if(!this._foundRoom)
         {
            ++this._contSlotRoom;
            this.hasVisitThisRoom();
         }
      }
      
      private function firstReportDequeue() : void
      {
         if(!firstTimeInSession)
         {
            return this.tryToDequeueReport();
         }
         var _loc1_:GaturroProfile = user.profile as GaturroProfile;
         _loc1_.increaseSessionCount();
         if(this.gui.modal == null && firstTimeInSession && _loc1_.sessionCount % settings.gui.tipsFrequency === 1)
         {
            this.showModeratorModal();
         }
         else
         {
            this.tryToDequeueReport();
         }
         firstTimeInSession = false;
      }
      
      private function openSettings(param1:MouseEvent) : void
      {
         this.instatiateModal("UserSettingsBanner");
      }
      
      private function openAlbumDetective(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("AlbumMonster2019");
      }
      
      protected function createHomeGuiButton() : IDisposable
      {
         return new GuiCloset(gui,tasks,gRoom);
      }
      
      protected function tryToDequeueReport(param1:Event = null) : void
      {
         var _loc2_:InfoReportItem = null;
         if(this.gui && !this.gui.hasModal && this.reports.hasItems)
         {
            _loc2_ = this.reports.dequeue();
            if(_loc2_.type === InfoReportType.COINS)
            {
               this.gui.addModal(new AcquiredCoinsGuiModal(_loc2_.data as GameMinigameReward,this.gRoom,this.gui));
            }
            else if(_loc2_.type === InfoReportType.HALLOWEEN_2017)
            {
               api.instantiateBannerModal("HalloweenRewardsBanner",null,"",_loc2_.data);
            }
            else if(_loc2_.type === InfoReportType.NAVIDAD_2017)
            {
               api.instantiateBannerModal("NavidadRewardsBanner",null,"",_loc2_.data);
            }
            else if(_loc2_.type === InfoReportType.REYES_2018)
            {
               api.instantiateBannerModal("ReyesRewardsBanner",null,"",_loc2_.data);
            }
            else
            {
               this.addInformationModal(_loc2_.message,_loc2_.type);
            }
         }
      }
      
      protected function buyRoom(param1:int) : void
      {
      }
      
      public function freeze() : void
      {
         var _loc1_:int = 0;
         this.screenShoot.bitmapData.draw(this);
         addChildAt(this.screenShoot,0);
         if(this.layers == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.layers.length)
         {
            this.layers[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function initChat() : void
      {
         this.chat.addEventListener(ChatEvent.SENT,this.sentMessage);
         this.chat.addEventListener(ChatEvent.RECEIVED,this.addMessage);
         this.balloons = new BalloonManager(tileLayer);
         tasks.add(this.balloons);
      }
      
      private function whenQueueIsReady(param1:QueueModalEvent) : void
      {
         this.closeQueueModal(param1);
         if(param1.type === QueueModalEvent.QUEUE_IS_READY)
         {
            this.gRoom.startMultiplayer(param1.login);
         }
         else
         {
            this.gRoom.startMinigame(param1.name);
         }
      }
      
      private function openSiloModal(param1:SiloModalEvent) : void
      {
         this.gui.addModal(new SiloModal(tasks,param1.api,param1.asset));
      }
      
      protected function checkCursorState(param1:DisplayObject = null) : void
      {
         if(!param1)
         {
            this.cursor.pointer = Cursor.WALK;
         }
         else
         {
            this.cursor.pointer = this.getSelectedCursor(param1);
         }
         this.cursor.visible = true;
      }
      
      private function createModalFactory() : void
      {
         this.modalFactory = new ModalFactory(api,tasks,net);
         Context.instance.addByType(this.modalFactory,ModalFactory);
      }
      
      public function showPhotoCamera(param1:Boolean) : void
      {
         this.gui.addModal(new CaptureSceneModal(this,param1));
      }
      
      private function getTilesFromConfig(param1:int) : Object
      {
         var _loc2_:String = null;
         for(_loc2_ in settings._tiles_)
         {
            if(param1.toString() == _loc2_)
            {
               return settings._tiles_[_loc2_];
            }
         }
         return settings._tiles_.normal;
      }
      
      override protected function createPortal(param1:Portal) : DisplayObject
      {
         return new GaturroPortalView(param1,tiles,this.gRoom,this.cursor);
      }
      
      protected function createMapHomeButtons() : IDisposable
      {
         return new GuiHouseMap(this.gui,this.gRoom,false,this.buyRoom);
      }
      
      public function addThinkBalloonImg(param1:DisplayObject, param2:int, param3:int, param4:Array) : void
      {
         this.balloons.thinkImg(param1,param2,param3,param4);
      }
      
      protected function getSelectedCursor(param1:DisplayObject) : String
      {
         return Cursor.HAND;
      }
      
      private function createGuiEmoticons(param1:UserAvatar) : IDisposable
      {
         this.emoticonsGUI = new GuiEmoticons(this.gui,param1);
         return this.emoticonsGUI;
      }
      
      public function getActions() : NetActionManager
      {
         if(this.actions == null)
         {
            this.actions = new NetActionManager(net,this.gRoom);
         }
         return this.actions;
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         if(param1 is OwnedNpcRoomSceneObject)
         {
            _loc2_ = new OwnedNpcRoomSceneObjectView(param1 as NpcRoomSceneObject,tasks,tiles,sceneObjects,this.gRoom,api);
         }
         else if(param1 is NpcRoomSceneObject)
         {
            _loc2_ = new NpcRoomSceneObjectView(param1 as NpcRoomSceneObject,tasks,tiles,sceneObjects,this.gRoom,api);
            this.npcUtility.tryModify(_loc2_ as NpcRoomSceneObjectView,room.id);
         }
         if(param1 is MinigameRoomSceneObject)
         {
            _loc2_ = new MinigameRoomSceneObjectView(param1 as MinigameRoomSceneObject,tiles,this.gRoom);
         }
         if(param1 is VendorRoomSceneObject)
         {
            _loc2_ = new VendorRoomSceneObjectView(param1 as VendorRoomSceneObject,tiles);
         }
         if(param1.name === "city.houseEntrance")
         {
            _loc2_ = new HouseEntranceRoomSceneObjectView(param1,tiles);
         }
         if(param1 is HolderRoomSceneObject)
         {
            _loc2_ = new HolderRoomSceneObjectView(param1 as HolderRoomSceneObject,tiles,sceneObjects);
         }
         if(param1 is MultiHolderRoomSceneObject)
         {
            _loc2_ = new MultiHolderRoomSceneObjectView(param1 as MultiHolderRoomSceneObject,tiles,sceneObjects);
         }
         if(param1 is BannerRoomSceneObject)
         {
            _loc2_ = new BannerRoomSceneObjectView(param1 as BannerRoomSceneObject,tiles,this.gui,this.gRoom,api);
         }
         if(param1 is ImageRoomSceneObject)
         {
            _loc2_ = new ImageRoomSceneObjectView(param1 as ImageRoomSceneObject,tiles,this.gui);
         }
         if(param1 is QueueRoomSceneObject)
         {
            _loc2_ = new QueueRoomSceneObjectView(param1 as QueueRoomSceneObject,tiles);
         }
         if(param1 is HouseDecorationRoomSceneObject)
         {
            _loc2_ = new HouseDecorationRoomSceneObjectView(param1 as HouseDecorationRoomSceneObject,tiles);
         }
         if(param1 is HomeInteractiveRoomSceneObject)
         {
            _loc2_ = new HomeInteractiveRoomSceneObjectView(param1 as HomeInteractiveRoomSceneObject,tiles,this.gRoom,api);
         }
         if(!_loc2_)
         {
            _loc2_ = new GaturroRoomSceneObjectView(param1,tiles);
         }
         switch(param1.name)
         {
            case null:
            case "":
               break;
            case GATURRO_NAME:
               Object(_loc2_).add(new Gaturro(param1));
               break;
            case AvatarPet.NAME:
               Object(_loc2_).add(new PetMovieClip(param1 as AvatarPet));
               break;
            default:
               libs.fetch(param1.name,this.loadAsset,{
                  "view":_loc2_,
                  "object":param1
               });
         }
         return _loc2_ as DisplayObject;
      }
      
      private function onParticleEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.y += _loc2_.config.directionY;
         _loc2_.x += _loc2_.config.directionX;
         _loc2_.rotation += _loc2_.config.rotation;
         if(_loc2_.y > 800)
         {
            _loc2_.y = Math.random() * 900 * 2 - 900;
            _loc2_.x = Math.random() * 1600 * 2 - 1600;
         }
      }
      
      private function handleAlerts(param1:AlertEvent) : void
      {
         if(param1.type === AlertEvent.GOOD)
         {
            this.alerts.good(param1.text);
         }
         else
         {
            this.alerts.bad(param1.text);
         }
      }
      
      private function openGranjaParcelaUnlock(param1:GranjaParcelaUnlockEvent) : void
      {
         this.gui.addModal(new GranjaParcelaUnlock(param1.objectAPI,api));
      }
      
      private function removeEventGui() : void
      {
         if(this.gui)
         {
            while(this.gui.dance_ph.numChildren > 0)
            {
               this.gui.dance_ph.removeChildAt(0);
            }
         }
      }
      
      private function showBadwordsMessage() : void
      {
         trace("badwords message");
         this.gui.addModal(new ModeratorTipModal(ModeratorTipModal.BADWORDS));
      }
      
      protected function whenTryingToGrab(param1:GaturroRoomSceneObjectEvent) : void
      {
         var _loc2_:RoomSceneObject = param1.object;
         var _loc3_:GaturroInventory = InventoryUtil.getInventory(_loc2_);
         if(_loc3_.hasRoomFor(param1.object.name))
         {
            _loc3_.grab(param1.object.id);
            this.userView.clip.leanOver();
         }
         else
         {
            this.addInformationModal(region.key("cannot_grab"),InfoReportType.INVENTORY);
         }
      }
      
      private function particleCallback(param1:DisplayObject, param2:Object) : void
      {
         var _loc3_:MovieClip = param1 as MovieClip;
         _loc3_.config = new Object();
         _loc3_.config.directionX = Boolean(param2.config) && param2.config.directionX != null ? param2.config.directionX : Math.random() * 2 - 1;
         _loc3_.config.directionY = Boolean(param2.config) && param2.config.directionY != null ? param2.config.directionY : Math.random() * 2;
         _loc3_.config.rotation = Boolean(param2.config) && param2.config.rotation != null ? param2.config.rotation : Math.random() * 2 - 1;
         _loc3_.x = Math.random() * 1600 * 2 - 1600;
         _loc3_.y = Math.random() * 900 * 2 - 900;
         _loc3_.addEventListener(Event.ENTER_FRAME,this.onParticleEnterFrame);
         this.particleArray.push(_loc3_);
         param2.layer.addChild(_loc3_);
      }
      
      public function callOnBGround(param1:String, param2:Object = null) : void
      {
         if(param1 in this.background)
         {
            if(param2)
            {
               this.background[param1](param2);
            }
            else
            {
               this.background[param1]();
            }
         }
      }
      
      private function showImageModal(param1:ImageModalEvent) : void
      {
         this.gui.addModal(new ImageGuiModal(param1.image));
      }
      
      public function captureScene(param1:Boolean = false, param2:Boolean = false, param3:Number = 0, param4:Number = 0, param5:Number = 800, param6:Number = 480) : BitmapData
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this.gui.visible = param1;
         this.balloons.visibility(param2);
         var _loc7_:BitmapData = new BitmapData(param5,param6);
         var _loc8_:Rectangle = new Rectangle(param3,param4,param5,param6);
         _loc7_.draw(this,null,null,null,_loc8_);
         if(api.country == "BR")
         {
            _loc9_ = 500;
            _loc10_ = 400;
         }
         else
         {
            _loc9_ = Number(settings.services.socialNet.sceneImage.width);
            _loc10_ = Number(settings.services.socialNet.sceneImage.height);
         }
         var _loc11_:Number = param5 / 2 - _loc9_ / 2;
         var _loc12_:Number = param6 / 2 - _loc10_ / 2;
         var _loc13_:BitmapData = new BitmapData(_loc9_,_loc10_);
         var _loc14_:Rectangle = new Rectangle(_loc11_,_loc12_,_loc9_,_loc10_);
         _loc13_.copyPixels(_loc7_,_loc14_,new Point(param3,param4));
         this.gui.visible = true;
         this.balloons.visibility(true);
         return _loc13_;
      }
      
      public function messageToGUI(param1:String) : void
      {
         if(!this.guiMessage)
         {
            this.guiMessage = new GuiMessage();
            this.gui.phTop.addChild(this.guiMessage);
         }
         this.guiMessage.playMessage(param1);
      }
      
      protected function endShake() : void
      {
         this.lastStep = true;
      }
      
      private function openFannys(param1:MouseEvent) : void
      {
         var _loc2_:BubbleFlannysService = this.getFannyService();
         var _loc3_:Object = new Object();
         _loc3_.userName = api.user.username;
         _loc3_.token = _loc2_.funnysToken;
         api.trackEvent("FEATURES:BUBBLEFLANYS:SHOW_MY_LIST","");
         api.startUnityMinigame("fluffyflaffy",0,null,_loc3_);
      }
      
      private function partyServiceCreated(param1:ContextEvent) : void
      {
         if(param1.instanceType == EventsService)
         {
            logger.info(this,"partyServiceCreated()",param1.instanceType);
            Context.instance.removeEventListener(ContextEvent.ADDED,this.partyServiceCreated);
            this.addPartyCreationHandler();
         }
      }
      
      public function openIphoneNews() : void
      {
         this.guiIPhoneButton.showIphoneNews();
      }
      
      protected function showModeratorModal() : void
      {
         this.gui.addModal(new ModeratorTipModal());
      }
      
      private function shake(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this.layers == null)
         {
            return;
         }
         this.direction *= -1;
         if(!this.lastStep)
         {
            _loc2_ = 0;
            while(_loc2_ < this.layers.length)
            {
               if(this.layers[_loc2_].name != "layer1" && this.layers[_loc2_].name != "layer3")
               {
                  _loc3_ = Math.random() * this.amp * this.direction;
                  this.layers[_loc2_].x += _loc3_;
                  _loc4_ = Math.random() * this.amp * this.direction;
                  this.layers[_loc2_].y += _loc4_;
                  (this.layersPositions[_loc2_] as Vector2D).add(new Vector2D(_loc3_,0));
               }
               _loc2_++;
            }
         }
         else
         {
            this.iShaking = false;
            this.removeEventListener(Event.ENTER_FRAME,this.shake);
            _loc5_ = 0;
            while(_loc5_ < this.layers.length)
            {
               if(this.layers[_loc5_].name != "layer1" && this.layers[_loc5_].name != "layer3")
               {
                  this.layers[_loc5_].x -= this.layersPositions[_loc5_].x;
                  this.layers[_loc5_].y = this.layersPositions[_loc5_].y;
               }
               _loc5_++;
            }
         }
      }
      
      protected function checkAvatarChanges(param1:CustomAttributesEvent) : void
      {
      }
      
      private function enableHidden() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(room.attributes.hidden)
         {
            if(!floorLayer.getChildByName("hidden"))
            {
               logger.debug(this,"el background de este room no tiene capa hidden");
               return;
            }
            _loc1_ = floorLayer.getChildByName("hidden") as DisplayObjectContainer;
            addChildAt(_loc1_,getChildIndex(floorLayer) + 1);
            this.hiddenObjects = HiddenObjects.create(_loc1_,"animalesLocos");
         }
      }
      
      private function userSettings() : void
      {
         var _loc1_:UserSettings = new UserSettings(this.stage);
         Context.instance.addByType(_loc1_,UserSettings);
         api.userSettings = _loc1_;
      }
      
      protected function isActivable(param1:DisplayObject) : Boolean
      {
         return param1 is ActivableView && ActivableView(param1).isActivable;
      }
      
      private function addXmasBtn() : void
      {
         this.gui.albumXmas2018Btn.visible = false;
      }
      
      protected function createOwnedNpc(param1:CreateOwnedNpcEvent) : void
      {
         var _loc3_:GaturroRoom = null;
         var _loc2_:Mobject = OwnedNpcFactory.createOwnedNpcMo(param1.data,param1.avatar);
         if(!_loc2_)
         {
            GaturroRoom(this.room).removeOwnedNpcByAvatar(param1.avatar);
         }
         else
         {
            _loc3_ = GaturroRoom(this.room);
            setTimeout(_loc3_.createSceneObjectFromMobject,100,_loc2_);
            param1.dispose();
         }
      }
      
      public function combatStop(param1:CombatEvent) : void
      {
         if(this.combatManager)
         {
            this.combatManager.stop();
         }
      }
      
      private function openCurrencyCatalog(param1:CurrencyCatalogEvent) : void
      {
         if(this.gui.modal is CatalogModal)
         {
            return;
         }
         var _loc2_:CatalogModal = new CatalogModal(param1.catalog,net,tasks,this.gRoom,{"currency":param1.currency});
         this.gui.addModal(_loc2_);
      }
      
      public function get userView() : GaturroAvatarView
      {
         return this.avatars[user.id] as GaturroAvatarView;
      }
      
      private function enableParty() : void
      {
         if(Context.instance.getByType(EventsService))
         {
            this.addPartyCreationHandler();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.partyServiceCreated);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this.cursor = new Cursor(this);
         if(Context.instance.hasByType(NpcUtility))
         {
            this.npcUtility = Context.instance.getByType(NpcUtility) as NpcUtility;
         }
         else
         {
            this.npcUtility = new NpcUtility();
            Context.instance.addByType(this.npcUtility,NpcUtility);
         }
      }
      
      public function getFannyService() : BubbleFlannysService
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
         return _loc1_;
      }
      
      public function get gaturroMailer() : GaturroMailer
      {
         return this.mailer as GaturroMailer;
      }
      
      public function showPhoto(param1:Bitmap, param2:Boolean = true) : void
      {
         this.gui.addModal(new ShowPhotoModal(param1,param2));
      }
      
      public function addDialogBalloonImg(param1:DisplayObject, param2:int, param3:int, param4:Array) : void
      {
         this.balloons.sayImg(param1,param2,param3,param4);
      }
      
      protected function rolloutLastTile(param1:Boolean = true) : void
      {
         var _loc2_:DisplayObject = null;
         if(!this.lastTile)
         {
            return;
         }
         for each(_loc2_ in this.getChildren(this.lastTile))
         {
            if(_loc2_ is NamedView)
            {
               this.usernameDisplay.unsetCharacter(_loc2_ as NamedView);
            }
            if(param1 && _loc2_ is RollableView && RollableView(_loc2_).isRollable)
            {
               RollableView(_loc2_).rollout();
            }
            if(_loc2_ is HomeInteractiveRoomSceneObjectView)
            {
               _loc2_.dispatchEvent(new Event(HomeInteractiveRoomSceneObjectView.TOOLTIP_OUT));
            }
            if(Boolean(_loc2_) && _loc2_ is DisplayObject)
            {
               this.deactivateSceneObject(_loc2_);
            }
         }
         this.lastTile = null;
      }
      
      private function sentMessage(param1:ChatEvent) : void
      {
         audio.addLazyPlay("chat");
         this.addMessage(param1);
      }
      
      private function openSellPopup(param1:SellItemGuiModalEvent) : void
      {
         this.gui.addModal(new SellItemGuiModal(user.allItemsGrouped,tasks,net));
      }
      
      private function addContextualMenu(param1:Object) : void
      {
         var _loc2_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         _loc2_.addMenu(param1.id,param1.avatar);
      }
      
      private function setContextualMenu() : void
      {
         var _loc1_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         _loc1_.container = this.infoLayer;
         _loc1_.cursor = this.cursor;
      }
      
      private function loadBounds() : void
      {
         this.bounds = int(room.attributes.bounds) || 0;
      }
      
      public function unlockLoading() : void
      {
         this.gui.loading.visible = false;
      }
      
      override protected function createLayers() : void
      {
         super.createLayers();
         this.infoLayer = addLayer(true);
      }
      
      public function addProgressModal(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.gui.addModal(new ProgressModal(param1,param2,param3,param4));
      }
      
      private function toggleConsole(param1:Event) : void
      {
         if(!this.console)
         {
            return;
         }
         param1.preventDefault();
         param1.stopImmediatePropagation();
         this.console.toggle();
      }
      
      public function unlockGui() : void
      {
         this.gui.block.visible = false;
      }
      
      protected function get chat() : RoomChat
      {
         return this.gRoom.chat;
      }
      
      override protected function tileSelected(param1:Tile) : void
      {
         var _loc3_:RoomSceneObject = null;
         var _loc4_:DisplayObject = null;
         if(this.cursor)
         {
            this.cursor.click();
         }
         var _loc2_:GaturroRoomViewEvent = new GaturroRoomViewEvent(GaturroRoomViewEvent.OBJECT_CLICKED);
         for each(_loc3_ in param1.children)
         {
            if(!(_loc4_ = sceneObjects.getItem(_loc3_) as DisplayObject) || !_loc4_.dispatchEvent(_loc2_))
            {
               return;
            }
         }
         super.tileSelected(param1);
      }
      
      private function whenNpcSaysSomething(param1:Object) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(Boolean(_loc2_) && "message" in param1)
         {
            this.balloons.say(_loc2_,param1.message);
         }
      }
      
      protected function getBgName() : String
      {
         if(room && room.attributes && Boolean(room.attributes.background))
         {
            return room.attributes.background;
         }
         return DEFAULT_BG;
      }
      
      public function proposeInvite(param1:QEvent) : void
      {
         var _loc2_:Number = Number(param1.data.roomId);
         var _loc3_:String = String(param1.data.text);
         this.balloons.proposeInvite(_loc2_,_loc3_,this.userView);
         var _loc4_:String = "@" + this.INVITE_PREFIX + ";" + _loc2_.toString() + ";" + _loc3_;
         GaturroRoom(room).chat.send(_loc4_);
      }
      
      private function onEventOver(param1:Event) : void
      {
         this.removeEventGui();
      }
      
      private function addEditor() : void
      {
         this.actions = new NetActionManager(net,this.gRoom);
         this.guiEditor = new GuiEditor(this,this.actions);
         var _loc1_:Rectangle = new Rectangle(0,0,stageData.width,stageData.height * 0.75);
         this.console = new Console(tasks,_loc1_);
         this.console.mouseChildren = false;
         this.console.mouseEnabled = false;
         this.console.register("gui.mode",this.guiMode);
         addChild(this.console);
         this.consoleEditor = new ConsoleEditor(this.console,this.actions,net);
         this.hotkey = new Hotkey(this);
         this.hotkey.add("F1, Ü",this.toggleConsole);
         logger;
      }
      
      public function particleEmit(param1:String, param2:int = 50, param3:Object = null) : void
      {
         var _loc4_:int = 0;
         if(MovieClip(this.background).layer3)
         {
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               api.libraries.fetch(param1,this.particleCallback,{
                  "layer":MovieClip(this.background).layer3,
                  "config":param3
               });
               _loc4_++;
            }
         }
      }
      
      private function getChildren(param1:TileView) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.tile.children)
         {
            _loc2_.push(sceneObjects.getItem(_loc3_));
         }
         return _loc2_;
      }
      
      private function temporalFeatures() : void
      {
         var _loc2_:Inventory = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc1_:Boolean = api.getSession("serePixelado") as Boolean;
         if(!_loc1_)
         {
            _loc2_ = api.user.inventory("visualizer");
            _loc3_ = _loc2_.byType("serenito.trajePixelado");
            _loc4_ = _loc2_.byType("serenito.trajePixeladoRojo");
            _loc5_ = _loc2_.byType("serenito.trajePixeladoAzul");
            _loc6_ = _loc2_.byType("serenito.trajePixeladoVerde");
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               api.takeFromUser("serenito.trajePixelado",_loc3_.length);
               setTimeout(this.cleanClothes,1300);
            }
            if(Boolean(_loc4_) && _loc4_.length > 0)
            {
               api.takeFromUser("serenito.trajePixeladoRojo",_loc4_.length);
               setTimeout(this.cleanClothes,1300);
            }
            if(Boolean(_loc5_) && _loc5_.length > 0)
            {
               api.takeFromUser("serenito.trajePixeladoAzul",_loc5_.length);
               setTimeout(this.cleanClothes,1300);
            }
            if(Boolean(_loc6_) && _loc6_.length > 0)
            {
               api.takeFromUser("serenito.trajePixeladoVerde",_loc6_.length);
               setTimeout(this.cleanClothes,1300);
            }
         }
         this.showPassportWarningModal();
         this.enableParty();
      }
      
      protected function whenObjectHovered(param1:DisplayObject) : DisplayObject
      {
         if(param1 is NamedView)
         {
            this.usernameDisplay.setCharacter(param1 as NamedView);
         }
         if(param1 is RollableView && RollableView(param1).isRollable)
         {
            RollableView(param1).rollover();
         }
         if(this.isActivable(param1))
         {
            if(param1 is HomeInteractiveRoomSceneObjectView)
            {
               param1.dispatchEvent(new Event(HomeInteractiveRoomSceneObjectView.TOOLTIP_IN));
            }
            if(param1 is NpcRoomSceneObjectView && NpcRoomSceneObjectView(param1).isDisabled)
            {
               return null;
            }
            this.activateSceneObject(param1);
            return param1;
         }
         return null;
      }
      
      private function openGiftReceiverPopup(param1:GiftReceiverGuiModalEvent) : void
      {
         this.gui.addModal(new GiftReceiverGuiModal());
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = param1 is UserAvatar ? new GaturroUserAvatarView(param1 as UserAvatar,tasks,tiles,sceneObjects) : new GaturroAvatarView(param1,tasks,tiles,sceneObjects);
         _loc2_.addEventListener(CreateOwnedNpcEvent.NAME,this.createOwnedNpc);
         this.avatars[param1.avatarId] = this.avatars[param1.username] = _loc2_;
         return _loc2_;
      }
      
      private function guiMode(param1:String = "") : void
      {
         if(!this.console)
         {
            return;
         }
         api.trackEvent("HACKING:GUI_MODE",api.user.username + ", " + param1);
         this.guiEditor.setAction(param1);
         this.console.hide();
      }
      
      private function guiStuff(param1:GaturroRoom, param2:UserAvatar) : void
      {
         var _loc3_:Array = [51687982,51688011,51688019,51688020,51683118];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1.id)
            {
               this.combatManager = new CombatManager(this.gui,this.gRoom,param2,tasks);
            }
            _loc4_++;
         }
         var _loc5_:Array = [51683117];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc5_[_loc6_] == param1.id)
            {
               this.guiDancingModal = new GuiDancingModal(this.gRoom,param2);
               this.gui.dance_ph.addChild(this.guiDancingModal);
            }
            _loc6_++;
         }
         var _loc7_:Array = settings.vuelos.photoTripRooms;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            if(_loc7_[_loc8_] == param1.id)
            {
               this.photoTripButton = new PhotoTripButton(this.gRoom,api,tasks);
               this.gui.dance_ph.addChild(this.photoTripButton);
            }
            _loc8_++;
         }
      }
      
      private function openAlbumHalloween(param1:MouseEvent) : void
      {
         api.trackEvent("FEATURES:HALLOWEEN_2018:ALBUM:ABRE_GUI","true");
         api.instantiateBannerModal("AlbumHalloween2018");
      }
      
      public function getAvatarView(param1:int) : GaturroAvatarView
      {
         return this.avatars[param1] as GaturroAvatarView;
      }
      
      public function addDialogBalloonWithImg(param1:DisplayObject, param2:String, param3:String) : void
      {
         this.balloons.sayWithImg(param1,param2,param3);
      }
      
      private function isNotSelectedFilter(param1:BitmapFilter) : Boolean
      {
         return param1 is GlowFilter === false || GlowFilter(param1).color !== this.selectedFilter.color;
      }
      
      public function getTaskRunner() : TaskRunner
      {
         return tasks;
      }
      
      public function addInformationModal(param1:String, param2:String, param3:String = null, param4:String = null) : void
      {
         this.gui.addModal(new InformationModal(param1,param2,param3,param4));
      }
      
      protected function finalInit() : void
      {
         this.roomCamera();
         this.initGui();
         logger.debug(this,server.version);
         if(Boolean(user.isAdmin) || server.serverName.indexOf("DEV") == -1)
         {
            this.addEditor();
         }
         reportReady();
         tasks.add(new Timeout(this.firstReportDequeue,1000));
         stage.focus = stage;
         this.visitingRooms();
         this.enableHidden();
      }
      
      private function openGranjalevelUpModal(param1:GranjaLevelUpEvent) : void
      {
         this.gui.addModal(new GranjaLevelUpModal(param1.level,param1.acquired));
      }
      
      protected function loadAsset(param1:Sprite, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         if(param1 is InteractiveRoomSceneObject)
         {
            InteractiveRoomSceneObject(param1).acquireAPI(api);
            InteractiveRoomSceneObject(param1).acquireObjectAPI(new GaturroSceneObjectAPI(param2.object,param2.view,this.gRoom));
         }
         else
         {
            if("acquireAPI" in param1)
            {
               Object(param1).acquireAPI(api);
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < param1.numChildren)
               {
                  if((Boolean(_loc4_ = param1.getChildAt(_loc3_))) && "acquireAPI" in _loc4_)
                  {
                     Object(_loc4_).acquireAPI(api);
                  }
                  _loc3_++;
               }
            }
            if("acquireObjectAPI" in param1)
            {
               Object(param1).acquireObjectAPI(new GaturroSceneObjectAPI(param2.object,param2.view,this.gRoom));
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < param1.numChildren)
               {
                  if((Boolean(_loc6_ = param1.getChildAt(_loc5_))) && "acquireObjectAPI" in _loc6_)
                  {
                     Object(_loc6_).acquireObjectAPI(new GaturroSceneObjectAPI(param2.object,param2.view,this.gRoom));
                  }
                  _loc5_++;
               }
            }
         }
         param2.view.add(param1);
      }
      
      protected function showBannerModal(param1:BannerModalEvent) : void
      {
         this.gui.addModal(new BannerGuiModal(param1.banner,param1.sceneAPI,param1.roomAPI,param1.options));
      }
      
      protected function openFishingPopup(param1:FishingGuiModalEvent) : void
      {
         this.gui.addModal(new FishingGuiModal(tasks,net,param1.objectApi));
      }
      
      private function openGranjaModal(param1:GranjaModalEvent) : void
      {
         this.gui.addModal(new GranjaModal(tasks,param1.objectAPI,api));
      }
      
      private function logUserDataForStadisticalPorpouses() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(api.getProfileAttribute("census_2017"))
         {
            return;
         }
         var _loc2_:Telemetry = Telemetry.getInstance();
         _loc2_.trackEvent("USERSTATS","lastLogin" + ":" + server.date.toString());
         logger.debug("USERSTATS","user" + ":" + api.user.username,server.date.date);
         _loc2_.trackEvent("USERSTATS","coins","",int(api.getProfileAttribute("coins")));
         logger.debug("USERSTATS","coins","",int(api.getProfileAttribute("coins")));
         var _loc3_:Array = api.user.allItemsGrouped;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = String(_loc4_.split(" ")[0].split("[")[1]);
            _loc7_ = (_loc6_ = String(_loc4_.split("name=\"")[1])).slice(0,_loc6_.indexOf("\"")).replace("/",".");
            _loc2_.trackEvent("USERSTATS","inventory" + ":" + _loc5_ + ":" + _loc7_);
            logger.debug("USERSTATS","inventory",_loc5_ + ":" + _loc7_);
         }
         _loc2_.trackEvent("USERSTATS",!!("isCitizen" + ":" + api.userAvatar.isCitizen) ? "yes" : "no");
         logger.debug("USERSTATS","isCitizen",!!api.userAvatar.isCitizen ? "yes" : "no");
         _loc2_.trackEvent("USERSTATS","club" + ":" + api.user.club.name);
         logger.debug("USERSTATS","club",api.user.club.name);
         api.setProfileAttribute("census_2017","true");
      }
      
      private function getBubbleFlanysService() : void
      {
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            this.bubbleFlanysServie = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            this.bubbleFlanysServie = new BubbleFlannysService();
            this.bubbleFlanysServie.init();
            Context.instance.addByType(this.bubbleFlanysServie,BubbleFlannysService);
         }
      }
      
      private function addMundialBtn() : void
      {
         this.gui.albumBtn.visible = false;
      }
      
      override protected function createTile(param1:Tile) : TileView
      {
         logger.info("Los hackers me dejan por la mitad!!!");
         var _loc2_:Object = settings._tiles_.normal;
         var _loc3_:Sprite = new GaturroTileView(param1,_loc2_.width,_loc2_.height,_loc2_.angle);
         var _loc4_:Coord = param1.coord;
         var _loc5_:uint = uint(room.grid.size.height - 1);
         var _loc6_:Number = (_loc3_.width - _loc2_.width - 1) * (_loc5_ - _loc4_.y);
         _loc3_.x = _loc4_.x * _loc2_.width + _loc6_ + _loc3_.width / 2 + _loc2_.delta;
         _loc3_.y = _loc4_.y * _loc2_.height + _loc3_.height / 2;
         return _loc3_ as TileView;
      }
      
      public function instatiateModal(param1:String, param2:GaturroSceneObjectAPI = null, param3:String = "", param4:Object = null) : void
      {
         logger.info("GaturroRoomView > instatiateModal > banneer: " + param1);
         var _loc5_:BaseGuiModal = this.modalFactory.build(param1,param2,param3,param4);
         this.gui.addModal(_loc5_);
      }
      
      private function openAlbumXmas(param1:MouseEvent) : void
      {
         api.trackEvent("FEATURES:XMAS_2018:ALBUM:ABRE_GUI","true");
         api.instantiateBannerModal("AlbumXmas2018");
      }
      
      private function cleanClothes() : void
      {
         api.giveInstantCloth("cloth","");
         api.giveInstantCloth("hats","");
         api.giveInstantCloth("arm","");
         api.giveInstantCloth("leg","");
         api.giveInstantCloth("foot","");
      }
      
      public function addAwardModal(param1:String, param2:String, param3:String, param4:int = 1, param5:String = null) : void
      {
         this.gui.addModal(new AwardModal(param1,param2,param3,param4,param5));
      }
      
      private function loadBg() : void
      {
         var _loc1_:String = this.getRelativeBkgUrl();
         _loc1_ = URLUtil.getUrl(_loc1_);
         _loc1_ = URLUtil.versionedPath(_loc1_);
         var _loc2_:com.wispagency.display.Loader = new com.wispagency.display.Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.whenBackgroundLoaded);
         var _loc3_:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         _loc2_.load(new URLRequest(_loc1_),new LoaderContext(false,_loc3_));
      }
      
      public function startShake(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         if(this.iShaking)
         {
            return;
         }
         if(param3)
         {
            api.playSound("terremoto");
         }
         this.iShaking = true;
         this.addEventListener(Event.ENTER_FRAME,this.shake);
         var _loc4_:Timeout = new Timeout(this.endShake,param1);
         tasks.add(_loc4_);
         this.amp = param2;
         this.layersPositions = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this.layers.length)
         {
            this.layersPositions[_loc5_] = new Vector2D(0,this.layers[_loc5_].y);
            _loc5_++;
         }
         this.lastStep = false;
      }
      
      public function combatStart(param1:CombatEvent) : void
      {
         if(this.combatManager)
         {
            this.combatManager.start(param1.objectAPI);
         }
      }
      
      protected function getBgLayer(param1:String) : DisplayObject
      {
         var _loc2_:DisplayObject = this.background.getChildByName(param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         logger.warning("GaturroRoomView > The background",this.bgName,"does not have",param1);
         return new Shape();
      }
      
      protected function deactivateSceneObject(param1:DisplayObject) : void
      {
         param1.filters = this.getCleanFilters(param1);
      }
      
      private function addSettingsBtn() : void
      {
         this.gui.settings.buttonMode = true;
         this.gui.settings.addEventListener(MouseEvent.CLICK,this.openSettings);
      }
      
      private function loadingFinished() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:MovieClip = null;
         var _loc4_:InteractiveObject = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         if(!this.userView)
         {
            return logger.debug("GaturroRoomView > The user\'s avatar didn\'t join the room");
         }
         var _loc1_:Object = settings.test_parallax;
         if(settings.not_broken)
         {
            _loc2_ = new TiledLayer(this.getBgLayer("layer1"),_loc1_.layer1Speed);
            _loc2_.name = "layer1";
            floorLayer.addChild(_loc2_);
            this.layers.push(_loc2_);
            _loc3_ = this.getBgLayer("hidden") as MovieClip;
            if(_loc3_)
            {
               logger.debug(this,"adding hidden objects",_loc3_.name);
               floorLayer.addChild(_loc3_);
               this.layers.push(_loc3_);
            }
            (_loc4_ = this.getBgLayer("layer2") as InteractiveObject).cacheAsBitmap = true;
            _loc4_.mouseEnabled = false;
            addChildAt(_loc4_,getChildIndex(tileLayer));
            this.layers.push(_loc4_);
            frontLayer.name = "layer3";
            _loc5_ = new TiledLayer(this.getBgLayer("layer3"),_loc1_.layer3Speed);
            frontLayer.addChildAt(_loc5_,0);
            this.layers.push(frontLayer);
            this.frontTileLayer = new Sprite();
            this.frontTileLayer.name = "frontTileLayer";
            this.frontTileLayer.y = tileLayer.y;
            addChildAt(this.frontTileLayer,getChildIndex(frontLayer));
            this.layers.push(this.frontTileLayer);
            this.cursor.addCursors(numChildren,getChildIndex(tileLayer));
            audio.register("flecha").start();
            tasks.add(this.cursor);
            for each(_loc6_ in this.layers)
            {
               logger.debug(this,_loc6_.name);
            }
         }
      }
      
      protected function roomCamera() : void
      {
         CameraSwitcher.instance.taskRunner = tasks;
         CameraSwitcher.instance.switchCamera(CameraSwitcher.ROOM_CAMERA,tileLayer,this.layers,this.bounds,this.userView);
      }
      
      protected function initAlertManager() : void
      {
         this.alerts = new AlertManager(tasks);
         this.alerts.x = stageData.width / 2;
         this.alerts.y = stageData.height / 2;
         addChild(this.alerts);
         addEventListener(AlertEvent.BAD,this.handleAlerts);
         addEventListener(AlertEvent.GOOD,this.handleAlerts);
      }
      
      protected function get gRoom() : GaturroRoom
      {
         return room as GaturroRoom;
      }
      
      private function addPartyCreationHandler() : void
      {
         logger.info(this,"addPartyCreationHandler()");
         var _loc1_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         _loc1_.addEventListener(EventsService.PARTY_CREATED,this.addPartyGui);
         _loc1_.addEventListener(EventsService.IS_OVER,this.onEventOver);
         if(_loc1_.eventRunning)
         {
            this.addPartyGui();
         }
      }
      
      private function getCleanFilters(param1:DisplayObject) : Array
      {
         return filter(param1.filters,this.isNotSelectedFilter);
      }
      
      public function loadingGuiFor(param1:int) : void
      {
         this.gui.loadingFor(param1);
      }
      
      private function onInstatiateModal(param1:BannerModalEvent) : void
      {
         this.instatiateModal(param1.banner,param1.sceneAPI,param1.options,param1.data);
      }
      
      public function showCaptureSceneModal() : void
      {
         this.gui.addModal(new CaptureSceneModal(this));
      }
      
      private function openPetCatalog(param1:PetCatalogEvent) : void
      {
         if(this.gui.modal is CatalogModal)
         {
            return;
         }
         var _loc2_:CatalogModal = new CatalogModal(param1.catalog,net,tasks,this.gRoom,{"petType":param1.petType});
         this.gui.addModal(_loc2_);
      }
      
      private function removeContextualMenu(param1:Object) : void
      {
         var _loc2_:ContextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         _loc2_.removeMenu(param1.avatar);
      }
      
      protected function activateSceneObject(param1:DisplayObject) : void
      {
         var _loc2_:Array = this.getCleanFilters(param1);
         _loc2_.push(this.selectedFilter);
         param1.filters = _loc2_;
      }
      
      private function showInformationModal(param1:InformationModalEvent) : void
      {
         this.addInformationModal(param1.message,param1.imageName);
      }
   }
}
