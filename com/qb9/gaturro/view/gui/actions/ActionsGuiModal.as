package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsMC;
   import assets.action.duermeMC;
   import assets.actions.*;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ActionsGuiModal extends BaseGuiModal
   {
      
      private static const COLS:uint = 9;
      
      private static const MARGIN_X:uint = 3;
      
      private static const MARGIN_Y:uint = 3;
      
      public static const ACTIONS:Array = [{
         "n":"boca01",
         "a":loveBocaMC,
         "s":"acc1",
         "vip":"boca"
      },{
         "n":"amazed",
         "a":amazedMC,
         "s":"acc1"
      },{
         "n":"celebrate",
         "a":celebrateMC,
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
         "n":"idea",
         "a":ideaMC,
         "s":"acc5"
      },{
         "n":"joke",
         "a":jokeMC,
         "s":"acc6"
      },{
         "n":"jump",
         "a":jumpMC,
         "s":"acc7"
      },{
         "n":"laugh",
         "a":laughMC,
         "s":"acc8"
      },{
         "n":"love",
         "a":loveMC,
         "s":"acc9"
      },{
         "n":"sad",
         "a":sadMC,
         "s":"acc10"
      },{
         "n":"vertical",
         "a":verticalMC,
         "s":"acc11"
      },{
         "n":"sit",
         "a":sitMC,
         "s":"acc12"
      },{
         "n":"dance2",
         "a":dance2MC,
         "s":"acc13"
      },{
         "n":"dance3",
         "a":dance3MC,
         "s":"acc14"
      },{
         "n":"dance4",
         "a":dance4MC,
         "s":"acc15"
      },{
         "n":"dance5",
         "a":dance5MC,
         "s":"acc16"
      },{
         "n":"dormido2",
         "a":duermeMC,
         "s":"acc2"
      }];
       
      
      private var asset:ActionsMC;
      
      private var avatar:UserAvatar;
      
      public function ActionsGuiModal(param1:UserAvatar)
      {
         super();
         this.avatar = param1;
         this.init();
      }
      
      override protected function get closeSound() : String
      {
         return null;
      }
      
      private function createCells() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < ACTIONS.length)
         {
            this.asset.ph.addChild(this.createCell(_loc1_));
            _loc1_++;
         }
      }
      
      private function init() : void
      {
         this.asset = new ActionsMC();
         this.createCells();
         addChild(this.asset);
         addEventListener(MouseEvent.CLICK,this.handleClicks);
         GuiUtil.addOverlay(this);
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
      
      private function handleClicks(param1:Event) : void
      {
         var _loc2_:Cell = this.getCell(param1);
         if(_loc2_)
         {
            if(_loc2_.vip)
            {
               if(this.avatar.attributes.passportType !== _loc2_.vip)
               {
                  api.showBannerModal("pasaporteBoca");
                  return;
               }
            }
            audio.addLazyPlay(_loc2_.sound);
            tracker.event(TrackCategories.MMO,TrackActions.SET_ACTION,_loc2_.action);
            this.avatar.attributes.action = _loc2_.action;
            close();
         }
      }
      
      private function createCell(param1:uint) : Cell
      {
         var _loc3_:Cell = null;
         var _loc2_:Object = ACTIONS[param1];
         _loc3_ = new Cell(_loc2_);
         var _loc4_:uint = param1 % COLS;
         var _loc5_:uint = param1 / COLS;
         _loc3_.x = (_loc3_.width + MARGIN_X) * _loc4_;
         _loc3_.y = (_loc3_.height + MARGIN_Y) * _loc5_;
         return _loc3_;
      }
      
      override public function dispose() : void
      {
         this.avatar = null;
         this.asset = null;
         removeEventListener(MouseEvent.CLICK,this.handleClicks);
         super.dispose();
      }
   }
}

import assets.ActionsButtonMC;

final class Cell extends ActionsButtonMC
{
    
   
   private var data:Object;
   
   public function Cell(param1:Object)
   {
      super();
      this.data = param1;
      ph.addChild(new param1.a());
      buttonMode = true;
      stop();
   }
   
   public function get action() : String
   {
      return this.data.n;
   }
   
   public function get vip() : String
   {
      return this.data.vip;
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
   
   public function get sound() : String
   {
      return this.data.s;
   }
}
