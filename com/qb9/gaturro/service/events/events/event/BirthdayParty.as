package com.qb9.gaturro.service.events.events.event
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.events.BaseEvent;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class BirthdayParty extends BaseEvent
   {
       
      
      private var sicka:NpcRoomSceneObjectView;
      
      private var torta:NpcRoomSceneObjectView;
      
      private var capitan:NpcRoomSceneObjectView;
      
      private var nik:NpcRoomSceneObjectView;
      
      private var pinata:NpcRoomSceneObjectView;
      
      private var bruja:NpcRoomSceneObjectView;
      
      public function BirthdayParty(param1:EventsService)
      {
         super(param1);
      }
      
      override public function configureBackground(param1:DisplayObjectContainer) : void
      {
         (param1 as MovieClip).layer2.username.text = eventService.eventData.host;
         if(eventService.eventData.feature(4))
         {
            (param1 as MovieClip).layer2.gotoAndStop("premium");
         }
      }
      
      private function hideTorta() : void
      {
         if(this.torta)
         {
            this.torta.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE));
         }
      }
      
      override public function configureNpcs(param1:NpcRoomSceneObjectView) : void
      {
         var _loc2_:NpcRoomSceneObjectView = param1 as NpcRoomSceneObjectView;
         var _loc3_:String = _loc2_.object.name;
         if(_loc3_.indexOf("tortaCumple1_so") != -1)
         {
            this.torta = _loc2_;
         }
         else if(_loc3_.indexOf("pinata_so") != -1)
         {
            this.pinata = _loc2_;
         }
         else if(_loc3_.indexOf("capitan_so") != -1)
         {
            this.capitan = _loc2_;
         }
         else if(_loc3_.indexOf("bruja_so") != -1)
         {
            this.bruja = _loc2_;
         }
         else if(_loc3_.indexOf("nik_so") != -1)
         {
            this.nik = _loc2_;
         }
         else if(_loc3_.indexOf("sicka_so") != -1)
         {
            this.sicka = _loc2_;
         }
      }
      
      private function hideNPCs() : void
      {
         var _loc1_:Event = new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE);
         if(this.nik)
         {
            this.nik.dispatchEvent(_loc1_);
         }
         if(this.sicka)
         {
            this.sicka.dispatchEvent(_loc1_);
         }
         if(this.bruja)
         {
            this.bruja.dispatchEvent(_loc1_);
         }
         if(this.capitan)
         {
            this.capitan.dispatchEvent(_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         this.stopAudio();
      }
      
      private function stopAudio() : void
      {
         api.stopSound("party2017/cumple_fiesta");
         api.stopSound("party2017/cumple_fiesta_tranqui");
      }
      
      override public function configureFeatures() : void
      {
         if(!eventService.eventData.feature(0))
         {
            setTimeout(this.hideTorta,1500);
         }
         if(!eventService.eventData.feature(1))
         {
            setTimeout(this.hidePinata,1500);
         }
         if(!eventService.eventData.feature(2))
         {
            api.setSession("partyMusic","party2017/cumple_fiesta");
            api.playSound("party2017/cumple_fiesta",100);
         }
         else
         {
            api.setSession("partyMusic","party2017/cumple_fiesta_tranqui");
            api.playSound("party2017/cumple_fiesta_tranqui",100);
         }
         if(!eventService.eventData.feature(3))
         {
            setTimeout(this.hideNPCs,1500);
         }
      }
      
      private function hidePinata() : void
      {
         if(this.pinata)
         {
            this.pinata.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE));
         }
      }
      
      override public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         if(param1.attribute.value == "cake")
         {
            this.torta.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE));
         }
         else if(param1.attribute.value == "pinata")
         {
            this.pinata.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE));
         }
      }
   }
}
