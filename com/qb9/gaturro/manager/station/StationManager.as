package com.qb9.gaturro.manager.station
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class StationManager implements ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var timer:Timer;
      
      private var currentStationDef:Object;
      
      private var stationSet:Array;
      
      private var autoDeparture:Boolean;
      
      private var observerDepatureSet:Array;
      
      private var currentStationId:int = -1;
      
      private var observerArrivalSet:Array;
      
      public function StationManager(param1:Object, param2:int = -1, param3:Boolean = true)
      {
         super();
         this.autoDeparture = param3;
         this.setup(param1);
         if(param2 > -1)
         {
            this.setInitialStation(param2);
         }
      }
      
      private function setCurrentStation(param1:int) : Object
      {
         this.currentStationId = param1;
         this.currentStationDef = this.stationSet[this.currentStationId];
         return this.currentStationDef;
      }
      
      private function setupDeparture() : void
      {
         this.timer.delay = this.currentStationDef.departureDelay;
         this.timer.repeatCount = 1;
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDepartureWaitingComplete);
         this.timer.start();
      }
      
      private function getNextStation() : int
      {
         return this.currentStationId >= this.stationSet.length - 1 ? 0 : this.currentStationId + 1;
      }
      
      public function setInitialStation(param1:int = 0) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(param1 > 0)
         {
            while(_loc4_ < this.stationSet.length)
            {
               _loc3_ = this.stationSet[_loc4_];
               if(_loc3_.roomId == param1)
               {
                  _loc2_ = _loc4_;
                  break;
               }
               _loc4_++;
            }
         }
         this.setCurrentStation(_loc2_);
      }
      
      private function setup(param1:Object) : void
      {
         this.observerArrivalSet = new Array();
         this.observerDepatureSet = new Array();
         this.stationSet = param1.stations;
      }
      
      private function depart() : void
      {
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTripTimeComplete);
         this.timer.delay = this.currentStationDef.tripDelay;
         this.timer.start();
      }
      
      private function onDepartureWaitingComplete(param1:TimerEvent) : void
      {
         var _loc4_:Function = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDepartureWaitingComplete);
         var _loc2_:int = this.getNextStation();
         var _loc3_:Object = this.stationSet[_loc2_];
         for each(_loc4_ in this.observerDepatureSet)
         {
            _loc4_.apply(this,[_loc3_.name]);
         }
         this.depart();
      }
      
      public function getCurrentStationDef() : Object
      {
         return this.currentStationDef;
      }
      
      public function start() : void
      {
         if(!this.currentStationDef)
         {
            throw new Error("Theres no station setted");
         }
         if(!this.timer)
         {
            this.timer = new Timer(0,1);
         }
         this.depart();
      }
      
      public function get getCurrentStationName() : String
      {
         return this.currentStationDef.name;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function onTripTimeComplete(param1:TimerEvent) : void
      {
         var _loc3_:Function = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTripTimeComplete);
         var _loc2_:int = this.getNextStation();
         this.setCurrentStation(_loc2_);
         for each(_loc3_ in this.observerArrivalSet)
         {
            _loc3_.apply(this,[this.currentStationDef.name]);
         }
         if(this.autoDeparture)
         {
            this.setupDeparture();
         }
      }
      
      public function dispose() : void
      {
         this.observerArrivalSet.length = 0;
         this.observerArrivalSet = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTripTimeComplete);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDepartureWaitingComplete);
         this.timer = null;
         this._disposed = true;
      }
      
      public function departure() : void
      {
         if(!this.autoDeparture)
         {
            this.setupDeparture();
         }
      }
      
      public function isFirstStation() : Boolean
      {
         return this.currentStationId == 0;
      }
      
      public function observeDeparture(param1:Function) : void
      {
         this.observerDepatureSet.push(param1);
      }
      
      public function getCurrentRoomId() : Number
      {
         return this.currentStationDef.roomId;
      }
      
      public function isLastStation() : Boolean
      {
         return this.currentStationId == this.stationSet.length - 1;
      }
      
      public function observeArrival(param1:Function) : void
      {
         this.observerArrivalSet.push(param1);
      }
   }
}
