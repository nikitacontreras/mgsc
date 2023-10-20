package com.qb9.gaturro.view.gui.news
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   
   public class NewsConfig
   {
       
      
      public var long_text:String;
      
      public var loader:Loader;
      
      public var gotoX:int;
      
      public var gotoY:int;
      
      public var corner_text:String;
      
      public var room:int;
      
      public var instanceBanner:String;
      
      public var banner:String;
      
      public var countries:Array;
      
      public var isDynamic:Boolean;
      
      public var assetPath:String;
      
      public function NewsConfig(param1:Object)
      {
         super();
         this.assetPath = param1.assetPath;
         this.countries = this.getCountries(param1.countries);
         this.room = param1.room;
         this.gotoX = param1.gotoX;
         this.gotoY = param1.gotoY;
         this.long_text = param1.long_text;
         this.corner_text = param1.corner_text;
         this.banner = param1.banner;
         this.instanceBanner = param1.instanceBanner;
         this.isDynamic = param1.hasOwnProperty("isDynamic") ? Boolean(param1.isDynamic) : false;
      }
      
      public function get movie() : MovieClip
      {
         if(this.loader)
         {
            return this.loader.content as MovieClip;
         }
         return null;
      }
      
      private function getCountries(param1:String) : Array
      {
         if(!param1)
         {
            return null;
         }
         param1 = param1.substr(param1.indexOf("[") + 1);
         param1 = param1.substr(0,param1.indexOf("]"));
         return param1.split(",");
      }
   }
}
