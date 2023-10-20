package com.qb9.gaturro.user.club
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class MeritContest
   {
       
      
      private const ATTR_MERIT_PRICE:String = "meritWeekPrice";
      
      private var _premioSemanal:String;
      
      private var _from:Number;
      
      private const ATTR_MERIT_POINTS:String = "meritPoints";
      
      private var _settings:Object;
      
      private var _to:Number;
      
      private var _getMeritsWS_URL:String;
      
      private var _loader:URLLoader;
      
      private const ATTR_LAST_MERIT_ACCESS:String = "lastMeritAccess";
      
      private const REQUEST_MODE_GET_MERITPOINTS:uint = 0;
      
      private const REQUEST_MODE_SET_MERITPOINTS:uint = 1;
      
      private const METHOD_ADD_MERITS:String = "add_merit_points";
      
      private const ATTR_STACKED_MERIT_POINTS:String = "stackedMeritPoints";
      
      private var _minigames:Array;
      
      private const METHOD_GET_MERITS:String = "get_merit_points";
      
      private var _targetMerits:uint;
      
      private var CLUBES_WS_AR_URL:String;
      
      private var _getMeritsCallback:Function;
      
      private var _hasMeritPrice:Boolean;
      
      public function MeritContest()
      {
         super();
         this.init();
      }
      
      public function get premioSemanal() : String
      {
         return this.currentWeek.premio;
      }
      
      public function get hasMeritPrice() : Boolean
      {
         if(api.getProfileAttribute(this.ATTR_MERIT_PRICE) == "true")
         {
            return true;
         }
         return false;
      }
      
      public function get aportedMeritPoints() : uint
      {
         return uint(api.getProfileAttribute(this.ATTR_STACKED_MERIT_POINTS));
      }
      
      public function set lastUserAccess(param1:Number) : void
      {
         api.setProfileAttribute(this.ATTR_LAST_MERIT_ACCESS,String(param1));
      }
      
      public function get targetMerits() : uint
      {
         return uint(this.currentWeek.puntosObjetivo);
      }
      
      private function init() : void
      {
         this._settings = api.config.clubMeritos;
         this._getMeritsWS_URL = api.config.clubes.servicPath;
      }
      
      public function get currentWeek() : Object
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Array = this._settings.mes.semanas;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new Date(_loc1_[_loc2_].from).getTime();
            trace(_loc3_);
            _loc4_ = new Date(_loc1_[_loc2_].to).getTime();
            if(this.actualTime > _loc3_ && this.actualTime < _loc4_)
            {
               return _loc1_[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function set aportedMeritPoints(param1:uint) : void
      {
         api.setProfileAttribute(this.ATTR_STACKED_MERIT_POINTS,0);
      }
      
      public function get active() : Boolean
      {
         if(this.currentWeek != null)
         {
            return true;
         }
         return false;
      }
      
      public function get settings() : Object
      {
         return this._settings;
      }
      
      public function get to() : Number
      {
         return new Date(this.currentWeek.to).getTime();
      }
      
      public function givemePrize() : String
      {
         if(this.currentWeek == null)
         {
            return null;
         }
         if(this.lastUserAccess < this.from && this.hasMeritPrice)
         {
            this.hasMeritPrice = false;
            this.userMeritPoints = 0;
         }
         this.lastUserAccess = this.actualTime;
         this._minigames = this.currentWeek.minigames;
         this._premioSemanal = this.currentWeek.premio;
         this._targetMerits = this.currentWeek.puntosObjetivo;
         if(this.userMeritPoints >= this._targetMerits && !this.hasMeritPrice)
         {
            this.userMeritPoints = 0;
            this.hasMeritPrice = true;
            return this._premioSemanal;
         }
         return null;
      }
      
      private function onGetMeritsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data;
         var _loc4_:Object = com.adobe.serialization.json.JSON.decode(_loc3_);
         this._getMeritsCallback(_loc4_);
      }
      
      private function addMeritsToClub(param1:uint) : void
      {
         var loader:URLLoader = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         var points:uint = param1;
         try
         {
            loader = new URLLoader();
            request = new URLRequest(this._getMeritsWS_URL);
            request.method = URLRequestMethod.POST;
            variables = new URLVariables();
            variables.m = this.METHOD_ADD_MERITS;
            variables.at = api.user.hashSessionId;
            variables.cn = api.getProfileAttribute("clubPertenencia");
            variables.p = String(points);
            request.data = variables;
            loader.addEventListener(Event.COMPLETE,this.onSetMeritsComplete);
            loader.load(request);
         }
         catch(err:Error)
         {
            logger.error("====================  No se pudieron agregar meritos al club: error: " + err.errorID + ", mensaje: " + err.message);
         }
      }
      
      public function get lastUserAccess() : Number
      {
         return Number(api.getProfileAttribute(this.ATTR_LAST_MERIT_ACCESS));
      }
      
      private function onSetMeritsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data;
      }
      
      public function get from() : Number
      {
         return new Date(this.currentWeek.from).getTime();
      }
      
      public function get minigames() : Array
      {
         if(this.currentWeek != null)
         {
            return this.currentWeek.minigames;
         }
         return null;
      }
      
      public function getClubMeritScore(param1:Function) : void
      {
         if(param1 == null)
         {
            throw Error("debe especificar un callback");
         }
         this._getMeritsCallback = param1;
         this.readClubPoints();
      }
      
      public function isMeritableGame(param1:String) : Boolean
      {
         var _loc2_:Array = this.currentWeek.minigames as Array;
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].name == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function addMeritPoints(param1:uint, param2:String) : void
      {
         var _loc3_:uint = 0;
         if(!api.user.club.hasClub)
         {
            return;
         }
         if(this.isMeritableGame(param2) || param2 == "special")
         {
            _loc3_ = this.userMeritPoints + param1;
            this.userMeritPoints = _loc3_;
            _loc3_ = uint(int(api.getProfileAttribute(this.ATTR_STACKED_MERIT_POINTS)) + param1);
            api.setProfileAttribute(this.ATTR_STACKED_MERIT_POINTS,String(_loc3_));
            this.addMeritsToClub(param1);
         }
      }
      
      private function readClubPoints() : void
      {
         var urlConsulted:String = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         try
         {
            this._loader = new URLLoader();
            urlConsulted = this._getMeritsWS_URL;
            request = new URLRequest(urlConsulted);
            request.method = URLRequestMethod.POST;
            variables = new URLVariables();
            variables.m = this.METHOD_GET_MERITS;
            variables.at = api.user.hashSessionId;
            request.data = "at=" + api.user.hashSessionId + "&m=" + "get%5Fmerit%5Fpoints";
            request.url = urlConsulted;
            this._loader.addEventListener(Event.COMPLETE,this.onGetMeritsComplete);
            this._loader.load(request);
         }
         catch(err:Error)
         {
         }
      }
      
      public function discardClubPoints() : void
      {
         this.userMeritPoints = 0;
         this.aportedMeritPoints = 0;
      }
      
      public function set userMeritPoints(param1:uint) : void
      {
         api.setProfileAttribute(this.ATTR_MERIT_POINTS,param1);
      }
      
      public function get actualTime() : Number
      {
         return new Date(api.time).getTime();
      }
      
      public function set hasMeritPrice(param1:Boolean) : void
      {
         api.setProfileAttribute(this.ATTR_MERIT_PRICE,String(param1));
      }
      
      public function get userMeritPoints() : uint
      {
         return uint(api.getProfileAttribute(this.ATTR_MERIT_POINTS));
      }
   }
}
