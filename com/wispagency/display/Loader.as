package com.wispagency.display
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class Loader extends Sprite
   {
       
      
      private var realLoader:flash.display.Loader;
      
      private var loader:URLLoader;
      
      private var loaderContext:LoaderContext = null;
      
      private var loaderInfoReference:com.wispagency.display.LoaderInfo;
      
      private var commObject:Object;
      
      public function Loader()
      {
         this.commObject = {"url":""};
         super();
         this.loader = new URLLoader();
         this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.handleHttpStatus);
         this.loader.addEventListener(Event.COMPLETE,this.handleLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleURLLoadError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.handleProgress);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         this.loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.realLoader = new flash.display.Loader();
         this.realLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoaderComplete);
         this.realLoader.contentLoaderInfo.addEventListener(Event.UNLOAD,this.handleUnload);
         this.realLoader.addEventListener(Event.INIT,this.handleInit);
         this.loaderInfoReference = new com.wispagency.display.LoaderInfo(this,this.loader,this.realLoader,this.commObject);
         addChild(this.realLoader);
      }
      
      private function handleUnload(param1:Event) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      private function handleLoadComplete(param1:Event) : void
      {
         this.realLoader.loadBytes(this.loader.data,this.loaderContext);
      }
      
      private function handleInit(param1:Event) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      private function handleURLLoadError(param1:IOErrorEvent) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      private function handleSecurityError(param1:Event) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      public function loadBytes(param1:ByteArray, param2:LoaderContext = null) : void
      {
         this.loaderContext = param2;
         this.commObject.url = "";
      }
      
      private function handleHttpStatus(param1:HTTPStatusEvent) : void
      {
         this.contentLoaderInfo.dispatchEvent(param1);
      }
      
      override public function toString() : String
      {
         return "[Instance Of Wisp Loader]";
      }
      
      public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this.loaderContext = param2;
         this.commObject.url = param1.url;
         this.loader.load(param1);
      }
      
      private function handleLoaderComplete(param1:Event) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      private function handleProgress(param1:ProgressEvent) : void
      {
         this.loaderInfoReference.dispatchEvent(param1);
      }
      
      public function close() : void
      {
         this.commObject.url = "";
         this.loader.close();
         this.realLoader.close();
      }
      
      public function get content() : DisplayObject
      {
         return this.realLoader.content;
      }
      
      public function get contentLoaderInfo() : com.wispagency.display.LoaderInfo
      {
         return this.loaderInfoReference;
      }
      
      public function unload() : void
      {
         this.commObject.url = "";
         this.close();
         this.realLoader.unload();
      }
   }
}
