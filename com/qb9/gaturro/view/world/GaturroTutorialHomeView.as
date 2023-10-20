package com.qb9.gaturro.view.world
{
   import assets.InterfazArrowsMC;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.quest.GaturroQuestView;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.actions.GuiActionsButton;
   import com.qb9.gaturro.view.gui.bag.TutorialGuiBag;
   import com.qb9.gaturro.view.gui.chat.GuiChat;
   import com.qb9.gaturro.view.gui.emoticons.GuiEmoticons;
   import com.qb9.gaturro.view.gui.map.GuiMap;
   import com.qb9.gaturro.view.gui.profile.GuiProfile;
   import com.qb9.gaturro.view.gui.whitelist.GuiWhiteListButton;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class GaturroTutorialHomeView extends GaturroHomeView
   {
       
      
      private var op:TutorialOperations;
      
      private var arrows:InterfazArrowsMC;
      
      private var tutorial:TutorialManager;
      
      public function GaturroTutorialHomeView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         this.arrows = new InterfazArrowsMC();
         super(param1,param2,param3,param4);
      }
      
      override protected function showModeratorModal() : void
      {
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
         disposables.push(new GuiActionsButton(gui,_loc1_),new GuiEmoticons(gui,_loc1_),new GuiProfile(gui,_loc1_,user.profile as GaturroProfile,_loc2_,tasks),new GuiWhiteListButton(gui,_loc3_,tasks),createHomeGuiButton(),createMapHomeButtons(),new TutorialGuiBag(gui,_loc3_,tasks),new GuiMap(gui,_loc3_));
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
      }
      
      private function clickOnArrows(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      override protected function whenAddedToStage() : void
      {
         super.whenAddedToStage();
         if(Boolean(this.gui.questlog) && Boolean(this.gui.questlog.parent))
         {
            this.gui.questlog.parent.removeChild(this.gui.questlog);
         }
         this.op = new TutorialOperations();
         this.op.setGui(this.gui);
         this.op.setSceneObjects(this.room.sceneObjects);
         this.op.setUiArrows(this.arrows);
         this.op.setTasks(this.tasks);
         this.tutorial = new TutorialManager();
         this.tutorial.initState(this.gRoom,this.op,this.gui);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.arrows.removeEventListener(MouseEvent.CLICK,this.clickOnArrows);
         this.arrows.removeEventListener(MouseEvent.MOUSE_DOWN,this.clickOnArrows);
         this.arrows.removeEventListener(MouseEvent.MOUSE_UP,this.clickOnArrows);
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
