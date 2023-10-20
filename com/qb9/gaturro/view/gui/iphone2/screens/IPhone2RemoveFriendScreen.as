package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   
   public final class IPhone2RemoveFriendScreen extends InternalConfirmationScreen
   {
       
      
      private var removedBuddy:Buddy;
      
      public function IPhone2RemoveFriendScreen(param1:IPhone2Modal, param2:Buddy)
      {
         super(param1,region.getText("¿SEGURO QUE QUIERES BORRAR A") + " " + param2.username + "?",region.getText("¿Y TAMBIÉN BLOQUEAR A") + " " + param2.username + "?");
         this.removedBuddy = param2;
         this.init();
      }
      
      private function init() : void
      {
         setText("send.field","Borrar");
      }
      
      override protected function ok() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.buddy = this.removedBuddy;
         goto(IPhone2Screens.REMOVING_FRIEND,_loc1_);
      }
      
      override protected function cancel() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.buddy = this.removedBuddy;
         back(IPhone2Screens.SEE_FRIEND,_loc1_);
      }
   }
}
