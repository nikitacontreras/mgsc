package com.qb9.gaturro.view.gui.banner
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.events.Event;
   
   public final class BannerModalEvent extends Event
   {
      
      public static const OPEN:String = "beOpenBanner";
      
      public static const INSTANTIATE:String = "instatiate";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _data:Object;
      
      private var _banner:String;
      
      private var _sceneAPI:GaturroSceneObjectAPI;
      
      private var _options:String;
      
      public function BannerModalEvent(param1:String, param2:String, param3:GaturroRoomAPI, param4:GaturroSceneObjectAPI, param5:String = null, param6:Object = null)
      {
         super(param1,true);
         this._roomAPI = param3;
         this._data = param6;
         this._banner = param2;
         this._sceneAPI = param4;
         this._options = param5;
      }
      
      public function get options() : String
      {
         return this._options;
      }
      
      public function get roomAPI() : GaturroRoomAPI
      {
         return this._roomAPI;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get banner() : String
      {
         return this._banner;
      }
      
      public function get sceneAPI() : GaturroSceneObjectAPI
      {
         return this._sceneAPI;
      }
      
      override public function clone() : Event
      {
         return new BannerModalEvent(type,this.banner,this._roomAPI,this._sceneAPI,this._options,this._data);
      }
   }
}
