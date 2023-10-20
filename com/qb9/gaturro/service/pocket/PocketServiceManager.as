package com.qb9.gaturro.service.pocket
{
   import com.adobe.serialization.json.JSON;
   import com.dynamicflash.util.Base64;
   import com.qb9.gaturro.crypto.customsha256.HMCACustomSHA256;
   import com.qb9.gaturro.globals.logger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   
   public class PocketServiceManager extends EventDispatcher
   {
       
      
      private var _requestedData:Object;
      
      private var _timestamp:String;
      
      private var _accessKey:String;
      
      private var _url:String;
      
      private var _loader:URLLoader;
      
      private var _signature:String;
      
      private var _customHeader:Object;
      
      public function PocketServiceManager()
      {
         super();
      }
      
      public function buildRequest(param1:String = "POST", param2:String = "", param3:String = "", param4:Array = null) : void
      {
         this._url = param2;
         this._customHeader = param4;
         logger.info(this,"@@@@@@ URL:" + param2 + " , data:" + param3);
         if(param1 == "POST")
         {
            this.POSTRequest(param3);
         }
      }
      
      private function generateSignature(param1:String, param2:String, param3:String) : String
      {
         var _loc5_:String = param1 + " " + param3 + " " + param2;
         var _loc6_:HMCACustomSHA256;
         (_loc6_ = new HMCACustomSHA256("uV3F3YluFJax1cknvbcGwgjvx4QpvB+leU8dUj2o",_loc5_)).calculate();
         return Base64.encode(_loc6_.calculate());
      }
      
      private function POSTRequest(param1:String) : void
      {
         this._accessKey = "0PN5J17HBGZHT7JJ3X82";
         this._timestamp = this.getTimestamp();
         this._signature = this.generateSignature("POST",this._timestamp,this._accessKey);
         var _loc2_:String = this.url;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.contentType = "application/json";
         var _loc4_:Array = this.buildHeader("POST");
         if(this._customHeader)
         {
            _loc4_ = _loc4_.concat(this._customHeader);
         }
         _loc3_.requestHeaders = _loc4_;
         _loc3_.url = _loc2_;
         if(param1 != "")
         {
            _loc3_.data = com.adobe.serialization.json.JSON.encode(com.adobe.serialization.json.JSON.decode(param1));
         }
         this._loader = new URLLoader(_loc3_);
         this._loader.addEventListener(Event.COMPLETE,this.requestComplete);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErr);
         this._loader.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         this._loader.dataFormat = URLLoaderDataFormat.TEXT;
         this._loader.load(_loc3_);
         logger.info(this,"@@@@@@ REQUEST SENT HEADER: " + _loc4_);
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         logger.info(this,"@@@@@@ REQUEST HTTPStatusEvent eventPhase:" + param1.eventPhase);
         logger.info(this,"@@@@@@ REQUEST HTTPStatusEvent STATUS:" + param1.status);
      }
      
      private function buildHeader(param1:String) : Array
      {
         return [new URLRequestHeader("X-AccessKey",this._accessKey),new URLRequestHeader("X-Method",param1),new URLRequestHeader("X-Timestamp",this._timestamp),new URLRequestHeader("X-Signature",this._signature),new URLRequestHeader("Content-Type","application/json")];
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         logger.info(this,"@@@@@@ REQUEST PROGRESS DATA:" + param1.target);
      }
      
      private function onSecurityErr(param1:SecurityErrorEvent) : void
      {
         trace("error: " + param1.text);
      }
      
      private function getTimestamp() : String
      {
         var _loc1_:Date = new Date();
         return _loc1_.getFullYear() + "/" + (_loc1_.getMonth() + 1) + "/" + _loc1_.getDate() + " " + _loc1_.getHours() + ":" + _loc1_.getMinutes() + ":" + _loc1_.getSeconds();
      }
      
      private function requestComplete(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.requestComplete);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErr);
         logger.info(this,"@@@@@@ REQUEST COMPLETED DATA:" + param1.target.data);
         if((param1.target.data as String).indexOf("Error") >= 0)
         {
            this.dispatchEvent(new Event(Event.CANCEL));
         }
         else
         {
            this._requestedData = com.adobe.serialization.json.JSON.decode(param1.target.data);
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         trace("error: " + param1.toString());
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get requestedData() : Object
      {
         return this._requestedData;
      }
   }
}
