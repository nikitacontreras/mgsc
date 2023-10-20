package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public class AppBola8 extends CellPhoneApp
   {
       
      
      public function AppBola8()
      {
         super();
         _scActionName = "bola8";
         _appName = "BOLA 8";
         _appDescription = "NO TENGAS DUDAS, LA BOLA 8 TIENE TODAS LAS RESPUESTAS.";
         _marketView = new Bola8MV();
         _value = 500;
      }
   }
}
