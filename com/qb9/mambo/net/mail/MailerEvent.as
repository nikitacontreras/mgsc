package com.qb9.mambo.net.mail
{
   import flash.events.Event;
   
   public final class MailerEvent extends Event
   {
      
      public static const ADDED:String = "meMailAdded";
      
      public static const CHANGED:String = "meMailsChanged";
      
      public static const REMOVED:String = "meMailRemoved";
       
      
      private var _mail:com.qb9.mambo.net.mail.MailMessage;
      
      public function MailerEvent(param1:String, param2:com.qb9.mambo.net.mail.MailMessage = null)
      {
         super(param1);
         this._mail = param2;
      }
      
      override public function clone() : Event
      {
         return new MailerEvent(type,this.mail);
      }
      
      public function get mail() : com.qb9.mambo.net.mail.MailMessage
      {
         return this._mail;
      }
   }
}
