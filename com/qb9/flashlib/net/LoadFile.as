package com.qb9.flashlib.net
{
   import com.qb9.flashlib.tasks.Task;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public class LoadFile extends Task
   {
      
      protected static const EVENTS:Array = [ProgressEvent.PROGRESS,Event.COMPLETE];
       
      
      protected var loader:com.qb9.flashlib.net.ILoader;
      
      public var url:String;
      
      protected var silent:Boolean;
      
      public var id:String;
      
      protected var failed:Boolean = false;
      
      public function LoadFile(param1:String, param2:String = "infer", param3:String = null, param4:Boolean = false)
      {
         super();
         this.url = param1;
         this.id = param3 || param1;
         this.loader = LoadFile.makeLoader(param2,param1);
         this.silent = param4;
      }
      
      public static function makeLoader(param1:String, param2:String = null) : com.qb9.flashlib.net.ILoader
      {
         var _loc3_:com.qb9.flashlib.net.ILoader = null;
         if(!param1 || param1 == LoadFileFormat.INFER)
         {
            param1 = LoadFileFormat.infer(param2);
         }
         switch(param1)
         {
            case LoadFileFormat.SOUND:
               _loc3_ = new QSound();
               break;
            case LoadFileFormat.SWF:
            case LoadFileFormat.IMAGE:
               _loc3_ = new QLoader();
               break;
            case LoadFileFormat.JSON:
            case LoadFileFormat.XML:
            case LoadFileFormat.PLAIN_TEXT:
            case LoadFileFormat.BINARY:
            case LoadFileFormat.VARIABLES:
               _loc3_ = new QURLLoader();
               break;
            default:
               throw new ArgumentError("LoadFile > Unknown file format:" + param1);
         }
         _loc3_.setDataFormat(param1);
         return _loc3_;
      }
      
      public static function load(param1:String, param2:Function, param3:String = "infer") : com.qb9.flashlib.net.ILoader
      {
         var loader:com.qb9.flashlib.net.ILoader = null;
         var url:String = param1;
         var complete:Function = param2;
         var format:String = param3;
         loader = makeLoader(format,url);
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            complete(loader.getData());
            loader.removeEventListener(Event.COMPLETE,arguments.callee);
         });
         loader.loadURL(new URLRequest(url));
         return loader;
      }
      
      public function get bytesTotal() : uint
      {
         return this.loader.getBytesTotal();
      }
      
      public function get dataFormat() : String
      {
         return this.loader.getDataFormat();
      }
      
      override public function stop() : void
      {
         var _loc1_:String = null;
         super.stop();
         for each(_loc1_ in EVENTS)
         {
            this.loader.removeEventListener(_loc1_,dispatchEvent);
         }
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      }
      
      private function errorHandler(param1:Event) : void
      {
         this.failed = true;
         if(this.silent)
         {
            this.taskComplete();
            return;
         }
         throw new Error(Object(param1).text);
      }
      
      override public function start() : void
      {
         var _loc1_:String = null;
         super.start();
         for each(_loc1_ in EVENTS)
         {
            this.loader.addEventListener(_loc1_,dispatchEvent);
         }
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
         this.loader.loadURL(new URLRequest(this.url));
      }
      
      public function get loaded() : Boolean
      {
         return this.failed || this.bytesTotal !== 0 && this.bytesLoaded === this.bytesTotal;
      }
      
      public function get bytesLoaded() : uint
      {
         return this.loader.getBytesLoaded();
      }
      
      protected function onComplete(param1:Event) : void
      {
         taskComplete();
      }
      
      public function get data() : *
      {
         return this.failed ? null : this.loader.getData();
      }
      
      public function get loading() : Boolean
      {
         return !this.failed && running && this.bytesTotal !== 0;
      }
   }
}
