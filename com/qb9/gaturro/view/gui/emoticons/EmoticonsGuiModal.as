package com.qb9.gaturro.view.gui.emoticons
{
   import assets.EmoticonsMC;
   import assets.emoticons.*;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public final class EmoticonsGuiModal extends BaseGuiModal
   {
      
      private static const MODAL_OFFSET:Point = new Point(-11,-2);
      
      private static const EMOTE_OFFSET:int = -53;
      
      private static const EMOTES:Array = [{
         "n":"normal",
         "a":normalMC,
         "s":"expr1"
      },{
         "n":"boca01",
         "a":loveBocaMC,
         "s":"expr1",
         "vip":"boca"
      },{
         "n":"angry",
         "a":angryMC,
         "s":"expr2"
      },{
         "n":"boring",
         "a":boringMC,
         "s":"expr3"
      },{
         "n":"good",
         "a":goodMC,
         "s":"expr4"
      },{
         "n":"smile",
         "a":LaughMC,
         "s":"expr5"
      },{
         "n":"love",
         "a":loveMC,
         "s":"expr6"
      },{
         "n":"money",
         "a":moneyMC,
         "s":"expr7"
      }];
      
      public static const DEFAULT_EMOTE:String = EMOTES[0].n;
      
      private static const MARGIN:uint = 3;
       
      
      private var current:String;
      
      private var asset:EmoticonsMC;
      
      private var avatar:UserAvatar;
      
      private var selected:Cell;
      
      public function EmoticonsGuiModal(param1:UserAvatar)
      {
         super();
         this.avatar = param1;
         this.init();
      }
      
      public static function makeIcon(param1:String) : DisplayObject
      {
         var _loc2_:Object = null;
         param1 ||= DEFAULT_EMOTE;
         for each(_loc2_ in EMOTES)
         {
            if(_loc2_.n === param1)
            {
               return new _loc2_.a();
            }
         }
         return new EMOTES[0].a();
      }
      
      private function get container() : MovieClip
      {
         return this.asset.container;
      }
      
      private function get defaultCell() : Cell
      {
         return this.container.getChildByName(DEFAULT_EMOTE) as Cell;
      }
      
      private function add(param1:Object) : void
      {
         var _loc2_:Cell = null;
         _loc2_ = new Cell(param1);
         _loc2_.y = EmoticonsGuiModal.EMOTE_OFFSET + (_loc2_.height + MARGIN) * (this.container.numChildren - 1);
         if(_loc2_.emote === this.current)
         {
            this.selected = _loc2_;
            _loc2_.select();
         }
         this.container.addChild(_loc2_);
      }
      
      private function init() : void
      {
         var _loc1_:Object = null;
         this.asset = new EmoticonsMC();
         this.current = String(this.avatar.attributes.emote) || DEFAULT_EMOTE;
         for each(_loc1_ in EMOTES)
         {
            this.add(_loc1_);
         }
         addChild(this.asset);
         this.asset.x = EmoticonsGuiModal.MODAL_OFFSET.x;
         this.asset.y = EmoticonsGuiModal.MODAL_OFFSET.y;
         addEventListener(MouseEvent.CLICK,this.handleClicks);
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
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.vip)
         {
            if(this.avatar.attributes.passportType !== _loc2_.vip)
            {
               api.showBannerModal("pasaporteBoca");
               return;
            }
         }
         if(_loc2_.emote === this.current)
         {
            _loc2_ = this.defaultCell;
         }
         if(this.selected)
         {
            this.selected.unselect();
         }
         this.selected = _loc2_;
         this.current = _loc2_.emote;
         _loc2_.select();
         audio.addLazyPlay(_loc2_.sound);
         this.avatar.attributes.emote = _loc2_.emote;
         tracker.event(TrackCategories.MMO,TrackActions.CHANGE_MOOD,_loc2_.emote);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleClicks);
         this.avatar = null;
         this.asset = null;
         this.selected = null;
         super.dispose();
      }
   }
}

import assets.EmoticonButtonMC;

final class Cell extends EmoticonButtonMC
{
    
   
   private var _emote:String;
   
   private var data:Object;
   
   public function Cell(param1:Object)
   {
      super();
      this.data = param1;
      name = this.emote;
      ph.addChild(new param1.a());
      buttonMode = true;
   }
   
   public function unselect() : void
   {
      gotoAndStop(1);
   }
   
   public function get emote() : String
   {
      return this.data.n;
   }
   
   public function get selected() : Boolean
   {
      return currentFrame === 2;
   }
   
   public function select() : void
   {
      gotoAndStop(2);
   }
   
   public function get vip() : String
   {
      return this.data.vip;
   }
   
   public function get sound() : String
   {
      return this.data.s;
   }
}
