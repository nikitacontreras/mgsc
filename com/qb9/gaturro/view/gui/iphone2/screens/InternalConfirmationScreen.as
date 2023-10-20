package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.IPhone2ConfirmationMC;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   
   internal class InternalConfirmationScreen extends BaseIPhone2Screen
   {
       
      
      public function InternalConfirmationScreen(param1:IPhone2Modal, param2:String, param3:String)
      {
         super(param1,new IPhone2ConfirmationMC(),{"send":this.ok});
         asset.field.text = param2.toUpperCase();
      }
      
      override protected function backButton() : void
      {
         this.cancel();
      }
      
      protected function cancel() : void
      {
      }
      
      protected function ok() : void
      {
      }
      
      protected function alsoBlock() : void
      {
      }
   }
}
