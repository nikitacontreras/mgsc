package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.image.ImageGuiModal;
   import com.qb9.gaturro.world.core.elements.ImageRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public final class ImageRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
      
      private static const BASE:String = "content/";
       
      
      private var _loaded:Boolean;
      
      private var loader:Loader;
      
      private var gui:Gui;
      
      public function ImageRoomSceneObjectView(param1:ImageRoomSceneObject, param2:TwoWayLink, param3:Gui)
      {
         super(param1,param2);
         this.gui = param3;
         this.loaded = false;
      }
      
      private function imageLoaded(param1:Event) : void
      {
         var _loc2_:Sprite = mc.ph || mc;
         (this.info.content as Bitmap).smoothing = true;
         this.info.content.width = 80;
         this.info.content.height = 54;
         _loc2_.addChild(this.info.content);
         this.loaded = true;
      }
      
      override public function add(param1:Sprite) : void
      {
         super.add(param1);
         this.load(BASE + this.object.image);
      }
      
      private function load(param1:String) : void
      {
         this.loader = new Loader();
         this.info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         this.info.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         this.info.addEventListener(Event.INIT,this.imageLoaded);
         var _loc2_:String = URLUtil.versionedPath(URLUtil.getUrl(param1));
         this.loader.load(new URLRequest(_loc2_));
      }
      
      private function set loaded(param1:Boolean) : void
      {
         this._loaded = param1;
         if(mc)
         {
            mc.gotoAndStop(1);
            mc.gotoAndStop(param1 ? "loaded" : "loading");
         }
      }
      
      private function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      private function get info() : LoaderInfo
      {
         return this.loader.contentLoaderInfo;
      }
      
      override public function get isActivable() : Boolean
      {
         return true;
      }
      
      private function get imageCopy() : Bitmap
      {
         var _loc1_:Bitmap = null;
         _loc1_ = new Bitmap((this.loader.content as Bitmap).bitmapData.clone());
         _loc1_.smoothing = true;
         return _loc1_;
      }
      
      private function handleLoadingError(param1:Event) : void
      {
         logger.warning("In the scene object, the image ",this.object.image,"could not be loaded");
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         var _loc2_:ImageGuiModal = new ImageGuiModal(this.imageCopy);
         if(this.gui)
         {
            this.gui.addModal(_loc2_);
         }
      }
      
      override public function dispose() : void
      {
         this.gui = null;
         asset = null;
         super.dispose();
      }
      
      override public function get captures() : Boolean
      {
         return this.loaded;
      }
      
      private function get object() : ImageRoomSceneObject
      {
         return sceneObject as ImageRoomSceneObject;
      }
   }
}
