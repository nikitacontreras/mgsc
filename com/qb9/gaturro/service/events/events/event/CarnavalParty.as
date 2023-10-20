package com.qb9.gaturro.service.events.events.event
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.events.BaseEvent;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import config.AdminControl;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class CarnavalParty extends BaseEvent
   {
       
      
      private var modifyRoom:NpcRoomSceneObjectView;
      
      public function CarnavalParty(param1:EventsService)
      {
         super(param1);
         this.setupMesssages();
      }
      
      private function setupMesssages() : void
      {
         messages = new Dictionary();
      }
      
      override public function configureNpcs(param1:NpcRoomSceneObjectView) : void
      {
         var _loc2_:NpcRoomSceneObjectView = param1 as NpcRoomSceneObjectView;
         var _loc3_:String = _loc2_.object.name;
         if(_loc3_ == "reyMomo2018/props.modify_so")
         {
            this.modifyRoom = _loc2_;
         }
      }
      
      private function endSession() : void
      {
         if(eventService.imHost)
         {
         }
      }
      
      private function exit() : void
      {
         api.changeRoomXY(51688753,5,5);
      }
      
      override public function configureSceneObjects(param1:Array) : void
      {
      }
      
      override public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         var _loc2_:String = param1.attribute.value as String;
         if(AdminControl.validAdminEvent(_loc2_))
         {
            this.modifyRoom.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE));
         }
      }
   }
}
