package com.qb9.gaturro.net.secure
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   
   public class SecureURLLoader extends EventDispatcher
   {
       
      
      private var _serviceDebuggLog:String;
      
      protected var _jsonRequest:String;
      
      protected var _headerMethodField:String = "X-Method";
      
      protected var _webServiceRequest:URLRequest;
      
      protected var _webServiceLoader:URLLoader;
      
      private var _signatureRequest:URLRequest;
      
      protected var _webServiceMethod:String;
      
      private var _className:String;
      
      protected var _webServicePath:String;
      
      private var _serviceEnabled:Boolean;
      
      protected var _headerXMethod:String;
      
      protected var _webServiceURL:String;
      
      private var _signatureResponse:Object;
      
      private var _debugOutput:Boolean;
      
      private var _signatureURL:String;
      
      protected var _timeStamp:String;
      
      protected var _signatureValue:String;
      
      private var _signatureLoader:URLLoader;
      
      private var _signaturePath:String;
      
      public function SecureURLLoader()
      {
         super();
         this._debugOutput = settings.secureWebServices.debuggMode;
         this._className = getQualifiedClassName(this);
         this._className = this._className.substr(this._className.indexOf("::") + 2);
         this._serviceEnabled = settings.secureWebServices[this._className].enabled;
         this._signatureLoader = new URLLoader();
         this._webServiceRequest = new URLRequest();
         this._signatureURL = settings.secureWebServices.signer_service.url;
         this._signaturePath = settings.secureWebServices.signer_service.path;
         this._webServiceURL = settings.secureWebServices[this._className].url;
         this._webServiceMethod = settings.secureWebServices[this._className].method;
         this._webServicePath = settings.secureWebServices[this._className].path;
         this.addEventListener(SecureResponseErrorEvent.ERROR,this.printLog);
         this.addEventListener(SecureResponseEvent.PREPROCESS_COMPLETE,this.printLog);
         this._serviceDebuggLog = "________________ LOG: " + this._className + "________________\n";
      }
      
      private function preProcessResponse(param1:Event) : void
      {
         this._serviceDebuggLog += " <-- raw response: " + param1.currentTarget.data + "\n";
         var _loc2_:String = URLLoader(param1.target).data;
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(_loc2_);
         if(_loc3_.error != null)
         {
            this.dispatchEvent(new SecureResponseErrorEvent(SecureResponseErrorEvent.ERROR,_loc3_.error));
         }
         else
         {
            this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.PREPROCESS_COMPLETE,_loc3_));
            this.onWebserviceLoaded(_loc3_);
         }
         this.dispose();
      }
      
      private function printLog(param1:Event) : void
      {
         this._serviceDebuggLog += "________________ -------------- ________________\n";
         if(this._debugOutput)
         {
            logger.debug(this._serviceDebuggLog);
         }
      }
      
      private function onSignatureLoaded(param1:Event) : void
      {
         this._serviceDebuggLog += " \t\t<-- response: " + param1.currentTarget.data + "\n";
         if(Object(com.adobe.serialization.json.JSON.decode(param1.currentTarget.data)).error != null)
         {
            return;
         }
         this._signatureResponse = com.adobe.serialization.json.JSON.decode(param1.currentTarget.data) as Object;
         this._signatureValue = this._signatureResponse.signature;
         this._timeStamp = this._signatureResponse.timestamp;
         this._serviceDebuggLog += "\t\t<-- signature: " + this._signatureValue + "\n";
         this._serviceDebuggLog += " \t\t<-- timestamp: " + this._timeStamp + "\n";
         this.loadWebService();
      }
      
      protected function onWebserviceLoaded(param1:Object) : void
      {
         this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.SERVICE_COMPLETE,param1));
      }
      
      protected function loadWebService() : void
      {
         var _loc1_:Object = null;
         var _loc2_:URLRequestHeader = null;
         this._serviceDebuggLog += " ---------- LOADING WEBSERVICE ----------\n";
         this._webServiceRequest.requestHeaders.push(new URLRequestHeader("X-Timestamp",this._timeStamp));
         this._webServiceRequest.requestHeaders.push(new URLRequestHeader("X-Signature",this._signatureValue));
         this._webServiceRequest.requestHeaders.push(new URLRequestHeader("X-AccessKey",GameData.serviceAccessKey));
         this._webServiceRequest.requestHeaders.push(new URLRequestHeader(this._headerMethodField,this._headerXMethod));
         this._webServiceLoader = new URLLoader();
         this._webServiceLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this._webServiceRequest.method = this._webServiceMethod;
         this._webServiceLoader.addEventListener(Event.COMPLETE,this.preProcessResponse);
         this._webServiceLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onwebServiceLoadIOError);
         this._webServiceLoader.addEventListener(IOErrorEvent.DISK_ERROR,this.onwebServiceLoadIOError);
         this._webServiceLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onwebServiceLoadIOError);
         this._webServiceLoader.addEventListener(IOErrorEvent.VERIFY_ERROR,this.onwebServiceLoadIOError);
         this._webServiceLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onwebServiceLoadSecurityError);
         this._webServiceLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onhttpStatus);
         this._webServiceLoader.load(this._webServiceRequest);
         this._serviceDebuggLog += " -- url: " + this._webServiceRequest.url + "\n";
         this._serviceDebuggLog += " -- headers: \n";
         for each(_loc1_ in this._webServiceRequest.requestHeaders)
         {
            _loc2_ = URLRequestHeader(_loc1_);
            this._serviceDebuggLog += "\t\t|--header --> " + _loc2_.name + " // " + _loc2_.value + "\n";
         }
      }
      
      private function onhttpStatus(param1:HTTPStatusEvent) : void
      {
         var _loc2_:HttpStatus = new HttpStatus();
         this._serviceDebuggLog += " \t\t<-- HTTP_STATUS: " + param1.status + " - " + _loc2_[param1.status] + "\n";
      }
      
      private function onSignatureLoadIOError(param1:IOErrorEvent) : void
      {
         this._serviceDebuggLog += " [X] -- IO_SIGNATURE_ERROR: " + param1.text + "\n";
         this.dispatchEvent(new SecureResponseErrorEvent(SecureResponseErrorEvent.ERROR,param1.text));
         this.dispose();
      }
      
      private function onwebServiceLoadIOError(param1:IOErrorEvent) : void
      {
         this._serviceDebuggLog += " [X] -- IO_ERROR: " + param1.text + "\n";
         this.dispatchEvent(new SecureResponseErrorEvent(SecureResponseErrorEvent.ERROR,param1.text));
         this.dispose();
      }
      
      protected function dispose() : void
      {
         if(this._webServiceLoader)
         {
            this._webServiceLoader.removeEventListener(Event.COMPLETE,this.preProcessResponse);
            this._webServiceLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onwebServiceLoadIOError);
            this._webServiceLoader.removeEventListener(IOErrorEvent.DISK_ERROR,this.onwebServiceLoadIOError);
            this._webServiceLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onwebServiceLoadIOError);
            this._webServiceLoader.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.onwebServiceLoadIOError);
            this._webServiceLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onwebServiceLoadSecurityError);
            this._webServiceLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onhttpStatus);
         }
         if(this._signatureLoader)
         {
            this._signatureLoader.removeEventListener(Event.COMPLETE,this.onSignatureLoaded);
            this._signatureLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onSignatureLoadIOError);
            this._signatureLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onhttpStatus);
         }
         this.removeEventListener(SecureResponseErrorEvent.ERROR,this.printLog);
         this.removeEventListener(SecureResponseEvent.PREPROCESS_COMPLETE,this.printLog);
      }
      
      private function onwebServiceLoadSecurityError(param1:SecurityErrorEvent) : void
      {
         this.dispatchEvent(new SecureResponseErrorEvent(SecureResponseErrorEvent.ERROR,param1.text));
         this._serviceDebuggLog += " [X] -- SECURITY_ERROR: " + param1.text + "\n";
         this.dispose();
      }
      
      protected function loadSignature() : void
      {
         if(!this._serviceEnabled)
         {
            this.dispatchEvent(new SecureResponseErrorEvent(SecureResponseErrorEvent.ERROR,"Service disabled by the client settings",ResponseErrorCode.SERVICE_DISABLED));
            return;
         }
         this._serviceDebuggLog += "------------ LOADING SIGNATURE ---------- \n";
         this._signatureRequest = new URLRequest(this._signatureURL + this._signaturePath);
         this._signatureLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this._signatureRequest.method = URLRequestMethod.POST;
         var _loc1_:* = "{\"session\":\"" + user.hashSessionId + "\", \"username\":\"" + user.username + "\",\"method\":\"" + this._headerXMethod + "\",\"access_token\":\"" + GameData.serviceAccessKey + "\"}";
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.request = _loc1_;
         this._signatureRequest.data = _loc2_;
         this._signatureLoader.addEventListener(Event.COMPLETE,this.onSignatureLoaded);
         this._signatureLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onSignatureLoadIOError);
         this._signatureLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onhttpStatus);
         this._signatureLoader.load(this._signatureRequest);
         this._serviceDebuggLog += " --> url: " + this._signatureRequest.url + "\n";
         this._serviceDebuggLog += " --> json request: " + _loc1_ + "\n";
      }
   }
}
