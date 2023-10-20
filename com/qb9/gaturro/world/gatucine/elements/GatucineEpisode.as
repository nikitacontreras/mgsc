package com.qb9.gaturro.world.gatucine.elements
{
   import com.wispagency.display.Loader;
   import com.wispagency.display.LoaderInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class GatucineEpisode
   {
       
      
      protected var dataTrackerId:String;
      
      protected var thumbail:Sprite;
      
      protected var dataTitle:String;
      
      protected var dataPlayId:String;
      
      protected var dataThumbailLoaded:Boolean = false;
      
      public function GatucineEpisode()
      {
         this.thumbail = new Sprite();
         super();
      }
      
      public function get trackerId() : String
      {
         return this.dataTrackerId;
      }
      
      private function loaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.currentTarget);
         _loc2_.removeEventListener(Event.COMPLETE,this.loaded);
         this.dataThumbailLoaded = true;
         this.thumbail.x = -this.thumbail.width / 2;
         this.thumbail.y = -this.thumbail.height / 2;
      }
      
      public function set trackerId(param1:String) : void
      {
         this.dataTrackerId = param1;
      }
      
      public function get playId() : String
      {
         return this.dataPlayId;
      }
      
      public function set title(param1:String) : void
      {
         this.dataTitle = param1;
      }
      
      public function createThumbnail(param1:String) : void
      {
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaded);
         _loc2_.load(new URLRequest(param1));
         this.thumbail.addChild(_loc2_);
      }
      
      public function get title() : String
      {
         return this.dataTitle;
      }
      
      public function get image() : DisplayObject
      {
         return this.thumbail;
      }
      
      public function set playId(param1:String) : void
      {
         this.dataPlayId = param1;
      }
   }
}
