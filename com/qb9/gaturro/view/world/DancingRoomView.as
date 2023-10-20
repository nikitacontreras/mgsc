package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.socialnet.messages.GaturroChatMessage;
   import com.qb9.gaturro.view.world.avatars.DancingGaturro.DancingGaturroAvatarView;
   import com.qb9.gaturro.view.world.avatars.DancingGaturro.DancingGaturroUserAvatarView;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.chat.BalloonManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.ChatEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   
   public class DancingRoomView extends GaturroRoomView
   {
       
      
      private var balloons:BalloonManager;
      
      private var myAvatar:DancingGaturroUserAvatarView;
      
      private const INVITE_PREFIX:String = "INVITE";
      
      private const AGUA_LENGHT:int = 14;
      
      private var BADWORDS_TEXT:String = ". . .";
      
      private var _aguas_so:Array;
      
      private var avatars:Array;
      
      public function DancingRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         this.avatars = [];
         this._aguas_so = [];
         super(param1,param3,param4,param5);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.setupChat();
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         super.whenReady();
         var _loc2_:DisplayObject = param1 is UserAvatar ? new DancingGaturroUserAvatarView(param1 as UserAvatar,tasks,tiles,sceneObjects) : new DancingGaturroAvatarView(param1,tasks,tiles,sceneObjects);
         if(param1 is UserAvatar)
         {
            api.setAvatarAttribute(Gaturro.EFFECT2_KEY," ");
            this.myAvatar = _loc2_ as DancingGaturroUserAvatarView;
         }
         this.avatars[param1.avatarId] = this.avatars[param1.username] = _loc2_;
         return _loc2_;
      }
      
      private function setupChat() : void
      {
         this.chat.addEventListener(ChatEvent.SENT,this.addMessage);
         this.chat.addEventListener(ChatEvent.RECEIVED,this.addMessage);
         this.balloons = new BalloonManager(tileLayer);
         tasks.add(this.balloons);
      }
      
      private function addMessage(param1:ChatEvent) : void
      {
         var _loc4_:GaturroUserAvatar = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc2_:GaturroChatMessage = param1.message as GaturroChatMessage;
         var _loc3_:DancingGaturroAvatarView = this.avatars[_loc2_.sender];
         _loc4_ = room.userAvatar as GaturroUserAvatar;
         if(_loc3_ && _loc2_.message)
         {
            if(_loc2_.message.charAt(0) == "@")
            {
               if(_loc2_.message.substr(0,this.INVITE_PREFIX.length + 1) == "@" + this.INVITE_PREFIX)
               {
                  _loc6_ = Number(_loc2_.message.split(";")[1]);
                  _loc7_ = String(_loc2_.message.split(";")[2]);
                  this.balloons.proposeInvite(_loc6_,_loc7_,_loc3_);
               }
               else
               {
                  interactionManager.receivedOp(_loc2_);
               }
            }
            else
            {
               if(_loc2_.badwords)
               {
                  _loc2_.message = this.BADWORDS_TEXT;
               }
               interactionManager.say(this.balloons,_loc2_.sender,_loc2_.message);
               this.balloons.say(_loc3_,_loc2_.message);
            }
         }
      }
      
      override public function get userView() : GaturroAvatarView
      {
         return this.avatars[user.id] as DancingGaturroAvatarView;
      }
   }
}
