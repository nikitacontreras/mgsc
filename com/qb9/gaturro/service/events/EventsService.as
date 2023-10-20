package com.qb9.gaturro.service.events
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.service.events.billboard.BillboardService;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class EventsService extends EventDispatcher
   {
      
      private static const PARTY_TIMEOUT_THRESHOLD:int = 3000;
      
      public static const IS_OVER:String = "partyOver";
      
      public static const TICK:String = "partyTick";
      
      public static const PARTY_CREATED:String = "partyCreated";
       
      
      private var eventsLinks:Array;
      
      private var currentEvent:com.qb9.gaturro.service.events.EventData;
      
      private var ticker:Timer;
      
      private var billboard:BillboardService;
      
      public function EventsService()
      {
         super();
         if(api)
         {
            this.createService();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.whenAPIAddedToContext);
         }
      }
      
      private function tick(param1:Event) : void
      {
         dispatchEvent(new Event(TICK));
         if(this.calculateRemainingTime() < 0)
         {
            dispatchEvent(new Event(IS_OVER));
            this.dispose();
         }
      }
      
      public function dispose(param1:Event = null) : void
      {
         if(this.ticker)
         {
            this.ticker.removeEventListener(TimerEvent.TIMER,this.tick);
         }
         api.setAvatarAttribute(EventsAttributeEnum.EVENT_ATTR,"");
         api.setAvatarAttribute("effect2","");
         this.currentEvent = null;
      }
      
      public function get links() : Array
      {
         return this.eventsLinks;
      }
      
      public function get eventData() : com.qb9.gaturro.service.events.EventData
      {
         return this.currentEvent;
      }
      
      public function calculateRemainingTime() : Number
      {
         if(!this.currentEvent)
         {
            return -1;
         }
         return this.currentEvent.remainingTime;
      }
      
      public function get imHost() : Boolean
      {
         return Boolean(this.currentEvent) && this.currentEvent.host == api.user.username;
      }
      
      public function get eventRunning() : Boolean
      {
         if(!this.currentEvent)
         {
            return false;
         }
         return this.currentEvent.remainingTime > 0;
      }
      
      public function set links(param1:Array) : void
      {
         this.eventsLinks = param1;
      }
      
      public function inviteToEvent(param1:String) : void
      {
         if(this.currentEvent)
         {
            this.dispose();
         }
         this.currentEvent = com.qb9.gaturro.service.events.EventData.fromString(param1);
         api.setAvatarAttribute(EventsAttributeEnum.EVENT_ATTR,this.currentEvent.asJSONString());
         switch(this.currentEvent.type)
         {
            case EventsAttributeEnum.ELITE_PARTY:
               api.showModal("LA FIESTA DE " + this.currentEvent.host,"information","VISITANDO");
               setTimeout(this.gotoEvent,2000);
               break;
            case EventsAttributeEnum.WEDDING_PARTY:
               api.showModal("LA FIESTA DE " + this.currentEvent.host,"information","VISITANDO");
               setTimeout(this.gotoEvent,2000);
               break;
            case EventsAttributeEnum.BIRTHDAY_PARTY:
               api.showModal("LA FIESTA DE " + this.currentEvent.host,"information","VISITANDO");
               setTimeout(this.gotoEvent,2000);
               break;
            case EventsAttributeEnum.CARNAVAL_PARTY:
               this.gotoEvent();
               break;
            case EventsAttributeEnum.GATUBERS_LIVE:
               this.gotoEvent();
               break;
            case EventsAttributeEnum.SERETUBERS:
               this.gotoEvent();
               break;
            case EventsAttributeEnum.MATEADA_PARTY:
               this.gotoEvent();
               break;
            default:
               logger.debug(this,"tenés que agregar el tipo de evento aca...");
         }
         this.initEventTimer();
      }
      
      public function gotoEvent() : void
      {
         logger.debug(this,"gotoEvent()");
         var _loc1_:Point = new Point();
         _loc1_.x = this.imHost ? 5 : 20;
         _loc1_.y = 4;
         if(this.currentEvent.type == EventsAttributeEnum.ELITE_PARTY)
         {
            _loc1_.x = 22;
            _loc1_.y = 7;
         }
         else if(this.currentEvent.type == EventsAttributeEnum.SERETUBERS)
         {
            _loc1_.x = 6;
            _loc1_.y = 5;
            if(this.currentEvent.host != api.user.username)
            {
               _loc1_.x = 20;
            }
            _loc1_.y = 1;
         }
         else if(this.currentEvent.type == EventsAttributeEnum.GATUBERS_LIVE)
         {
            _loc1_.x = 6;
            _loc1_.y = 5;
         }
         else if(this.currentEvent.type != EventsAttributeEnum.CARNAVAL_PARTY)
         {
            _loc1_.x = 12;
            _loc1_.y = 10;
         }
         else
         {
            _loc1_.x = this.imHost ? 5 : 20;
            _loc1_.y = 4;
         }
         if(this.currentEvent)
         {
            if(this.calculateRemainingTime() > PARTY_TIMEOUT_THRESHOLD)
            {
               api.changeRoomXY(this.currentEvent.roomID,_loc1_.x,_loc1_.y);
            }
         }
      }
      
      public function get billboardService() : BillboardService
      {
         return this.billboard;
      }
      
      private function createService() : void
      {
         this.billboard = new BillboardService();
         this.eventsLinks = new Array();
         var _loc1_:String = api.getAvatarAttribute(EventsAttributeEnum.EVENT_ATTR) as String;
         if(!_loc1_)
         {
            return;
         }
         if(com.qb9.gaturro.service.events.EventData.isValidData(_loc1_))
         {
            this.currentEvent = com.qb9.gaturro.service.events.EventData.fromString(_loc1_);
            if(this.currentEvent.remainingTime > 0)
            {
               this.initEventTimer();
            }
            else
            {
               this.dispose();
            }
         }
      }
      
      private function whenAPIAddedToContext(param1:ContextEvent = null) : void
      {
         if(param1.instanceType != GaturroRoomAPI)
         {
            return;
         }
         Context.instance.removeEventListener(ContextEvent.ADDED,this.whenAPIAddedToContext);
         this.createService();
      }
      
      private function initEventTimer() : void
      {
         this.ticker = new Timer(1000,0);
         this.ticker.addEventListener(TimerEvent.TIMER,this.tick);
         this.ticker.start();
      }
      
      public function createEvent(param1:Object) : void
      {
         if(this.currentEvent)
         {
            this.dispose();
         }
         this.currentEvent = com.qb9.gaturro.service.events.EventData.fromObject(param1);
         api.setAvatarAttribute(EventsAttributeEnum.EVENT_ATTR,this.currentEvent.asJSONString());
         if(!api.isCitizen)
         {
            api.setSession(EventsAttributeEnum.PARTY_LIMIT_ATTR,true);
         }
         this.initEventTimer();
         dispatchEvent(new Event(PARTY_CREATED));
      }
   }
}
