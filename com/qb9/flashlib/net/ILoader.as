package com.qb9.flashlib.net
{
   import flash.events.IEventDispatcher;
   import flash.net.URLRequest;
   
   public interface ILoader extends IEventDispatcher
   {
       
      
      function getData() : *;
      
      function setDataFormat(param1:String) : void;
      
      function getDataFormat() : String;
      
      function close() : void;
      
      function loadURL(param1:URLRequest) : void;
      
      function getBytesLoaded() : uint;
      
      function getBytesTotal() : uint;
   }
}
