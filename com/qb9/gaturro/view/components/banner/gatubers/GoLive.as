package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import com.qb9.gaturro.service.events.roomviews.GatubersRoomView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GoLive extends BannerState
   {
       
      
      private var counterManager:GaturroCounterManager;
      
      public function GoLive(param1:GatubersLiveBanner)
      {
         super(param1);
      }
      
      private function freeUserBurningLikes() : void
      {
         this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         var _loc1_:Boolean = Boolean(this.counterManager) && this.counterManager.reachedMax(GatubersRoomView.LIKE_GIVED_COUNTER_TYPE);
         if(_loc1_)
         {
            this.counterManager.reset(GatubersRoomView.LIKE_GIVED_COUNTER_TYPE);
            api.trackEvent("GATUBERS:NO_VIP:AVAILABLE",api.user.username);
         }
      }
      
      private function goLive() : void
      {
         var _loc1_:Timeout = null;
         this.freeUserBurningLikes();
         banner.creating.visible = true;
         if(this.canBuy(banner.totalPrice.value))
         {
            api.setProfileAttribute("system_coins",api.user.attributes.coins - banner.totalPrice.value);
            _loc1_ = new Timeout(this.partyCreated,1000);
            banner.result.start = server.time;
            api.addParty(banner.result.asObject());
            Telemetry.getInstance().trackEvent("GATUBERS:CREATED:",EventsRoomsEnum.getGatubersType(banner.result.roomID).toString());
            Telemetry.getInstance().trackEvent("GATUBERS:DURATION:",banner.result.duration.toString());
         }
         else
         {
            _loc1_ = new Timeout(this.partyForbidden,1000);
         }
         banner.taskRunner.add(_loc1_);
      }
      
      private function onAction(param1:Event = null) : void
      {
         api.gotoParty();
      }
      
      private function canBuy(param1:int) : Boolean
      {
         return param1 > api.user.attributes.coins ? false : true;
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         this.goLive();
      }
      
      private function partyCreated(param1:Event = null) : void
      {
         banner.information.text = banner.settings.create.information;
         banner.action.visible = true;
         banner.action.label.text = banner.settings.create.action;
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
         banner.creating.visible = false;
         banner.readyClip.gotoAndStop("ok");
         banner.readyClip.visible = true;
      }
      
      private function partyForbidden(param1:Event = null) : void
      {
         logger.info(this,"not enough mony");
         Telemetry.getInstance().trackEvent("GATUBERS:CREATED:","noMoney");
         banner.information.text = banner.settings.create.nomony;
         banner.creating.visible = false;
         banner.readyClip.gotoAndStop("ok");
         banner.readyClip.visible = true;
      }
   }
}
