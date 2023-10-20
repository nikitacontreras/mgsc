package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.gaturro.world.community.CommunityManager;
   import flash.events.Event;
   
   public final class IPhone2RemovingFriendScreen extends InternalWaitingScreen
   {
       
      
      private var buddy:Buddy;
      
      private var hasFailed:Boolean = false;
      
      public function IPhone2RemovingFriendScreen(param1:IPhone2Modal, param2:Buddy)
      {
         super(param1);
         this.buddy = param2;
         this.hasFailed = false;
         this.init();
      }
      
      private function init() : void
      {
         user.community.addEventListener(CommunityManager.CONFIRM_RELATION,this.proceedOk);
         user.community.addEventListener(CommunityManager.ERROR,this.proceedError);
         user.community.destroyRelation(this.buddy.username,this.buddy.accountId);
         tracker.event(TrackCategories.BUDDIES,TrackActions.REMOVE_BUDDY);
      }
      
      private function proceedError(param1:Event) : void
      {
         show(region.getText("no se pudo remover a") + " " + this.buddy.username,this.goBack);
         this.hasFailed = true;
      }
      
      override public function dispose() : void
      {
         user.community.removeEventListener(CommunityManager.CONFIRM_RELATION,this.proceedOk);
         user.community.removeEventListener(CommunityManager.ERROR,this.proceedError);
         super.dispose();
      }
      
      private function proceedOk(param1:Event) : void
      {
         show(region.getText("se ha removido a") + " " + this.buddy.username,this.goBack);
         audio.addLazyPlay("celuDel");
         this.hasFailed = false;
      }
      
      private function goBack() : void
      {
         var _loc1_:Object = null;
         if(this.hasFailed)
         {
            _loc1_ = new Object();
            _loc1_.buddy = this.buddy;
            back(IPhone2Screens.SEE_FRIEND,_loc1_);
         }
         else
         {
            back(IPhone2Screens.FRIENDS);
         }
      }
   }
}
