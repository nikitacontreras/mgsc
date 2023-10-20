package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   
   public class InternalFriendsScreen extends InternalBuddiesListScreen
   {
       
      
      public function InternalFriendsScreen(param1:IPhone2Modal, param2:int = 4)
      {
         super(param1,region.getText("Comunidad"),param2);
         this.init();
      }
      
      private function init() : void
      {
      }
   }
}
