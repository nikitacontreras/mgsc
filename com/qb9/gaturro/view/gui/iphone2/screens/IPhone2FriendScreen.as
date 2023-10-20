package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.IPhone2FriendOptionsMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.gaturro.world.community.CommunityManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.events.Event;
   
   public class IPhone2FriendScreen extends InternalTitledScreen
   {
       
      
      private var backTo:String;
      
      private var buddy:Buddy;
      
      private var room:GaturroRoom;
      
      public function IPhone2FriendScreen(param1:IPhone2Modal, param2:GaturroRoom, param3:Buddy, param4:String = null)
      {
         var _loc5_:String = null;
         super(param1,param3.username,new IPhone2FriendOptionsMC(),{
            "newMessage":this.compose,
            "privateRoom":this.goHome,
            "down":this.removeFriend
         });
         this.buddy = param3;
         this.room = param2;
         this.backTo = param4 || IPhone2Screens.FRIENDS;
         this.init();
         if(param3.numberOfFriends == -1)
         {
            user.community.addEventListener(CommunityManager.BUDDY_LOADED,this.onBuddyLoaded);
            user.community.sendGetBuddyRequest(param3.username,param3.accountId);
         }
         else
         {
            _loc5_ = (_loc5_ = String(region.getText("AMIGOS ({num})"))).replace("{num}","" + param3.numberOfFriends);
            setTitle(param3.username + " - " + _loc5_);
         }
      }
      
      private function evalButtons(param1:Event = null) : void
      {
         if(Boolean(settings.socialNet) && this.buddy.username == region.key("feedbackMessageName"))
         {
            this.blockAllButtons();
            return;
         }
         setEnabled("privateRoom",!this.isFriend || this.buddy.online && this.buddy.worldName.toLowerCase() == server.serverName.toLowerCase());
      }
      
      private function goHome() : void
      {
         this.room.visit(this.buddy.username);
      }
      
      private function get isFriend() : Boolean
      {
         return this.buddy !== null;
      }
      
      private function removeFriend() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.buddy = this.buddy;
         goto(IPhone2Screens.REMOVE_FRIEND,_loc1_);
      }
      
      private function blockAllButtons() : void
      {
         setEnabled("privateRoom",false);
         setEnabled("newMessage",false);
         setVisible("down",false);
      }
      
      private function onBuddyLoaded(param1:Event) : void
      {
         var _loc2_:Buddy = user.community.getBuddy(this.buddy.username);
         var _loc3_:String = String(region.getText("AMIGOS ({num})"));
         _loc3_ = _loc3_.replace("{num}","" + _loc2_.numberOfFriends);
         setTitle(_loc2_.username + " - " + _loc3_);
         user.community.removeEventListener(CommunityManager.BUDDY_LOADED,this.onBuddyLoaded);
      }
      
      private function init() : void
      {
         setText("newMessage.field","Nuevo mensaje");
         setText("privateRoom.field","Ir a su casa");
         setText("down.field","Borrar");
         this.evalButtons();
         setVisible("arrow_offline",Boolean(this.buddy) && !this.buddy.online);
         setVisible("arrow_online",Boolean(this.buddy) && this.buddy.online);
         setText("status",Boolean(this.buddy) && this.buddy.online ? region.getText("Conectado") + " (" + this.buddy.worldName + ")" : String(region.getText("Desconectado")));
      }
      
      private function compose() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.internalMessage = new InternalMessageData(this.buddy.username,"");
         _loc1_.buddy = this.buddy;
         goto(IPhone2Screens.COMPOSE_TO_FRIEND,_loc1_);
      }
      
      override protected function backButton() : void
      {
         back(this.backTo);
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
   }
}
