package com.wispagency.display
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   
   public class LoaderInfo extends EventDispatcher
   {
       
      
      protected var parentLoader:com.wispagency.display.Loader;
      
      public var urlLoader:URLLoader;
      
      protected var commObject:Object;
      
      protected var displayLoader:flash.display.Loader;
      
      public function LoaderInfo(param1:com.wispagency.display.Loader, param2:URLLoader, param3:flash.display.Loader, param4:Object)
      {
         super();
         this.parentLoader = param1;
         this.urlLoader = param2;
         this.displayLoader = param3;
         this.commObject = param4;
      }
      
      public static function getLoaderInfoByDefinition(param1:Object) : LoaderInfo
      {
         return flash.display.Loader["getLoaderInfoByDefinition"](param1);
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         return super.dispatchEvent(param1);
      }
      
      public function get width() : int
      {
         return this.displayLoader.contentLoaderInfo.width;
      }
      
      public function get sameDomain() : Boolean
      {
         return this.displayLoader.contentLoaderInfo.sameDomain;
      }
      
      public function set parentSandboxBridge(param1:Object) : void
      {
         this.displayLoader.contentLoaderInfo["parentSandboxBridge"] = param1;
      }
      
      public function get bytesLoaded() : uint
      {
         return this.displayLoader.contentLoaderInfo.bytesLoaded;
      }
      
      public function get contentType() : String
      {
         return this.displayLoader.contentLoaderInfo.contentType;
      }
      
      public function get childAllowsParent() : Boolean
      {
         return this.displayLoader.contentLoaderInfo.childAllowsParent;
      }
      
      public function get bytesTotal() : uint
      {
         return this.displayLoader.contentLoaderInfo.bytesTotal;
      }
      
      public function get loader() : com.wispagency.display.Loader
      {
         return this.parentLoader;
      }
      
      public function get loaderURL() : String
      {
         return this.displayLoader.contentLoaderInfo.loaderURL;
      }
      
      public function get sharedEvents() : EventDispatcher
      {
         return this.displayLoader.contentLoaderInfo.sharedEvents;
      }
      
      public function get parentSandboxBridge() : Object
      {
         return this.displayLoader.contentLoaderInfo["parentSandboxBridge"];
      }
      
      public function get height() : int
      {
         return this.displayLoader.contentLoaderInfo.height;
      }
      
      public function set childSandboxBridge(param1:Object) : void
      {
         this.displayLoader.contentLoaderInfo["childSandboxBridge"] = param1;
      }
      
      override public function toString() : String
      {
         return "[Object Wisp LoaderInfo]";
      }
      
      public function get frameRate() : Number
      {
         return this.displayLoader.contentLoaderInfo.frameRate;
      }
      
      public function get parentAllowsChild() : Boolean
      {
         return this.displayLoader.contentLoaderInfo.parentAllowsChild;
      }
      
      public function get parameters() : Object
      {
         return this.displayLoader.contentLoaderInfo.parameters;
      }
      
      public function get bytes() : ByteArray
      {
         return this.displayLoader.contentLoaderInfo["bytes"];
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.displayLoader.contentLoaderInfo.applicationDomain;
      }
      
      public function get swfVersion() : uint
      {
         return this.displayLoader.contentLoaderInfo.swfVersion;
      }
      
      public function get actionScriptVersion() : uint
      {
         return this.displayLoader.contentLoaderInfo.actionScriptVersion;
      }
      
      public function get content() : DisplayObject
      {
         return this.displayLoader.contentLoaderInfo.content;
      }
      
      public function get childSandboxBridge() : Object
      {
         return this.displayLoader.contentLoaderInfo["childSandboxBridge"];
      }
      
      public function get url() : String
      {
         return this.commObject.url;
      }
   }
}
