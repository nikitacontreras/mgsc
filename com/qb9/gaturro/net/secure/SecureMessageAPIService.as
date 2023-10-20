package com.qb9.gaturro.net.secure
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class SecureMessageAPIService extends SecureURLLoader
   {
       
      
      private var _parameters:URLVariables;
      
      private var _messageAPIMethod:String;
      
      private var _serviceMethod:String;
      
      public function SecureMessageAPIService()
      {
         super();
         this._parameters = new URLVariables();
      }
      
      public function getMessageById(param1:Number) : void
      {
         _webServiceMethod = URLRequestMethod.GET;
         this._messageAPIMethod = MessageAPIMethod.GET;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId + "&";
         this._parameters.id = param1;
         _webServiceRequest.data = this._parameters;
         _headerXMethod = HttpMethod.GET;
         loadSignature();
      }
      
      override protected function onWebserviceLoaded(param1:Object) : void
      {
         switch(this._messageAPIMethod)
         {
            case MessageAPIMethod.CHECK:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_CHECK,param1));
               break;
            case MessageAPIMethod.DELETE:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_DELETE,param1));
               break;
            case MessageAPIMethod.GET:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_GET,param1));
               break;
            case MessageAPIMethod.GET_NEWEST:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_GET_NEWEST,param1));
               break;
            case MessageAPIMethod.MARK_READ:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_MARK_READ,param1));
               break;
            case MessageAPIMethod.NEW_CODED:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_NEW_CODED,param1));
               break;
            case MessageAPIMethod.WHITELIST:
               this.dispatchEvent(new SecureResponseEvent(SecureResponseEvent.API_MESSAGE_WHITELIST,param1));
         }
      }
      
      override protected function loadWebService() : void
      {
         super.loadWebService();
      }
      
      public function getNewestMessages(param1:Number, param2:Number = NaN) : void
      {
         _webServiceMethod = URLRequestMethod.GET;
         this._messageAPIMethod = MessageAPIMethod.GET_NEWEST;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId + "&";
         this._parameters.n = param1;
         this._parameters.f = param2;
         _webServiceRequest.contentType = "application/json";
         trace(_webServiceRequest.requestHeaders);
         _headerXMethod = HttpMethod.GET;
         loadSignature();
      }
      
      public function get parameters() : URLVariables
      {
         return this._parameters;
      }
      
      public function getWhiteList() : void
      {
         _webServiceMethod = URLRequestMethod.GET;
         this._messageAPIMethod = MessageAPIMethod.WHITELIST;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "/" + settings.secureWebServices.SecureMessageAPIService.country + "?access_token=" + user.hashSessionId;
         _headerXMethod = HttpMethod.GET;
         loadSignature();
      }
      
      public function checkMessages() : void
      {
         _webServiceMethod = URLRequestMethod.GET;
         this._messageAPIMethod = MessageAPIMethod.CHECK;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId;
         _webServiceRequest.data = this._parameters;
         _webServiceRequest.contentType = "application/json";
         _headerXMethod = HttpMethod.GET;
         loadSignature();
      }
      
      public function markAsRead(param1:Number) : void
      {
         _headerMethodField = HttpHeaderField.METHOD_OVERRIDE;
         _webServiceMethod = URLRequestMethod.POST;
         this._messageAPIMethod = MessageAPIMethod.MARK_READ;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId + "&";
         this._parameters.id = param1;
         _webServiceRequest.data = this._parameters;
         _headerXMethod = HttpMethod.PUT;
         loadSignature();
      }
      
      public function newMessage(param1:String, param2:Object, param3:String) : void
      {
         _webServiceMethod = URLRequestMethod.POST;
         _headerMethodField = HttpHeaderField.METHOD;
         this._messageAPIMethod = MessageAPIMethod.NEW_CODED;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId;
         _jsonRequest = "{ \"subject\":\"" + param1 + "\", \"message\":\"" + param2 + "\", \"recipient\":\"" + param3 + "\"}";
         trace("----------- " + _jsonRequest);
         _webServiceRequest.contentType = "application/json";
         _webServiceRequest.data = _jsonRequest;
         _headerXMethod = HttpMethod.POST;
         loadSignature();
      }
      
      public function get messageAPIMethod() : String
      {
         return this._messageAPIMethod;
      }
      
      public function deleteMessage(param1:Number) : void
      {
         _headerMethodField = HttpHeaderField.METHOD_OVERRIDE;
         _webServiceMethod = URLRequestMethod.POST;
         this._messageAPIMethod = MessageAPIMethod.DELETE;
         _webServiceRequest.url = _webServiceURL + _webServicePath + "/" + this._messageAPIMethod + "?access_token=" + user.hashSessionId + "&";
         this._parameters.id = param1;
         _webServiceRequest.data = this._parameters;
         _headerXMethod = HttpMethod.DELETE;
         loadSignature();
      }
   }
}
