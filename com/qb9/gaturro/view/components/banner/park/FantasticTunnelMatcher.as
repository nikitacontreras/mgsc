package com.qb9.gaturro.view.components.banner.park
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.FantasticTunnelRoomView;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class FantasticTunnelMatcher extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var count:int = 0;
      
      private var confirmButton:MovieClip;
      
      private var page:int = 1;
      
      private var confirmAccompButton:MovieClip;
      
      private const MAX_PER_PAGE:int = 8;
      
      private const COLUMNS:int = 2;
      
      private var leftArrow:MovieClip;
      
      private var pages:int = 1;
      
      private var timer:Timer;
      
      private var rightArrow:MovieClip;
      
      private var confirmSoloButton:MovieClip;
      
      private var selectedAvatar:Avatar;
      
      private var avatarButtonContainer:MovieClip;
      
      private const ROWS:int = 4;
      
      private var avatarButtons:Array;
      
      private var _asset:MovieClip;
      
      private var avatarDataArray:Array;
      
      public function FantasticTunnelMatcher()
      {
         super("fantasticTunnelMatcher","FantasticTunnelMatcherAsset");
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function takeUserToRoom() : void
      {
         var _loc1_:int = Math.random() > 0.49 ? 5 : 6;
         var _loc2_:int = _loc1_ == 5 ? 5 : 6;
         setTimeout(this._roomAPI.changeRoomXY,2000,51688752,_loc1_,_loc2_);
         this._roomAPI.takeFromUser("parqueDiversiones/props.ticket");
         this._asset.stop();
      }
      
      private function setupAvatarData() : void
      {
         var _loc2_:AvatarData = null;
         this.avatarDataArray = [];
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
         if(this.selectedAvatar.attributes && this.selectedAvatar.attributes[FantasticTunnelRoomView.TUNEL_FANTASTICO] && this.selectedAvatar.attributes[FantasticTunnelRoomView.TUNEL_FANTASTICO] == this._roomAPI.userAvatar.username)
         {
            return true;
         }
         return false;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this.gaturroMatches(this._roomAPI.userAvatar.username))
         {
            this._asset.gotoAndStop("success");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onSuccess);
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.timer.stop();
            this.timer = null;
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
            this.cleanPreviousData();
            return;
         }
      }
      
      private function setupSelection() : void
      {
         this.confirmSoloButton = view.getChildByName("confirmSolo") as MovieClip;
         this.confirmAccompButton = view.getChildByName("confirm") as MovieClip;
         this.confirmSoloButton.t.text = "ENTRAR SOLO";
         this.confirmSoloButton.addEventListener(MouseEvent.CLICK,this.onConfirmSolo);
         this.confirmAccompButton.addEventListener(MouseEvent.CLICK,this.onTutorial);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.cleanPreviousData();
         this._asset = view as MovieClip;
         this.setupSelection();
      }
      
      private function onSuccess(param1:Event) : void
      {
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onSuccess);
         this.takeUserToRoom();
      }
      
      private function selectAvatarReady(param1:Event) : void
      {
         this.avatarDataArray = [];
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
      
      private function cleanPreviousData() : void
      {
         this._roomAPI.setAvatarAttribute(FantasticTunnelRoomView.TUNEL_FANTASTICO," ");
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
      
      override public function dispose() : void
      {
         super.dispose();
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
         if(!this.avatarDataArray)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.avatarDataArray.length)
         {
            this.avatarDataArray[_loc1_].dispose();
            _loc1_++;
         }
      }
      
      private function removeSelectionListener() : void
      {
         this.confirmSoloButton.removeEventListener(MouseEvent.CLICK,this.onConfirmSolo);
         this.confirmAccompButton.removeEventListener(MouseEvent.CLICK,this.onTutorial);
      }
      
      private function onAvatarLeft(param1:Event) : void
      {
         this._asset.infoText.avatarName.text = this.selectedAvatar.username;
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
         this.setupSelection();
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
      
      private function onAvatarClick(param1:Avatar, param2:Boolean) : void
      {
         this.selectedAvatar = param1;
         if(!this.gaturroInRoom(param1.username))
         {
            this._asset.gotoAndStop("leftRoom");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onAvatarLeft);
            return;
         }
         this._roomAPI.setAvatarAttribute(FantasticTunnelRoomView.TUNEL_FANTASTICO,param1.username);
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
      
      private function onTutorial(param1:MouseEvent) : void
      {
         this._asset.gotoAndStop("selectAvatar");
         this._asset.addEventListener(Event.EXIT_FRAME,this.selectAvatarReady);
      }
      
      private function onConfirmSolo(param1:MouseEvent) : void
      {
         this.takeUserToRoom();
         this._asset.gotoAndStop("success");
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
            this._asset.gotoAndStop("success");
            this._asset.addEventListener(Event.EXIT_FRAME,this.onSuccess);
            return;
         }
         this.timer = new Timer(1000,13);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.timer.start();
      }
      
      private function onMiss(param1:Event) : void
      {
         this._asset.removeEventListener(Event.EXIT_FRAME,this.onMiss);
         this._asset.missInfo.avatarName.text = this.selectedAvatar.username;
         this.setupSelection();
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
            this.cleanPreviousData();
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
