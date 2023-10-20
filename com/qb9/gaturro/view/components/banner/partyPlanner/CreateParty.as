package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CreateParty extends BannerState
   {
       
      
      public function CreateParty(param1:PartyPlanner)
      {
         super(param1);
      }
      
      private function partyCreated(param1:Event = null) : void
      {
         logger.info(this,"partyCreated");
         api.levelManager.addSocialExp(50);
         banner.information.gotoAndStop("started");
         banner.action.visible = true;
         banner.action.label.text = "IR A LA FIESTA";
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
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
         banner.information.gotoAndStop("creating");
         api.trackEvent("FIESTAS:PLANNER_BANNER","create");
         this.createParty();
      }
      
      private function givePrizes() : void
      {
         var _loc4_:Array = ["prizes_0","prizes_1","prizes_2"];
         if(banner.givingPrizes != -1)
         {
            logger.debug(this,"givingPrizes",banner.givingPrizes);
            api.giveUser("galaPremios2017/props.estatuaDoradaBag",banner.settings.prizesMenu[_loc4_[banner.givingPrizes]].qty[0]);
            api.giveUser("galaPremios2017/props.estatuaPlataBag",banner.settings.prizesMenu[_loc4_[banner.givingPrizes]].qty[1]);
            api.giveUser("galaPremios2017/props.estatuaBronzeBag",banner.settings.prizesMenu[_loc4_[banner.givingPrizes]].qty[2]);
         }
      }
      
      private function createParty() : void
      {
         var _loc1_:Timeout = null;
         if(this.canBuy(banner.total()))
         {
            api.setProfileAttribute("system_coins",api.user.attributes.coins - banner.total());
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:TYPE",banner.result.type);
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:DURATION",banner.result.duration.toString());
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:FEATURES",banner.result.features);
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:PRIZES",banner.givingPrizes.toString());
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:MATEADA",banner.mateBackgroundPrice.toString());
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:PUBLIC",banner.result.isPublic.toString());
            api.trackEvent("FIESTAS:PLANNER_BANNER:CREATE:TOTAL",banner.total().toString());
            _loc1_ = new Timeout(this.partyCreated,1000);
            banner.result.start = server.time;
            if(banner.result.type == EventsAttributeEnum.MATEADA_PARTY)
            {
               banner.result.roomID = EventsRoomsEnum.MATEADA[banner.mateBackground];
            }
            else
            {
               banner.result.roomID = EventsRoomsEnum.getPartyRoom(banner.result.type);
            }
            if(banner.result.type == EventsAttributeEnum.ELITE_PARTY)
            {
               this.givePrizes();
            }
            api.addParty(banner.result.asObject());
         }
         else
         {
            _loc1_ = new Timeout(this.partyForbidden,1000);
         }
         banner.taskRunner.add(_loc1_);
      }
      
      private function partyForbidden(param1:Event = null) : void
      {
         logger.info(this,"not enough mony");
         banner.information.gotoAndStop("nomoney");
      }
   }
}
