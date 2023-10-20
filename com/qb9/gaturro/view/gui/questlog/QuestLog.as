package com.qb9.gaturro.view.gui.questlog
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public class QuestLog extends Sprite implements IDisposable
   {
      
      private static const BASE:String = "ui/";
      
      private static const FILENAME:String = "questlog.swf";
       
      
      private var loader:Loader;
      
      private var roomApi:GaturroRoomAPI;
      
      public function QuestLog(param1:GaturroRoomAPI)
      {
         super();
         this.roomApi = param1;
         this.init();
      }
      
      public function destroy() : void
      {
         try
         {
            if(this.info && this.info.content && "destroy" in this.info.content)
            {
               Object(this.info.content).destroy();
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function load() : void
      {
         this.loader = new Loader();
         this.info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         this.info.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         this.info.addEventListener(Event.COMPLETE,this.whenTheBannerIsLoaded);
         this.loader.load(new URLRequest(this.url));
      }
      
      private function get info() : LoaderInfo
      {
         return this.loader.contentLoaderInfo;
      }
      
      private function get url() : String
      {
         var _loc1_:String = URLUtil.getUrl(BASE + FILENAME);
         return URLUtil.versionedPath(_loc1_);
      }
      
      private function init() : void
      {
         this.load();
      }
      
      private function whenTheBannerIsLoaded(param1:Event) : void
      {
         if(!this.loader)
         {
            return;
         }
         addChild(this.info.content);
         if("acquireAPI" in this.info.content)
         {
            Object(this.info.content).acquireAPI(this.roomApi);
         }
      }
      
      private function handleLoadingError(param1:Event) : void
      {
         logger.warning("Failed to load the swf for the quest log (retrieving",this.url + ")");
         this.dispose();
      }
      
      public function dispose() : void
      {
         this.info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         this.info.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         this.info.removeEventListener(Event.COMPLETE,this.whenTheBannerIsLoaded);
         this.loader = null;
         this.roomApi = null;
      }
      
      public function addSignalSimple(param1:int, param2:String) : void
      {
         if(Object(this.info.content))
         {
            Object(this.info.content).addSignalSimple(param1,param2);
         }
      }
      
      public function addSignalSimpleButton(param1:int, param2:String, param3:Function, param4:String) : void
      {
         if(Object(this.info.content))
         {
            Object(this.info.content).addSignalSimpleButton(param1,param2,param3,param4);
         }
      }
   }
}
