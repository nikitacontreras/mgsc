package com.qb9.gaturro.service.events.roomviews
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.events.event.BirthdayParty;
   import com.qb9.gaturro.service.events.events.event.CarnavalParty;
   import com.qb9.gaturro.service.events.events.event.EliteParty;
   import com.qb9.gaturro.service.events.events.event.MateadaParty;
   import com.qb9.gaturro.service.events.events.event.WeddingParty;
   import com.qb9.gaturro.view.camera.CameraSwitcher;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class PartyRoomView extends EventsRoomView
   {
       
      
      public function PartyRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function roomCamera() : void
      {
         CameraSwitcher.instance.taskRunner = tasks;
         CameraSwitcher.instance.switchCamera(CameraSwitcher.CUMPLE_ROOM_CAMERA,tileLayer,layers,int(room.attributes.bounds) || 0,userView,room.userAvatar);
      }
      
      override protected function initGui() : void
      {
         super.initGui();
         if(eventsService.eventData.type == EventsAttributeEnum.MATEADA_PARTY)
         {
            api.showModal("¡SIENTATE EN LOS ASIENTOS PARA COMENZAR!","information","BIENVENIDO A LA RONDA DE MATES","4000");
            return;
         }
         if(eventsService.eventData.type == EventsAttributeEnum.CARNAVAL_PARTY)
         {
            api.showModal("¡A BAILAR Y DIVERTIRSE!","information","BIENVENID@ Al CARNAVAL","4000");
            return;
         }
         api.showModal("¡BIENVENIDO A LA FIESTA!","information",null,"2000");
      }
      
      private function get hasClock() : Boolean
      {
         return (background as MovieClip)["layer2"].clock;
      }
      
      override protected function kick() : void
      {
         api.showModal("SE HA TERMINADO LA FIESTA","information");
         setTimeout(api.changeRoomXY,1500,51688753,10,10);
      }
      
      override protected function finalInit() : void
      {
         currentEvent.configureBackground(background);
         currentEvent.configureFeatures();
         currentEvent.configureSceneObjects(gRoom.sceneObjects);
         var _loc1_:Timeout = new Timeout(super.finalInit,1000);
         tasks.add(_loc1_);
         api.setAvatarAttribute("effect2","");
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            currentEvent.configureNpcs(_loc2_ as NpcRoomSceneObjectView);
         }
         return _loc2_;
      }
      
      private function updateTimer() : void
      {
         if(!background)
         {
            return;
         }
         var _loc1_:Date = new Date(eventsService.calculateRemainingTime());
         var _loc2_:String = _loc1_.minutes < 10 ? "0" + _loc1_.minutes.toString() : _loc1_.minutes.toString();
         var _loc3_:String = _loc1_.seconds < 10 ? "0" + _loc1_.seconds.toString() : _loc1_.seconds.toString();
         var _loc4_:String = _loc2_ + ":" + _loc3_;
         if(this.hasClock)
         {
            (background as MovieClip)["layer2"].clock.text.text = _loc4_;
         }
      }
      
      override protected function onTick(param1:Event) : void
      {
         this.updateTimer();
      }
      
      override protected function setup() : void
      {
         switch(eventsService.eventData.type)
         {
            case EventsAttributeEnum.BIRTHDAY_PARTY:
               currentEvent = new BirthdayParty(eventsService);
               break;
            case EventsAttributeEnum.WEDDING_PARTY:
               currentEvent = new WeddingParty(eventsService);
               break;
            case EventsAttributeEnum.ELITE_PARTY:
               currentEvent = new EliteParty(eventsService);
               break;
            case EventsAttributeEnum.MATEADA_PARTY:
               currentEvent = new MateadaParty(eventsService);
               break;
            case EventsAttributeEnum.CARNAVAL_PARTY:
               currentEvent = new CarnavalParty(eventsService);
         }
         super.setup();
      }
   }
}
