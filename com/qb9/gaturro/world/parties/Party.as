package com.qb9.gaturro.world.parties
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   
   public class Party
   {
      
      public static const COSTUMES:int = 3;
      
      public static const WEDDING:int = 5;
      
      public static const POOL:int = 2;
      
      public static const BIRTHDAY:int = 1;
      
      public static const ELEGANT:int = 4;
       
      
      private var _invitedFriends:String;
      
      private var _duration:int;
      
      private var _isPublic:Boolean;
      
      private var _world:String;
      
      private var _type:int;
      
      private var _options:Array;
      
      private var _capacity:int;
      
      private var _time:Number;
      
      private var _owner:String;
      
      private var _roomId:Number;
      
      public function Party(param1:String, param2:Number, param3:int, param4:String)
      {
         super();
         this._owner = param1;
         this._roomId = param2;
         this._type = param3;
         this._world = param4;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set capacity(param1:int) : void
      {
         this._capacity = param1;
      }
      
      public function get timestampInit() : Number
      {
         return this._time;
      }
      
      public function set isPublic(param1:Boolean) : void
      {
         this._isPublic = param1;
      }
      
      public function get capacity() : int
      {
         return this._capacity;
      }
      
      public function get isPublic() : Boolean
      {
         return this._isPublic;
      }
      
      public function set invitedFriends(param1:String) : void
      {
         this._invitedFriends = param1;
      }
      
      public function get isActive() : Boolean
      {
         return this._time + this._duration > server.time;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get roomId() : Number
      {
         return this._roomId;
      }
      
      public function get invitedFriends() : String
      {
         return this._invitedFriends;
      }
      
      public function set timestampInit(param1:Number) : void
      {
         this._time = param1;
      }
      
      public function setOptions(param1:Array) : void
      {
         this._options = param1;
      }
      
      public function isOptionActive(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         for each(_loc2_ in this._options)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function get owner() : String
      {
         return this._owner;
      }
      
      public function set roomId(param1:Number) : void
      {
         this._roomId = param1;
      }
      
      public function get invitationText() : String
      {
         switch(this._type)
         {
            case BIRTHDAY:
               return region.key("birthdayPartyInvitation");
            case POOL:
               return region.key("poolPartyInvitation");
            case COSTUMES:
               return region.key("costumesPartyInvitation");
            case ELEGANT:
               return region.key("elegantPartyInvitation");
            case WEDDING:
               return region.key("weddingPartyInvitation");
            default:
               return region.key("genericPartyInvitation");
         }
      }
      
      public function get worldName() : String
      {
         return this._world;
      }
   }
}
