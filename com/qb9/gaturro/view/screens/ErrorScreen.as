package com.qb9.gaturro.view.screens
{
   import assets.ErrorScreenMC;
   import com.qb9.gaturro.globals.region;
   import flash.net.URLLoader;
   
   public final class ErrorScreen extends ErrorScreenMC
   {
       
      
      private var loader:URLLoader;
      
      public function ErrorScreen(param1:String)
      {
         super();
         field.wordWrap = true;
         region.setText(field,param1.toUpperCase());
      }
   }
}
