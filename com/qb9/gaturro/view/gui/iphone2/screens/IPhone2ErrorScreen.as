package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   
   public final class IPhone2ErrorScreen extends InternalWaitingScreen
   {
       
      
      private var data:InternalErrorData;
      
      public function IPhone2ErrorScreen(param1:IPhone2Modal, param2:InternalErrorData)
      {
         super(param1);
         this.data = param2;
         this.init();
      }
      
      private function init() : void
      {
         show(this.data.message,this.proceed);
      }
      
      private function proceed() : void
      {
         back(this.data.state);
      }
      
      override public function dispose() : void
      {
         this.data = null;
         super.dispose();
      }
   }
}
