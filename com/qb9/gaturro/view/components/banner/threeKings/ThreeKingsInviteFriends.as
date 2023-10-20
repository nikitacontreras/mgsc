package com.qb9.gaturro.view.components.banner.threeKings
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.gui.PartyInviteFriendsBanner;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ThreeKingsInviteFriends extends PartyInviteFriendsBanner
   {
       
      
      public function ThreeKingsInviteFriends()
      {
         super();
      }
      
      override protected function onInviteFriend(param1:MouseEvent) : void
      {
         logger.debug(this,"sending mail");
         api.roomView.gaturroMailer.sendMail((param1.currentTarget as MovieClip).data,api.user.username + " quiere que le dejes un regalo" + "|reyes","TE INVITARON A UNA FIESTA");
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.CLICK,this.onInviteFriend);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         (param1.currentTarget as MovieClip).gotoAndStop("click");
         Telemetry.getInstance().trackEvent("REYES:INVITER","MAIL_INVITATION_SENT");
      }
   }
}
