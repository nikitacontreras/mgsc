package com.qb9.mambo.net.chat
{
   import flash.events.Event;
   
   public final class ChatEvent extends Event
   {
      
      public static const RECEIVED_KEY:String = "chatMessageReceivedKey";
      
      public static const SENT_KEY:String = "chatMessageSentKey";
      
      public static const RECEIVED:String = "chatMessageReceived";
      
      public static const SENT:String = "chatMessageSent";
       
      
      private var _message:com.qb9.mambo.net.chat.ChatMessage;
      
      public function ChatEvent(param1:String, param2:com.qb9.mambo.net.chat.ChatMessage)
      {
         super(param1,false,true);
         this._message = param2;
      }
      
      override public function clone() : Event
      {
         return new ChatEvent(type,this.message);
      }
      
      public function get message() : com.qb9.mambo.net.chat.ChatMessage
      {
         return this._message;
      }
   }
}
