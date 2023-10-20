package com.qb9.gaturro.util.xmprpc
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class ConnectionXMLRCP extends EventDispatcher implements Connection
   {
       
      
      private var _method:com.qb9.gaturro.util.xmprpc.MethodCall;
      
      private var ERROR_NO_URL:String = "No URL was specified for XMLRPCall.";
      
      private var _PRODUCT:String = "ConnectionImpl";
      
      private var _response:URLLoader;
      
      private var _fault:com.qb9.gaturro.util.xmprpc.MethodFault;
      
      private var _parsed_response:Object;
      
      private var _url:String;
      
      private var _VERSION:String = "1.0.0";
      
      private var _rpc_response:Object;
      
      private var _parser:com.qb9.gaturro.util.xmprpc.Parser;
      
      public function ConnectionXMLRCP()
      {
         super();
         this._method = new MethodCallXMLRPC();
         this._parser = new ParserXMLRPC();
         this._response = new URLLoader();
         this.addListeners();
      }
      
      private function _onLoad(param1:Event) : void
      {
         var responseXML:XML = null;
         var parsedFault:Object = null;
         var xml:XML = null;
         var evt:Event = param1;
         trace(this._response.data);
         try
         {
            responseXML = new XML(this._response.data);
            if(responseXML.fault.length() > 0)
            {
               parsedFault = this.parseResponse(responseXML.fault.value.*[0]);
               this._fault = new MethodFaultXMLRPC(parsedFault);
               trace("XMLRPC Fault (" + this._fault.getFaultCode() + "):\n" + this._fault.getFaultString());
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            }
            else if(responseXML.params)
            {
               xml = XML(responseXML.params.param.value[0]);
               if(xml.toString() != "")
               {
                  this._parsed_response = this.parseResponse(responseXML.params.param.value[0]);
               }
               else
               {
                  this._parsed_response = {};
               }
               dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
         }
         finally
         {
            this.removeListeners();
         }
      }
      
      public function setUrl(param1:String) : void
      {
         this._url = param1;
      }
      
      public function getFault() : com.qb9.gaturro.util.xmprpc.MethodFault
      {
         return this._fault;
      }
      
      public function getUrl() : String
      {
         return this._url;
      }
      
      private function debug(param1:String) : void
      {
      }
      
      private function parseResponse(param1:XML) : Object
      {
         return this._parser.parse(param1);
      }
      
      override public function toString() : String
      {
         return "<xmlrpc.ConnectionImpl Object>";
      }
      
      public function getResponse() : Object
      {
         return this._parsed_response;
      }
      
      private function removeListeners() : void
      {
         this._response.removeEventListener(Event.COMPLETE,this._onLoad);
         this._response.removeEventListener(IOErrorEvent.IO_ERROR,this._onError);
         this._response.removeEventListener(IOErrorEvent.NETWORK_ERROR,this._onError);
         this._response.removeEventListener(IOErrorEvent.VERIFY_ERROR,this._onError);
         this._response.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this._onError);
         this._response = null;
      }
      
      private function addListeners() : void
      {
         this._response.addEventListener(Event.COMPLETE,this._onLoad);
         this._response.addEventListener(IOErrorEvent.IO_ERROR,this._onError);
         this._response.addEventListener(IOErrorEvent.NETWORK_ERROR,this._onError);
         this._response.addEventListener(IOErrorEvent.VERIFY_ERROR,this._onError);
         this._response.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this._onError);
      }
      
      public function get methodCall() : com.qb9.gaturro.util.xmprpc.MethodCall
      {
         return this._method;
      }
      
      public function call(param1:String) : void
      {
         this._call(param1);
      }
      
      private function _onError(param1:Event) : void
      {
         this.removeListeners();
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      public function addParam(param1:Object, param2:String) : void
      {
         this._method.addParam(param1,param2);
      }
      
      public function removeParams() : void
      {
         this._method.removeParams();
      }
      
      private function _call(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         if(!this.getUrl())
         {
            trace(this.ERROR_NO_URL);
            throw Error(this.ERROR_NO_URL);
         }
         this.debug("Call -> " + param1 + "() -> " + this.getUrl());
         this._method.setName(param1);
         _loc2_ = new URLRequest(this.getUrl());
         _loc2_.contentType = "text/xml";
         _loc2_.data = this._method.getXml();
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.url = this.getUrl();
         trace(_loc2_.data);
         this._response.load(_loc2_);
      }
   }
}
