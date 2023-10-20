package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.socialnet.SocialNet;
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public dynamic class AppPicapon extends CellPhoneApp
   {
       
      
      public function AppPicapon()
      {
         super();
         _scActionName = "socialnet";
      }
      
      override public function get enabled() : Boolean
      {
         return SocialNet.uiEenabled;
      }
      
      override protected function shortCutOnstage() : void
      {
         super.shortCutOnstage();
      }
   }
}
