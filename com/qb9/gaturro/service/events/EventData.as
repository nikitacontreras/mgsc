package com.qb9.gaturro.service.events
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import com.qb9.gaturro.util.TimeSpan;
   
   public class EventData
   {
       
      
      private var _host:String;
      
      private var _isPublic:String;
      
      private var _roomID:int;
      
      private var _type:String;
      
      private var _features:String;
      
      private var _start:Number;
      
      private var _duration:Number;
      
      public function EventData()
      {
         super();
      }
      
      public static function mocap(param1:String = "def", param2:String = "def", param3:String = "def") : Object
      {
         var _loc4_:Object;
         (_loc4_ = {})[EventsAttributeEnum.HOST] = param1 == "def" ? user.username : param1;
         _loc4_[EventsAttributeEnum.START_TIME] = server.time;
         _loc4_[EventsAttributeEnum.DURATION] = 10 * 60000;
         _loc4_[EventsAttributeEnum.TYPE] = param3 == "def" ? EventsAttributeEnum.MATEADA_PARTY : param3;
         _loc4_[EventsAttributeEnum.ROOM_ID] = param2 == "def" ? EventsRoomsEnum.MATEADA[0] : settings.rooms.links[param3].roomId;
         _loc4_[EventsAttributeEnum.FEATURES] = "";
         var _loc5_:int = 0;
         while(_loc5_ < 5)
         {
            _loc4_[EventsAttributeEnum.FEATURES] += Math.random() < 0.5 ? "1" : "0";
            _loc5_++;
         }
         _loc4_[EventsAttributeEnum.PUBLIC] = "1";
         return _loc4_;
      }
      
      public static function parseObjectToJSON(param1:Object) : String
      {
         var _loc2_:EventData = EventData.fromObject(param1);
         return api.JSONEncode(_loc2_.asObject());
      }
      
      public static function fromObject(param1:Object) : EventData
      {
         var _loc2_:EventData = new EventData();
         _loc2_._host = param1[EventsAttributeEnum.HOST];
         _loc2_._start = param1[EventsAttributeEnum.START_TIME];
         _loc2_._duration = param1[EventsAttributeEnum.DURATION];
         _loc2_._roomID = param1[EventsAttributeEnum.ROOM_ID];
         _loc2_._type = param1[EventsAttributeEnum.TYPE];
         _loc2_._features = param1[EventsAttributeEnum.FEATURES];
         _loc2_._isPublic = param1[EventsAttributeEnum.PUBLIC];
         return _loc2_;
      }
      
      public static function fromString(param1:String) : EventData
      {
         if(isValidData(param1))
         {
            return EventData.fromObject(api.JSONDecode(param1));
         }
         throw new Error("data is not valid",param1);
      }
      
      public static function isValidData(param1:String) : Boolean
      {
         if(!nameInText(param1,EventsAttributeEnum.HOST))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.HOST);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.START_TIME))
         {
            logger.info("error in: " + EventsAttributeEnum.START_TIME);
            logger.info(param1[EventsAttributeEnum.START_TIME]);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.DURATION))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.DURATION);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.ROOM_ID))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.ROOM_ID);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.TYPE))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.TYPE);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.FEATURES))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.FEATURES);
            return false;
         }
         if(!nameInText(param1,EventsAttributeEnum.PUBLIC))
         {
            logger.info("!nameInText: " + EventsAttributeEnum.PUBLIC);
            return false;
         }
         return true;
      }
      
      private static function nameInText(param1:String, param2:String) : Boolean
      {
         return param1.indexOf("\"" + param2 + "\"") != -1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get isPublic() : Boolean
      {
         return this._isPublic == "1" ? true : false;
      }
      
      public function set start(param1:Number) : void
      {
         this._start = param1;
      }
      
      public function feature(param1:int) : Boolean
      {
         if(this._features.length - 1 < param1)
         {
            return false;
         }
         return this._features.charAt(param1) != "0" ? true : false;
      }
      
      public function set features(param1:String) : void
      {
         this._features = param1;
      }
      
      public function asJSONString() : String
      {
         return api.JSONEncode(this.asObject());
      }
      
      public function set host(param1:String) : void
      {
         this._host = param1;
      }
      
      public function asObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_[EventsAttributeEnum.HOST] = this._host;
         _loc1_[EventsAttributeEnum.START_TIME] = this._start;
         _loc1_[EventsAttributeEnum.DURATION] = this._duration;
         _loc1_[EventsAttributeEnum.ROOM_ID] = this._roomID;
         _loc1_[EventsAttributeEnum.TYPE] = this._type;
         _loc1_[EventsAttributeEnum.FEATURES] = this._features;
         _loc1_[EventsAttributeEnum.PUBLIC] = this._isPublic;
         return _loc1_;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function calculateRemainingTime() : Number
      {
         var _loc1_:Date = new Date(server.time);
         var _loc2_:Date = this.expiration;
         var _loc3_:int = TimeSpan.fromDates(_loc1_,_loc2_).totalMilliseconds;
         return _loc3_ > 0 ? _loc3_ : -1;
      }
      
      public function get start() : Number
      {
         return this._start;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function set roomID(param1:int) : void
      {
         this._roomID = param1;
      }
      
      public function set isPublic(param1:Boolean) : void
      {
         this._isPublic = param1 ? "1" : "0";
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get roomID() : int
      {
         return this._roomID;
      }
      
      public function get remainingTime() : Number
      {
         return this.calculateRemainingTime();
      }
      
      public function get features() : String
      {
         return this._features;
      }
      
      public function get expiration() : Date
      {
         return new Date(this._start + this._duration);
      }
   }
}
