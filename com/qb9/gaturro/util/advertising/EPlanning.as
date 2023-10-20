package com.qb9.gaturro.util.advertising
{
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.setTimeout;
   
   public class EPlanning extends EventDispatcher
   {
       
      
      private var clickThroughURL:String;
      
      private var loader:Loader;
      
      private var clickThroughTags:Array;
      
      private const codeName:String = "e-planning v1.2";
      
      private var xmlContentTags:Array;
      
      private var urlLoader:URLLoader;
      
      private var impressionURL:String;
      
      private var contentURL:String;
      
      private var adTag:String;
      
      private var xmlImpressionTags:Array;
      
      public function EPlanning()
      {
         this.xmlContentTags = ["Ad","InLine","Video","MediaFiles","MediaFile","URL"];
         this.xmlImpressionTags = ["Ad","InLine","Impression","URL"];
         this.clickThroughTags = ["Space","Ad","ClickThroughURL"];
         super();
      }
      
      public static function isValidTag(param1:String) : Boolean
      {
         return settings.services.eplanning && settings.services.eplanning.enabled && param1 in settings.services.eplanning && settings.services.eplanning[param1] != "";
      }
      
      private function clickOnSWF(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(param1.target.name != "close" && "externalLinkOnClick" in param1.currentTarget)
         {
            _loc2_ = String(param1.currentTarget["externalLinkOnClick"]);
            URLUtil.openURL(_loc2_);
         }
      }
      
      private function handleSWFLoadingError(param1:Event) : void
      {
         logger.warning(this.codeName + " -> Failed to load the swf for the tag named",this.adTag);
         this.destroyLoader();
      }
      
      private function clickOnImage(param1:MouseEvent) : void
      {
         URLUtil.openURL(this.clickThroughURL);
      }
      
      public function get tag() : String
      {
         return this.adTag;
      }
      
      private function whenTheSWFIsLoaded(param1:Event) : void
      {
         var displayObject:DisplayObject = null;
         var imageBitmap:DisplayObject = null;
         var imageAd:EPlanningAdImage = null;
         var e:Event = param1;
         logger.debug(this.codeName + " -> Success load the swf for the tag named",this.adTag);
         try
         {
            logger.debug(this.loader.content);
            if(settings.services.eplanning[this.adTag].externalLinkOnClick)
            {
               displayObject = DisplayObject(this.loader.content);
               displayObject["externalLinkOnClick"] = settings.services.eplanning[this.adTag].externalLinkOnClick;
               displayObject.addEventListener(MouseEvent.CLICK,this.clickOnSWF);
               displayObject["close"].removeEventListener(MouseEvent.CLICK,this.clickOnSWF);
            }
            else
            {
               imageBitmap = DisplayObject(this.loader.content);
               imageAd = new EPlanningAdImage();
               if(api.isDesktop)
               {
                  imageAd.addEventListener(MouseEvent.CLICK,this.clickOnImage);
               }
               imageAd.addChild(imageBitmap);
               displayObject = imageAd;
            }
            this.urlLoader = new URLLoader();
            this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLLoadingError);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
            logger.debug(this.codeName + " -> send impression --> " + this.impressionURL);
            if(this.impressionURL)
            {
               this.urlLoader.load(new URLRequest(this.impressionURL));
            }
            setTimeout(this.destroyLoader,5000);
         }
         catch(er:Error)
         {
            logger.debug(codeName + " -> Error conviertiendo a DisplayObject -> " + er.toString() + " - " + er.message);
         }
         this.dispatchEvent(new EPlanningEvent(EPlanningEvent.CONTENT_LOADED,displayObject));
         this.destroyLoader();
      }
      
      private function handleXMLLoadingError(param1:Event) : void
      {
         logger.warning(this.codeName + " -> Failed to load the xml for the tag named",this.adTag);
         this.destroyLoader();
      }
      
      private function whenTheXMLIsLoaded(param1:Event = null) : void
      {
         var xml:XML = null;
         var req:URLRequest = null;
         var context:LoaderContext = null;
         var e:Event = param1;
         logger.debug(this.codeName + " -> Success load the xml for the tag named",this.adTag);
         this.destroyLoader();
         try
         {
            xml = new XML(e.target.data);
            this.contentURL = this.getURLformXMLtags(xml,this.xmlContentTags);
            this.impressionURL = this.getURLformXMLtags(xml,this.xmlImpressionTags);
            this.clickThroughURL = this.getURLformXMLtags(xml,this.clickThroughTags);
            this.loader = new Loader();
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSWFLoadingError);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleSWFLoadingError);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.whenTheSWFIsLoaded);
            req = new URLRequest(this.contentURL);
            context = new LoaderContext();
            context.checkPolicyFile = true;
            logger.debug(this.codeName + " -> Load SWF resourse --> " + this.contentURL);
            this.loader.load(req,context);
         }
         catch(e:Error)
         {
            logger.warning(codeName + " -> XML bad format -> " + e.message);
         }
      }
      
      private function getURLformXMLtags(param1:XML, param2:Array) : String
      {
         var _loc3_:XMLList = param1.child(param2[0]);
         var _loc4_:int = 1;
         while(_loc4_ < param2.length)
         {
            _loc3_ = _loc3_.child(param2[_loc4_]);
            _loc4_++;
         }
         return _loc3_.text();
      }
      
      private function destroyLoader() : void
      {
         if(this.urlLoader)
         {
            this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLLoadingError);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
            this.urlLoader.removeEventListener(Event.COMPLETE,this.whenTheXMLIsLoaded);
         }
         if(this.loader)
         {
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSWFLoadingError);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleSWFLoadingError);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.whenTheSWFIsLoaded);
         }
         this.urlLoader = null;
         this.loader = null;
      }
      
      public function loadByTag(param1:String) : void
      {
         var _loc3_:String = null;
         this.adTag = param1;
         var _loc2_:Object = settings.services.eplanning[this.adTag];
         if(_loc2_ is String)
         {
            _loc3_ = String(_loc2_);
            this.xmlContentTags = ["Ad","InLine","Video","MediaFiles","MediaFile","URL"];
            this.xmlImpressionTags = ["Ad","InLine","Impression","URL"];
         }
         else
         {
            _loc3_ = String(_loc2_.url);
            this.xmlContentTags = _loc2_.xmlContentTags;
            this.xmlImpressionTags = _loc2_.xmlImpressionTags;
         }
         if(!_loc3_ || _loc3_ == "")
         {
            return;
         }
         var _loc4_:String = new Date().getTime().toString();
         _loc3_ = _loc3_.replace("$RANDOM",_loc4_);
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLLoadingError);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
         this.urlLoader.addEventListener(Event.COMPLETE,this.whenTheXMLIsLoaded);
         logger.debug(this.codeName + " -> Load XML resourse --> " + _loc3_);
         this.urlLoader.load(new URLRequest(_loc3_));
      }
   }
}
