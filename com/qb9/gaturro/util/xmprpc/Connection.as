package com.qb9.gaturro.util.xmprpc
{
   import flash.events.IEventDispatcher;
   
   public interface Connection extends IEventDispatcher
   {
       
      
      function getFault() : MethodFault;
      
      function getResponse() : Object;
      
      function getUrl() : String;
      
      function addParam(param1:Object, param2:String) : void;
      
      function setUrl(param1:String) : void;
      
      function call(param1:String) : void;
   }
}
