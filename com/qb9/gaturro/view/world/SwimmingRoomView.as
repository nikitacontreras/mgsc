package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.socialnet.messages.GaturroChatMessage;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.avatars.SwimmingTiledGaturro.SwimmingGaturroAvatarView;
   import com.qb9.gaturro.view.world.avatars.SwimmingTiledGaturro.SwimmingGaturroUserAvatarView;
   import com.qb9.gaturro.view.world.chat.BalloonManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.ChatEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SwimmingRoomView extends GaturroRoomView
   {
       
      
      private const INVITE_PREFIX:String = "INVITE";
      
      private var BADWORDS_TEXT:String = ". . .";
      
      private var _alwaysSwimm:Boolean;
      
      private var balloons:BalloonManager;
      
      private var myAvatar:SwimmingGaturroUserAvatarView;
      
      private const AGUA_LENGHT:int = 8;
      
      private var _aguas_so:Array;
      
      private var avatars:Array;
      
      public function SwimmingRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode, param6:Boolean = false)
      {
         this.avatars = [];
         this._aguas_so = [];
         super(param1,param3,param4,param5);
         this._alwaysSwimm = param6;
      }
      
      override protected function whenReady() : void
      {
      }
      
      private function checkCoord(param1:Event) : void
      {
         var _loc2_:SwimmingGaturroAvatarView = null;
         var _loc3_:Boolean = false;
         var _loc4_:RoomSceneObjectView = null;
         for each(_loc2_ in this.avatars)
         {
            if(this._aguas_so && this.avatars && api && this.myAvatar && this._aguas_so.length > 0)
            {
               _loc3_ = false;
               for each(_loc4_ in this._aguas_so)
               {
                  _loc3_ = this.lookForColission(_loc4_.currentCoord,this.myAvatar.currentCoord);
                  if(_loc3_)
                  {
                     break;
                  }
               }
               _loc2_.floor_water = _loc3_;
            }
         }
      }
      
      private function lookForColission(param1:Coord, param2:Coord) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.AGUA_LENGHT)
         {
            if(param1.y == param2.y)
            {
               if(param1.x - _loc3_ == param2.x)
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         if(!this._alwaysSwimm)
         {
            this.addEventListener(Event.ENTER_FRAME,this.checkCoord);
         }
         this.setupChat();
      }
      
      private function addMessage(param1:ChatEvent) : void
      {
         var _loc4_:GaturroUserAvatar = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc2_:GaturroChatMessage = param1.message as GaturroChatMessage;
         var _loc3_:SwimmingGaturroAvatarView = this.avatars[_loc2_.sender];
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
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:RoomSceneObjectView = null;
         var _loc4_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is RoomSceneObjectView)
         {
            _loc3_ = _loc2_ as RoomSceneObjectView;
            if((_loc4_ = _loc3_.nameMC).indexOf("agua1_so") != -1)
            {
               this._aguas_so.push(_loc3_);
            }
            else if(_loc4_.indexOf("agua2_so") != -1)
            {
               this._aguas_so.push(_loc3_);
            }
            else if(_loc4_.indexOf("agua3_so") != -1)
            {
               this._aguas_so.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         super.whenReady();
         var _loc2_:DisplayObject = param1 is UserAvatar ? new SwimmingGaturroUserAvatarView(param1 as UserAvatar,tasks,tiles,sceneObjects) : new SwimmingGaturroAvatarView(param1,tasks,tiles,sceneObjects);
         if(this._alwaysSwimm)
         {
            (_loc2_ as SwimmingGaturroAvatarView).floor_water = true;
         }
         if(param1 is UserAvatar)
         {
            api.setAvatarAttribute(Gaturro.EFFECT2_KEY," ");
            this.myAvatar = _loc2_ as SwimmingGaturroUserAvatarView;
         }
         this.avatars[param1.avatarId] = this.avatars[param1.username] = _loc2_;
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEventListener(Event.ENTER_FRAME,this.checkCoord);
      }
      
      private function setupChat() : void
      {
         this.chat.addEventListener(ChatEvent.SENT,this.addMessage);
         this.chat.addEventListener(ChatEvent.RECEIVED,this.addMessage);
         this.balloons = new BalloonManager(tileLayer);
         tasks.add(this.balloons);
      }
      
      override public function get userView() : GaturroAvatarView
      {
         return this.avatars[user.id] as SwimmingGaturroAvatarView;
      }
   }
}
