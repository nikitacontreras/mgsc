package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.CellPhoneApp;
   
   public class AppSnakeGame extends CellPhoneApp
   {
       
      
      public function AppSnakeGame()
      {
         super();
         _scActionName = "snakegame";
         _appName = "SNAKE";
         _appDescription = "TAN ESCURRIDIZA COMO DIVERTIDA. ¡JUEGA, QUE NO MUERDE!";
         _marketView = new SnakeMV();
         _value = 500;
      }
   }
}
