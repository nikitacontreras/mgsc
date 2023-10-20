package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public class AppPodometro extends CellPhoneApp
   {
      
      public static var running:Boolean;
      
      public static var steps:uint;
       
      
      public function AppPodometro()
      {
         super();
         _scActionName = "podometro";
         _appName = "PODÓMETRO";
         _appDescription = "¡ENTÉRATE LA CANTIDAD DE PASOS QUE DAS EN MUNDO GATURRO!";
         _marketView = new PodometroMV();
         _value = 0;
      }
      
      public static function addSteps(param1:uint) : void
      {
         if(running)
         {
            steps += param1;
         }
      }
      
      override protected function shortCutOnstage() : void
      {
         super.shortCutOnstage();
      }
   }
}
