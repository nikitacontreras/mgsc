package com.qb9.flashlib.net
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   internal class QLoader extends Loader implements ILoader
   {
       
      
      protected var _dataFormat:String;
      
      public function QLoader()
      {
         super();
      }
      
      public function setDataFormat(param1:String) : void
      {
         this._dataFormat = param1;
      }
      
      override public function willTrigger(param1:String) : Boolean
      {
         return contentLoaderInfo.willTrigger(param1);
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         contentLoaderInfo.addEventListener(param1,param2,param3,param4,param5);
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         return contentLoaderInfo.dispatchEvent(param1);
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         contentLoaderInfo.removeEventListener(param1,param2,param3);
      }
      
      public function getBytesTotal() : uint
      {
         return contentLoaderInfo.bytesTotal;
      }
      
      public function getData() : *
      {
         return contentLoaderInfo.content;
      }
      
      public function getBytesLoaded() : uint
      {
         return contentLoaderInfo.bytesLoaded;
      }
      
      public function loadURL(param1:URLRequest) : void
      {
         load(param1);
      }
      
      public function getDataFormat() : String
      {
         return this._dataFormat;
      }
      
      override public function hasEventListener(param1:String) : Boolean
      {
         return contentLoaderInfo.hasEventListener(param1);
      }
   }
}
