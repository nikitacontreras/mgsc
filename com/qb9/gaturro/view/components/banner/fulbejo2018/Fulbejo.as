package com.qb9.gaturro.view.components.banner.fulbejo2018
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.view.gui.interaction.InteractionGuiModal;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import com.qb9.gaturro.view.world.interaction.Interaction;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class Fulbejo extends InteractionGuiModal
   {
       
      
      private var _gameOver:Boolean;
      
      private var _localAssetLoaded:Boolean;
      
      private var _avatarDresser:AvatarDresser;
      
      private var teamManager:TeamManager;
      
      private var send_timeoutID:uint;
      
      private var _readyMe:Boolean;
      
      private var _readyFriend:Boolean;
      
      private var myAccountId:String;
      
      private var _teQuereVestiComoIo:Boolean;
      
      private var _imFirst:Boolean;
      
      private var _avatarToCopyDress:UserAvatar;
      
      private var _remoteAssetLoaded:Boolean;
      
      public function Fulbejo(param1:GaturroRoom, param2:String, param3:Function, param4:String)
      {
         super(param1,param2,param3,param4);
         this.myAccountId = api.user.accountId;
         this.initPopup();
      }
      
      private function onReceiveReady(param1:int) : void
      {
         if(param1 == avatarDataMe.avatarId)
         {
            this._readyMe = true;
         }
         else
         {
            this._readyFriend = true;
         }
         if(this._readyMe && this._readyFriend)
         {
            this.onReady();
         }
      }
      
      override public function close() : void
      {
         if(!this._gameOver)
         {
            this._gameOver = true;
            this.send("quit","");
         }
         super.close();
      }
      
      override public function send(param1:String, param2:String) : void
      {
         if(param1 == "quit")
         {
            super.send(param1,param2);
         }
         else
         {
            this.send_timeoutID = setTimeout(super.send,100,param1,param2);
         }
      }
      
      protected function onReady() : void
      {
         if(this._teQuereVestiComoIo)
         {
            this.startGame();
         }
      }
      
      private function onQuit(param1:MouseEvent) : void
      {
         asset.bannerMC.close.removeEventListener(MouseEvent.MOUSE_DOWN,this.onQuit);
         this.close();
      }
      
      protected function sendAssetLoaded() : void
      {
         this.send("assetLoaded","");
      }
      
      override protected function displayElement(param1:DisplayObject) : void
      {
         super.displayElement(param1);
         this.sendAssetLoaded();
      }
      
      override public function executeOperation(param1:String, param2:Avatar, param3:Avatar, param4:Array) : void
      {
         var _loc6_:String = null;
         var _loc5_:Boolean = param2.avatarId == avatarDataMe.avatarId ? true : false;
         trace(param1,param2,param3,param4);
         trace(">>>>>>OPERATION: " + param1 + " <-----LOCAL OPERATION?: " + _loc5_);
         switch(param1)
         {
            case Interaction.PROPOSAL:
            case "click":
               break;
            case "assetLoaded":
               if(_loc5_)
               {
                  this._localAssetLoaded = true;
               }
               else
               {
                  this._remoteAssetLoaded = true;
               }
               if(this.globalAssetLoaded)
               {
                  this.sendReady();
                  this.avatarsImages(avatarDataMe,avatarDataMate);
                  break;
               }
               break;
            case "imFirst":
               this._imFirst = _loc5_ ? true : false;
               if(this._teQuereVestiComoIo)
               {
               }
               break;
            case "dressLikeMe":
               if(!_loc5_)
               {
                  _loc6_ = api.getAvatarAttribute("superClasico2018TEAM") as String;
                  api.startExternalMinigame("fulbejo",{
                     "roomid":avatarDataMate.id,
                     "servername":server.serverName,
                     "team":_loc6_
                  });
                  this.close();
                  break;
               }
               break;
            case "imReady":
               this.onReceiveReady(param2.avatarId);
               if(!_loc5_ && !this._remoteAssetLoaded)
               {
                  this._teQuereVestiComoIo = true;
                  api.levelManager.addSocialExp(10);
                  this.sendReady();
                  this._avatarToCopyDress = api.userAvatar;
                  break;
               }
               break;
            case "quit":
               if(!_loc5_)
               {
                  this.close();
                  break;
               }
               break;
            case "gameOver":
         }
      }
      
      private function startGame() : void
      {
         var _loc1_:String = api.getAvatarAttribute("superClasico2018TEAM") as String;
         api.startExternalMinigame("fulbejo",{
            "roomid":api.userAvatar.id,
            "servername":server.serverName,
            "team":_loc1_
         });
         api.setAvatarAttribute("action","jueguito.mundial2018/props.pelota");
         this.send("dressLikeMe","");
      }
      
      protected function get globalAssetLoaded() : Boolean
      {
         return this._localAssetLoaded && this._remoteAssetLoaded;
      }
      
      protected function sendReady() : void
      {
         this.send("imReady","");
      }
      
      override protected function initPopup() : void
      {
         super.initPopup();
         this._avatarDresser = new AvatarDresser();
         this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
      }
   }
}
