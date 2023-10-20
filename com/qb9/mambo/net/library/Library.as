package com.qb9.mambo.net.library
{
   import com.qb9.mambo.core.objects.MamboObject;
   import com.wispagency.display.Loader;
   import com.wispagency.display.LoaderInfo;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class Library extends MamboObject
   {
       
      
      private var loader:Loader;
      
      private var _loaded:Boolean = false;
      
      private var loaderInfo:LoaderInfo;
      
      public var url:String;
      
      private var failed:Boolean = false;
      
      public function Library(param1:String = ".", param2:Boolean = false, param3:String = null)
      {
         var _loc4_:String = null;
         super();
         if(param3)
         {
            _loc4_ = this.makeURL(param1,param3);
            this.load(param2,_loc4_);
         }
      }
      
      public static function fromLoaderInfo(param1:LoaderInfo) : Library
      {
         var _loc2_:Library = new Library();
         _loc2_.loaderInfo = param1;
         return _loc2_;
      }
      
      protected function notifyFailure() : void
      {
         this.failed = true;
         this.dispatch(LibraryEvent.LOAD_FAILED);
      }
      
      public function get loadFailed() : Boolean
      {
         return this.failed;
      }
      
      private function get domain() : ApplicationDomain
      {
         return this.loaderInfo.applicationDomain;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded || this.failed;
      }
      
      public function getClass(param1:String) : Class
      {
         if(!this.loaded)
         {
            warning("The swf " + this.url + " isn\'t loaded yet");
         }
         if(!this.failed && !this.hasClass(param1))
         {
            warning("No class named \"" + param1 + "\" was found on " + this.url);
            return null;
         }
         return this.domain.getDefinition(param1) as Class;
      }
      
      protected function whenLibraryIsLoaded(param1:Event) : void
      {
         this._loaded = true;
         if(this.loaderInfo)
         {
            this.dispatch(LibraryEvent.LOADED);
         }
      }
      
      private function whenLibraryFailsToLoad(param1:Event) : void
      {
         warning("Failed to load the swf:",this.url,"because:",Object(param1).text);
         this.notifyFailure();
      }
      
      public function getItem(param1:String) : Object
      {
         var _loc2_:Class = this.getClass(param1);
         return !!_loc2_ ? new _loc2_() : null;
      }
      
      override public function dispose() : void
      {
         try
         {
            if(this.loader)
            {
               if(this._loaded)
               {
                  this.loader.unload();
               }
               else if(!this.failed)
               {
                  this.loader.close();
               }
            }
         }
         catch(err:Error)
         {
         }
         this.loaderInfo.removeEventListener(Event.COMPLETE,this.whenLibraryIsLoaded);
         this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.whenLibraryFailsToLoad);
         this.loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.whenLibraryFailsToLoad);
         this.loaderInfo = null;
         this.loader = null;
         super.dispose();
      }
      
      protected function makeURL(param1:String, param2:String) : String
      {
         return param1 + param2.split(".").join("/") + ".swf";
      }
      
      private function load(param1:Boolean, param2:String) : void
      {
         this.url = param2;
         this.loader = new Loader();
         this.loaderInfo = this.loader.contentLoaderInfo;
         this.loaderInfo.addEventListener(Event.COMPLETE,this.whenLibraryIsLoaded);
         this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.whenLibraryFailsToLoad);
         this.loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.whenLibraryFailsToLoad);
         var _loc3_:ApplicationDomain = new ApplicationDomain(param1 ? ApplicationDomain.currentDomain : null);
         this.loader.load(new URLRequest(param2),new LoaderContext(false,_loc3_));
      }
      
      public function get content() : DisplayObject
      {
         return !!this.loader ? this.loader.content : null;
      }
      
      override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new LibraryEvent(param1));
      }
      
      public function hasClass(param1:String) : Boolean
      {
         return this.domain !== null && this.domain.hasDefinition(param1);
      }
   }
}
