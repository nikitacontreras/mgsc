package com.qb9.gaturro.view.gui.banner
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.stageData;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.util.advertising.EPlanning;
   import com.qb9.gaturro.util.advertising.EPlanningAdImage;
   import com.qb9.gaturro.util.advertising.EPlanningEvent;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.wispagency.display.Loader;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class BannerGuiModal extends BaseGuiModal
   {
      
      protected static const BASE:String = "banners/";
       
      
      private var _options:String;
      
      private var objectAPI:GaturroSceneObjectAPI;
      
      protected var wLoader:Loader;
      
      private var banner:String;
      
      protected var relativeName:String;
      
      protected var adImage:DisplayObject;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function BannerGuiModal(param1:String, param2:GaturroSceneObjectAPI, param3:GaturroRoomAPI, param4:String = null)
      {
         super();
         this.banner = param1;
         this.objectAPI = param2;
         this.roomAPI = param3;
         this._options = param4;
         this.init();
      }
      
      protected function whenTheBannerIsComplete(param1:Event) : void
      {
         var _loc2_:String = URLUtil.getUrl(this.relativeName);
         var _loc3_:String = URLUtil.versionedPath(_loc2_);
         var _loc4_:String = URLUtil.versionedFileName(_loc3_);
         this.displayElement(this.wLoader.content);
      }
      
      protected function adLoaded(param1:EPlanningEvent) : void
      {
         logger.debug("banner -> ad loaded ");
         EPlanning(param1.currentTarget).removeEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
         if(param1.content is EPlanningAdImage)
         {
            this.relativeName = BASE + "eplanningPNG.swf";
            this.load(URLUtil.getUrl(this.relativeName));
            this.adImage = param1.content;
         }
         else
         {
            this.displayElement(param1.content);
         }
      }
      
      private function init() : void
      {
         var _loc1_:EPlanning = null;
         if(EPlanning.isValidTag(this.banner))
         {
            _loc1_ = new EPlanning();
            _loc1_.addEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
            _loc1_.loadByTag(this.banner);
         }
         else if(this.banner != null && this.banner != "")
         {
            this.relativeName = BASE + this.banner + ".swf";
            this.load(URLUtil.getUrl(this.relativeName));
         }
      }
      
      protected function displayElement(param1:DisplayObject) : void
      {
         var _loc2_:Object = null;
         addChild(param1);
         if(param1 is EPlanningAdImage)
         {
            x = stageData.width / 2 - width / 2;
            y = stageData.height / 2 - height / 2;
         }
         else
         {
            x = stageData.width / 2;
            y = stageData.height / 2;
         }
         if(Boolean(this.objectAPI) && "acquireObjectAPI" in param1)
         {
            Object(param1).acquireObjectAPI(this.objectAPI);
         }
         if(Boolean(this.roomAPI) && "acquireAPI" in param1)
         {
            Object(param1).acquireAPI(this.roomAPI);
         }
         if("setOptions" in param1 && this._options != null)
         {
            _loc2_ = com.adobe.serialization.json.JSON.decode(this._options);
            Object(param1).setOptions(_loc2_);
         }
         if(Boolean(this.adImage) && "bannerLoad" in param1)
         {
            Object(param1).bannerLoad(this.adImage);
         }
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.complete();
      }
      
      override public function dispose() : void
      {
         if(this.denomination == "leer")
         {
            this.roomAPI.trackEvent("QUESTS","LECTURA:CERRO_BANNER");
         }
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         if(Boolean(this.wLoader) && Boolean(this.wLoader.contentLoaderInfo))
         {
            this.wLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.whenTheBannerIsComplete);
            this.wLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
            this.wLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         }
         this.wLoader = null;
         this.objectAPI = null;
         this.roomAPI = null;
         super.dispose();
      }
      
      override public function get denomination() : String
      {
         return this.banner;
      }
      
      protected function load(param1:String) : void
      {
         this.wLoader = new Loader();
         this.wLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.whenTheBannerIsComplete);
         this.wLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         this.wLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         var _loc2_:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         this.wLoader.load(new URLRequest(URLUtil.versionedPath(param1)),new LoaderContext(false,_loc2_));
      }
      
      private function handleLoadingError(param1:Event) : void
      {
         logger.warning("Failed to load the swf for the banner named",this.banner);
         close();
      }
      
      protected function complete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               return close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
   }
}
