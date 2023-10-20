package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.commons.event.EventManager;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class CameraSwitcher extends EventDispatcher implements ICameraSwitcher
   {
      
      public static const ROOM_CAMERA:String = "roomCamera";
      
      public static const BOSS_FIGHT_ROOM_CAMERA:String = "BossFightRoomCamera";
      
      private static var _instance:com.qb9.gaturro.view.camera.CameraSwitcher;
      
      public static const CUMPLE_ROOM_CAMERA:String = "RoomCumpleCamera";
      
      public static const GRANJA_ROOM_CAMERA:String = "RoomGranjaCamera";
       
      
      private var _isPaused:Boolean;
      
      private var cameraFactory:CameraFactory;
      
      private var _taskRunner:TaskRunner;
      
      private var eventManager:EventManager;
      
      private var _currentCamera:com.qb9.gaturro.view.camera.AbstractCamera;
      
      public function CameraSwitcher()
      {
         super();
         if(_instance)
         {
            throw new IllegalOperationError("this is a singleton implementation and shouldn\'t instantiate it by your own.");
         }
         _instance = this;
         this.cameraFactory = new CameraFactory();
         this.eventManager = new EventManager();
      }
      
      public static function get instance() : com.qb9.gaturro.view.camera.CameraSwitcher
      {
         if(_instance)
         {
         }
         return _instance;
      }
      
      public function switchCamera(param1:String, param2:Sprite, param3:Array, param4:int, ... rest) : void
      {
         var _loc6_:com.qb9.gaturro.view.camera.AbstractCamera;
         if(_loc6_ = this.cameraFactory.build.apply(this.cameraFactory,new Array(param1,param2,param3,param4).concat(rest)) as com.qb9.gaturro.view.camera.AbstractCamera)
         {
            if(this._currentCamera)
            {
               this.eventManager.removeAll();
               this._taskRunner.remove(this._currentCamera);
            }
            this._currentCamera = _loc6_;
            this._taskRunner.add(this._currentCamera);
            this._currentCamera.init();
         }
      }
      
      public function set tasksRunner(param1:TaskRunner) : void
      {
         if(Boolean(this._currentCamera) && Boolean(this._taskRunner))
         {
            this._taskRunner.remove(this._currentCamera);
         }
         this._taskRunner = param1;
         if(this._taskRunner)
         {
            this._taskRunner.add(this._currentCamera);
         }
      }
      
      public function get currentCamera() : com.qb9.gaturro.view.camera.AbstractCamera
      {
         return this._currentCamera;
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.eventManager.removeEventListener(this.currentCamera,param1,param2);
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.eventManager.addEventListener(this.currentCamera,param1,param2);
      }
      
      public function init() : void
      {
      }
      
      public function move(param1:Point) : void
      {
         this._currentCamera.move(param1);
      }
      
      public function set taskRunner(param1:TaskRunner) : void
      {
         this._taskRunner = param1;
      }
      
      public function resume() : void
      {
         this._currentCamera.start();
         this._isPaused = false;
      }
      
      public function pause() : void
      {
         this._currentCamera.stop();
         this._isPaused = true;
      }
      
      public function isPaused() : Boolean
      {
         return this._isPaused;
      }
   }
}

import com.qb9.gaturro.view.camera.*;
import flash.display.Sprite;
import flash.utils.Dictionary;

class CameraFactory
{
    
   
   private var map:Dictionary;
   
   public function CameraFactory()
   {
      super();
      this.map = new Dictionary();
      this.map[CameraSwitcher.ROOM_CAMERA] = RoomCamera;
      this.map[CameraSwitcher.BOSS_FIGHT_ROOM_CAMERA] = BossFightRoomCamera;
      this.map[CameraSwitcher.GRANJA_ROOM_CAMERA] = RoomGranjaCamera;
      this.map[CameraSwitcher.CUMPLE_ROOM_CAMERA] = RoomCumpleCamera;
   }
   
   public function build(param1:String, param2:Sprite, param3:Array, param4:int, ... rest) : ICamera
   {
      var _loc7_:ICamera = null;
      var _loc6_:Class = this.map[param1];
      switch(rest.length)
      {
         case 0:
            _loc7_ = new _loc6_(param2,param3,param4);
            break;
         case 1:
            _loc7_ = new _loc6_(param2,param3,param4,rest[0]);
            break;
         case 2:
            _loc7_ = new _loc6_(param2,param3,param4,rest[0],rest[1]);
            break;
         case 3:
            _loc7_ = new _loc6_(param2,param3,param4,rest[0],rest[1],rest[2]);
            break;
         default:
            _loc7_ = new _loc6_(param2,param3,param4);
      }
      return _loc7_;
   }
}
