package com.qb9.gaturro.world.parties
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.world.parties.service.PartiesConnection;
   import com.qb9.gaturro.world.parties.target.Target;
   import com.qb9.gaturro.world.parties.target.TargetMonitor;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PartiesManager extends EventDispatcher
   {
      
      public static const ERROR:String = "ERROR";
       
      
      private var _mailer:GaturroMailer;
      
      private var _parties:Array;
      
      private var partyCreatedCallback:Function;
      
      private var userInvitedFriends:Array;
      
      private var lastRefreshTime:Number = 4.9e-324;
      
      private var _popularityPoints:int = 0;
      
      private var monitor:TargetMonitor;
      
      private var _listLoaded:Boolean = false;
      
      private var totalPartyPrice:Number;
      
      private var partyErrorCallback:Function;
      
      private var _popularityLoaded:Boolean = false;
      
      private var callbackPartiesList:Function;
      
      private var partyCreating:com.qb9.gaturro.world.parties.Party;
      
      public function PartiesManager(param1:GaturroMailer)
      {
         this._parties = new Array();
         this.monitor = new TargetMonitor();
         super();
         this._mailer = param1;
         this.getPopularity();
         this.getParties();
      }
      
      private function serviceError(param1:String, param2:Object) : void
      {
         this.dispatchEvent(new Event(PartiesManager.ERROR));
         if(this.partyErrorCallback != null)
         {
            this.partyErrorCallback();
         }
         this.partyCreatedCallback = null;
         this.partyErrorCallback = null;
      }
      
      public function get targetMonitor() : TargetMonitor
      {
         return this.monitor;
      }
      
      public function get parties() : Array
      {
         var _loc2_:com.qb9.gaturro.world.parties.Party = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._parties)
         {
            if(_loc2_.isActive)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function roomCreatedEvent(param1:NetworkManagerEvent) : void
      {
         var _loc7_:String = null;
         net.removeEventListener(GaturroNetResponses.PARTY_ROOM_CREATED,this.roomCreatedEvent);
         var _loc2_:Boolean = param1.mobject.getBoolean("success");
         if(!_loc2_)
         {
            if(this.partyErrorCallback != null)
            {
               this.partyErrorCallback();
            }
            this.partyCreating = null;
            this.userInvitedFriends = [];
            this.totalPartyPrice = 0;
            return;
         }
         var _loc3_:Number = Number(user.attributes.coins);
         var _loc4_:Number = _loc3_ - this.totalPartyPrice;
         user.profile.attributes["system_coins"] = _loc4_;
         var _loc5_:Number = param1.mobject.getInteger("roomId");
         this.partyCreating.roomId = _loc5_;
         this._parties.push(this.partyCreating);
         var _loc6_:String = (_loc6_ = (_loc6_ = (_loc6_ = this.partyCreating.invitationText).replace("%servername",server.serverName)).replace("%servername",server.serverName)).replace("%roomId",_loc5_.toString());
         for each(_loc7_ in this.userInvitedFriends)
         {
            this._mailer.sendMail(_loc7_,_loc6_,region.key("subjectPartyInvitation"));
         }
         this.partyCreatedCallback(_loc5_);
         this.partyCreating = null;
         this.userInvitedFriends = [];
         this.totalPartyPrice = 0;
         this.partyCreatedCallback = null;
         this.partyErrorCallback = null;
      }
      
      public function savePopularity(param1:int) : void
      {
         this._popularityPoints = param1;
         var _loc2_:PartiesConnection = new PartiesConnection(this.loadPopularity,this.serviceError);
         _loc2_.setPopularity(param1,this.abilityString());
      }
      
      private function partyCreatingError(param1:String, param2:Object) : void
      {
         var _loc3_:String = null;
         this.dispatchEvent(new Event(PartiesManager.ERROR));
         if(this.partyErrorCallback != null)
         {
            _loc3_ = String(param2.params[3]);
            this.partyErrorCallback(_loc3_);
            logger.debug("Error Creando Fiesta --> " + _loc3_);
         }
         this.partyCreating = null;
         this.userInvitedFriends = [];
         this.totalPartyPrice = 0;
         this.partyCreatedCallback = null;
         this.partyErrorCallback = null;
      }
      
      public function partyByRoomId(param1:Number) : com.qb9.gaturro.world.parties.Party
      {
         var _loc2_:com.qb9.gaturro.world.parties.Party = null;
         for each(_loc2_ in this._parties)
         {
            if(_loc2_.roomId == param1 && _loc2_.isActive)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function partyByOwner(param1:String) : com.qb9.gaturro.world.parties.Party
      {
         var _loc2_:com.qb9.gaturro.world.parties.Party = null;
         for each(_loc2_ in this._parties)
         {
            if(_loc2_.owner == param1 && _loc2_.isActive)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function buyUpgrade(param1:int) : void
      {
         if(!settings.services.parties || !settings.services.parties.enabled)
         {
            return;
         }
         var _loc2_:Object = this.abilityByNumber(param1);
         if(!_loc2_)
         {
            return;
         }
         this.enabledAbility(param1);
         this._popularityPoints -= _loc2_.popularity;
         var _loc3_:PartiesConnection = new PartiesConnection(this.loadPopularity,this.serviceError);
         _loc3_.setPopularity(this._popularityPoints,this.abilityString());
      }
      
      public function abilityByNumber(param1:Number) : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in settings.parties.abilities)
         {
            for each(_loc3_ in settings.parties.abilities[_loc2_])
            {
               if(_loc3_.id == param1)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function get listLoaded() : Boolean
      {
         return this._listLoaded;
      }
      
      public function haveParty(param1:String) : Boolean
      {
         var _loc2_:com.qb9.gaturro.world.parties.Party = null;
         for each(_loc2_ in this._parties)
         {
            if(_loc2_.owner == param1 && _loc2_.isActive)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get myParty() : com.qb9.gaturro.world.parties.Party
      {
         if(!user)
         {
            return null;
         }
         return this.partyByOwner(user.username);
      }
      
      public function endParty() : void
      {
         var _loc2_:Target = null;
         var _loc3_:PartiesConnection = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.targetMonitor.targets)
         {
            if(_loc2_.done)
            {
               _loc1_ += _loc2_.popularityValue;
            }
         }
         this._popularityPoints += _loc1_;
         _loc3_ = new PartiesConnection(this.loadPopularity,this.serviceError);
         _loc3_.setPopularity(this._popularityPoints,this.abilityString());
      }
      
      public function getParties(param1:Function = null) : void
      {
         if(!settings.services.parties || !settings.services.parties.enabled)
         {
            return;
         }
         this.callbackPartiesList = param1;
         var _loc2_:Number = new Date().getTime();
         if(_loc2_ - this.lastRefreshTime < settings.services.parties.blockRefreshPeriod)
         {
            if(this.callbackPartiesList != null)
            {
               this.callbackPartiesList();
            }
            return;
         }
         this.lastRefreshTime = _loc2_;
         var _loc3_:PartiesConnection = new PartiesConnection(this.createParties,this.serviceError);
         _loc3_.getParties();
      }
      
      private function createParties(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:com.qb9.gaturro.world.parties.Party = null;
         this._parties = new Array();
         for each(_loc3_ in param2)
         {
            (_loc4_ = new com.qb9.gaturro.world.parties.Party(_loc3_.owner,_loc3_.roomId,_loc3_.type,_loc3_.serverName)).isPublic = _loc3_.isPublic;
            _loc4_.capacity = _loc3_.capacity;
            _loc4_.duration = _loc3_.duration;
            _loc4_.invitedFriends = _loc3_.invited;
            _loc4_.setOptions(_loc3_.props);
            _loc4_.timestampInit = _loc3_.timestampInit;
            this._parties.push(_loc4_);
         }
         this._listLoaded = true;
         if(this.callbackPartiesList != null)
         {
            this.callbackPartiesList();
         }
      }
      
      public function get popularityLoaded() : Boolean
      {
         return this._popularityLoaded;
      }
      
      public function abilityString() : String
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:String = "";
         for(_loc2_ in settings.parties.abilities)
         {
            for each(_loc3_ in settings.parties.abilities[_loc2_])
            {
               if(_loc3_.available == true)
               {
                  _loc1_ += _loc3_.id.toString() + ";";
               }
            }
         }
         if(_loc1_.length > 1)
         {
            _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
         }
         return _loc1_;
      }
      
      public function getPopularity() : void
      {
         if(!settings.services.parties || !settings.services.parties.enabled)
         {
            return;
         }
         if(this._popularityLoaded)
         {
            return;
         }
         var _loc1_:PartiesConnection = new PartiesConnection(this.loadPopularity,this.serviceError);
         _loc1_.getPopularity();
      }
      
      public function createParty(param1:int, param2:Number, param3:int, param4:Boolean, param5:int, param6:int, param7:String, param8:String, param9:Function, param10:Function) : void
      {
         if(!settings.services.parties || !settings.services.parties.enabled)
         {
            return;
         }
         this.userInvitedFriends = param8.split(";");
         this.partyCreatedCallback = param9;
         this.partyErrorCallback = param10;
         param6 *= 1000;
         this.partyCreating = new com.qb9.gaturro.world.parties.Party(user.username,0,param3,server.serverName);
         this.partyCreating.isPublic = param4;
         this.partyCreating.capacity = param5;
         this.partyCreating.duration = param6;
         this.partyCreating.invitedFriends = param8;
         this.partyCreating.setOptions(param7.split(";"));
         this.partyCreating.timestampInit = server.time;
         this.totalPartyPrice = param1;
         net.addEventListener(GaturroNetResponses.PARTY_ROOM_CREATED,this.roomCreatedEvent);
         var _loc11_:PartiesConnection;
         (_loc11_ = new PartiesConnection(null,this.partyCreatingError)).createParty(param2,param4,param5,param6,param7,param8,server.time,param3,server.serverName);
      }
      
      public function enabledAbility(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in settings.parties.abilities)
         {
            for each(_loc3_ in settings.parties.abilities[_loc2_])
            {
               if(_loc3_.id == param1)
               {
                  _loc3_.available = true;
               }
            }
         }
      }
      
      public function get isPartyCreating() : Boolean
      {
         return this.partyCreating != null;
      }
      
      public function get popularityPoints() : int
      {
         return this._popularityPoints;
      }
      
      private function loadPopularity(param1:String, param2:Object) : void
      {
         var _loc4_:String = null;
         this._popularityLoaded = true;
         this._popularityPoints = param2.popularity;
         if(param2.abilitiesStr.indexOf(";") < 0)
         {
            return;
         }
         var _loc3_:Array = param2.abilitiesStr.split(";");
         for each(_loc4_ in _loc3_)
         {
            this.enabledAbility(int(_loc4_));
         }
      }
   }
}
