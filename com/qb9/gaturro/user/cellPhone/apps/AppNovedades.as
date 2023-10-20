package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.cellPhone.AppShortCut;
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   import com.qb9.gaturro.user.cellPhone.NotificationStatus;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   
   public class AppNovedades extends CellPhoneApp
   {
       
      
      public function AppNovedades()
      {
         super();
         _scActionName = "news";
         _appName = "NOVEDADES";
         _appDescription = "";
      }
      
      override protected function shortCutOnstage() : void
      {
         super.shortCutOnstage();
      }
      
      override protected function setNotification() : void
      {
         super.setNotification();
         var _loc1_:* = !GaturroProfile(user.profile).hasReadNews;
         if(_loc1_)
         {
            AppShortCut(_scView).notificationStatus = NotificationStatus.ALERT;
         }
      }
   }
}
