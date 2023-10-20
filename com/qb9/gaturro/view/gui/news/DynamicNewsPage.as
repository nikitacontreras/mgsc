package com.qb9.gaturro.view.gui.news
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   
   public class DynamicNewsPage extends EventDispatcher
   {
      
      private static const BASE:String = "content/";
      
      public static const TYPE_VIGUTS:String = "iamavigutdynamicnew";
      
      private static const URI:String = "news/";
       
      
      private var config:com.qb9.gaturro.view.gui.news.NewsConfig;
      
      private var movie:MovieClip;
      
      private var dynamicClassType:String;
      
      public function DynamicNewsPage(param1:com.qb9.gaturro.view.gui.news.NewsConfig)
      {
         super();
         this.config = param1;
         this.dynamicClassType = this.inferClass(param1);
         this.loadSwf(param1);
      }
      
      private function showHome(param1:DisplayObject) : void
      {
         this.movie.ph.addChild(param1);
      }
      
      private function wearBot(param1:DisplayObject) : void
      {
         var _loc2_:String = String(api.vigutData.item);
         var _loc3_:String = String(_loc2_.split(".")[0]);
         var _loc4_:MovieClip = this.config.movie.bot;
         this.fixClothes(param1["clothes"]);
         this.checkAllDataLoaded(_loc4_,param1["clothes"],_loc3_);
      }
      
      private function transport(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = this.movie.transport_display;
         var _loc3_:MovieClip = this.movie.dimensions;
         GuiUtil.fit(param1,_loc3_.width,_loc3_.height);
         _loc2_.addChild(param1);
         _loc3_.visible = false;
      }
      
      private function inferClass(param1:com.qb9.gaturro.view.gui.news.NewsConfig) : String
      {
         var _loc2_:String = String((param1.assetPath as String).split(".swf")[0]);
         switch(_loc2_)
         {
            case "vigutsDinamico":
               return TYPE_VIGUTS;
            default:
               return null;
         }
      }
      
      private function fixClothes(param1:Object) : void
      {
         if(param1.arm)
         {
            param1.armFore = param1.arm;
            param1.armBack = param1.arm;
         }
         if(param1.gloves)
         {
            param1.gloveFore = param1.gloves;
            param1.gloveBack = param1.gloves;
         }
         if(param1.grip)
         {
            param1.grip = param1.gripFore;
            param1.grip = param1.gripBack;
         }
      }
      
      private function fetchPart(param1:String) : void
      {
         api.libraries.fetch(param1,this.onClothFetch);
      }
      
      private function checkAllDataLoaded(param1:MovieClip, param2:Object, param3:String) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:String = null;
         var _loc4_:Array = this.gatherPlaceholders(param1);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if((_loc6_ = _loc4_[_loc5_]).name in param2)
            {
               if((_loc7_ = String(param2[_loc6_.name])) != "")
               {
                  api.libraries.fetch(param3 + "." + _loc7_,this.onIndividualClothFetched,_loc6_);
               }
            }
            _loc5_++;
         }
      }
      
      private function onAssetLoaded(param1:Event) : void
      {
         var e:Event = param1;
         this.movie = this.config.movie;
         if(TYPE_VIGUTS)
         {
            api.libraries.fetch(api.currentVigut,function(param1:DisplayObject):void
            {
               var ds:DisplayObject = param1;
               if(api.vigutData.type == "cloth")
               {
                  movie.gotoAndStop("cloth");
                  movie.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
                  {
                     if(param1.type == Event.ENTER_FRAME)
                     {
                        movie.removeEventListener(param1.type,arguments.callee);
                        wearBot(ds);
                        wearManiquin(ds);
                        dispatchEvent(new Event(Event.COMPLETE));
                     }
                  });
               }
               if(api.vigutData.type == "home")
               {
                  movie.gotoAndStop("home");
                  movie.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
                  {
                     if(param1.type == Event.ENTER_FRAME)
                     {
                        movie.removeEventListener(param1.type,arguments.callee);
                        showHome(ds);
                        dispatchEvent(new Event(Event.COMPLETE));
                     }
                  });
               }
               if(api.vigutData.type == "transport")
               {
                  movie.gotoAndStop("transport");
                  movie.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
                  {
                     if(param1.type == Event.ENTER_FRAME)
                     {
                        movie.removeEventListener(param1.type,arguments.callee);
                        transport(ds);
                        dispatchEvent(new Event(Event.COMPLETE));
                     }
                  });
               }
            });
         }
      }
      
      private function wearManiquin(param1:DisplayObject) : void
      {
         var _loc2_:String = String(api.vigutData.item);
         var _loc3_:String = String(_loc2_.split(".")[0]);
         var _loc4_:MovieClip;
         (_loc4_ = this.config.movie.display).addChild(param1);
      }
      
      private function gatherPlaceholders(param1:MovieClip) : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in DisplayUtil.children(param1,true))
         {
            if(_loc3_.name && _loc3_ is MovieClip && MovieClip(_loc3_).numChildren === 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function loadSwf(param1:com.qb9.gaturro.view.gui.news.NewsConfig) : void
      {
         var _loc2_:String = URI + param1.assetPath;
         var _loc3_:String = URLUtil.versionedPath(_loc2_);
         var _loc4_:String = URLUtil.getUrl(_loc3_);
         param1.loader = new Loader();
         param1.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAssetLoaded);
         param1.loader.load(new URLRequest(_loc2_));
      }
      
      private function onIndividualClothFetched(param1:DisplayObject, param2:MovieClip) : void
      {
         param2.addChild(param1);
      }
      
      private function onClothFetch(param1:DisplayObject) : void
      {
         logger.debug(this,param1);
      }
   }
}
