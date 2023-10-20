package com.qb9.gaturro.view.gui.contextual
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.loader.SWFLoader;
   import com.qb9.gaturro.commons.loader.SWFLoaderWrapper;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuActionDefinition;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuDefinition;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class AbstractContextualMenu extends Sprite implements ICheckableDisposable
   {
       
      
      protected var loaderWrapper:SWFLoaderWrapper;
      
      private var _disposed:Boolean;
      
      protected var _data:Object;
      
      protected var definition:ContextualMenuDefinition;
      
      protected var view:DisplayObjectContainer;
      
      private var swfLoader:SWFLoader;
      
      protected var owner:DisplayObject;
      
      protected var buttonHolder:DisplayObjectContainer;
      
      public function AbstractContextualMenu(param1:ContextualMenuDefinition, param2:DisplayObject)
      {
         super();
         this.owner = param2;
         this.definition = param1;
         this.loadAsset();
      }
      
      private function onEventLoading(param1:Event) : void
      {
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onPrivateLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onEventLoading);
         this.swfLoader.removeEventListener(ErrorEvent.ERROR,this.onEventLoading);
      }
      
      private function onPrivateLoadComplete(param1:Event) : void
      {
         this.view = this.swfLoader.getInstanceByName(this.definition.assetClass) as DisplayObjectContainer;
         addChild(this.view);
         this.viewReady();
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
      }
      
      protected function setupButtons() : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc1_:int = this.buttonHolder.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.buttonHolder.getChildAt(_loc3_) as InteractiveObject;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_++;
         }
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this.swfLoader.hasDefinition(param1);
      }
      
      public function getDefinition(param1:String) : Class
      {
         return this.swfLoader.getDefinition(param1) as Class;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      protected function viewReady() : void
      {
         this.buttonHolder = this.view.getChildByName("buttonHolder") as DisplayObjectContainer;
         this.setupButtons();
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:String = DisplayObject(param1.currentTarget).name;
         var _loc3_:ContextualMenuActionDefinition = this.definition.getAction(_loc2_);
         var _loc4_:String;
         if((_loc4_ = _loc3_.action) in this)
         {
            Function(this[_loc4_]).apply(_loc3_);
         }
      }
      
      private function disposeLoader() : void
      {
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onPrivateLoadComplete);
         this.swfLoader.removeEventListener(Event.COMPLETE,this.onEventLoading);
         this.swfLoader.removeEventListener(ErrorEvent.ERROR,this.onEventLoading);
         this.swfLoader.dispose();
         this.swfLoader = null;
      }
      
      protected function disposeButtons() : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc1_:int = this.buttonHolder.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.buttonHolder.getChildAt(_loc3_) as InteractiveObject;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc3_++;
         }
      }
      
      final protected function makeFinalURL(param1:String) : String
      {
         var _loc2_:String = URLUtil.getUrl(param1 + ".swf");
         return URLUtil.versionedPath(_loc2_);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.disposeLoader();
         this.disposeButtons();
      }
      
      protected function loadAsset() : void
      {
         var _loc1_:String = this.makeFinalURL(this.definition.assetName);
         this.swfLoader = new SWFLoader(_loc1_);
         this.loaderWrapper = new SWFLoaderWrapper(this.swfLoader);
         this.swfLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.swfLoader.addEventListener(Event.COMPLETE,this.onPrivateLoadComplete);
         this.swfLoader.addEventListener(Event.COMPLETE,this.onEventLoading);
         this.swfLoader.addEventListener(ErrorEvent.ERROR,this.onEventLoading);
         this.swfLoader.load();
      }
      
      public function getInstanceByName(param1:String) : DisplayObject
      {
         return this.swfLoader.getInstanceByName(param1);
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.swfLoader.applicationDomain;
      }
   }
}
