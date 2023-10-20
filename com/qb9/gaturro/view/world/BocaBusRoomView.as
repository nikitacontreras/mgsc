package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.manager.station.StationManager;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BocaBusRoomView extends GaturroRoomView
   {
      
      private static const BACKGROUND_START_GOING_LABEL:String = "comienzoIda";
      
      private static const DOOR_AMOUNT:int = 2;
      
      private static const DOOR_OPEN_LABEL:String = "open";
      
      private static const BACKGROUND_END_RETURNING_LABEL:String = "llegadaComienzo";
      
      private static const BACKGROUND_START_RETURNING_LABEL:String = "ComienzoVuelta";
      
      private static const BACKGROUND_END_GOING_LABEL:String = "llegadaDestino";
      
      private static const DOOR_CLOSE_LABEL:String = "close";
      
      private static const NPC_DOOR_NAME:String = "boca2017/props.salidaBondi_so";
       
      
      private var arrivedTimeoutID:int;
      
      private var backgroundView:MovieClip;
      
      private var stationManager:StationManager;
      
      private var npcDoorSet:Array;
      
      private var stationCount:int = 1;
      
      public function BocaBusRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.setup();
      }
      
      private function onEndLoop(param1:Event) : void
      {
         this.backgroundView.removeEventListener("END_LOOP",this.onEndLoop);
         var _loc2_:String = this.stationManager.isFirstStation() ? BACKGROUND_END_RETURNING_LABEL : BACKGROUND_END_GOING_LABEL;
         this.changeBackgroundState(_loc2_);
      }
      
      private function onArrivalComplete(param1:Event) : void
      {
         api.stopSound("boca/ambienteColectivo");
         endShake();
         this.changeDoorInteractionEnabling(true);
         this.stationManager.departure();
      }
      
      private function seupInteractiveDoor(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onDoorClick);
         param1.mouseEnabled = false;
         param1.visible = false;
         this.npcDoorSet.push(param1);
      }
      
      private function setup() : void
      {
         this.stationManager = new StationManager(settings.bocaBus,-1,false);
         this.stationManager.observeArrival(this.onGetStation);
         this.stationManager.observeDeparture(this.onLeaveStation);
         this.npcDoorSet = new Array();
      }
      
      private function goOut() : void
      {
         api.trackEvent("FEATURES:BOCA_BUS:VAGON:EXIT:" + api.isCitizen,this.stationCount.toString());
         api.changeRoom(this.stationManager.getCurrentRoomId(),new Coord(10,8));
      }
      
      private function setupBackground() : void
      {
         this.backgroundView = (background as MovieClip).layer1;
         this.backgroundView.addEventListener("ARRIVED_AT_STATION",this.onArrivalComplete);
      }
      
      private function changeDoorInteractionEnabling(param1:Boolean) : void
      {
         var _loc2_:InteractiveObject = null;
         for each(_loc2_ in this.npcDoorSet)
         {
            _loc2_.mouseEnabled = param1;
            _loc2_.visible = param1;
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc4_:InteractiveObject = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         var _loc3_:NpcRoomSceneObject = param1 as NpcRoomSceneObject;
         if(Boolean(_loc3_) && _loc3_.name.indexOf(NPC_DOOR_NAME) >= 0)
         {
            _loc4_ = InteractiveObject(_loc2_);
            this.seupInteractiveDoor(_loc4_);
         }
         return _loc2_;
      }
      
      private function shakeFX() : void
      {
         var _loc1_:int = int(this.stationManager.getCurrentStationDef().tripDelay);
         startShake(_loc1_,0.3,false);
      }
      
      private function avatarArrived() : void
      {
         clearTimeout(this.arrivedTimeoutID);
         this.goOut();
      }
      
      override public function dispose() : void
      {
         var _loc1_:InteractiveObject = null;
         for each(_loc1_ in this.npcDoorSet)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onDoorClick);
            clearTimeout(this.arrivedTimeoutID);
         }
         this.backgroundView.removeEventListener("ARRIVED_AT_STATION",this.onArrivalComplete);
         this.backgroundView.removeEventListener("END_LOOP",this.onEndLoop);
         this.stationManager.dispose();
         super.dispose();
      }
      
      private function onDoorClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = Math.random() * 1000;
         this.arrivedTimeoutID = setTimeout(this.avatarArrived,_loc2_);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.setupBackground();
         var _loc1_:int = int(api.getSession("bocaBusStation"));
         this.stationManager.setInitialStation(_loc1_);
         this.stationManager.start();
         var _loc2_:String = this.stationManager.isFirstStation() ? BACKGROUND_START_GOING_LABEL : BACKGROUND_START_RETURNING_LABEL;
         this.changeBackgroundState(_loc2_);
         this.shakeFX();
         api.playSound("boca/ambienteColectivo");
      }
      
      private function changeBackgroundState(param1:String) : void
      {
         this.backgroundView.gotoAndStop(param1);
      }
      
      private function onLeaveStation(param1:String) : void
      {
         this.changeDoorInteractionEnabling(false);
         var _loc2_:String = this.stationManager.isFirstStation() ? BACKGROUND_START_GOING_LABEL : BACKGROUND_START_RETURNING_LABEL;
         this.changeBackgroundState(_loc2_);
         this.shakeFX();
         ++this.stationCount;
         api.playSound("boca/ambienteColectivo");
      }
      
      private function onGetStation(param1:String) : void
      {
         this.shakeFX();
         this.backgroundView.addEventListener("END_LOOP",this.onEndLoop);
      }
   }
}
