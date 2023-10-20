package com.qb9.gaturro.service.events.roomviews
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.events.BaseEvent;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class EventsRoomView extends GaturroRoomView
   {
       
      
      protected var currentEvent:BaseEvent;
      
      protected var eventsService:EventsService;
      
      private var avatars:Array;
      
      public function EventsRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
         this.eventsService = Context.instance.getByType(EventsService) as EventsService;
         if(this.eventsService)
         {
            this.setup();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onEventServiceAdded);
         }
      }
      
      override protected function disposeChild(param1:DisplayObject) : void
      {
         if(!param1)
         {
            return;
         }
         super.disposeChild(param1);
      }
      
      protected function kick() : void
      {
      }
      
      override protected function tileSelected(param1:Tile) : void
      {
         if(cursor)
         {
            cursor.click();
         }
         room.tileSelected(param1);
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         var _loc3_:EventData = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            _loc2_.attributes.owner.addCustomAttributeListener("message",this.currentEvent.onMessageBroadcasted);
            this.avatars.push(_loc2_);
            _loc3_ = EventData.fromString(_loc2_.attributes[EventsAttributeEnum.EVENT_ATTR]);
            if(this.eventsService.eventData.type != EventsAttributeEnum.CARNAVAL_PARTY && this.eventsService.eventData.host != _loc3_.host)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      private function onEventServiceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == EventsService)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onEventServiceAdded);
            this.eventsService = param1.instance as EventsService;
            this.setup();
         }
      }
      
      private function onEventOver(param1:Event) : void
      {
         this.eventsService.removeEventListener(EventsService.IS_OVER,this.onEventOver);
         this.kick();
      }
      
      private function removeMessageListener() : void
      {
         var _loc1_:Avatar = null;
         for each(_loc1_ in this.avatars)
         {
            _loc1_.attributes.owner.removeCustomAttributeListener("message",this.currentEvent.onMessageBroadcasted);
         }
         this.avatars = null;
      }
      
      protected function onTick(param1:Event) : void
      {
      }
      
      protected function setup() : void
      {
         this.eventsService.addEventListener(EventsService.TICK,this.onTick);
         this.eventsService.addEventListener(EventsService.IS_OVER,this.onEventOver);
         this.avatars = [];
      }
      
      override public function dispose() : void
      {
         this.eventsService.removeEventListener(EventsService.TICK,this.onTick);
         this.eventsService.removeEventListener(EventsService.IS_OVER,this.onEventOver);
         if(this.currentEvent)
         {
            this.currentEvent.dispose();
         }
         super.dispose();
      }
   }
}
