package com.qb9.gaturro.service.events.events.gatubers
{
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.events.BaseEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.display.DisplayObjectContainer;
   
   public class GatubersLive extends BaseEvent
   {
       
      
      public function GatubersLive(param1:EventsService)
      {
         super(param1);
      }
      
      override public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         trace("MENSAJE OWNER BASE EVENT OVERRIDE");
         trace(param1);
      }
      
      override public function configureBackground(param1:DisplayObjectContainer) : void
      {
         trace("CONFIGURANDO BACKGROUND BASE EVENT OVERRIDE");
      }
   }
}
