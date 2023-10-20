package com.qb9.mambo.net.mail
{
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public class MailMessage implements MobjectBuildable
   {
       
      
      protected var _serverMessage:Boolean = false;
      
      protected var _message:String;
      
      protected var _date:Date;
      
      protected var _messageKeys:Array;
      
      protected var _sender:String;
      
      protected var _subject:String;
      
      protected var _id:Number;
      
      protected var _isRead:Boolean;
      
      public function MailMessage()
      {
         super();
      }
      
      public function get isFromSystem() : Boolean
      {
         return this.sender === null;
      }
      
      public function get serverMessage() : Boolean
      {
         return this._serverMessage;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = param1.getInteger("id");
         this._sender = param1.getString("sender");
         this._subject = param1.getString("subject");
         this._isRead = param1.getBoolean("read");
         this._message = param1.getString("message");
         this._messageKeys = param1.getIntegerArray("messageKeys");
         var _loc2_:Number = Number(param1.getString("date"));
         this._date = new Date(_loc2_);
         this._serverMessage = true;
      }
      
      public function read() : void
      {
         this._isRead = true;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get isRead() : Boolean
      {
         return this._isRead;
      }
      
      public function get messageKeys() : Array
      {
         return this._messageKeys && this._messageKeys.concat();
      }
      
      public function get subject() : String
      {
         return this._subject;
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function get sender() : String
      {
         return this._sender;
      }
   }
}
