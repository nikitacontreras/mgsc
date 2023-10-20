package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public dynamic class AppMensajes extends CellPhoneApp
   {
       
      
      private var _mailer:GaturroMailer;
      
      public function AppMensajes()
      {
         super();
         _scActionName = "messages";
      }
      
      override protected function shortCutOnstage() : void
      {
         super.shortCutOnstage();
         this._mailer = user.cellPhone.mailer;
      }
   }
}
