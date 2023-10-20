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
   
   public class WeddingParty extends BaseEvent
   {
       
      
      private var torta:NpcRoomSceneObjectView;
      
      private var bunny:NpcRoomSceneObjectView;
      
      private var warhol:NpcRoomSceneObjectView;
      
      private var princesa:NpcRoomSceneObjectView;
      
      private var helmut:NpcRoomSceneObjectView;
      
      public function WeddingParty(param1:EventsService)
      {
         super(param1);
      }
      
      private function deliverFlowers() : void
      {
         api.showAwardModal("¡RECIBISTE EL RAMO DE CASAMIENTO!","party2017/props.bouquet");
      }
      
      private function notifyFlowersDelivery(param1:String) : void
      {
         var _loc2_:* = param1 + " RECIBIÓ EL RAMO DE CASAMIENTO.";
         api.showModal(_loc2_,"information");
      }
      
      override public function dispose() : void
      {
         this.stopAudio();
      }
      
      private function hideTorta() : void
      {
         if(this.torta)
         {
            this.torta.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE));
         }
      }
      
      override public function configureFeatures() : void
      {
         if(!eventService.eventData.feature(0))
         {
            setTimeout(this.hideTorta,1500);
         }
         if(!eventService.eventData.feature(2))
         {
            api.setSession("partyMusic","party2017/casamiento");
            api.playSound("party2017/casamiento",100);
         }
         else
         {
            api.setSession("partyMusic","party2017/casamiento_premium");
            api.playSound("party2017/casamiento_premium",100);
         }
         if(!eventService.eventData.feature(3))
         {
            setTimeout(this.hideNPCs,1500);
         }
      }
      
      private function hideNPCs() : void
      {
         var _loc1_:Event = new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE);
         if(this.warhol)
         {
            this.warhol.dispatchEvent(_loc1_);
         }
         if(this.helmut)
         {
            this.helmut.dispatchEvent(_loc1_);
         }
         if(this.bunny)
         {
            this.bunny.dispatchEvent(_loc1_);
         }
         if(this.princesa)
         {
            this.princesa.dispatchEvent(_loc1_);
         }
      }
      
      override public function configureBackground(param1:DisplayObjectContainer) : void
      {
         if(eventService.eventData.feature(4))
         {
            (param1 as MovieClip).layer2.gotoAndStop("premium");
            (param1 as MovieClip).layer3.gotoAndStop("premium");
         }
      }
      
      override public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1.attribute.value as String;
         if(_loc2_ == "cake")
         {
            this.torta.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE));
            api.playSound("escenarioVip/aplausos");
            api.playSound("aplausoCasamiento");
         }
         else if(_loc2_.indexOf("ramo") != -1)
         {
            api.playSound("party2017/ramo");
            _loc3_ = _loc2_.substr("ramo:".length);
            if(api.user.username == _loc3_)
            {
               this.deliverFlowers();
            }
            else
            {
               this.notifyFlowersDelivery(_loc3_);
            }
         }
      }
      
      private function stopAudio() : void
      {
         api.stopSound("party2017/casamiento");
         api.stopSound("party2017/casamiento_premium");
      }
      
      override public function configureNpcs(param1:NpcRoomSceneObjectView) : void
      {
         var _loc2_:NpcRoomSceneObjectView = param1 as NpcRoomSceneObjectView;
         var _loc3_:String = _loc2_.object.name;
         if(_loc3_.indexOf("tortaCasamiento_so") != -1)
         {
            this.torta = _loc2_;
         }
         else if(_loc3_.indexOf("pinata_so") == -1)
         {
            if(_loc3_.indexOf("andy_so") != -1)
            {
               this.warhol = _loc2_;
            }
            else if(_loc3_.indexOf("helmut_so") != -1)
            {
               this.helmut = _loc2_;
            }
            else if(_loc3_.indexOf("reclutaMonstruos_so") != -1)
            {
               this.bunny = _loc2_;
            }
            else if(_loc3_.indexOf("princesa_so") != -1)
            {
               this.princesa = _loc2_;
            }
         }
      }
   }
}
