package com.qb9.gaturro.view.gui
{
   import assets.InterfazMC_testing;
   import assets.action.duermeMC;
   import assets.actions.amazedMC;
   import assets.actions.blankMC;
   import assets.actions.celebrateMC;
   import assets.actions.dance2MC;
   import assets.actions.dance3MC;
   import assets.actions.dance4MC;
   import assets.actions.dance5MC;
   import assets.actions.danceMC;
   import assets.actions.greetMC;
   import assets.actions.ideaMC;
   import assets.actions.jokeMC;
   import assets.actions.jumpMC;
   import assets.actions.laughMC;
   import assets.actions.loveMC;
   import assets.actions.sadMC;
   import assets.actions.shyMC;
   import assets.actions.sitMC;
   import assets.actions.verticalMC;
   import assets.actions.winkMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.components.banner.emoting.ActionConfigCanvas;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.questlog.QuestLog;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mines.mobject.MobjectCreator;
   import config.AttributeControl;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class Gui extends InterfazMC_testing implements IDisposable
   {
      
      private static const COLS:uint = 9;
      
      private static const MARGIN_X:uint = 6;
      
      private static const MARGIN_Y:uint = 2;
      
      public static var ACTIONS:Array = [{
         "n":"amazed",
         "a":amazedMC,
         "s":"acc1"
      },{
         "n":"dance2",
         "a":dance2MC,
         "s":"acc2"
      },{
         "n":"dance3",
         "a":dance3MC,
         "s":"acc2"
      },{
         "n":"dance4",
         "a":dance4MC,
         "s":"acc2"
      },{
         "n":"dance5",
         "a":dance5MC,
         "s":"acc2"
      },{
         "n":"idea",
         "a":ideaMC,
         "s":"acc2"
      },{
         "n":"joke",
         "a":jokeMC,
         "s":"acc2"
      },{
         "n":"jump",
         "a":jumpMC,
         "s":"acc2"
      },{
         "n":"laugh",
         "a":laughMC,
         "s":"acc2"
      },{
         "n":"celebrate",
         "a":celebrateMC,
         "s":"acc2"
      },{
         "n":"sit",
         "a":sitMC,
         "s":"acc2"
      },{
         "n":"vertical",
         "a":verticalMC,
         "s":"acc2"
      },{
         "n":"sad",
         "a":sadMC,
         "s":"acc2"
      },{
         "n":"dance",
         "a":danceMC,
         "s":"acc3"
      },{
         "n":"greet",
         "a":greetMC,
         "s":"acc4"
      },{
         "n":"love",
         "a":loveMC,
         "s":"acc9"
      },{
         "n":"wink",
         "a":winkMC,
         "s":"acc6"
      },{
         "n":"shy",
         "a":shyMC,
         "s":"acc8"
      },{
         "n":"blank",
         "a":blankMC,
         "s":"acc10"
      },{
         "n":"dormido2",
         "a":duermeMC,
         "s":"acc5"
      }];
       
      
      private var _modal:BaseGuiModal;
      
      private var _guiInteractionView:com.qb9.gaturro.view.gui.GuiInteractionView;
      
      private var intervalId:uint;
      
      private var ACTIONS_NOVIP:Array;
      
      private var _timer:Timer;
      
      private var _actionBarData:Array;
      
      private var canPress:Boolean = true;
      
      private var _questLog:QuestLog;
      
      public function Gui()
      {
         this._actionBarData = [];
         this.ACTIONS_NOVIP = [{
            "n":"acciones.action_amazed",
            "a":amazedMC,
            "s":"acc1"
         },{
            "n":"acciones.action_celebrate",
            "a":celebrateMC,
            "s":"acc2"
         },{
            "n":"acciones.action_dance",
            "a":danceMC,
            "s":"acc3"
         },{
            "n":"acciones.action_greet",
            "a":greetMC,
            "s":"acc4"
         },{
            "n":"acciones.action_love",
            "a":loveMC,
            "s":"acc9"
         },{
            "n":"acciones.action_wink",
            "a":winkMC,
            "s":"acc6"
         },{
            "n":"acciones.action_shy",
            "a":shyMC,
            "s":"acc8"
         },{
            "n":"acciones.action_blank",
            "a":blankMC,
            "s":"acc10"
         },{
            "n":"acciones.action_dormido2",
            "a":duermeMC,
            "s":"acc5"
         }];
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function select(param1:Event) : void
      {
         version.setSelection(0,version.length);
      }
      
      public function setQuestLog(param1:QuestLog) : void
      {
         this._questLog = param1;
         questlog_ph.addChild(this._questLog);
      }
      
      private function onSettingsClick(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("ActionConfiguration");
         api.trackEvent("Experiments:GUI_ACTIONS:CONFIGURATION:VIP"," ");
      }
      
      private function onActionsClick(param1:MouseEvent) : void
      {
         if(actionDisplayer.currentLabel == "closed")
         {
            actionDisplayer.gotoAndPlay("opens");
            api.trackEvent("Experiments:GUI_ACTIONS:OPENS","true");
            this._guiInteractionView.close();
         }
         else
         {
            actionDisplayer.gotoAndPlay("closes");
         }
      }
      
      public function hideEmoticons() : void
      {
         if(Boolean(this.modal) && !this.modal.isDisposed)
         {
            this.modal.close();
         }
      }
      
      private function startCoolDown() : void
      {
         this.canPress = false;
         this._timer = new Timer(0,70);
         actionDisplayer.mcTimer.gotoAndStop(0);
         actionDisplayer.mcTimer.visible = true;
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleted);
         this._timer.reset();
         this._timer.start();
      }
      
      private function setupActionsButton() : void
      {
         actionDisplayer.openButton.addEventListener(MouseEvent.CLICK,this.onActionsClick);
         this.createButtons();
      }
      
      private function interpreteAndExecuteBarAction(param1:Object) : void
      {
         var _loc2_:InventorySceneObject = null;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(block.visible)
         {
            return;
         }
         if(param1.id)
         {
            _loc2_ = user.bag.byId(param1.id) || user.visualizer.byId(param1.id);
            _loc3_ = (_loc2_ as Object).providedAttributes;
            _loc4_ = false;
            if("action" in _loc3_ && AttributeControl.isProhibitedInAction(_loc3_.action))
            {
               return;
            }
            for(_loc5_ in _loc3_)
            {
               if((_loc6_ = String(api.userAvatar.attributes[_loc5_])) == _loc3_[_loc5_])
               {
                  api.userAvatar.attributes[_loc5_] = " ";
                  _loc4_ = true;
               }
            }
            if(!_loc4_)
            {
               api.userAvatar.attributes.mergeObject(_loc3_,true);
            }
            api.trackEvent("Experiments:GUI_ACTIONS:USA_ITEM",param1.a);
         }
         else if(param1.a)
         {
            _loc7_ = (param1.a as String).replace("acciones.action_","");
            this.executeAction(_loc7_);
         }
      }
      
      public function blockFor(param1:int) : void
      {
         var ms:int = param1;
         block.visible = true;
         this.intervalId = 0;
         clearTimeout(this.intervalId);
         this.intervalId = setTimeout(function():void
         {
            block.visible = false;
         },ms);
      }
      
      private function setupPrize() : void
      {
         this.prizeEvent.visible = false;
      }
      
      public function get chatDisabled() : Boolean
      {
         return !user.isBlackList || Boolean(api.silcenceRoom);
      }
      
      private function init(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         if(this.chatDisabled)
         {
            chat.gotoAndStop(2);
         }
         else
         {
            chat.gotoAndStop(1);
         }
         this.initDebug();
         block.visible = false;
         this.setupPrize();
         this.setupHUBFirstTimeUser();
         this.setupActionsButton();
         this.setupGuiInteractionView();
         this.setupHouseKickButton();
         this.setupChatColor();
      }
      
      private function executeAction(param1:String) : void
      {
         api.trackEvent("Experiments:GUI_ACTIONS:ACTION",param1);
         api.userAvatar.attributes.action = param1;
      }
      
      private function setupHouseKickButton() : void
      {
         kickHouseBtn.buttonMode = true;
         kickHouseBtn.addEventListener(MouseEvent.CLICK,this.openKickBanner);
         if(api.room.ownerName == user.username)
         {
            kickHouseBtn.gotoAndStop(0);
         }
         else
         {
            kickHouseBtn.gotoAndStop(1);
         }
         if(api.room.ownerName == user.username)
         {
            kickHouseBtn.gotoAndStop(1);
         }
         else
         {
            kickHouseBtn.gotoAndStop(2);
         }
      }
      
      public function showPrize() : void
      {
         this.prizeEvent.gotoAndStop(0);
         this.prizeEvent.visible = true;
         this.prizeEvent.gotoAndPlay(1);
      }
      
      private function timerCompleted(param1:TimerEvent) : void
      {
         this.canPress = true;
         actionDisplayer.mcTimer.visible = false;
         this._timer.stop();
         this._timer.reset();
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleted);
      }
      
      public function dispose() : void
      {
         if(this.modal)
         {
            this.disposeModal(this.modal);
         }
         if(this._guiInteractionView)
         {
            this._guiInteractionView.dispose();
         }
         btnColorSelect2.removeEventListener(MouseEvent.CLICK,this.onBtnColorSelectClick2);
         this.disposeClick();
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
         }
         version.removeEventListener(MouseEvent.CLICK,this.select);
         if(this._questLog)
         {
            if(this._questLog.parent)
            {
               this._questLog.parent.removeChild(this._questLog);
            }
            this._questLog.destroy();
         }
         this._questLog = null;
      }
      
      public function get questlog() : QuestLog
      {
         return this._questLog;
      }
      
      private function onKeyPress(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.charCode)
         {
            case 49:
               _loc2_ = this._actionBarData[0];
               break;
            case 50:
               _loc2_ = this._actionBarData[1];
               break;
            case 51:
               _loc2_ = this._actionBarData[2];
               break;
            case 52:
               _loc2_ = this._actionBarData[3];
               break;
            case 53:
               _loc2_ = this._actionBarData[4];
               break;
            case 54:
               _loc2_ = this._actionBarData[5];
               break;
            case 55:
               _loc2_ = this._actionBarData[6];
               break;
            case 56:
               _loc2_ = this._actionBarData[7];
               break;
            case 57:
               _loc2_ = this._actionBarData[8];
         }
         if(_loc2_ != null)
         {
            if(!this.canPress)
            {
               return;
            }
            this.interpreteAndExecuteBarAction(_loc2_);
            this.startCoolDown();
         }
      }
      
      public function addModal(param1:BaseGuiModal) : void
      {
         if(this._modal)
         {
            this._modal.close();
         }
         this._modal = param1;
         param1.addEventListener(Event.CLOSE,this.disposeModalFromEvent);
         addChild(param1);
         setTimeout(this.setupClick,10);
      }
      
      private function checkClickOutside(param1:Event) : void
      {
         if(!this.modal)
         {
            return this.disposeClick();
         }
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(Boolean(_loc2_.parent) && !contains(_loc2_))
         {
            this.modal.close();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = (param1.target.repeatCount - param1.target.currentCount) * (actionDisplayer.mcTimer as MovieClip).totalFrames / param1.target.repeatCount;
         actionDisplayer.mcTimer.gotoAndStop(_loc2_);
      }
      
      private function onCellClick(param1:MouseEvent) : void
      {
         if(!this.canPress)
         {
            return;
         }
         this.interpreteAndExecuteBarAction(param1.target.data);
         var _loc2_:Cell = this.getCell(param1);
         if(_loc2_)
         {
            this.startCoolDown();
         }
      }
      
      private function disposeClick() : void
      {
         if(parent)
         {
            parent.removeEventListener(MouseEvent.MOUSE_UP,this.checkClickOutside);
         }
      }
      
      private function initDebug() : void
      {
         var _loc1_:Array = ["M=" + server.version,"E=" + server.extensionVersion,"C=" + GameData.VERSION];
         version.text = _loc1_.join("; ");
         version.addEventListener(MouseEvent.CLICK,this.select);
         setTimeout(this.fixSelectable,10);
      }
      
      public function get guiInteractionView() : com.qb9.gaturro.view.gui.GuiInteractionView
      {
         return this._guiInteractionView;
      }
      
      public function get modal() : BaseGuiModal
      {
         return this._modal;
      }
      
      private function setupHUBFirstTimeUser() : void
      {
         if(Boolean(api.getProfileAttribute("hubUser")) && !api.getProfileAttribute("usuarioNuevo_final"))
         {
            map.gotoAndStop(2);
            cel.visible = false;
            fannysBtn.visible = false;
            albumBtn.visible = false;
            interactionDisplayer.visible = false;
            achievements.visible = false;
            map.addEventListener(MouseEvent.CLICK,this.onHubButton);
            tutorialBtn.addEventListener(MouseEvent.CLICK,this.onTutorial);
            tutorialBtn.buttonMode = true;
         }
         else
         {
            map.gotoAndStop(1);
            tutorialBtn.visible = false;
         }
      }
      
      public function get hasModal() : Boolean
      {
         return this.modal !== null;
      }
      
      private function setupClick() : void
      {
         if(parent)
         {
            parent.addEventListener(MouseEvent.MOUSE_UP,this.checkClickOutside);
         }
      }
      
      private function fixSelectable() : void
      {
         version.selectable = true;
         version.mouseEnabled = true;
      }
      
      private function onBtnColorSelectClick2(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("ColorPickerModal2");
      }
      
      private function disposeModal(param1:BaseGuiModal) : void
      {
         if(!param1.isDisposed)
         {
            param1.dispose();
         }
         param1.removeEventListener(Event.CLOSE,this.disposeModalFromEvent);
         DisplayUtil.remove(param1);
         if(api)
         {
            api.unfreeze();
         }
         if(param1 === this._modal)
         {
            this.disposeClick();
            this._modal = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function getCell(param1:Event) : Cell
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ is Cell === false)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ as Cell;
      }
      
      private function onTutorial(param1:MouseEvent) : void
      {
         TutorialManager.start();
      }
      
      private function disposeModalFromEvent(param1:Event = null) : void
      {
         setTimeout(this.disposeModal,10,param1.target);
      }
      
      private function createButtons() : void
      {
         var _loc2_:Cell = null;
         actionDisplayer.mcTimer.visible = false;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
         actionDisplayer.actionPanel.config.addEventListener(MouseEvent.CLICK,this.onSettingsClick);
         actionDisplayer.actionPanel.config.buttonMode = true;
         this._actionBarData = new Array();
         var _loc1_:uint = 0;
         while(_loc1_ < ActionConfigCanvas.SLOTS_MAX)
         {
            _loc2_ = this.createCell(_loc1_);
            actionDisplayer.actionPanel.ph.addChild(_loc2_);
            _loc2_.num.text = (_loc1_ + 1 as uint).toString();
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onCellClick);
            _loc1_++;
         }
      }
      
      private function onHubButton(param1:MouseEvent) : void
      {
         api.changeRoomXY(51690158,6,7);
      }
      
      public function loadingFor(param1:int) : void
      {
         var ms:int = param1;
         loading.visible = true;
         this.intervalId = 0;
         clearTimeout(this.intervalId);
         this.intervalId = setTimeout(function():void
         {
            loading.visible = false;
         },ms);
      }
      
      private function setupChatColor() : void
      {
         btnColorSelect2.addEventListener(MouseEvent.CLICK,this.onBtnColorSelectClick2);
      }
      
      private function setupGuiInteractionView() : void
      {
         this._guiInteractionView = new com.qb9.gaturro.view.gui.GuiInteractionView(this);
         this._guiInteractionView.init();
      }
      
      private function createCell2(param1:uint) : Cell
      {
         var _loc2_:Object = ACTIONS[param1];
         var _loc3_:Cell = new Cell(_loc2_);
         var _loc4_:uint = param1 % COLS;
         var _loc5_:uint = param1 / COLS;
         _loc3_.x = (_loc3_.width + MARGIN_X) * _loc4_;
         _loc3_.y = (_loc3_.height + MARGIN_Y) * _loc5_;
         return _loc3_;
      }
      
      private function openKickBanner(param1:MouseEvent) : void
      {
         if(Boolean(api.isCitizen) && api.room.ownerName == user.username)
         {
            api.instantiateBannerModal("HouseKickModal");
            api.trackEvent("FEATURES:HOUSE:KICKBANNER:OPEN"," ");
         }
         else if(api.isCitizen)
         {
            api.showBannerModal("casitaMagica");
            api.trackEvent("FEATURES:HOUSE:VISIT"," ");
         }
         else
         {
            api.trackEvent("FEATURES:HOUSE:KICKBANNER:CANT_OPEN"," ");
            api.showBannerModal("pasaporte2");
         }
      }
      
      private function createCell(param1:uint) : Cell
      {
         var _loc3_:GaturroInventorySceneObject = null;
         var _loc10_:InventorySceneObject = null;
         var _loc2_:Object = api.getProfileAttribute("ActionBarCFG_SLOT_" + param1.toString());
         var _loc4_:CustomAttributes = new CustomAttributes();
         var _loc5_:MobjectCreator = new MobjectCreator();
         var _loc6_:Object = {};
         if(Boolean(_loc2_) && (_loc2_ as String).indexOf("acciones") != -1)
         {
            _loc6_.a = _loc2_;
         }
         else if(_loc2_)
         {
            _loc3_ = (_loc10_ = user.bag.byId(Number(_loc2_)) || user.visualizer.byId(Number(_loc2_))) as GaturroInventorySceneObject;
            if(_loc3_)
            {
               _loc6_.a = _loc3_.name;
               _loc6_.id = Number(_loc2_);
               _loc6_.currentAttrObj;
            }
         }
         var _loc7_:Cell = new Cell(_loc6_);
         this._actionBarData.push(_loc6_);
         var _loc8_:uint = param1 % COLS;
         var _loc9_:uint = param1 / COLS;
         _loc7_.x = (_loc7_.width + MARGIN_X) * _loc8_;
         _loc7_.y = (_loc7_.height + MARGIN_Y) * _loc9_;
         return _loc7_;
      }
   }
}

import assets.ActionsButtonMC2;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.gui.Gui;
import com.qb9.gaturro.view.gui.util.GuiUtil;
import flash.display.MovieClip;

final class Cell extends ActionsButtonMC2
{
    
   
   public var data:Object;
   
   public function Cell(param1:Object)
   {
      var _loc2_:String = null;
      var _loc3_:int = 0;
      super();
      this.data = param1;
      if(param1 && param1.a && (param1.a as String).indexOf("acciones") != -1)
      {
         _loc2_ = (param1.a as String).replace("acciones.action_","");
         _loc3_ = 0;
         while(_loc3_ < Gui.ACTIONS.length)
         {
            if(Gui.ACTIONS[_loc3_].n == _loc2_)
            {
               ph.addChild(new Gui.ACTIONS[_loc3_].a());
            }
            _loc3_++;
         }
      }
      else if(Boolean(param1) && Boolean(param1.a))
      {
         api.libraries.fetch(param1.a,this.onLoadedAddChild);
      }
      buttonMode = true;
      stop();
   }
   
   public function get action() : String
   {
      return this.data.n;
   }
   
   public function get sound() : String
   {
      return this.data.s;
   }
   
   public function get vip() : String
   {
      return this.data.vip;
   }
   
   private function onLoadedAddChild(param1:MovieClip) : void
   {
      GuiUtil.fit(param1,40,40);
      icon.addChild(param1);
   }
   
   public function setGlow(param1:Boolean) : void
   {
      if(param1)
      {
         this.gotoAndStop("glow");
      }
      else
      {
         this.gotoAndStop("on");
      }
   }
}
