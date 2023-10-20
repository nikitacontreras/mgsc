package com.qb9.gaturro.view.gui.socialnet
{
   import assets.IphoneGenericMC;
   import assets.SocialNetGuiMC;
   import com.qb9.flashlib.movieclip.MovieClipManager;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.view.gui.iphone2.screens.BaseIPhone2Screen;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2Screens;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class SocialNetIphone2GuiModal extends BaseIPhone2Screen
   {
      
      private static const BASE:String = "content/";
       
      
      private var lastGiftCode:String;
      
      private var captureSceneButton:com.qb9.gaturro.view.gui.socialnet.SocialNetButton;
      
      private var captureAvatarButton:com.qb9.gaturro.view.gui.socialnet.SocialNetButton;
      
      private var gRoom:GaturroRoomView;
      
      private var sendCodeButton:com.qb9.gaturro.view.gui.socialnet.SocialNetButton;
      
      private var room:GaturroRoom;
      
      private var popup:SocialNetGuiMC;
      
      private var manager:MovieClipManager;
      
      private var sendMessageButton:com.qb9.gaturro.view.gui.socialnet.SocialNetButton;
      
      public function SocialNetIphone2GuiModal(param1:IPhone2Modal, param2:GaturroRoom, param3:GaturroRoomView)
      {
         super(param1,new IphoneGenericMC(),{});
         this.room = param2;
         this.gRoom = param3;
         this.init();
      }
      
      private function addGift(param1:DisplayObject) : void
      {
      }
      
      private function showResult(param1:String) : void
      {
      }
      
      private function backToMenu() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function codeReturnError() : void
      {
      }
      
      private function init() : void
      {
         this.manager = new MovieClipManager(asset);
         this.popup = new SocialNetGuiMC();
         this.popup.backToMenu.addEventListener(MouseEvent.CLICK,this.clickOnBack);
         asset.ph.addChild(this.popup);
         if(!settings.services.socialNet.showUI)
         {
            this.popup.gotoAndStop("inactive");
            return;
         }
         this.popup.sendCode.addEventListener(MouseEvent.CLICK,this.onLaunchHTML5);
      }
      
      private function clickOnBack(param1:MouseEvent) : void
      {
         this.popup.backToMenu.removeEventListener(MouseEvent.CLICK,this.clickOnBack);
         back(IPhone2Screens.MENU);
      }
      
      private function activeButtons() : void
      {
      }
      
      private function sendCode() : void
      {
      }
      
      private function backToSocialNet() : void
      {
      }
      
      private function sendMessage() : void
      {
      }
      
      private function showCapturePopup() : void
      {
      }
      
      override public function dispose() : void
      {
         this.popup.backToMenu.removeEventListener(MouseEvent.CLICK,this.clickOnBack);
         asset = null;
         this.popup = null;
         this.manager.dispose();
         this.manager = null;
         this.room = null;
         super.dispose();
      }
      
      private function captureScene() : void
      {
      }
      
      private function onLaunchHTML5(param1:MouseEvent) : void
      {
         this.popup.sendCode.removeEventListener(MouseEvent.CLICK,this.onLaunchHTML5);
         api.startHtmlMMO();
      }
      
      private function deactiveButtons() : void
      {
      }
      
      private function codeRejectError() : void
      {
      }
      
      private function changeBackground(param1:Event) : void
      {
      }
      
      private function captureAvatar() : void
      {
      }
   }
}
