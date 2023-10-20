package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SiloModalEvent extends Event
   {
      
      public static const OPEN:String = "openSiloModal";
       
      
      private var _asset:MovieClip;
      
      private var _api:GaturroRoomAPI;
      
      public function SiloModalEvent(param1:String, param2:GaturroRoomAPI, param3:MovieClip)
      {
         super(param1);
         this._api = param2;
         this._asset = param3;
      }
      
      public function get asset() : MovieClip
      {
         return this._asset;
      }
      
      public function get api() : GaturroRoomAPI
      {
         return this._api;
      }
      
      override public function clone() : Event
      {
         return new SiloModalEvent(type,this._api,this._asset);
      }
   }
}
