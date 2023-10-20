package com.qb9.gaturro.service.torneo
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.user;
   
   public class PlayOffMatchData
   {
       
      
      private var _player:String;
      
      private var _start:Number;
      
      private var _duration:Number;
      
      public function PlayOffMatchData()
      {
         super();
      }
      
      public static function createMatchData() : PlayOffMatchData
      {
         var _loc1_:PlayOffMatchData = new PlayOffMatchData();
         _loc1_.player = user.username;
         _loc1_.start = server.time;
         _loc1_.duration = 10 * 60000;
         return _loc1_;
      }
      
      public function get player() : String
      {
         return this._player;
      }
      
      public function get start() : Number
      {
         return this._start;
      }
      
      public function set start(param1:Number) : void
      {
         this._start = param1;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function set player(param1:String) : void
      {
         this._player = param1;
      }
      
      public function asJSONString() : String
      {
         return api.JSONEncode(this.asObject());
      }
      
      public function asObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_[PlayOffMatchEnum.PLAYER] = this._player;
         _loc1_[PlayOffMatchEnum.START_TIME] = this._start;
         _loc1_[PlayOffMatchEnum.DURATION] = this._duration;
         return _loc1_;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
   }
}
