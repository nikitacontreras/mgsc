package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public class AppPiano extends CellPhoneApp
   {
       
      
      public function AppPiano()
      {
         super();
         _scActionName = "piano";
         _appName = "PIANO";
         _appDescription = "¿LISTO PARA INTERPRETAR UNA BELLA MELODÍA?";
         _marketView = new PianoMV();
         _value = 500;
      }
   }
}
