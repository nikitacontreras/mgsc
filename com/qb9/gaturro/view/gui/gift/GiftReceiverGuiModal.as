package com.qb9.gaturro.view.gui.gift
{
   import assets.GiftScreenMC;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.world.community.CommunityManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class GiftReceiverGuiModal extends BaseGuiModal
   {
       
      
      private var indexFirstBuddy:int = 0;
      
      private const BUDDIES_PER_PAGE:int = 24;
      
      private var asset:GiftScreenMC;
      
      public function GiftReceiverGuiModal()
      {
         super();
         this.init();
      }
      
      private function clickOnList(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         var _loc3_:Object = _loc2_.buddyObj;
         this.choose(_loc3_.username);
      }
      
      private function choose(param1:String) : void
      {
         dispatchEvent(new GiftGuiModalEvent(GiftGuiModalEvent.OPEN,param1));
      }
      
      private function downList(param1:MouseEvent) : void
      {
         var _loc2_:int = this.indexFirstBuddy;
         this.indexFirstBuddy += this.BUDDIES_PER_PAGE;
         if(this.indexFirstBuddy >= user.community.buddies.length)
         {
            this.indexFirstBuddy = _loc2_;
         }
         this.loadBuddiesList();
      }
      
      private function getSlotMC(param1:int) : MovieClip
      {
         return MovieClip(this.asset.friendList.getChildByName("f" + param1.toString()));
      }
      
      override public function dispose() : void
      {
         var _loc2_:MovieClip = null;
         if(disposed)
         {
            return;
         }
         user.community.removeEventListener(CommunityManager.BUDDIES_LOADED,this.loadBuddiesList);
         this.asset.friendList.arrows.up.removeEventListener(MouseEvent.CLICK,this.upList);
         this.asset.friendList.arrows.down.removeEventListener(MouseEvent.CLICK,this.downList);
         var _loc1_:int = 1;
         while(_loc1_ <= this.BUDDIES_PER_PAGE)
         {
            _loc2_ = this.getSlotMC(_loc1_);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.clickOnList);
            _loc1_++;
         }
         this.asset.send.removeEventListener(MouseEvent.CLICK,this.chooseFromField);
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this.asset = null;
         super.dispose();
      }
      
      private function loadFriends() : void
      {
         this.asset.friendList.visible = false;
         this.asset.errorText.visible = false;
         this.asset.friendList.arrows.visible = true;
         this.asset.friendList.arrows.up.addEventListener(MouseEvent.CLICK,this.upList);
         this.asset.friendList.arrows.down.addEventListener(MouseEvent.CLICK,this.downList);
         user.community.addEventListener(CommunityManager.BUDDIES_LOADED,this.loadBuddiesList);
         user.community.getBuddiesList();
      }
      
      private function chooseFromField(param1:Event) : void
      {
         if(this.fieldValue)
         {
            this.choose(this.fieldValue);
         }
      }
      
      private function upList(param1:MouseEvent) : void
      {
         this.indexFirstBuddy -= this.BUDDIES_PER_PAGE;
         if(this.indexFirstBuddy < 0)
         {
            this.indexFirstBuddy = 0;
         }
         this.loadBuddiesList();
      }
      
      private function loadBuddiesList(param1:Object = null) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Object = null;
         this.asset.loadingFriends.visible = false;
         if(user.community.buddies.length == 0)
         {
            this.asset.errorText.visible = true;
            return;
         }
         var _loc2_:int = 1;
         var _loc3_:int = this.indexFirstBuddy;
         while(_loc3_ <= this.indexFirstBuddy + this.BUDDIES_PER_PAGE)
         {
            if(_loc4_ = this.getSlotMC(_loc2_))
            {
               if(_loc5_ = user.community.buddies[_loc3_])
               {
                  this.asset.friendList.visible = true;
                  _loc4_.visible = true;
                  _loc4_.buddyObj = _loc5_;
                  _loc4_.username.text = _loc5_.username;
                  _loc4_.buttonMode = true;
                  if(_loc5_.online)
                  {
                     _loc4_.gotoAndStop(2);
                  }
                  else
                  {
                     _loc4_.gotoAndStop(1);
                  }
                  _loc4_.addEventListener(MouseEvent.CLICK,this.clickOnList);
               }
               else
               {
                  _loc4_.visible = false;
                  _loc4_.buddyObj = null;
                  _loc4_.removeEventListener(MouseEvent.CLICK,this.clickOnList);
               }
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      private function get fieldValue() : String
      {
         return this.asset.inputField.text;
      }
      
      private function init() : void
      {
         this.asset = new GiftScreenMC();
         addChild(this.asset);
         if(api.getSession("giftChristmas") == "y")
         {
            this.asset.icon.gotoAndStop("christmas");
         }
         else
         {
            this.asset.icon.gotoAndStop("normal");
         }
         this.loadFriends();
         region.setText(this.asset.send.text,"REGALAR");
         this.asset.send.addEventListener(MouseEvent.CLICK,this.chooseFromField);
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
      }
   }
}
