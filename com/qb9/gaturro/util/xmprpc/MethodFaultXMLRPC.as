package com.qb9.gaturro.util.xmprpc
{
   public class MethodFaultXMLRPC implements MethodFault
   {
       
      
      private var _fault:Object;
      
      public function MethodFaultXMLRPC(param1:Object)
      {
         super();
         if(param1)
         {
            this.setFaultObject(param1);
         }
      }
      
      public function getFaultString() : String
      {
         return String(this._fault.faultString);
      }
      
      public function toString() : String
      {
         return "[MethodFaultImpl(faultCode=" + this._fault.faultCode + ", faultString=" + this._fault.faultString + ")]";
      }
      
      public function setFaultObject(param1:Object) : void
      {
         this._fault = param1;
      }
      
      public function getArgs() : Array
      {
         return new Array(this._fault.args);
      }
      
      public function getFaultCode() : Number
      {
         return Number(this._fault.faultCode);
      }
   }
}
