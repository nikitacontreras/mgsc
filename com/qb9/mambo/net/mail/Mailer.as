package com.qb9.mambo.net.mail
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.mail.DeleteMailActionRequest;
   import com.qb9.mambo.net.requests.mail.MailMessageActionRequest;
   import com.qb9.mambo.net.requests.mail.MailsDataRequest;
   import com.qb9.mambo.net.requests.mail.MarkMailAsReadActionRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public class Mailer extends MamboObject
   {
       
      
      protected var _mails:Array;
      
      private var net:NetworkManager;
      
      protected var _unreadMails:int;
      
      public function Mailer(param1:NetworkManager)
      {
         this._mails = [];
         super();
         this.net = param1;
         this.init();
      }
      
      protected function addToList(param1:MailMessage) : void
      {
         this._mails.unshift(param1);
         this.changed();
      }
      
      public function deleteMail(param1:Number) : void
      {
         var _loc2_:MailMessage = this.byId(param1);
         if(_loc2_.serverMessage)
         {
            this.net.sendAction(new DeleteMailActionRequest(param1));
         }
         else
         {
            this._mailDeleted(_loc2_);
            this.dispatch(MailerEvent.REMOVED,_loc2_);
         }
      }
      
      protected function buildMail(param1:Mobject) : MailMessage
      {
         var _loc2_:MailMessage = new MailMessage();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
      
      private function assert(param1:NetworkManagerEvent, param2:Boolean) : Boolean
      {
         if(!param1.success)
         {
            return false;
         }
         var _loc3_:Array = param1.mobject.getIntegerArray("mails");
         if(_loc3_)
         {
            return true;
         }
         var _loc4_:Number = param1.mobject.getInteger("mailId");
         var _loc5_:*;
         if((_loc5_ = this.byId(_loc4_) !== null) === param2)
         {
            return true;
         }
         warning(_loc4_,"was " + (param2 ? "" : "not ") + "expected to be in the list");
         return false;
      }
      
      private function getMailsFromEvent(param1:NetworkManagerEvent) : Array
      {
         var _loc4_:Number = NaN;
         var _loc2_:Array = param1.mobject.getIntegerArray("mails");
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc3_.push(this.byId(_loc4_));
         }
         return _loc3_;
      }
      
      protected function _mailRead(param1:MailMessage) : void
      {
         param1.read();
         this.changed();
      }
      
      protected function init() : void
      {
         this.net.addEventListener(NetworkManagerEvent.MAIL_DATA,this.initMails);
         this.net.sendAction(new MailsDataRequest());
      }
      
      public function byId(param1:Number) : MailMessage
      {
         var _loc2_:MailMessage = null;
         for each(_loc2_ in this._mails)
         {
            if(_loc2_.id === param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function markAsRead(param1:Number) : void
      {
         var _loc2_:MailMessage = this.byId(param1);
         if(Boolean(_loc2_) && !_loc2_.isRead)
         {
            if(_loc2_.serverMessage)
            {
               this.net.sendAction(new MarkMailAsReadActionRequest(param1));
            }
            else
            {
               this._mailRead(_loc2_);
            }
         }
      }
      
      private function mailAdded(param1:NetworkManagerEvent) : void
      {
         var _loc2_:MailMessage = null;
         if(this.assert(param1,false))
         {
            _loc2_ = this.buildMail(param1.mobject);
            this.addToList(_loc2_);
         }
         this.dispatch(MailerEvent.ADDED,_loc2_);
      }
      
      public function get mails() : Array
      {
         return this._mails.concat();
      }
      
      public function sendMail(param1:String, param2:Object, param3:String = null) : void
      {
         this.net.sendAction(new MailMessageActionRequest(param1,param2,param3));
      }
      
      private function mailDeleted(param1:NetworkManagerEvent) : void
      {
         var _loc2_:MailMessage = null;
         var _loc3_:Array = null;
         var _loc4_:MailMessage = null;
         if(this.assert(param1,true))
         {
            _loc3_ = this.getMailsFromEvent(param1);
            for each(_loc4_ in _loc3_)
            {
               this._mailDeleted(_loc4_);
            }
         }
         if(_loc3_.length > 0)
         {
            _loc2_ = _loc3_[0];
         }
         this.dispatch(MailerEvent.REMOVED,_loc2_);
      }
      
      private function getMailFromEvent(param1:NetworkManagerEvent) : MailMessage
      {
         return this.byId(param1.mobject.getInteger("mailId"));
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.MAIL_DATA,this.initMails);
         this.net.removeEventListener(NetworkManagerEvent.MAIL_DELETED,this.mailDeleted);
         this.net.removeEventListener(NetworkManagerEvent.MAIL_RECEIVED,this.mailAdded);
         this.net.removeEventListener(NetworkManagerEvent.MAIL_READ,this.mailRead);
         this.net = null;
         super.dispose();
      }
      
      protected function _mailDeleted(param1:MailMessage) : void
      {
         ArrayUtil.removeElement(this._mails,param1);
         this.changed();
      }
      
      private function initMails(param1:NetworkManagerEvent) : void
      {
         this._mails = map(param1.mobject.getMobjectArray("mails") || [],this.buildMail);
         this.net.addEventListener(NetworkManagerEvent.MAIL_RECEIVED,this.mailAdded);
         this.net.addEventListener(NetworkManagerEvent.MAIL_DELETED,this.mailDeleted);
         this.net.addEventListener(NetworkManagerEvent.MAIL_READ,this.mailRead);
         this.changed();
      }
      
      public function get unreadMails() : int
      {
         return (filter(this._mails,this.isNotRead) as Array).length;
      }
      
      public function deleteMails(param1:Array) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:MailMessage = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if((_loc4_ = this.byId(_loc3_)).serverMessage)
            {
               _loc2_.push(_loc3_);
            }
            else
            {
               this._mailDeleted(_loc4_);
               this.dispatch(MailerEvent.REMOVED,_loc4_);
            }
         }
         if(_loc2_.length > 0)
         {
            this.net.sendAction(new DeleteMailActionRequest(_loc2_));
         }
      }
      
      protected function changed() : void
      {
         this.dispatch(MailerEvent.CHANGED);
      }
      
      final override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new MailerEvent(param1,param2 as MailMessage));
      }
      
      private function mailRead(param1:NetworkManagerEvent) : void
      {
         if(!this.assert(param1,true))
         {
            return;
         }
         var _loc2_:MailMessage = this.getMailFromEvent(param1);
         this._mailRead(_loc2_);
      }
      
      protected function isNotRead(param1:MailMessage) : Boolean
      {
         return !param1.isRead;
      }
   }
}
