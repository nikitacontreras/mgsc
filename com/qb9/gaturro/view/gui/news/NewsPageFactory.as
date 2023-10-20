package com.qb9.gaturro.view.gui.news
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   
   public class NewsPageFactory extends EventDispatcher
   {
      
      private static const BASE:String = "content/";
      
      private static const URI:String = "news/";
      
      public static const ALL_NEWS_READY:String = "ALL_NEWS_READY";
      
      public static const FIRST_NEWS_READY:String = "FIRST_NEWS_READY";
      
      public static const NEWS_PROFILE_KEY:String = "openNewsKey";
       
      
      private var allLoaded:Boolean;
      
      private var currentNewsIndex:int;
      
      private var configs:Array;
      
      private var country:String;
      
      private var newsCount:int = 0;
      
      public function NewsPageFactory(param1:String)
      {
         super();
         this.country = param1;
         this.init();
      }
      
      private function isValidCountry(param1:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         if(param1 == null)
         {
            return true;
         }
         var _loc2_:* = param1[0].indexOf("!") != -1;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc5_ = (_loc4_ = String(param1[_loc3_])).indexOf("!") != -1) && this.country == _loc4_.substr(1))
            {
               return false;
            }
            if(this.country == _loc4_)
            {
               return true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get currentPage() : DisplayObject
      {
         return this.currentConfig.movie;
      }
      
      public function nextPage() : void
      {
         ++this.currentNewsIndex;
         if(this.currentNewsIndex >= this.configs.length)
         {
            this.currentNewsIndex = 0;
         }
      }
      
      public function get currentConfig() : NewsConfig
      {
         return this.configs[this.currentNewsIndex];
      }
      
      public function setCurrentPageByKey(param1:String) : void
      {
         var _loc3_:NewsConfig = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.configs.length)
         {
            _loc3_ = this.configs[_loc2_];
            if(param1 + ".swf" == _loc3_.assetPath)
            {
               this.currentNewsIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
      }
      
      private function init() : void
      {
         var _loc2_:NewsConfig = null;
         this.currentNewsIndex = 0;
         this.configs = [];
         var _loc1_:int = 0;
         while(_loc1_ < settings.newsConfig.length)
         {
            _loc2_ = new NewsConfig(settings.newsConfig[_loc1_]);
            if(this.isValidCountry(_loc2_.countries))
            {
               this.configs.push(_loc2_);
               if(!_loc2_.isDynamic)
               {
                  this.requestPage(_loc2_);
               }
               else
               {
                  this.requestDynamicPage(_loc2_);
               }
            }
            _loc1_++;
         }
      }
      
      public function previousPage() : void
      {
         --this.currentNewsIndex;
         if(this.currentNewsIndex < 0)
         {
            this.currentNewsIndex = this.configs.length - 1;
         }
      }
      
      public function dispose() : void
      {
      }
      
      private function onPageLoaded(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         ++this.newsCount;
         if(!param1.currentTarget is DynamicNewsPage)
         {
            if(param1.target && param1.target.loader && Boolean(param1.target.loader.content))
            {
               _loc2_ = param1.target.loader.content as MovieClip;
               if("acquireAPI" in _loc2_)
               {
                  _loc2_.acquireAPI(api);
               }
            }
         }
         if(this.newsCount >= this.configs.length)
         {
            this.allLoaded = true;
            dispatchEvent(new Event(ALL_NEWS_READY));
         }
      }
      
      private function requestPage(param1:NewsConfig) : void
      {
         var _loc2_:String = URI + param1.assetPath;
         var _loc3_:String = URLUtil.versionedPath(_loc2_);
         var _loc4_:String = URLUtil.getUrl(_loc3_);
         param1.loader = new Loader();
         param1.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPageLoaded);
         param1.loader.load(new URLRequest(_loc4_));
      }
      
      private function requestDynamicPage(param1:NewsConfig) : void
      {
         var _loc2_:DynamicNewsPage = new DynamicNewsPage(param1);
         _loc2_.addEventListener(Event.COMPLETE,this.onPageLoaded);
      }
   }
}
