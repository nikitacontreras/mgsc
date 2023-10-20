package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.IphoneMessagesMenuMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.mambo.net.mail.MailerEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Iphone2MessagesMenu extends InternalTitledScreen
   {
       
      
      private var mailer:GaturroMailer;
      
      public function Iphone2MessagesMenu(param1:IPhone2Modal, param2:GaturroMailer)
      {
         super(param1,"MENSAJES",new IphoneMessagesMenuMC(),{
            "inbox":this.clickedInbox,
            "inboxNews":this.clickedInboxNews,
            "compose":this.clickedCompose
         });
         this.mailer = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.mailer.addEventListener(MailerEvent.CHANGED,this.onMailerChange);
      }
      
      private function clickedInboxNews() : void
      {
         goto(IPhone2Screens.INBOX_NOTIFICATIONS);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.mailer.removeEventListener(MailerEvent.CHANGED,this.onMailerChange);
      }
      
      private function updateContent() : void
      {
         var _loc5_:GaturroMailMessage = null;
         var _loc6_:TextField = null;
         var _loc7_:TextField = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.mailer.mails.length)
         {
            _loc5_ = this.mailer.mails[_loc3_] as GaturroMailMessage;
            _loc1_ += _loc5_.isNotificationMail && !_loc5_.isRead ? 1 : 0;
            _loc2_ += !_loc5_.isNotificationMail && !_loc5_.isRead ? 1 : 0;
            _loc3_++;
         }
         var _loc4_:MovieClip;
         if((_loc4_ = this.asset.getChildByName("content") as MovieClip) != null)
         {
            if((_loc6_ = _loc4_.getChildByName("newMessages") as TextField) != null && _loc2_ > 0)
            {
               if(_loc2_ > 1)
               {
                  _loc8_ = (_loc8_ = String(region.getText("TIENES %U NUEVOS MENSAJES"))).replace("%U",_loc2_);
                  _loc6_.text = _loc8_;
               }
               else
               {
                  _loc6_.text = region.getText("TIENES 1 NUEVO MENSAJE");
               }
            }
            else
            {
               _loc6_.visible = false;
            }
            if((_loc7_ = _loc4_.getChildByName("newNotifications") as TextField) != null && _loc1_ > 0)
            {
               if(_loc1_ > 1)
               {
                  _loc9_ = (_loc9_ = String(region.getText("TIENES %U NUEVAS NOTIFICACIONES"))).replace("%U",_loc1_);
                  _loc7_.text = _loc9_;
               }
               else
               {
                  _loc7_.text = region.getText("TIENES 1 NUEVA NOTIFICACION");
               }
            }
            else
            {
               _loc7_.visible = false;
            }
         }
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function onMailerChange(param1:MailerEvent) : void
      {
         this.updateContent();
      }
      
      private function clickedCompose() : void
      {
         goto(IPhone2Screens.COMPOSE);
      }
      
      private function clickedInbox() : void
      {
         goto(IPhone2Screens.INBOX);
      }
   }
}
