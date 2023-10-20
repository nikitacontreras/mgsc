package com.qb9.gaturro.view.gui.base.modal
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.commons.loader.SWFLoader;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.banner.properties.IHasPropertyTarget;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class InstantiableGuiModal extends BaseGuiModal implements IAssetProvider, IHasPropertyTarget
   {
      
      protected static var BASE:String = "banners/";
       
      
      private var closeBtn:SimpleButton;
      
      private var _bannerView:DisplayObjectContainer;
      
      private var _dataReady:Boolean;
      
      private var className:String;
      
      private var _assetReady:Boolean;
      
      private var swfLoader:SWFLoader;
      
      public function InstantiableGuiModal(param1:String = "", param2:String = "")
      {
         super();
         if(param1)
         {
            this.loadAsset(param1,param2);
         }
      }
      
      private function onEventLoading(param1:Event) : void
      {
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onPrivateLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onEventLoading);
         this.swfLoader.removeEventListener(ErrorEvent.ERROR,this.onEventLoading);
         trace("modal/AbstractInstantiableGUIModal > onEventLoading > e = [" + param1 + "]");
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.swfLoader.applicationDomain;
      }
      
      protected function ready() : void
      {
      }
      
      public function getDefinition(param1:String) : Class
      {
         return this.swfLoader.getDefinition(param1) as Class;
      }
      
      private function onPrivateLoadComplete(param1:Event) : void
      {
         logger.debug(this,this.className);
         this._bannerView = this.swfLoader.getInstanceByName(this.className) as DisplayObjectContainer;
         addChild(this._bannerView);
         this.setupCloseButton();
         this._assetReady = true;
         this.onAssetReady();
         if(this.isReady)
         {
            this.ready();
         }
      }
      
      private function onClickClose(param1:MouseEvent) : void
      {
         close();
      }
      
      protected function onAssetReady() : void
      {
      }
      
      public function get assetReady() : Boolean
      {
         return this._assetReady;
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this.swfLoader.hasDefinition(param1);
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
      }
      
      protected function get hasCloseButton() : Boolean
      {
         return this.closeBtn != null;
      }
      
      public function get dataReady() : Boolean
      {
         return this._dataReady;
      }
      
      protected function setupCloseButton() : void
      {
         this.closeBtn = this.view.getChildByName("close") as SimpleButton;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      public function get view() : DisplayObjectContainer
      {
         return this._bannerView;
      }
      
      public function propertySetted() : void
      {
         this._dataReady = true;
         if(this.isReady)
         {
            this.ready();
         }
      }
      
      final protected function makeFinalURL(param1:String) : String
      {
         var _loc2_:String = URLUtil.getUrl(BASE + param1 + ".swf");
         return URLUtil.versionedPath(_loc2_);
      }
      
      public function get isReady() : Boolean
      {
         return this._dataReady && this._assetReady;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.swfLoader.dispose();
         this.swfLoader = null;
         if(Boolean(this._bannerView) && contains(this._bannerView))
         {
            removeChild(this._bannerView);
         }
         if(this.closeBtn)
         {
            this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         }
      }
      
      protected function loadAsset(param1:String, param2:String = "") : void
      {
         var _loc3_:String = null;
         if(param1)
         {
            this.className = !!param2 ? param2 : "";
            _loc3_ = this.makeFinalURL(param1);
            this.swfLoader = new SWFLoader(_loc3_);
            this.swfLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            this.swfLoader.addEventListener(Event.COMPLETE,this.onPrivateLoadComplete);
            this.swfLoader.addEventListener(Event.COMPLETE,this.onEventLoading);
            this.swfLoader.addEventListener(ErrorEvent.ERROR,this.onEventLoading);
            this.swfLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onEventLoading);
            this.swfLoader.load();
         }
      }
      
      public function getInstanceByName(param1:String) : DisplayObject
      {
         return this.swfLoader.getInstanceByName(param1);
      }
   }
}
