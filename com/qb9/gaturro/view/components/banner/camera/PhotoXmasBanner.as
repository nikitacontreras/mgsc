package com.qb9.gaturro.view.components.banner.camera
{
   import com.qb9.gaturro.commons.view.image.ImageCapture;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.util.StubAttributeHolder;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PhotoXmasBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var pictureHeight:int;
      
      private var gaturroHolder:DisplayObjectContainer;
      
      private var captureButton:Sprite;
      
      private var picture:DisplayObjectContainer;
      
      private var pictureWidth:int;
      
      private var photoHolder:Sprite;
      
      private var gaturro:Gaturro;
      
      public function PhotoXmasBanner()
      {
         super("photoNavidad2016","photoXmasBannerAsset");
      }
      
      private function setupPicture() : void
      {
         this.picture = getInstanceByName("picture") as DisplayObjectContainer;
         (this.picture as MovieClip).countdown.visible = false;
         this.photoHolder.addChild(this.picture);
      }
      
      private function setupView() : void
      {
         this.photoHolder = view.getChildByName("photoHolder") as Sprite;
         this.setupPictureDimension();
         this.setupPicture();
         this.setupButton();
         this.setupUserAvatar();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function setupButton() : void
      {
         this.captureButton = view.getChildByName("captureButton") as Sprite;
         this.captureButton.addEventListener(MouseEvent.CLICK,this.onClickCaptureButton);
      }
      
      private function setupUserAvatar() : void
      {
         this.gaturroHolder = this.picture.getChildByName("gaturroHolder") as DisplayObjectContainer;
         var _loc1_:StubAttributeHolder = StubAttributeHolder.fromHolder(this._roomAPI.userAvatar);
         _loc1_.attributes.transport = "";
         logger.info(_loc1_.attributes.toString());
         this.gaturro = new Gaturro(_loc1_);
         this.gaturro.gotoAndPlay("sit");
         this.gaturro.scaleY = 0.5;
         this.gaturro.scaleX = 0.5;
         this.gaturroHolder.addChild(this.gaturro);
      }
      
      override protected function ready() : void
      {
         this._roomAPI.pauseBackgroundMusic();
         this.setupView();
      }
      
      private function setupPictureDimension() : void
      {
         this.pictureWidth = this.photoHolder.width;
         this.pictureHeight = this.photoHolder.height;
      }
      
      override public function dispose() : void
      {
         this.captureButton.removeEventListener(MouseEvent.CLICK,this.onClickCaptureButton);
         this.captureButton = null;
         if(this.picture.hasEventListener("takePicture"))
         {
            this.picture.removeEventListener("takePicture",this.doCapture);
         }
         this._roomAPI.resumeBackgroundMusic();
         this._roomAPI.stopSound("Fiesta_MG6_cabina");
         this.gaturro.dispose();
         if(this.gaturro.parent)
         {
            this.gaturro.parent.removeChild(this.gaturro);
         }
         this.gaturro = null;
         super.dispose();
      }
      
      private function onClickCaptureButton(param1:MouseEvent) : void
      {
         (this.picture as MovieClip).countdown.visible = true;
         (this.picture as MovieClip).countdown.gotoAndPlay(2);
         this.picture.addEventListener("takePicture",this.doCapture);
      }
      
      private function doCapture(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Bitmap = null;
         _loc2_ = this.photoHolder.x;
         _loc3_ = this.photoHolder.y;
         this.photoHolder.x = 0;
         this.photoHolder.y = 0;
         var _loc4_:ImageCapture;
         _loc5_ = (_loc4_ = new ImageCapture()).capture(this.photoHolder,new Rectangle(0,0,this.pictureWidth,this.pictureHeight));
         this.photoHolder.x = _loc2_;
         this.photoHolder.y = _loc3_;
         this._roomAPI.showPhoto(_loc5_);
      }
   }
}
