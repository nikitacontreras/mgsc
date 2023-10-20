package com.qb9.gaturro.view.components.banner.verano2018
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.service.events.gui.PartyInviteFriendsBanner;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PoolInviteFriends extends PartyInviteFriendsBanner
   {
       
      
      private var hasClubPassport:Boolean = false;
      
      private var club:String;
      
      public function PoolInviteFriends(param1:String = "PoolInviteFriendsRiver", param2:String = "PoolInviteFriendsRiverAsset")
      {
         if(api.hasPassportType("river"))
         {
            param1 = "PoolInviteFriendsRiver";
            param2 = "PoolInviteFriendsRiverAsset";
            this.hasClubPassport = true;
            this.club = "RIVER";
            api.trackEvent("RIVER:PILETA:TELEFONO","abre_vip");
         }
         if(api.hasPassportType("boca"))
         {
            param1 = "PoolInviteFriendsBoca";
            param2 = "PoolInviteFriendsBocaAsset";
            this.hasClubPassport = true;
            this.club = "BOCA";
            api.trackEvent("BOCA:PILETA:TELEFONO","abre_vip");
         }
         this.visible = false;
         super(param1,param2);
      }
      
      override protected function ready() : void
      {
         if(this.hasClubPassport)
         {
            this.visible = true;
            super.ready();
         }
         else if(api.room.id == 69404)
         {
            api.showBannerModal("pasaporteRiver");
         }
         else
         {
            api.showBannerModal("pasaporteBoca");
         }
      }
      
      override protected function onInviteFriend(param1:MouseEvent) : void
      {
         logger.debug(this,"sending mail");
         var _loc2_:String = String(server.time.toString());
         var _loc3_:String = String(api.room.id.toString());
         var _loc4_:String = "|" + "pool" + ":" + _loc3_ + ":" + _loc2_;
         api.roomView.gaturroMailer.sendMail((param1.currentTarget as MovieClip).data,api.user.username + " te invitó a la pileta" + _loc4_,"TE INVITARON A UNA PILETA");
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.CLICK,this.onInviteFriend);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         (param1.currentTarget as MovieClip).gotoAndStop("click");
         if(this.club)
         {
            api.trackEvent(this.club + ":PILETA:TELEFONO","envia");
         }
      }
   }
}
