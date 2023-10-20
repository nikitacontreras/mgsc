package com.gameanalytics.domain
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import com.gameanalytics.GALogEvent;
   import com.gameanalytics.constants.GAErrorSeverity;
   import com.gameanalytics.constants.GAEventConstants;
   import com.gameanalytics.constants.GASharedObjectConstants;
   import com.gameanalytics.utils.GAUniqueIdUtil;
   import com.gameanalytics.utils.IGADeviceUtil;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.utils.Timer;
   
   public class GACore extends EventDispatcher
   {
       
      
      private var sharedObject:SharedObject;
      
      private var gameKey:String;
      
      private var secretKey:String;
      
      private const API_URL:String = "https://api.gameanalytics.com";
      
      private const SDK_VERSION:String = "flash 2.0.2";
      
      private var debugMode:Boolean;
      
      private var eventQueue:Array;
      
      private var gameBuild:String;
      
      private var unhandledExceptionsLoaderInfo:LoaderInfo;
      
      private var dataSendTimer:Timer;
      
      private var deviceIdUtil:IGADeviceUtil;
      
      private const EVENT_LIMIT_PER_TYPE:int = 100;
      
      private var userId:String;
      
      private const DATA_SEND_INTERVAL:int = 7000;
      
      private var debugArray:Array;
      
      private var sessionId:String;
      
      private var initialized:Boolean;
      
      private var surpressExceptions:Boolean;
      
      public var RUN_IN_EDITOR_MODE:Boolean;
      
      private const API_VERSION:String = "1";
      
      public function GACore(param1:IGADeviceUtil)
      {
         this.debugArray = [];
         super();
         this.deviceIdUtil = param1;
      }
      
      public function destroy() : void
      {
         this.dataSendTimer.removeEventListener(TimerEvent.TIMER,this.onDataSendTimer);
         this.dataSendTimer.stop();
         if(this.unhandledExceptionsLoaderInfo)
         {
            this.deleteAllEvents();
         }
      }
      
      private function resetQueue(param1:String) : void
      {
         this.eventQueue[param1] = [];
         this.writeEventQueueToLocalSharedObject(this.eventQueue);
      }
      
      private function onRequestComplete(param1:Event) : void
      {
         this.removeEventListenersFromLoader(param1.currentTarget as URLLoader);
      }
      
      public function init(param1:String, param2:String, param3:String, param4:String = null, param5:String = null) : void
      {
         if(this.isValidString(param1))
         {
            this.secretKey = param1;
            if(this.isValidString(param2))
            {
               this.gameKey = param2;
               if(this.isValidString(param3))
               {
                  this.gameBuild = param3;
                  if(param5 != null)
                  {
                     if(!this.isValidString(param5))
                     {
                        this.throwError("init() - the user id can not be null or empty");
                        return;
                     }
                     this.userId = param5;
                  }
                  else
                  {
                     this.userId = this.deviceIdUtil.getDeviceId();
                  }
                  this.sessionId = !!param4 ? param4 : GAUniqueIdUtil.createUnuqueId();
                  this.eventQueue = this.getEventsQueue();
                  this.addEventToQueue(GAEventConstants.USER,this.deviceIdUtil.createInitialUserObject(this.userId,this.sessionId,param3,this.SDK_VERSION));
                  this.sendData();
                  this.dataSendTimer = new Timer(this.DATA_SEND_INTERVAL);
                  this.dataSendTimer.addEventListener(TimerEvent.TIMER,this.onDataSendTimer);
                  this.dataSendTimer.start();
                  this.initialized = true;
                  return;
               }
               this.throwError("init() - the game build can not be null or empty");
               return;
            }
            this.throwError("init() - the game key can not be null or empty");
            return;
         }
         this.throwError("init() - the secret key can not be null or empty");
      }
      
      private function addEventToQueue(param1:String, param2:Object) : void
      {
         if(this.RUN_IN_EDITOR_MODE)
         {
            this.log("RUN_IN_EDITOR_MODE is set to true - we will not send this " + param1 + " event: " + com.adobe.serialization.json.JSON.encode(param2));
         }
         else
         {
            this.log(param1 + " event added to queue: " + com.adobe.serialization.json.JSON.encode(param2));
            this.eventQueue[param1].push(param2);
            if(this.eventQueue[param1].length > this.EVENT_LIMIT_PER_TYPE)
            {
               this.eventQueue[param1].shift();
            }
            if(!this.RUN_IN_EDITOR_MODE)
            {
               this.writeEventQueueToLocalSharedObject(this.eventQueue);
            }
         }
      }
      
      private function isValidString(param1:String) : Boolean
      {
         return param1 != null && param1.length != 0;
      }
      
      private function writeEventQueueToLocalSharedObject(param1:Array) : void
      {
         var array:Array = param1;
         if(this.sharedObject)
         {
            this.sharedObject.data[GASharedObjectConstants.SHARED_OBJECT_EVENTQUEUE] = array;
            try
            {
               this.sharedObject.flush();
            }
            catch(e:Error)
            {
               trace(e.toString());
            }
         }
      }
      
      public function getVersion() : String
      {
         return this.SDK_VERSION;
      }
      
      public function getSessionId() : String
      {
         return this.sessionId;
      }
      
      public function deleteAllEvents() : void
      {
         this.eventQueue = this.createNewEventsQueue();
         if(this.sharedObject)
         {
            this.writeEventQueueToLocalSharedObject(null);
            this.log("All events deleted from the queue and local shared object");
         }
         else
         {
            this.log("All events deleted from the queue. Local shared object was not available so nothing was deleted in there");
         }
      }
      
      public function newErrorEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN, param5:Number = NaN, param6:Number = NaN) : void
      {
         if(param2 == GAErrorSeverity.CRITICAL || param2 == GAErrorSeverity.DEBUG || param2 == GAErrorSeverity.ERROR || param2 == GAErrorSeverity.INFO || param2 == GAErrorSeverity.WARNING)
         {
            this.addEventToQueue(GAEventConstants.ERROR,this.addOptionalParameters({
               "user_id":this.userId,
               "session_id":this.sessionId,
               "build":this.gameBuild,
               "message":param1,
               "severity":param2
            },param3,param4,param5,param6));
         }
         else
         {
            this.log("ERROR newErrorEvent: " + param2 + " is not a valid error severity. Please use the GAErrorSeverity constants for the types - for example, GAErrorSeverity.ERROR. Current value will be replaced with GAErrorSeverity.ERROR");
         }
      }
      
      public function get DEBUG_MODE() : Boolean
      {
         return this.debugMode;
      }
      
      public function catchUnhandledExceptions(param1:LoaderInfo, param2:Boolean) : void
      {
         if(!param1)
         {
            this.log("catchUnhandledExceptions - the loaderInfo can not be null. No exceptions will be catched");
         }
         else
         {
            this.unhandledExceptionsLoaderInfo = param1;
            this.surpressExceptions = param2;
         }
      }
      
      public function newDesignEvent(param1:String, param2:Number, param3:String = null, param4:Number = NaN, param5:Number = NaN, param6:Number = NaN) : void
      {
         this.addEventToQueue(GAEventConstants.DESIGN,this.addOptionalParameters({
            "user_id":this.userId,
            "session_id":this.sessionId,
            "build":this.gameBuild,
            "event_id":param1,
            "value":param2
         },param3,param4,param5,param6));
      }
      
      private function removeEventListenersFromLoader(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onRequestComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onRequestError);
         param1.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onRequestError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onRequestSecurityError);
         param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onRequestStatus);
      }
      
      private function onRequestError(param1:IOErrorEvent) : void
      {
         this.log("ERROR - There was an error with the Game Analytics Server. " + param1.text);
         this.removeEventListenersFromLoader(param1.currentTarget as URLLoader);
      }
      
      private function getEventsQueue() : Array
      {
         var eventsQueue:Array = null;
         try
         {
            this.sharedObject = SharedObject.getLocal(GASharedObjectConstants.SHARED_OBJECT_ID);
            eventsQueue = this.sharedObject.data[GASharedObjectConstants.SHARED_OBJECT_EVENTQUEUE];
         }
         catch(e:Error)
         {
            log("ERROR: Local storage is disabled - please check if the shared objects are enabled in the flash player settings. Events will not be stored locally and might get lost if there will be problems with sending events to the server (for example, if there is no internet connection available");
         }
         if(!eventsQueue)
         {
            this.log("No events found in local storage, creating new event queue");
            eventsQueue = this.createNewEventsQueue();
         }
         return eventsQueue;
      }
      
      public function getUserId() : String
      {
         return this.userId;
      }
      
      private function log(param1:String) : void
      {
         if(this.debugMode)
         {
            trace("GA SDK " + param1);
            dispatchEvent(new GALogEvent(GALogEvent.LOG,param1));
         }
         else
         {
            this.debugArray.push(param1);
            if(this.debugArray.length == 11)
            {
               this.debugArray.shift();
            }
         }
      }
      
      private function throwError(param1:String) : void
      {
         this.log(param1);
         throw new Error("GA SDK " + param1);
      }
      
      public function isInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function newUserEvent(param1:String, param2:uint = 0, param3:uint = 0, param4:String = "", param5:String = "", param6:String = "", param7:String = "", param8:String = "", param9:String = "", param10:String = "", param11:String = "", param12:String = "") : void
      {
         var _loc13_:Object = {
            "user_id":this.userId,
            "session_id":this.sessionId,
            "build":this.gameBuild
         };
         if(this.isValidString(param1))
         {
            if(param1 == "M" || param1 == "F")
            {
               _loc13_.gender = param1;
            }
            else
            {
               this.log("ERROR: newUserEvent - gender can only have values \"M\" or \"F\". This property will be ignored.");
            }
         }
         if(!isNaN(param2))
         {
            _loc13_.birth_year = param2;
         }
         if(!isNaN(param3))
         {
            _loc13_.friend_count = param3;
         }
         if(!isNaN(param3))
         {
            _loc13_.friend_count = param3;
         }
         if(this.isValidString(param4))
         {
            _loc13_.facebook_id = param4;
         }
         if(this.isValidString(param5))
         {
            _loc13_.googleplus_id = param5;
         }
         if(this.isValidString(param6))
         {
            _loc13_.install_publisher = param6;
         }
         if(this.isValidString(param7))
         {
            _loc13_.install_site = param7;
         }
         if(this.isValidString(param8))
         {
            _loc13_.install_campaign = param8;
         }
         if(this.isValidString(param9))
         {
            _loc13_.install_ad_group = param9;
         }
         if(this.isValidString(param10))
         {
            _loc13_.install_ad = param10;
         }
         if(this.isValidString(param11))
         {
            _loc13_.install_keyword = param11;
         }
         if(this.isValidString(param12))
         {
            _loc13_.adtruth_id = param12;
         }
         _loc13_.sdk_version = this.SDK_VERSION;
         this.addEventToQueue(GAEventConstants.USER,_loc13_);
      }
      
      public function sendData() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         if(this.dataSendTimer)
         {
            this.dataSendTimer.reset();
            this.dataSendTimer.start();
         }
         for(_loc1_ in this.eventQueue)
         {
            _loc2_ = this.eventQueue[_loc1_];
            if(_loc2_.length != 0)
            {
               this.sendEvent(_loc1_,_loc2_);
            }
         }
      }
      
      private function onRequestSecurityError(param1:SecurityErrorEvent) : void
      {
         this.log("ERROR - There was an error with the Game Analytics Server. " + param1.text);
         this.removeEventListenersFromLoader(param1.currentTarget as URLLoader);
      }
      
      private function onRequestStatus(param1:HTTPStatusEvent) : void
      {
         switch(param1.status)
         {
            case 200:
               this.log(param1.currentTarget.data + " event(s) were sent successfully.");
               break;
            case 400:
               this.log("ERROR 400 while sending " + param1.currentTarget.data + " event(s). Most likely this is because of an incorrect secret key, game id or corrupt JSON data");
               break;
            case 401:
               this.log("ERROR 401 while sending " + param1.currentTarget.data + " event(s). Most likely this is because of an incorrect secret key, game id or the value of the authorization header is not valid or missing");
               break;
            case 403:
               this.log("ERROR 403 while sending " + param1.currentTarget.data + " event(s). The url is invalid");
               break;
            case 404:
               this.log("ERROR 404 while sending " + param1.currentTarget.data + " event(s). Most likely the secret key or the game id are incorrect or there is a problem with the API call");
               break;
            case 500:
               this.log("ERROR 500 while sending " + param1.currentTarget.data + " event(s). Internal server error");
               break;
            case 501:
               this.log("ERROR 501 while sending " + param1.currentTarget.data + " event(s). The used HTTP method is not supported.");
               break;
            default:
               this.log("ERROR while sending " + param1.currentTarget.data + " event(s). Unknown error with the response code of " + param1.status);
         }
         this.resetQueue(param1.currentTarget.data);
      }
      
      private function createNewEventsQueue() : Array
      {
         var _loc1_:Array = [];
         _loc1_[GAEventConstants.BUSINESS] = [];
         _loc1_[GAEventConstants.DESIGN] = [];
         _loc1_[GAEventConstants.ERROR] = [];
         _loc1_[GAEventConstants.QUALITY] = [];
         _loc1_[GAEventConstants.USER] = [];
         return _loc1_;
      }
      
      public function set DEBUG_MODE(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         this.debugMode = param1;
         if(this.debugMode && this.debugArray.length != 0)
         {
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < this.debugArray.length)
            {
               _loc2_ += this.debugArray[_loc3_] + "\n";
               _loc3_++;
            }
            dispatchEvent(new GALogEvent(GALogEvent.LOG,_loc2_));
         }
      }
      
      private function addOptionalParameters(param1:Object, param2:String, param3:Number, param4:Number, param5:Number) : Object
      {
         if(param2 != null && param2 != "")
         {
            param1.area = param2;
         }
         if(!isNaN(param3))
         {
            param1.x = param3;
         }
         if(!isNaN(param4))
         {
            param1.y = param4;
         }
         if(!isNaN(param5))
         {
            param1.z = param5;
         }
         return param1;
      }
      
      private function sendEvent(param1:String, param2:Array) : void
      {
         var loader:URLLoader;
         var request:URLRequest;
         var jsonString:String = null;
         var type:String = param1;
         var data:Array = param2;
         try
         {
            jsonString = com.adobe.serialization.json.JSON.encode(data);
         }
         catch(e:Error)
         {
            throwError("ERROR: sendEvent - There was an error encoding the event as a JSON object. Error: " + e.message);
         }
         if(this.RUN_IN_EDITOR_MODE)
         {
            this.log("Event would be sent to the server if we were not in RUN_IN_EDITOR_MODE: " + type + " - " + jsonString);
            this.resetQueue(type);
            return;
         }
         this.log("Sending " + data.length + " " + type + " event(s): " + jsonString);
         request = new URLRequest(this.API_URL + "/" + this.API_VERSION + "/" + this.gameKey + "/" + type);
         request.data = jsonString;
         request.method = URLRequestMethod.POST;
         request.requestHeaders.push(new URLRequestHeader("Authorization",MD5.hash(jsonString + this.secretKey)));
         loader = new URLLoader();
         loader.data = type;
         loader.addEventListener(Event.COMPLETE,this.onRequestComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onRequestError);
         loader.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onRequestError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onRequestSecurityError);
         loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onRequestStatus);
         loader.load(request);
      }
      
      private function onDataSendTimer(param1:TimerEvent) : void
      {
         this.sendData();
      }
      
      public function newBusinessEvent(param1:String, param2:uint, param3:String, param4:String = null, param5:Number = NaN, param6:Number = NaN, param7:Number = NaN) : void
      {
         this.addEventToQueue(GAEventConstants.BUSINESS,this.addOptionalParameters({
            "user_id":this.userId,
            "session_id":this.sessionId,
            "build":this.gameBuild,
            "event_id":param1,
            "amount":param2,
            "currency":param3
         },param4,param5,param6,param7));
      }
   }
}
