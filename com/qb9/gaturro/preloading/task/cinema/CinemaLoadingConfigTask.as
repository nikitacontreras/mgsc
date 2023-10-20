package com.qb9.gaturro.preloading.task.cinema
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class CinemaLoadingConfigTask extends LoadingTask
   {
      
      private static const FILTER_TAG:String = "cinema";
       
      
      private var path:String;
      
      private var loader:URLLoader;
      
      public function CinemaLoadingConfigTask()
      {
         super();
      }
      
      private function endTask() : void
      {
         this.removeListeners();
         taskComplete();
      }
      
      override public function start() : void
      {
         this.loadConfig();
         super.start();
      }
      
      private function onLoadError(param1:IOErrorEvent) : void
      {
         this.endTask();
      }
      
      private function loadConfig() : void
      {
         var _loc1_:URLRequest = new URLRequest(this.path + FILTER_TAG);
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.TEXT;
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(_loc1_);
      }
      
      override public function set data(param1:Object) : void
      {
         this.path = param1.path;
      }
      
      private function removeListeners() : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         _sharedRespository.settings = com.adobe.serialization.json.JSON.decode(param1.target.data);
         this.endTask();
      }
   }
}
