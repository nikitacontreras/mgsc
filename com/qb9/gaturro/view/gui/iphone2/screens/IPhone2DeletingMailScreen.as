package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.mambo.net.mail.MailMessage;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.mail.MailerEvent;
   
   public final class IPhone2DeletingMailScreen extends InternalWaitingScreen
   {
       
      
      private var mailer:Mailer;
      
      private var mails:Array;
      
      public function IPhone2DeletingMailScreen(param1:IPhone2Modal, param2:Mailer, param3:Object)
      {
         super(param1);
         this.mailer = param2;
         if(param3 is MailMessage)
         {
            this.mails = [param3];
         }
         else
         {
            this.mails = param3 as Array;
         }
         this.init();
      }
      
      private function goToInbox() : void
      {
         var _loc1_:GaturroMailMessage = GaturroMailMessage(this.mails[0]);
         if(_loc1_.isNotificationMail)
         {
            back(IPhone2Screens.INBOX_NOTIFICATIONS);
         }
         else
         {
            back(IPhone2Screens.INBOX);
         }
      }
      
      protected function singleMail() : Boolean
      {
         return this.mails.length == 1;
      }
      
      private function proceed(param1:MailerEvent) : void
      {
         var _loc2_:String = null;
         if(param1.mail)
         {
            _loc2_ = "";
            if(this.singleMail())
            {
               _loc2_ = String(region.getText("El mensaje se ha borrado"));
            }
            else
            {
               _loc2_ = String(region.getText("Los mensajes se han borrado"));
            }
            show(_loc2_,this.goToInbox);
            audio.addLazyPlay("celuDel");
         }
         else
         {
            show(region.getText("No se pudo borrar el mensaje"),this.goToMail);
         }
      }
      
      private function init() : void
      {
         this.mailer.addEventListener(MailerEvent.REMOVED,this.proceed);
         if(this.singleMail())
         {
            this.mailer.deleteMail(this.mails[0].id);
         }
         else
         {
            this.mailer.deleteMails(this.ids);
         }
      }
      
      protected function get ids() : Array
      {
         var _loc2_:MailMessage = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.mails)
         {
            _loc1_.push(_loc2_.id);
         }
         return _loc1_;
      }
      
      private function goToMail() : void
      {
         var _loc1_:GaturroMailMessage = GaturroMailMessage(this.mails[0]);
         if(this.singleMail())
         {
            back(IPhone2Screens.READ_MAIL,_loc1_);
         }
         else if(_loc1_.isNotificationMail)
         {
            back(IPhone2Screens.INBOX_NOTIFICATIONS);
         }
         else
         {
            back(IPhone2Screens.INBOX);
         }
      }
      
      override public function dispose() : void
      {
         this.mailer.removeEventListener(MailerEvent.REMOVED,this.proceed);
         this.mailer = null;
         this.mails = null;
         super.dispose();
      }
   }
}
