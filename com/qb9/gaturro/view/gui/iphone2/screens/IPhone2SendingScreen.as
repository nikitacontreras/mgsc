package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public final class IPhone2SendingScreen extends InternalWaitingScreen
   {
       
      
      private var mailer:Mailer;
      
      private var data:InternalMessageData;
      
      private var net:NetworkManager;
      
      public function IPhone2SendingScreen(param1:IPhone2Modal, param2:Mailer, param3:NetworkManager, param4:InternalMessageData)
      {
         super(param1);
         this.mailer = param2;
         this.net = param3;
         this.data = param4;
         this.init();
      }
      
      private function backToMenu() : void
      {
         back(IPhone2Screens.MENU);
      }
      
      private function handleMessage(param1:NetworkManagerEvent) : void
      {
         if(param1.success)
         {
            show("El mensaje se ha enviado con éxito",this.backToMenu);
            audio.addLazyPlay("celuSend");
         }
         else
         {
            show("No se pudo enviar el mensaje",this.backToCompose);
         }
      }
      
      private function init() : void
      {
         this.net.addEventListener(NetworkManagerEvent.MAIL_SENT,this.handleMessage);
         this.mailer.sendMail(this.data.user,this.data.message);
      }
      
      private function backToCompose() : void
      {
         back(IPhone2Screens.COMPOSE,this.data);
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.MAIL_SENT,this.handleMessage);
         this.net = null;
         this.data = null;
         this.mailer = null;
         super.dispose();
      }
   }
}
