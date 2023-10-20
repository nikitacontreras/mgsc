package com.qb9.mambo.net.chat
{
   import com.qb9.flashlib.events.QEventDispatcher;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.user.User;
   import com.qb9.mines.mobject.Mobject;
   
   internal class BaseChat extends QEventDispatcher
   {
       
      
      protected var user:User;
      
      private var type:String;
      
      private var net:NetworkManager;
      
      public function BaseChat(param1:String, param2:NetworkManager, param3:User)
      {
         super();
         this.type = param1;
         this.net = param2;
         this.user = param3;
         this.initEvents();
      }
      
      protected function buildMessageMobject(param1:String) : Mobject
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setString("message",param1);
         return _loc2_;
      }
      
      private function receiveMessage(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         if(_loc2_.getString("messageType") !== this.type)
         {
            return;
         }
         var _loc3_:ChatMessage = this.getMessage(_loc2_);
         var _loc4_:Boolean = this.isOwnMessage(_loc3_);
         var _loc5_:* = !_loc3_.message;
         var _loc6_:ChatEvent = new ChatEvent(_loc4_ ? (_loc5_ ? ChatEvent.SENT_KEY : ChatEvent.SENT) : (_loc5_ ? ChatEvent.RECEIVED_KEY : ChatEvent.RECEIVED),_loc3_);
         dispatchEvent(_loc6_);
      }
      
      protected function buildMessageKeyMobject(param1:int) : Mobject
      {
         var _loc2_:Mobject = new Mobject();
         _loc2_.setInteger("messageKey",param1);
         return _loc2_;
      }
      
      protected function initEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.MESSAGE_RECEIVED,this.receiveMessage);
      }
      
      protected function isOwnMessage(param1:ChatMessage) : Boolean
      {
         return StringUtil.icompare(param1.sender,this.user.username);
      }
      
      public function getMessage(param1:Mobject) : ChatMessage
      {
         var _loc2_:ChatMessage = new ChatMessage();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
      
      protected function sendMobject(param1:Mobject) : void
      {
         this.net.sendAction(new ChatRequest(param1));
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.MESSAGE_RECEIVED,this.receiveMessage);
         this.net = null;
         super.dispose();
      }
   }
}

import com.qb9.mambo.net.requests.base.MamboRequest;
import com.qb9.mines.mobject.Mobject;

class ChatRequest implements MamboRequest
{
    
   
   private var mo:Mobject;
   
   public function ChatRequest(param1:Mobject)
   {
      super();
      this.mo = param1;
   }
   
   public function toMobject() : Mobject
   {
      return this.mo;
   }
   
   public function get type() : String
   {
      return "ChatMessageActionRequest";
   }
}
