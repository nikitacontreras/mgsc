package com.qb9.gaturro.view.screens.events
{
   import flash.events.Event;
   
   public final class ServersScreenEvent extends Event
   {
      
      public static const READY:String = "sseReady";
      
      public static const ERROR:String = "sseError";
      
      public static const CHOSE:String = "sseChose";
       
      
      private var _port:uint;
      
      private var _host:String;
      
      private var _name:String;
      
      public function ServersScreenEvent(param1:String, param2:String = null, param3:uint = 0, param4:String = "")
      {
         super(param1,true);
         this._name = param4;
         this._host = param2;
         this._port = param3;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      override public function clone() : Event
      {
         return new ServersScreenEvent(type,this.host,this.port,this.name);
      }
   }
}
