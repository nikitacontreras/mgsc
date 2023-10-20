package com.qb9.gaturro.commons.loader
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class SWFLoader extends EventDispatcher implements IAssetProvider, ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var request:URLRequest;
      
      private var loader:Loader;
      
      public function SWFLoader(param1:String)
      {
         super();
         this.setup(param1);
      }
      
      private function setup(param1:String) : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
         this.request = new URLRequest(param1);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function getDefinition(param1:String) : Class
      {
         return this.hasDefinition(param1) ? this.applicationDomain.getDefinition(param1) as Class : null;
      }
      
      public function getInstanceByName(param1:String) : DisplayObject
      {
         var _loc2_:Class = this.getDefinition(param1) as Class;
         return !!_loc2_ ? new _loc2_() : null;
      }
      
      public function load() : void
      {
         this.loader.load(this.request);
      }
      
      private function onLoadComplete(param1:Event = null) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onError(param1:Event) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.loader.contentLoaderInfo.applicationDomain;
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this.applicationDomain.hasDefinition(param1);
      }
      
      public function dispose() : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete,false);
         this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError,false);
         this.request = null;
         this.loader = null;
         this._disposed = true;
      }
   }
}
