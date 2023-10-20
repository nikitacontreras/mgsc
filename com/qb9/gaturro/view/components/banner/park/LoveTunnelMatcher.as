package com.qb9.gaturro.view.components.banner.park
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class LoveTunnelMatcher extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var confirmButton:MovieClip;
      
      private var page:int = 1;
      
      private var count:int = 0;
      
      private const MAX_PER_PAGE:int = 8;
      
      private var leftArrow:MovieClip;
      
      private var pages:int = 1;
      
      private var timer:Timer;
      
      private const COLUMNS:int = 2;
      
      private var rightArrow:MovieClip;
      
      private var selectedAvatar:Avatar;
      
      private var avatarButtonContainer:MovieClip;
      
      private const ROWS:int = 4;
      
      private var avatarButtons:Array;
      
      private var _asset:MovieClip;
      
      private var avatarDataArray:Array;
      
      public function LoveTunnelMatcher()
      {
         super("loveTunnelMatcher","LoveTunnelMatcherAsset");
      }
      
      private function onMiss(param1:Event) : void
      {
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onMiss);
         this._asset.missInfo.avatarName.text = this.selectedAvatar.username;
         this._asset.confirm.addEventListener(MouseEvent.CLICK,this.onConfirmTutorial);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function setupAvatarData() : void
      {
         var _loc2_:AvatarData = null;
         this.avatarDataArray = [];
         trace("avatars in room:",this._roomAPI.avatars.length);
         var _loc1_:int = 0;
         while(_loc1_ < this._roomAPI.avatars.length)
         {
            if(this._roomAPI.avatars[_loc1_] != this._roomAPI.userAvatar)
            {
               _loc2_ = new AvatarData(this._roomAPI.avatars[_loc1_],_loc1_,this.onAvatarClick);
               this.avatarDataArray.push(_loc2_);
               trace(_loc2_.avatar.username);
            }
            _loc1_++;
         }
         trace(this.avatarDataArray);
         this.pages = this.avatarDataArray.length / this.MAX_PER_PAGE + 1;
      }
      
      private function gaturroMatches(param1:String) : Boolean
      {
         if(!this.selectedAvatar)
         {
            return false;
         }
         if(this.selectedAvatar.attributes && this.selectedAvatar.attributes.loveTunnel && this.selectedAvatar.attributes.loveTunnel == this._roomAPI.userAvatar.username)
         {
            return true;
         }
         return false;
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.cleanPreviousData();
         this.setupTutorial();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this.gaturroMatches(this._roomAPI.userAvatar.username))
         {
            this._asset.gotoAndPlay("success");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onSuccess);
            return;
         }
         if(!this.gaturroInRoom(this.selectedAvatar.username))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.timer.stop();
            this.timer = null;
            this._asset.gotoAndStop("leftRoom");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
            return;
         }
      }
      
      private function cleanPreviousData() : void
      {
         this._roomAPI.setAvatarAttribute("loveTunnel"," ");
      }
      
      private function onSuccess(param1:Event) : void
      {
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onSuccess);
         this._roomAPI.playSound("parqueDiversiones/flechazo");
         this._asset.matchInfo.myName.text = this._roomAPI.userAvatar.username;
         this._asset.matchInfo.avatarName.text = this.selectedAvatar.username;
         var _loc2_:int = Math.random() > 0.49 ? 5 : 6;
         var _loc3_:int = _loc2_ == 5 ? 5 : 6;
         setTimeout(this._roomAPI.changeRoomXY,2000,51688309,_loc2_,_loc3_);
         this._roomAPI.takeFromUser("parqueDiversiones/props.ticket");
      }
      
      private function selectAvatarReady(param1:Event) : void
      {
         this._asset.removeEventListener(Event.EXIT_FRAME,this.selectAvatarReady);
         this.avatarButtonContainer = view.getChildByName("avatarButtonContainer") as MovieClip;
         this.rightArrow = view.getChildByName("rightArrow") as MovieClip;
         this.leftArrow = view.getChildByName("leftArrow") as MovieClip;
         this.avatarButtons = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.avatarButtonContainer.buttons.numChildren)
         {
            this.avatarButtons.push(this.avatarButtonContainer.buttons.getChildAt(_loc2_));
            _loc2_++;
         }
         this.setupAvatarData();
         this.setupAvatarButtons();
      }
      
      private function gaturroInRoom(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._roomAPI.avatars.length)
         {
            if(this._roomAPI.avatars[_loc2_].username == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.confirmButton) && this.confirmButton.hasEventListener(MouseEvent.CLICK))
         {
            this.confirmButton.removeEventListener(MouseEvent.CLICK,this.onConfirmTutorial);
         }
         if(Boolean(this._asset) && this._asset.hasEventListener(Event.EXIT_FRAME))
         {
            this._asset.removeEventListener(Event.EXIT_FRAME,this.selectAvatarReady);
            this._asset.removeEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
            this._asset.removeEventListener(Event.EXIT_FRAME,this.onWaiting);
            this._asset.removeEventListener(Event.EXIT_FRAME,this.onSuccess);
            this._asset.removeEventListener(Event.EXIT_FRAME,this.onMiss);
         }
         if(Boolean(this.rightArrow) && this.rightArrow.hasEventListener(MouseEvent.CLICK))
         {
            this.rightArrow.removeEventListener(MouseEvent.CLICK,this.onRightArrowClick);
         }
         if(Boolean(this.leftArrow) && this.leftArrow.hasEventListener(MouseEvent.CLICK))
         {
            this.leftArrow.removeEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
         }
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.timer.stop();
            this.timer = null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.avatarDataArray.length)
         {
            this.avatarDataArray[_loc1_].dispose();
            _loc1_++;
         }
      }
      
      private function onLeftArrowClick(param1:MouseEvent) : void
      {
         --this.page;
         if(this.page < 1)
         {
            this.page = this.pages;
         }
         this.setupAvatarButtons();
      }
      
      private function onAvatarLeft(param1:Event) : void
      {
         this._asset.infoText.avatarName.text = this.selectedAvatar.username;
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
         this._asset.confirm.addEventListener(MouseEvent.CLICK,this.onConfirmTutorial);
      }
      
      private function onAvatarClick(param1:Avatar, param2:Boolean) : void
      {
         this.selectedAvatar = param1;
         if(!this.gaturroInRoom(param1.username))
         {
            this._asset.gotoAndStop("leftRoom");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
            return;
         }
         this._roomAPI.setAvatarAttribute("loveTunnel",param1.username);
         this._asset.gotoAndStop("waiting");
         this._asset.addEventListener(Event.EXIT_FRAME,this.onWaiting);
      }
      
      private function onRightArrowClick(param1:MouseEvent) : void
      {
         ++this.page;
         if(this.page > this.pages)
         {
            this.page = 1;
         }
         this.setupAvatarButtons();
      }
      
      private function onConfirmTutorial(param1:MouseEvent) : void
      {
         if(this._asset.confirm.hasEventListener(MouseEvent.CLICK))
         {
            this._asset.confirm.removeEventListener(MouseEvent.CLICK,this.onConfirmTutorial);
         }
         this._asset.gotoAndStop("selectAvatar");
         this._asset.addEventListener(Event.EXIT_FRAME,this.selectAvatarReady);
      }
      
      private function setupAvatarButtons() : void
      {
         var _loc3_:int = 0;
         var _loc4_:AvatarData = null;
         if(!this.rightArrow.hasEventListener(MouseEvent.CLICK))
         {
            this.rightArrow.addEventListener(MouseEvent.CLICK,this.onRightArrowClick);
         }
         if(!this.leftArrow.hasEventListener(MouseEvent.CLICK))
         {
            this.leftArrow.addEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
         }
         if(this.pages == 1)
         {
            this.rightArrow.visible = false;
            this.leftArrow.visible = false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.avatarDataArray.length)
         {
            this.avatarDataArray[_loc1_].disOwnButton();
            _loc1_++;
         }
         var _loc2_:String = "";
         _loc1_ = 0;
         while(_loc1_ < this.avatarButtons.length)
         {
            _loc3_ = _loc1_ + (this.page - 1) * this.MAX_PER_PAGE;
            trace("Escribiendo sobre index:",_loc3_);
            if(!this.avatarDataArray[_loc3_])
            {
               this.avatarButtons[_loc1_].visible = false;
            }
            else
            {
               _loc4_ = this.avatarDataArray[_loc3_];
               this.avatarButtons[_loc1_].visible = true;
               _loc4_.ownButton(this.avatarButtons[_loc1_]);
               _loc2_ += _loc1_.toString() + ",";
            }
            _loc1_++;
         }
      }
      
      private function onWaiting(param1:Event) : void
      {
         if(this._asset.hasEventListener(Event.EXIT_FRAME))
         {
            this._asset.removeEventListener(Event.EXIT_FRAME,this.onWaiting);
         }
         this._asset.waitingClip.avatarName.text = this.selectedAvatar.username;
         if(this.gaturroMatches(this._roomAPI.userAvatar.username))
         {
            this._asset.gotoAndPlay("success");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onSuccess);
            return;
         }
         this.timer = new Timer(1000,9);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.timer.start();
      }
      
      private function setupTutorial() : void
      {
         this._asset = view as MovieClip;
         this.avatarDataArray = [];
         this.confirmButton = view.getChildByName("confirm") as MovieClip;
         this.confirmButton.addEventListener(MouseEvent.CLICK,this.onConfirmTutorial);
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(this.gaturroMatches(this._roomAPI.userAvatar.username))
         {
            this._asset.gotoAndStop("success");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onSuccess);
         }
         else
         {
            this._asset.gotoAndStop("miss");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onMiss);
         }
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.timer.stop();
         this.timer = null;
      }
   }
}

import com.qb9.mambo.world.avatars.Avatar;
import flash.display.MovieClip;
import flash.events.MouseEvent;

class AvatarData
{
    
   
   public var onClick:Function;
   
   public var position:int;
   
   public var button:MovieClip;
   
   public var avatar:Avatar;
   
   public function AvatarData(param1:Avatar, param2:int, param3:Function)
   {
      super();
      this.avatar = param1;
      this.position = param2;
      this.onClick = param3;
   }
   
   public function disOwnButton() : void
   {
      if(Boolean(this.button) && Boolean(this.button.hasEventListener(MouseEvent.CLICK)))
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
   }
   
   private function onButtonClick(param1:MouseEvent) : void
   {
      this.onClick(this.avatar,false);
   }
   
   public function ownButton(param1:MovieClip) : void
   {
      this.button = param1;
      this.button.avatarName.text = this.avatar.username;
      this.button.addEventListener(MouseEvent.CLICK,this.onButtonClick);
   }
   
   public function dispose() : void
   {
      this.avatar = null;
      if(Boolean(this.button) && Boolean(this.button.hasEventListener(MouseEvent.CLICK)))
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
      this.button = null;
      this.onClick = null;
   }
}
