package com.qb9.gaturro.view.gui.interaction
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.banner.BannerGuiModal;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class InteractionGuiModal extends BannerGuiModal
   {
      
      public static const CLOSE_OPERATION_EVENT:String = "CLOSE_OPERATION_EVENT";
       
      
      private var timer:Timer;
      
      protected var avatarDataMate:Avatar;
      
      protected var characterMate:Gaturro;
      
      protected var prefix:String;
      
      protected var bannerName:String;
      
      protected var canceled:Boolean = false;
      
      protected var avatarDataMe:Avatar;
      
      protected var characterMe:Gaturro;
      
      protected var room:GaturroRoom;
      
      protected var sendOperationFunc:Function;
      
      protected var asset:MovieClip;
      
      protected var mateUsername:String = "";
      
      private const TIME_OUT:int = 15000;
      
      public function InteractionGuiModal(param1:GaturroRoom, param2:String, param3:Function, param4:String)
      {
         this.room = param1;
         this.prefix = param2;
         this.sendOperationFunc = param3;
         this.bannerName = param4;
         super(this.bannerName,null,api);
         this.initPopup();
      }
      
      public function busy() : void
      {
         this.cancelInteraction();
         this.tryInteractionEvent("busy",50);
      }
      
      private function timeOut(param1:Event) : void
      {
         this.rejection(true);
         this.cleanTimer();
      }
      
      protected function initPopup() : void
      {
         this.timer = new Timer(this.TIME_OUT);
         this.timer.addEventListener(TimerEvent.TIMER,this.timeOut);
         this.timer.start();
      }
      
      public function saveAvatars(param1:Avatar, param2:Avatar) : void
      {
         this.avatarDataMe = param1;
         this.avatarDataMate = param2;
         if(this.bannerName == "")
         {
            this.avatarsNames(this.avatarDataMe,this.avatarDataMate);
            this.avatarsImages(this.avatarDataMe,this.avatarDataMate);
         }
      }
      
      public function rejection(param1:Boolean) : void
      {
         this.cancelInteraction();
         this.tryInteractionEvent("rejection",50,param1);
      }
      
      protected function cleanTimer() : void
      {
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.timeOut);
            this.timer.stop();
            this.timer = null;
         }
      }
      
      public function send(param1:String, param2:String) : void
      {
         this.sendOperationFunc(param1,this.mateUsername + ";" + param2);
      }
      
      public function get avatarMe() : Gaturro
      {
         return this.characterMe;
      }
      
      override protected function displayElement(param1:DisplayObject) : void
      {
         super.displayElement(param1);
         this.asset = MovieClip(param1);
         this.avatarsNames(this.avatarDataMe,this.avatarDataMate);
         this.avatarsImages(this.avatarDataMe,this.avatarDataMate);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.cleanTimer();
         this.room = null;
         this.avatarDataMe = null;
         this.avatarDataMate = null;
      }
      
      private function tryInteractionEvent(param1:String, param2:int, ... rest) : void
      {
         if(this.asset)
         {
            this.callInteractionEvent(param1,rest);
         }
         else
         {
            param2--;
            if(param2 > 0)
            {
               setTimeout(this.tryInteractionEvent,100,param1,param2,rest);
            }
         }
      }
      
      private function callInteractionEvent(param1:String, param2:Array) : void
      {
         var _loc3_:Avatar = null;
         var _loc4_:Avatar = null;
         if(this.bannerName != "" && param1 in this.asset)
         {
            switch(param1)
            {
               case "initInteraction":
                  _loc3_ = this.room.avatarByUsername(user.username);
                  _loc4_ = this.room.avatarByUsername(this.mateUsername);
                  Object(this.asset)[param1](_loc3_,_loc4_);
                  break;
               default:
                  Object(this.asset)[param1](param2[0]);
            }
         }
      }
      
      public function initInteraction(param1:String) : void
      {
         this.mateUsername = param1;
         this.cleanTimer();
         this.tryInteractionEvent("initInteraction",50);
      }
      
      protected function avatarsImages(param1:Avatar, param2:Avatar) : void
      {
         this.characterMe = new Gaturro(new Holder(param1));
         if(this.asset.avatar1)
         {
            this.asset.avatar1.avatarPh.addChild(this.characterMe);
         }
         this.characterMate = new Gaturro(new Holder(param2));
         if(this.asset.avatar2)
         {
            this.asset.avatar2.avatarPh.addChild(this.characterMate);
         }
      }
      
      protected function avatarsNames(param1:Avatar, param2:Avatar) : void
      {
         if(Boolean(this.asset.avatar1) && Boolean(this.asset.avatar2))
         {
            this.asset.avatar1.username.text = param1.username;
            this.asset.avatar2.username.text = param2.username;
            this.asset.avatar1.visible = true;
            this.asset.avatar2.visible = true;
         }
         this.mateUsername = param2.username;
      }
      
      public function executeOperation(param1:String, param2:Avatar, param3:Avatar, param4:Array) : void
      {
         if(Boolean(this.asset) && "executeOperation" in this.asset)
         {
            Object(this.asset).executeOperation(param1,param2,param3,param4);
         }
      }
      
      public function get avatarMate() : Gaturro
      {
         return this.characterMate;
      }
      
      public function cancelInteraction() : void
      {
         this.cleanTimer();
         this.canceled = true;
      }
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.Avatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:Avatar)
   {
      super();
      _attributes = param1.attributes.clone(this);
   }
}
