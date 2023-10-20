package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import flash.events.Event;
   
   public class CropTimerModalEvent extends Event
   {
      
      public static const OPEN:String = "openCropTimerModal";
       
      
      private var _behavior:GranjaBehavior;
      
      private var _api:GaturroRoomAPI;
      
      private var _objectAPI:GaturroSceneObjectAPI;
      
      public function CropTimerModalEvent(param1:String, param2:GaturroRoomAPI, param3:GaturroSceneObjectAPI, param4:GranjaBehavior)
      {
         super(param1);
         this._api = param2;
         this._objectAPI = param3;
         this._behavior = param4;
      }
      
      override public function clone() : Event
      {
         return new CropTimerModalEvent(type,this._api,this._objectAPI,this._behavior);
      }
      
      public function get behavior() : GranjaBehavior
      {
         return this._behavior;
      }
      
      public function get api() : GaturroRoomAPI
      {
         return this._api;
      }
      
      public function get objectAPI() : GaturroSceneObjectAPI
      {
         return this._objectAPI;
      }
   }
}
