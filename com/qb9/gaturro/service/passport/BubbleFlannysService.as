package com.qb9.gaturro.service.passport
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.service.pocket.PocketServiceManager;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   import flash.utils.clearTimeout;
   
   public class BubbleFlannysService
   {
       
      
      private var _settings:Object;
      
      private var _bubbleFunnysAutRequest:PocketServiceManager;
      
      private var _currentBreedName:String;
      
      private var _funnysToken;
      
      private var _authCompleted:Boolean = false;
      
      private var _onGiveFannyCallback:Function;
      
      private var _funnysAuthURLPROD:String = "https://api.mundogaturro.com/bubble";
      
      private var _timestamp:String;
      
      private var _chanceFunnyRequest:PocketServiceManager;
      
      private var _pocketRequest:PocketServiceManager;
      
      private var _cannotGetFunny:Boolean;
      
      private var loader:URLLoader;
      
      private var _getFunnysURL:String = "http://172.16.45.65:9060/api/gaturro-buble-reward/reward-bubble/";
      
      private var _pocketAuthURL:String = "http://api.devlop.mundogaturro.cmd.com.ar/auth?suppressResponseCodes=true";
      
      private var _giveFunnyRequest:PocketServiceManager;
      
      private var _signature:String;
      
      private var _listFunnyRequest:PocketServiceManager;
      
      private var _pocketToken;
      
      private var send_timeoutID:uint;
      
      private var _ableToSendReq:Boolean;
      
      private var _canIGetFunny:Boolean = false;
      
      private var _accessKey:String;
      
      private var _currentBreedCode:String;
      
      private var _funnysAuthURLPRE:String = "http://api.devlop.mundogaturro.cmd.com.ar/bubble";
      
      private var _userData:Object;
      
      private var availableGoal:Object;
      
      public function BubbleFlannysService()
      {
         super();
      }
      
      public function getChanceFunny() : void
      {
         this._canIGetFunny = false;
         if(!this._ableToSendReq)
         {
            return;
         }
         this.availableGoal = this.canIgetPet();
         if(!this.availableGoal)
         {
            return;
         }
         if(Math.random() > (this.availableGoal.chance as Number))
         {
            return;
         }
         var _loc1_:Array = [new URLRequestHeader("Authorization","Bearer " + this._funnysToken)];
         logger.info(this,"getChanceFunny : GET CHANCE CAN GET FANNY 1/2");
         this._chanceFunnyRequest = new PocketServiceManager();
         var _loc2_:String = !!settings.debug.fannysProd ? this._funnysAuthURLPROD : this._funnysAuthURLPRE;
         this._chanceFunnyRequest.buildRequest("POST",_loc2_ + "/gaturro-buble-reward/reward-bubble/" + api.user.username + "/" + this.availableGoal.goal + "?save=false","{}",_loc1_);
         this._chanceFunnyRequest.addEventListener(Event.COMPLETE,this.endGetChanceFunny);
         this._chanceFunnyRequest.addEventListener(Event.CANCEL,this.getChanceFailed);
      }
      
      private function getChanceFailed(param1:Event) : void
      {
         this._cannotGetFunny = true;
         logger.info(this,"@@@@ getChanceFunny : FAILED 2/2");
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + param1);
      }
      
      public function init() : void
      {
         var _loc1_:String = String(api.user.username);
         var _loc2_:String = String(api.user.passwd);
         var _loc3_:* = "{\"username\":\"" + api.user.username + "\",\"password\":\"" + api.user.passwd + "\",\"applicationId\":\"2\"}";
         this._pocketRequest = new PocketServiceManager();
         this._pocketRequest.buildRequest("POST",this.getURL2(),_loc3_);
         this._pocketRequest.addEventListener(Event.COMPLETE,this.requestDone2);
         this._settings = settings.BubbleFlannys;
         this._canIGetFunny = false;
         api.trackEvent("FEATURES:BUBBLEFLANYS:LOGIN","INTENTO");
         logger.info(this,"@@@@ INIT 2/3 POCKET");
      }
      
      public function get authCompleted() : Boolean
      {
         return this._authCompleted;
      }
      
      public function giveFunny(param1:Function) : void
      {
         if(!this._ableToSendReq)
         {
            return;
         }
         this.availableGoal = this.canIgetPet();
         if(!this.availableGoal)
         {
            return;
         }
         var _loc2_:Array = [new URLRequestHeader("Authorization","Bearer " + this._funnysToken)];
         this._onGiveFannyCallback = param1;
         this._giveFunnyRequest = new PocketServiceManager();
         var _loc3_:String = !!settings.debug.fannysProd ? this._funnysAuthURLPROD : this._funnysAuthURLPRE;
         this._giveFunnyRequest.buildRequest("POST",_loc3_ + "/gaturro-buble-reward/reward-bubble/" + api.user.username + "/" + this.availableGoal.goal + "?save=true","{}",_loc2_);
         this._giveFunnyRequest.addEventListener(Event.COMPLETE,this.endGiveFunny);
      }
      
      private function openHandler(param1:Event) : void
      {
         trace("openHandler: " + param1);
      }
      
      private function requestDone2(param1:Event) : void
      {
         this._pocketRequest.removeEventListener(Event.COMPLETE,this.requestDone2);
         var _loc2_:Object = this._pocketRequest.requestedData;
         this._funnysToken = _loc2_.id_token;
         this._ableToSendReq = true;
         logger.info(this,"@@@@ INIT 3/3 FANNYS TOKEN");
         api.trackEvent("FEATURES:BUBBLEFLANYS:LOGIN","COMPLETADO");
         clearTimeout(this.send_timeoutID);
      }
      
      public function init2() : void
      {
         var _loc1_:String = String(api.user.username);
         var _loc2_:String = String(api.user.passwd);
         var _loc3_:* = "{\"username\":\"" + api.user.username + "\",\"password\":\"" + api.user.passwd + "\",\"applicationId\":\"2\"}";
         this._pocketRequest = new PocketServiceManager();
         this._pocketRequest.buildRequest("POST",this.getURL(),_loc3_);
         this._pocketRequest.addEventListener(Event.COMPLETE,this.completed);
         this._settings = settings.BubbleFlannys;
         this._canIGetFunny = false;
         logger.info(this,"@@@@ INIT 1/3 POCKET");
      }
      
      public function get currentBreedCode() : String
      {
         return this._currentBreedCode;
      }
      
      public function get currentBreedName() : String
      {
         return this._currentBreedName;
      }
      
      private function requestDone(param1:Event) : void
      {
         this._bubbleFunnysAutRequest.removeEventListener(Event.COMPLETE,this.requestDone);
         var _loc2_:Object = this._bubbleFunnysAutRequest.requestedData;
         this._funnysToken = _loc2_.id_token;
         this._ableToSendReq = true;
         logger.info(this,"@@@@ INIT 3/3 FANNYS TOKEN");
      }
      
      private function endGetChanceFunny(param1:Event) : void
      {
         var _loc2_:Object = this._chanceFunnyRequest.requestedData;
         this._cannotGetFunny = false;
         this._canIGetFunny = true;
         this._currentBreedCode = this.getBreedFromData();
         logger.info(this,"@@@@ getChanceFunny : GET CHANCE CAN GET FANNY 2/2");
         api.trackEvent("FEATURES:BUBBLEFLANYS:SHOW_BUBBLE",api.room.id.toString());
      }
      
      private function createCustomHeaderRequest() : Array
      {
         return [new URLRequestHeader("X-AccessKey","0PN5J17HBGZHT7JJ3X82"),new URLRequestHeader("X-Method","POST"),new URLRequestHeader("X-Timestamp",this._timestamp),new URLRequestHeader("X-Signature",this._signature),new URLRequestHeader("Authorization: ","Bearer "),new URLRequestHeader("Content-Type","application/json")];
      }
      
      public function URLRequestHeaderExample(param1:String, param2:String) : void
      {
         var request:URLRequest;
         var header:URLRequestHeader;
         var url:String = param1;
         var method:String = param2;
         this.loader = new URLLoader();
         this.configureListeners(this.loader);
         header = new URLRequestHeader("pragma","no-cache");
         request = new URLRequest(url);
         request.data = new URLVariables("name=John+Doe");
         request.method = method;
         request.requestHeaders.push(header);
         try
         {
            this.loader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      private function getURL() : String
      {
         var _loc1_:String = !!settings.debug.fannysProd ? "https://api.mundogaturro.com/auth?suppressResponseCodes=true" : "http://api.devlop.mundogaturro.cmd.com.ar/auth?suppressResponseCodes=true";
         return _loc1_;
      }
      
      public function ableToSendReq() : Boolean
      {
         return this._ableToSendReq;
      }
      
      private function passportRequestCompleted(param1:Event) : void
      {
         trace(param1.target.data);
      }
      
      private function completed(param1:Event) : void
      {
         this._pocketRequest.removeEventListener(Event.COMPLETE,this.completed);
         var _loc2_:Object = this._pocketRequest.requestedData;
         logger.info(this,"@@@@ INIT 2/3 FANNYS TOKEN");
         this._bubbleFunnysAutRequest = new PocketServiceManager();
         this._pocketToken = _loc2_.access_token;
         var _loc3_:* = "{\"username\":\"" + api.user.username + "\",\"tokenPocket\":\"" + _loc2_.access_token + "\",\"rememberMe\":\"true\"}";
         var _loc4_:String = !!settings.debug.fannysProd ? this._funnysAuthURLPROD : this._funnysAuthURLPRE;
         this._bubbleFunnysAutRequest.buildRequest("POST",_loc4_ + "/auth/gaturro-authenticate",_loc3_);
         this._bubbleFunnysAutRequest.addEventListener(Event.COMPLETE,this.requestDone);
      }
      
      public function clonEinit(param1:String, param2:String) : void
      {
         this.URLRequestHeaderExample(param1,param2);
         user.community.getBuddiesList();
      }
      
      private function canIgetPet() : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._settings.activeGoals)
         {
            for each(_loc3_ in _loc2_.roomIDs)
            {
               if(_loc3_ == api.room.id)
               {
                  _loc1_.push(_loc2_);
               }
            }
         }
         if(_loc1_.length > 0)
         {
            _loc4_ = Random.randint(0,_loc1_.length - 1);
            return _loc1_[_loc4_];
         }
         return null;
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         trace("httpStatusHandler: " + param1);
      }
      
      private function completeHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         trace("completeHandler: " + _loc2_.data);
      }
      
      private function getBreedFromData() : String
      {
         return this._chanceFunnyRequest.requestedData.pet.breed.breedCode;
      }
      
      public function get funnysToken() : *
      {
         return this._funnysToken;
      }
      
      private function endGetListFunnys(param1:Event) : void
      {
         var _loc2_:Object = this._listFunnyRequest.requestedData;
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         trace("progressHandler loaded:" + param1.bytesLoaded + " total: " + param1.bytesTotal);
      }
      
      private function getURL2() : String
      {
         return !!settings.debug.fannysProd ? "https://api.mundogaturro.com/bubble/auth/gaturro-login" : "http://api.devlop.mundogaturro.cmd.com.ar/bubble/auth/gaturro-login";
      }
      
      public function canIGetFunny() : Boolean
      {
         return this._canIGetFunny;
      }
      
      private function tryAgain() : void
      {
         clearTimeout(this.send_timeoutID);
         this._pocketRequest.removeEventListener(Event.COMPLETE,this.requestDone2);
         this.init();
      }
      
      public function getListFunnys() : void
      {
         if(!this._ableToSendReq)
         {
            return;
         }
         var _loc1_:Array = [new URLRequestHeader("Authorization","Bearer " + this._funnysToken)];
         this._listFunnyRequest = new PocketServiceManager();
         var _loc2_:String = !!settings.debug.fannysProd ? this._funnysAuthURLPROD : this._funnysAuthURLPRE;
         this._listFunnyRequest.buildRequest("POST",_loc2_ + "/gaturro/" + api.user.username + "/bubble-pets","{}",_loc1_);
         this._listFunnyRequest.addEventListener(Event.COMPLETE,this.endGetListFunnys);
      }
      
      private function endGiveFunny(param1:Event) : void
      {
         var _loc2_:Object = this._chanceFunnyRequest.requestedData;
         this._currentBreedCode = _loc2_.pet.breed.breedCode;
         this._currentBreedName = _loc2_.pet.breed.breedName;
         api.trackEvent("FEATURES:BUBBLEFLANYS:GIVE",_loc2_.pet.breed.breedName);
         this._onGiveFannyCallback();
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + param1);
      }
      
      public function cannotGetFunny() : Boolean
      {
         return this._cannotGetFunny;
      }
      
      private function configureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.completeHandler);
         param1.addEventListener(Event.OPEN,this.openHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
   }
}
