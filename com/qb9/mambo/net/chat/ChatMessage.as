package com.qb9.mambo.net.chat
{
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public class ChatMessage implements MobjectBuildable
   {
       
      
      private var _key:int;
      
      private var _messageType:String;
      
      private var _message:String;
      
      private var _receiver:String;
      
      private var _avatarId:int;
      
      private var _sender:String;
      
      public function ChatMessage()
      {
         super();
      }
      
      public function get messagetype() : String
      {
         return this._messageType;
      }
      
      public function get avatarId() : int
      {
         return this._avatarId;
      }
      
      public function get sender() : String
      {
         return this._sender;
      }
      
      public function set message(param1:String) : void
      {
         this._message = param1;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._avatarId = param1.getInteger("avatarId");
         this._messageType = param1.getString("messageType");
         this._key = param1.getInteger("messageKey");
         this._message = param1.getString("message");
         this._sender = param1.getString("sender");
         this._receiver = param1.getString("receiver");
      }
      
      public function get receiver() : String
      {
         return this._receiver;
      }
      
      public function get key() : int
      {
         return this._key;
      }
   }
}
