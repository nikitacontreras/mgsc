package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   import flash.display.DisplayObject;
   
   public final class IPhone2FriendsScreen extends InternalFriendsScreen
   {
       
      
      private var backToMainMenu:Boolean = true;
      
      public function IPhone2FriendsScreen(param1:IPhone2Modal, param2:int, param3:Boolean)
      {
         super(param1,param2);
         this.backToMainMenu = param3;
         this.init();
      }
      
      private function init() : void
      {
      }
      
      override protected function backButton() : void
      {
         if(this.backToMainMenu)
         {
            back(IPhone2Screens.MENU);
         }
         else
         {
            back(IPhone2Screens.FRIENDS);
         }
      }
      
      override protected function selected(param1:Object) : void
      {
         var _loc2_:Buddy = param1 as Buddy;
         param1 = new Object();
         param1.buddy = _loc2_;
         goto(IPhone2Screens.SEE_FRIEND,param1);
      }
      
      override protected function map(param1:Object) : DisplayObject
      {
         return super.map(param1);
      }
   }
}
