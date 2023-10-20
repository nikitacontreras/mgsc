package com.qb9.gaturro.view.world.interaction
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.view.components.banner.boca.BocaPenales;
   import com.qb9.gaturro.view.components.banner.carreraCohete.CarreraCohete;
   import com.qb9.gaturro.view.components.banner.fulbejo2018.Fulbejo;
   import com.qb9.gaturro.view.components.banner.peleaMagia.PeleaMagiaCore;
   import com.qb9.gaturro.view.components.banner.vestiteComoYo.VestiteComoYo;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.exchange.ExchangeGuiModal;
   import com.qb9.gaturro.view.gui.interaction.InteractionGuiModal;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.chat.BalloonManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Interaction
   {
      
      public static const REJECTION:String = "R";
      
      public static const PROPOSAL:String = "P";
      
      public static const INIT_INTERACTION:String = "I";
      
      public static const BUSY:String = "B";
       
      
      protected var inOperation:Boolean = true;
      
      protected var room:GaturroRoom;
      
      protected var interactionData:Object;
      
      protected var modal:InteractionGuiModal;
      
      protected var mateUsername:String = "";
      
      public function Interaction(param1:GaturroRoom, param2:Object)
      {
         super();
         this.room = param1;
         this.interactionData = param2;
         net.addEventListener(NetworkManagerEvent.AVATAR_LEFT,this.avatarPresenceChange);
      }
      
      protected function rejection(param1:Boolean) : void
      {
         if(this.modal)
         {
            this.modal.rejection(param1);
         }
         this.closeOperation();
      }
      
      private function avatarPresenceChange(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Avatar = this.room.avatarByUsername(this.mateUsername);
         if(!_loc2_)
         {
            this.rejection(false);
         }
      }
      
      public function initPropose(param1:Gui, param2:String) : void
      {
         api.trackEvent("INTERACTION:" + this.prefix,"INIT");
         this.mateUsername = param2;
         this.sendOperation(Interaction.PROPOSAL,this.mateUsername);
         this.showModal(param1);
      }
      
      private function closeOperation(param1:Event = null) : void
      {
         this.inOperation = false;
      }
      
      public function get modalForm() : BaseGuiModal
      {
         return this.modal;
      }
      
      protected function get prefix() : String
      {
         return this.interactionData.prefix;
      }
      
      private function closeModal(param1:Event) : void
      {
         this.sendOperation(Interaction.REJECTION,this.mateUsername);
      }
      
      public function acceptPropose(param1:Gui, param2:String) : void
      {
         api.trackEvent("INTERACTION:" + this.prefix,"ACCEPTED");
         this.mateUsername = param2;
         this.sendOperation(Interaction.INIT_INTERACTION,this.mateUsername);
         this.showModal(param1);
         this.inOperation = true;
      }
      
      protected function get bannerName() : String
      {
         return this.interactionData.bannerName;
      }
      
      protected function createModal() : InteractionGuiModal
      {
         switch(this.interactionData.prefix)
         {
            case "EX":
               return new ExchangeGuiModal(this.room,this.prefix,this.sendOperation);
            case "FP":
               return new BocaPenales(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "PM":
               return new PeleaMagiaCore(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "CC":
               return new CarreraCohete(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "CV":
               return new VestiteComoYo(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "PR":
               return new BocaPenales(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "PT":
               return new BocaPenales(this.room,this.prefix,this.sendOperation,this.bannerName);
            case "PF":
               return new Fulbejo(this.room,this.prefix,this.sendOperation,this.bannerName);
            default:
               return new InteractionGuiModal(this.room,this.prefix,this.sendOperation,this.bannerName);
         }
      }
      
      public function rejectPropose(param1:String) : void
      {
         api.trackEvent("INTERACTION:" + this.prefix,"REJECT");
         this.sendOperation(Interaction.REJECTION,param1);
      }
      
      public function received(param1:String, param2:Avatar, param3:GaturroAvatarView, param4:Avatar, param5:GaturroAvatarView, param6:Array) : void
      {
         if(!this.inOperation)
         {
            return;
         }
         param1 = param1.replace(this.prefix,"");
         if(this.mateUsername != "" && this.mateUsername != param2.username && this.mateUsername != param4.username)
         {
            if(param1 == Interaction.PROPOSAL)
            {
               this.sendBusy(param2.username);
            }
            return;
         }
         switch(param1)
         {
            case Interaction.INIT_INTERACTION:
               this.initInteraction();
               return;
            case Interaction.BUSY:
               this.busy();
               return;
            case Interaction.REJECTION:
               this.rejection(param2.username == this.room.userAvatar.username);
               return;
            default:
               this.modal.executeOperation(param1,param2,param4,param6);
               return;
         }
      }
      
      protected function initInteraction() : void
      {
         this.modal.initInteraction(this.mateUsername);
         this.modal.addEventListener(InteractionGuiModal.CLOSE_OPERATION_EVENT,this.closeOperation);
      }
      
      public function dispose() : void
      {
         net.removeEventListener(NetworkManagerEvent.AVATAR_LEFT,this.avatarPresenceChange);
         this.room = null;
         this.interactionData = null;
         if(this.modal)
         {
            this.modal.removeEventListener(Event.CLOSE,this.closeModal);
            this.modal.removeEventListener(InteractionGuiModal.CLOSE_OPERATION_EVENT,this.closeOperation);
         }
      }
      
      private function sendBusy(param1:String) : void
      {
         this.sendOperation(Interaction.BUSY,param1);
      }
      
      public function say(param1:BalloonManager, param2:String, param3:String) : void
      {
         var _loc4_:DisplayObject = null;
         if(param2 == this.room.userAvatar.username)
         {
            _loc4_ = this.modal.avatarMe;
         }
         if(param2 == this.mateUsername)
         {
            _loc4_ = this.modal.avatarMate;
         }
         if(_loc4_)
         {
            param1.say(_loc4_,param3,Sprite(_loc4_));
         }
      }
      
      protected function showModal(param1:Gui) : void
      {
         this.modal = this.createModal();
         this.modal.addEventListener(Event.CLOSE,this.closeModal);
         param1.addModal(this.modal);
         var _loc2_:Avatar = Avatar(this.room.userAvatar);
         var _loc3_:Avatar = this.room.avatarByUsername(this.mateUsername);
         this.modal.saveAvatars(_loc2_,_loc3_);
      }
      
      protected function executeOperation(param1:String, param2:Avatar, param3:GaturroAvatarView, param4:Avatar, param5:GaturroAvatarView, param6:Array) : void
      {
      }
      
      protected function busy() : void
      {
         this.modal.busy();
         this.closeOperation();
      }
      
      private function sendOperation(param1:String, param2:String) : void
      {
         logger.debug(this,param1);
         logger.debug(this,param2);
         logger.debug(this,this.prefix);
         var _loc3_:String = "@" + this.prefix + param1 + ";" + param2;
         this.room.chat.send(_loc3_);
      }
   }
}
