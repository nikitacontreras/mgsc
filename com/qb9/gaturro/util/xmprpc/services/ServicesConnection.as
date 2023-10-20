package com.qb9.gaturro.util.xmprpc.services
{
   import com.qb9.gaturro.net.security.SecurityMethod;
   import com.qb9.gaturro.util.xmprpc.ConnectionXMLRCP;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   public class ServicesConnection extends ConnectionXMLRCP
   {
       
      
      protected var successCallback:Function;
      
      protected var errorCallback:Function;
      
      protected var managerCallback:Function;
      
      protected var usernameConsulted:String;
      
      private const securityKey:String = "YEDpIUWlKSIBBwIK";
      
      public function ServicesConnection(param1:Function = null, param2:Function = null)
      {
         super();
         this.successCallback = param1;
         this.errorCallback = param2;
      }
      
      protected function completeMethod(param1:Event) : void
      {
         this.removeListeners();
         var _loc2_:Array = this.getResponse() as Array;
         if(_loc2_[0] == "success")
         {
            if(_loc2_[1] == "false")
            {
               this.errorCallback(this.usernameConsulted,{
                  "success":false,
                  "conn":this,
                  "params":_loc2_
               });
               return;
            }
         }
         if(this.managerCallback != null)
         {
            this.managerCallback(_loc2_);
         }
         this.successCallback = null;
         this.errorCallback = null;
      }
      
      public function sendMessage(param1:String, param2:Function = null) : void
      {
         this.setUrl(this.urlApi);
         this.managerCallback = param2;
         this.addEventListener(Event.COMPLETE,this.completeMethod);
         this.addEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.addEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         this.addEventListener(IOErrorEvent.VERIFY_ERROR,this.error);
         this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.error);
         this.addEventListener(ErrorEvent.ERROR,this.error);
         this.call(param1);
      }
      
      protected function get urlApi() : String
      {
         return "";
      }
      
      protected function applySecurity() : void
      {
         var _loc1_:SecurityMethod = new SecurityMethod();
         var _loc2_:Object = _loc1_.createValidationDigest(this.securityKey);
         this.addParam(_loc2_.digestNum,XMLRPCDataTypes.STRING);
         this.addParam(_loc2_.digestHash,XMLRPCDataTypes.STRING);
      }
      
      protected function error(param1:Event) : void
      {
         this.removeListeners();
         var _loc2_:Object = this.getResponse();
         if(this.errorCallback != null)
         {
            if(!_loc2_)
            {
               _loc2_ = {
                  "success":false,
                  "conn":this
               };
            }
            this.errorCallback(this.usernameConsulted,_loc2_);
         }
         this.successCallback = null;
         this.errorCallback = null;
      }
      
      protected function removeListeners() : void
      {
         this.removeEventListener(Event.COMPLETE,this.completeMethod);
         this.removeEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         this.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.error);
         this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.error);
         this.removeEventListener(ErrorEvent.ERROR,this.error);
      }
   }
}
