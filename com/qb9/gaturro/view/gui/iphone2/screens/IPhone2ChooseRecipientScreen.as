package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   
   public final class IPhone2ChooseRecipientScreen extends InternalFriendsScreen
   {
       
      
      private var data:InternalMessageData;
      
      public function IPhone2ChooseRecipientScreen(param1:IPhone2Modal, param2:InternalMessageData = null)
      {
         super(param1,param2.friendType != -1 ? param2.friendType : Buddy.FRIEND);
         this.data = param2;
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.COMPOSE,this.data);
      }
      
      override protected function selected(param1:Object) : void
      {
         var _loc2_:Buddy = param1 as Buddy;
         back(IPhone2Screens.COMPOSE,new InternalMessageData(_loc2_.username.toUpperCase(),!!this.data ? this.data.message : "",this.data !== null && this.data.forceWhiteList));
      }
      
      override protected function gotoOtherFriendsScreen(param1:int) : void
      {
         this.data.friendType = param1;
         goto(IPhone2Screens.CHOOSE_RECIPIENT,this.data);
      }
   }
}
