package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import flash.events.Event;
   
   public class GranjaSellingModalEvent extends Event
   {
      
      public static const OPEN:String = "openGranjaSellingModal";
       
      
      private var _request:com.qb9.gaturro.view.gui.granja.FarmRequest;
      
      private var _api:GaturroRoomAPI;
      
      public function GranjaSellingModalEvent(param1:String, param2:GaturroRoomAPI, param3:com.qb9.gaturro.view.gui.granja.FarmRequest)
      {
         super(param1);
         this._api = param2;
         this._request = param3;
      }
      
      public function get api() : GaturroRoomAPI
      {
         return this._api;
      }
      
      override public function clone() : Event
      {
         return new GranjaSellingModalEvent(type,this._api,this._request);
      }
      
      public function get request() : com.qb9.gaturro.view.gui.granja.FarmRequest
      {
         return this._request;
      }
   }
}
