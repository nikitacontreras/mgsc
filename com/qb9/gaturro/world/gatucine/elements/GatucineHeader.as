package com.qb9.gaturro.world.gatucine.elements
{
   import com.qb9.gaturro.globals.user;
   import com.wispagency.display.Loader;
   import com.wispagency.display.LoaderInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class GatucineHeader
   {
       
      
      protected var dataRefId:String;
      
      protected var dataTitle:String;
      
      protected var dataColor:String;
      
      protected var dataThumbailLoaded:Boolean = false;
      
      protected var dataId:String;
      
      protected var dataCriteria:String;
      
      protected var thumbail:Sprite;
      
      public function GatucineHeader()
      {
         this.thumbail = new Sprite();
         super();
      }
      
      private function loaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.currentTarget);
         _loc2_.removeEventListener(Event.COMPLETE,this.loaded);
         this.dataThumbailLoaded = true;
         this.thumbail.x = -this.thumbail.width / 2;
         this.thumbail.y = -this.thumbail.height / 2;
      }
      
      public function set color(param1:String) : void
      {
         this.dataColor = param1;
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
      
      public function get id() : String
      {
         return this.dataId;
      }
      
      public function get criteria() : String
      {
         return this.dataCriteria;
      }
      
      public function get image() : DisplayObject
      {
         return this.thumbail;
      }
      
      public function get color() : String
      {
         return this.dataColor;
      }
      
      public function get allowPlay() : Boolean
      {
         return Boolean(user.isCitizen) && this.dataColor != "orange_list_movies";
      }
      
      public function set trackerId(param1:String) : void
      {
         this.dataRefId = param1;
      }
      
      public function set title(param1:String) : void
      {
         this.dataTitle = param1;
      }
      
      public function get trackerId() : String
      {
         return this.dataRefId;
      }
      
      public function set id(param1:String) : void
      {
         this.dataId = param1;
      }
      
      public function set criteria(param1:String) : void
      {
         this.dataCriteria = param1;
      }
   }
}
