package com.qb9.gaturro.service.events.events
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class BaseEvent extends EventDispatcher
   {
       
      
      protected var messages:Dictionary;
      
      protected var eventService:EventsService;
      
      public function BaseEvent(param1:EventsService)
      {
         super();
         this.eventService = param1;
      }
      
      public function onEnterFrame(param1:Event) : void
      {
      }
      
      public function configureFeatures() : void
      {
      }
      
      public function configureSceneObjects(param1:Array) : void
      {
      }
      
      public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = param1.attribute.value as String;
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(String(param1.attribute.value));
         var _loc4_:Function;
         (_loc4_ = this.messages[_loc3_.action])(_loc3_);
      }
      
      public function configureBackground(param1:DisplayObjectContainer) : void
      {
      }
      
      public function configureNpcs(param1:NpcRoomSceneObjectView) : void
      {
      }
      
      public function call(param1:String, ... rest) : void
      {
         this[param1](rest);
      }
      
      public function dispose() : void
      {
      }
   }
}
