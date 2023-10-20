package com.qb9.gaturro.view.world
{
   import assets.InterfazArrowsMC;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.quest.GaturroQuestView;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.tutorial.gui.BannerTutorialGuiModal;
   import com.qb9.gaturro.tutorial.gui.CatalogTutorialModal;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.achievements.GuiAchievementButton;
   import com.qb9.gaturro.view.gui.actions.GuiActionsButton;
   import com.qb9.gaturro.view.gui.bag.TutorialGuiBag;
   import com.qb9.gaturro.view.gui.banner.BannerModalEvent;
   import com.qb9.gaturro.view.gui.catalog.CatalogModal;
   import com.qb9.gaturro.view.gui.chat.GuiChat;
   import com.qb9.gaturro.view.gui.emoticons.GuiEmoticons;
   import com.qb9.gaturro.view.gui.map.GuiMap;
   import com.qb9.gaturro.view.gui.profile.GuiProfile;
   import com.qb9.gaturro.view.gui.whitelist.GuiWhiteListButton;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.catalog.CatalogEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class GaturroTutorialRoomView extends GaturroRoomView
   {
       
      
      private var op:TutorialOperations;
      
      private var arrows:InterfazArrowsMC;
      
      private var tutorial:TutorialManager;
      
      public function GaturroTutorialRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         this.arrows = new InterfazArrowsMC();
         super(param1,param2,param3,param4);
      }
      
      override protected function showBannerModal(param1:BannerModalEvent) : void
      {
         gui.addModal(new BannerTutorialGuiModal(param1.banner,param1.sceneAPI,api));
      }
      
      override protected function showModeratorModal() : void
      {
      }
      
      private function clickOnProfile(param1:MouseEvent) : void
      {
         api.showBannerModal("tutorialProfile");
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            if(_loc2_.username != room.userAvatar.username)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      override protected function initGui() : void
      {
         var _loc5_:GaturroQuestView = null;
         gui.addEventListener(Event.COMPLETE,tryToDequeueReport);
         addChild(gui);
         gui.actionDisplayer.visible = false;
         gui.kickHouseBtn.visible = false;
         gui.tutorialBtn.visible = false;
         var _loc1_:UserAvatar = room.userAvatar;
         var _loc2_:Gaturro = userView.clip;
         var _loc3_:GaturroRoom = gRoom;
         logger.debug("UI creation start");
         var _loc4_:int = getTimer();
         disposables.push(new GuiActionsButton(gui,_loc1_),new GuiEmoticons(gui,_loc1_),new GuiProfile(gui,_loc1_,user.profile as GaturroProfile,_loc2_,tasks),new GuiWhiteListButton(gui,_loc3_,tasks),new GuiAchievementButton(gui,_loc3_,tasks),createHomeGuiButton(),createMapHomeButtons(),new TutorialGuiBag(gui,_loc3_,tasks),new GuiMap(gui,_loc3_));
         if(!gui.chatDisabled)
         {
            disposables.push(new GuiChat(gui,chat));
         }
         logger.debug("UI creation ends. takes:" + (getTimer() - _loc4_) / 1000 + " seconds");
         initAlertManager();
         if(Context.instance.hasByType(GaturroQuestView))
         {
            (_loc5_ = Context.instance.getByType(GaturroQuestView) as GaturroQuestView).setup();
         }
         this.addChild(this.arrows);
         this.arrows.mouseEnabled = true;
         this.arrows.mouseChildren = true;
         this.arrows.addEventListener(MouseEvent.CLICK,this.clickOnArrows);
         this.arrows.addEventListener(MouseEvent.MOUSE_DOWN,this.clickOnArrows);
         this.arrows.addEventListener(MouseEvent.MOUSE_UP,this.clickOnArrows);
         if(!api.getProfileAttribute("hubUser"))
         {
            api.setProfileAttribute("hubUser",true);
         }
      }
      
      override protected function openCatalog(param1:CatalogEvent) : void
      {
         if(gui.modal is CatalogTutorialModal)
         {
            return;
         }
         var _loc2_:CatalogModal = new CatalogTutorialModal(param1.catalog,net,tasks,gRoom,this.op);
         gui.addModal(_loc2_);
      }
      
      private function clickOnArrows(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      override protected function whenAddedToStage() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         super.whenAddedToStage();
         for each(_loc1_ in this.room.sceneObjects)
         {
            if(_loc1_ is Avatar && !(_loc1_ is GaturroUserAvatar))
            {
               _loc2_ = Avatar(_loc1_).id;
               this.gRoom.removeSceneObjectById(_loc2_);
            }
         }
         if(Boolean(this.gui.questlog) && Boolean(this.gui.questlog.parent))
         {
            this.gui.questlog.parent.removeChild(this.gui.questlog);
         }
         this.arrows.profileArrow.btn.addEventListener(MouseEvent.MOUSE_UP,this.clickOnProfile);
         this.arrows.profileArrow.btn.buttonMode = true;
         this.op = new TutorialOperations();
         this.op.setGui(this.gui);
         this.op.setSceneObjects(this.room.sceneObjects);
         this.op.setModelViews(this.sceneObjects);
         this.op.setUiArrows(this.arrows);
         this.op.setTasks(this.tasks);
         this.op.portalStatus(false);
         this.gRoom.initTutorialRoom();
         this.tutorial = new TutorialManager();
         this.tutorial.initState(this.gRoom,this.op,this.gui);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.arrows.removeEventListener(MouseEvent.CLICK,this.clickOnArrows);
         this.arrows.removeEventListener(MouseEvent.MOUSE_DOWN,this.clickOnArrows);
         this.arrows.removeEventListener(MouseEvent.MOUSE_UP,this.clickOnArrows);
         this.arrows.profileArrow.btn.removeEventListener(MouseEvent.MOUSE_UP,this.clickOnProfile);
         if(this.arrows.parent)
         {
            this.arrows.parent.removeChild(this.arrows);
         }
         this.op.dispose();
         this.op = null;
         this.tutorial.dispose();
         this.tutorial = null;
         if(this.arrows.parent)
         {
            this.arrows.parent.removeChild(this.arrows);
         }
         this.arrows = null;
      }
   }
}
