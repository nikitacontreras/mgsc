package com.qb9.gaturro.view.world.chat
{
   import flash.events.Event;
   
   public final class ChatViewEvent extends Event
   {
      
      public static const FINISHED:String = "cveFinished";
      
      public static const SAY:String = "_message_";
       
      
      private var _message:String;
      
      public function ChatViewEvent(param1:String, param2:String = null)
      {
         super(param1,true);
         this._message = param2;
      }
      
      override public function clone() : Event
      {
         return new ChatViewEvent(type,this.message);
      }
      
      public function get message() : String
      {
         return this._message;
      }
   }
}
