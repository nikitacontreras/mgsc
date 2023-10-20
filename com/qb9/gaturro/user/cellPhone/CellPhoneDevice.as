package com.qb9.gaturro.user.cellPhone
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import flash.events.EventDispatcher;
   
   public class CellPhoneDevice extends EventDispatcher
   {
       
      
      private var _apps:com.qb9.gaturro.user.cellPhone.CellPhoneAppsManager;
      
      private var _mailer:GaturroMailer;
      
      public function CellPhoneDevice()
      {
         super();
         this._apps = new com.qb9.gaturro.user.cellPhone.CellPhoneAppsManager();
      }
      
      public function get mailer() : GaturroMailer
      {
         return this._mailer;
      }
      
      public function get gatuStars() : int
      {
         if(user.profile.attributes.gatuStars != null && user.profile.attributes.gatuStars != "")
         {
            return int(user.profile.attributes.gatuStars);
         }
         return 0;
      }
      
      public function set mailer(param1:GaturroMailer) : void
      {
         this._mailer = param1;
      }
      
      public function get apps() : com.qb9.gaturro.user.cellPhone.CellPhoneAppsManager
      {
         return this._apps;
      }
      
      public function set gatuStars(param1:int) : void
      {
         user.profile.attributes.gatuStars = String(param1);
      }
   }
}
