package com.qb9.gaturro.view.gui.moderatorTip
{
   import assets.ModeratorTipMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public final class ModeratorTipModal extends BaseGuiModal
   {
      
      private static var KEY_PREFIX:String = "moderator_tip_";
      
      public static const BADWORDS:String = "moderator_badwords_";
      
      public static const TIPS:String = "moderator_tip_";
       
      
      private var asset:ModeratorTipMC;
      
      private var numMessages:Dictionary;
      
      private var messages:Array;
      
      public function ModeratorTipModal(param1:String = "moderator_tip_")
      {
         this.messages = [];
         this.numMessages = new Dictionary();
         KEY_PREFIX = param1;
         this.loadNumMessages();
         super();
         this.init();
      }
      
      private function get profile() : GaturroProfile
      {
         return user.profile as GaturroProfile;
      }
      
      private function get next() : InteractiveObject
      {
         return this.asset.arrows.next;
      }
      
      private function nextTip(param1:Event) : void
      {
         this.moveBy(1);
      }
      
      private function initEvents() : void
      {
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         this.prev.addEventListener(MouseEvent.CLICK,this.previousTip);
         this.next.addEventListener(MouseEvent.CLICK,this.nextTip);
      }
      
      private function showMessage() : void
      {
         var _loc1_:int = this.profile.lastTipRead;
         this.asset.field.text = this.messages[_loc1_].toUpperCase();
      }
      
      private function previousTip(param1:Event) : void
      {
         this.moveBy(-1);
      }
      
      private function loadNumMessages() : void
      {
         this.numMessages[TIPS] = 8;
         this.numMessages[BADWORDS] = 2;
      }
      
      private function moveBy(param1:int) : void
      {
         var _loc2_:int = this.profile.lastTipRead + param1;
         if(_loc2_ < 0)
         {
            _loc2_ += this.max;
         }
         else
         {
            _loc2_ %= this.max;
         }
         this.profile.lastTipRead = _loc2_;
         this.showMessage();
      }
      
      private function collectMessages() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         _loc1_ = 1;
         while(_loc1_ <= this.numMessages[KEY_PREFIX])
         {
            _loc2_ = KEY_PREFIX + _loc1_;
            _loc3_ = String(region.key(_loc2_));
            this.messages.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function init() : void
      {
         this.collectMessages();
         this.asset = new ModeratorTipMC();
         region.setText(this.asset.close.text,"CERRAR");
         addChild(this.asset);
         this.initEvents();
         this.moveBy(1);
      }
      
      private function get prev() : InteractiveObject
      {
         return this.asset.arrows.prev;
      }
      
      private function get max() : int
      {
         return this.messages.length;
      }
      
      override public function dispose() : void
      {
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this.prev.removeEventListener(MouseEvent.CLICK,this.previousTip);
         this.next.removeEventListener(MouseEvent.CLICK,this.nextTip);
         this.asset = null;
         super.dispose();
      }
   }
}
