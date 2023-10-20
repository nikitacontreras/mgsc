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
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SubwayRoomView extends GaturroRoomView
   {
      
      private static const CURRENT_STATION_STRING:String = "ESTACIÓN ";
      
      private static const DOOR_PREFIX:String = "door";
      
      private static const NEXT_STATION_STRING:String = "PRÓXIMA: ";
      
      private static const DOOR_OPEN_LABEL:String = "open";
      
      private static const BILLBOARD_PREFIX:String = "billboard";
      
      private static const BACKGROUND_MOVING_LABEL:String = "moving";
      
      private static const BACKGROUND_STOPPING_LABEL:String = "stoped";
      
      private static const DOOR_CLOSE_LABEL:String = "close";
      
      private static const NPC_DOOR_NAME:String = "subte.salidaSubte_so";
       
      
      private var subwayBackground:MovieClip;
      
      private var arrivedTimeoutID:int;
      
      private var doorSet:Array;
      
      private var npcDoorSet:Array;
      
      private var stationManager:StationManager;
      
      private var billboardSet:Array;
      
      private var dispatcherDoor:IEventDispatcher;
      
      private var stationCount:int = 1;
      
      public function SubwayRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.setup();
      }
      
      private function changeDoorState(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this.doorSet)
         {
            _loc2_.gotoAndPlay(param1);
         }
      }
      
      private function seupInteractiveDoor(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onDoorClick);
         param1.mouseEnabled = false;
         param1.visible = false;
         this.npcDoorSet.push(param1);
      }
      
      private function onGetStation(param1:String) : void
      {
         this.changeBackgroundState(BACKGROUND_STOPPING_LABEL);
         this.setCurrentStation(param1);
      }
      
      private function setupDoors() : void
      {
         var _loc2_:MovieClip = null;
         this.doorSet = new Array();
         var _loc1_:MovieClip = layers[1];
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = _loc1_.getChildByName(DOOR_PREFIX + _loc3_) as MovieClip;
            _loc2_.gotoAndStop(1);
            this.doorSet.push(_loc2_);
            _loc3_++;
         }
         _loc2_.addEventListener("DOOR_CLOSED",this.onDoorsClosed);
         this.dispatcherDoor = _loc2_;
      }
      
      private function setupBillboard() : void
      {
         var _loc2_:DisplayObjectContainer = null;
         this.billboardSet = new Array();
         var _loc1_:MovieClip = layers[1];
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = _loc1_.getChildByName(BILLBOARD_PREFIX + _loc3_) as DisplayObjectContainer;
            this.billboardSet.push(_loc2_.getChildByName("label"));
            _loc3_++;
         }
      }
      
      private function setupBackground() : void
      {
         this.subwayBackground = (background as MovieClip).layer1;
         this.subwayBackground.addEventListener("ARRIVED_AT_STATION",this.onArrivalComplete);
         this.changeBackgroundState(BACKGROUND_MOVING_LABEL);
      }
      
      private function goOut() : void
      {
         api.trackEvent("FEATURES:SUBTE:VAGON:EXIT:" + api.isCitizen,this.stationCount.toString());
         api.changeRoom(this.stationManager.getCurrentRoomId(),new Coord(10,8));
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
         startShake(_loc1_,0.5,false);
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
      
      private function setCurrentStation(param1:String) : void
      {
         var _loc3_:TextField = null;
         for each(_loc3_ in this.billboardSet)
         {
            _loc3_.text = CURRENT_STATION_STRING + param1;
         }
      }
      
      private function changeBackgroundState(param1:String) : void
      {
         this.subwayBackground.gotoAndStop(param1);
      }
      
      private function onDoorClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = Math.random() * 1000;
         this.arrivedTimeoutID = setTimeout(this.avatarArrived,_loc2_);
      }
      
      private function avatarArrived() : void
      {
         clearTimeout(this.arrivedTimeoutID);
         this.goOut();
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.setupDoors();
         this.setupBillboard();
         this.setupBackground();
         var _loc1_:int = int(api.getSession("station"));
         this.stationManager.setInitialStation(_loc1_);
         this.stationManager.start();
         this.setCurrentStation(this.stationManager.getCurrentStationName);
         this.shakeFX();
         api.playSound("subte2017/subteMarcha");
      }
      
      override public function dispose() : void
      {
         var _loc1_:InteractiveObject = null;
         for each(_loc1_ in this.npcDoorSet)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onDoorClick);
            clearTimeout(this.arrivedTimeoutID);
         }
         this.npcDoorSet = null;
         this.dispatcherDoor.removeEventListener("DOOR_CLOSED",this.onDoorsClosed);
         this.subwayBackground.removeEventListener("ARRIVED_AT_STATION",this.onDoorsClosed);
         this.stationManager.dispose();
         super.dispose();
      }
      
      private function onDoorsClosed(param1:Event) : void
      {
         api.playSound("subte2017/subteMarcha");
         this.changeBackgroundState(BACKGROUND_MOVING_LABEL);
         this.shakeFX();
      }
      
      private function onArrivalComplete(param1:Event) : void
      {
         api.stopSound("subte2017/subteMarcha");
         api.playSound("subte2017/avisoCierre");
         api.playSound("subte2017/puertaAbre");
         this.changeDoorState(DOOR_OPEN_LABEL);
         this.changeDoorInteractionEnabling(true);
      }
      
      private function onLeaveStation(param1:String) : void
      {
         this.changeDoorInteractionEnabling(false);
         api.playSound("subte2017/puertaCierra");
         this.changeDoorState(DOOR_CLOSE_LABEL);
         this.setNextStation(param1);
         ++this.stationCount;
      }
      
      private function setup() : void
      {
         this.stationManager = new StationManager(settings.subway);
         this.stationManager.observeArrival(this.onGetStation);
         this.stationManager.observeDeparture(this.onLeaveStation);
         this.npcDoorSet = new Array();
      }
      
      private function setNextStation(param1:String) : void
      {
         var _loc3_:TextField = null;
         for each(_loc3_ in this.billboardSet)
         {
            _loc3_.text = NEXT_STATION_STRING + param1;
         }
      }
   }
}
