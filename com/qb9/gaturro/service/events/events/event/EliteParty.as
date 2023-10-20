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
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class EliteParty extends BaseEvent
   {
      
      internal static const BRONZE_BAG_AWARD:String = "galaPremios2017/props.estatuaBronzeBag";
      
      internal static const GOLDEN_AWARD:String = "galaPremios2017/props.estatuaDoradaBag";
      
      internal static const SILVER_AWARD:String = "galaPremios2017/props.estatuaPlataBag";
      
      internal static const GOLDEN_BAG_AWARD:String = "galaPremios2017/props.estatuaDoradaBag";
      
      internal static const SILVER_BAG_AWARD:String = "galaPremios2017/props.estatuaPlataBag";
      
      internal static const BRONZE_AWARD:String = "galaPremios2017/props.estatuaBronzeBag";
      
      public static var AWARD_LIST:Array = new Array(GOLDEN_AWARD,SILVER_AWARD,BRONZE_AWARD);
      
      private static var AWARD_NAME_LIST:Dictionary;
       
      
      private var presentador:NpcRoomSceneObjectView;
      
      private var mirta:NpcRoomSceneObjectView;
      
      private var estatua:NpcRoomSceneObjectView;
      
      private var abuelurra:NpcRoomSceneObjectView;
      
      private var camaraFotos:NpcRoomSceneObjectView;
      
      private var camaraDorada:NpcRoomSceneObjectView;
      
      private var duende:NpcRoomSceneObjectView;
      
      private var mesaMesaMesaQueMasAplauda:NpcRoomSceneObjectView;
      
      public function EliteParty(param1:EventsService)
      {
         super(param1);
      }
      
      private static function getCorrespondingAward(param1:String) : String
      {
         var _loc2_:Dictionary = getAwardNameList();
         var _loc3_:String = String(_loc2_[param1]);
         if(!_loc3_)
         {
            throw new Error("Attempted to get unexisting item name: [" + param1 + "]");
         }
         return _loc3_;
      }
      
      private static function getAwardNameList() : Dictionary
      {
         if(!AWARD_NAME_LIST)
         {
            AWARD_NAME_LIST = new Dictionary();
            AWARD_NAME_LIST[GOLDEN_BAG_AWARD] = GOLDEN_AWARD;
            AWARD_NAME_LIST[SILVER_BAG_AWARD] = SILVER_AWARD;
            AWARD_NAME_LIST[BRONZE_BAG_AWARD] = BRONZE_AWARD;
         }
         return AWARD_NAME_LIST;
      }
      
      private function hideMesa() : void
      {
         if(this.mesaMesaMesaQueMasAplauda)
         {
            this.mesaMesaMesaQueMasAplauda.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE));
         }
      }
      
      private function stopAudio() : void
      {
         api.stopSound("gala2017/musica_premiacion");
         api.stopSound("gala2017/musica_festiva");
         api.stopSound("gala2017/musica_mix");
      }
      
      override public function configureBackground(param1:DisplayObjectContainer) : void
      {
         if(eventService.eventData.feature(2))
         {
            (param1 as MovieClip).layer2.gotoAndStop("premium");
            (param1 as MovieClip).layer3.gotoAndStop("premium");
         }
      }
      
      override public function configureFeatures() : void
      {
         if(!eventService.eventData.feature(0))
         {
            setTimeout(this.hideMesa,1500);
         }
         if(!eventService.eventData.feature(1))
         {
            api.setSession("partyMusic","gala2017/musica_festiva");
            api.playSound("gala2017/musica_festiva",100);
         }
         else
         {
            api.setSession("partyMusic","gala2017/musica_mix");
            api.playSound("gala2017/musica_mix",100);
         }
         if(!eventService.eventData.feature(3))
         {
            setTimeout(this.hideNPCs,1500);
         }
      }
      
      private function hideNPCs() : void
      {
         var _loc1_:Event = new Event(NpcBehaviorEvent.MULTIPLAYER_HIDE);
         if(this.presentador)
         {
            this.presentador.dispatchEvent(_loc1_);
         }
         if(this.duende)
         {
            this.duende.dispatchEvent(_loc1_);
         }
         if(this.mirta)
         {
            this.mirta.dispatchEvent(_loc1_);
         }
         if(this.estatua)
         {
            this.estatua.dispatchEvent(_loc1_);
         }
         if(this.abuelurra)
         {
            this.abuelurra.dispatchEvent(_loc1_);
         }
         if(this.camaraDorada)
         {
            this.abuelurra.dispatchEvent(_loc1_);
         }
         if(this.camaraFotos)
         {
            this.abuelurra.dispatchEvent(_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         this.stopAudio();
      }
      
      override public function configureNpcs(param1:NpcRoomSceneObjectView) : void
      {
         var _loc2_:NpcRoomSceneObjectView = param1 as NpcRoomSceneObjectView;
         var _loc3_:String = _loc2_.object.name;
         if(_loc3_.indexOf("mesaComidaGala_so") != -1)
         {
            this.mesaMesaMesaQueMasAplauda = _loc2_;
         }
         else if(_loc3_.indexOf("presentador_so") != -1)
         {
            this.presentador = _loc2_;
         }
         else if(_loc3_.indexOf("duende_so") != -1)
         {
            this.duende = _loc2_;
         }
         else if(_loc3_.indexOf("mirta_so") != -1)
         {
            this.mirta = _loc2_;
         }
         else if(_loc3_.indexOf("estatua_so") != -1)
         {
            this.estatua = _loc2_;
         }
         else if(_loc3_.indexOf("camaraDorada_so") != -1)
         {
            this.camaraDorada = _loc2_;
         }
         else if(_loc3_.indexOf("camaraFotos_so") != -1)
         {
            this.camaraFotos = _loc2_;
         }
         else if(_loc3_.indexOf("abuelurra_so") != -1)
         {
            this.abuelurra = _loc2_;
         }
      }
      
      override public function onMessageBroadcasted(param1:CustomAttributeEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = api.JSONDecode(param1.attribute.value as String);
         if(api.user.username == _loc2_.user)
         {
            api.showSkinModal("¡HAS SIDO PREMIADO!",_loc2_.award,"¡FELICIDADES!");
            _loc3_ = getCorrespondingAward(_loc2_.award);
            api.giveUser(_loc3_);
         }
         else
         {
            api.textMessageToGUI(_loc2_.user + " HA SIDO PREMIADO!");
         }
         api.playSound("gala2017/anuncio",1);
      }
   }
}
