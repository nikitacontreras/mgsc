package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.mambo.net.mail.MailMessage;
   
   public final class IPhone2DeleteMailScreen extends InternalConfirmationScreen
   {
       
      
      private var mails:Array;
      
      public function IPhone2DeleteMailScreen(param1:IPhone2Modal, param2:Object)
      {
         if(param2 is MailMessage)
         {
            this.mails = [param2];
         }
         else
         {
            this.mails = param2 as Array;
         }
         super(param1,this.message,this.blockMessage);
         this.init();
      }
      
      private function get blockMessage() : String
      {
         return region.getText("¿También bloquear a") + " " + this.username + "?";
      }
      
      override protected function alsoBlock() : void
      {
         this.ok();
      }
      
      private function get message() : String
      {
         if(this.singleMail())
         {
            return region.getText("¿Seguro que quieres borrar el mensaje de") + " " + this.username + "?";
         }
         return region.getText("¿Seguro que quieres borrar los mensajes?") + " (" + this.mails.length.toString() + ")";
      }
      
      protected function singleMail() : Boolean
      {
         return this.mails.length == 1;
      }
      
      private function init() : void
      {
         var _loc1_:MailMessage = null;
         setText("send.field","Borrar");
         if(this.singleMail())
         {
            _loc1_ = MailMessage(this.mails[0]);
            if(_loc1_.isFromSystem || settings.socialNet && this.username == region.key("feedbackMessageName"))
            {
               setVisible("send2",false);
               setVisible("field2",false);
            }
         }
         else
         {
            setVisible("redFrame",false);
            setVisible("send2",false);
            setVisible("field2",false);
         }
      }
      
      private function get username() : String
      {
         if(this.singleMail())
         {
            return !!this.mails[0].isFromSystem ? IPhone2InboxScreen.MODERATOR_NAME : String(this.mails[0].sender);
         }
         return "";
      }
      
      override protected function cancel() : void
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
      
      override protected function ok() : void
      {
         goto(IPhone2Screens.DELETING_MAIL,this.mails);
      }
      
      override public function dispose() : void
      {
         this.mails = null;
         super.dispose();
      }
   }
}
