package com.qb9.gaturro.view.components.banner.camera
{
   import com.qb9.gaturro.commons.view.image.ImageCapture;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.util.StubAttributeHolder;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PhotoCabinBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var pictureHeight:int;
      
      private var gaturroHolder:DisplayObjectContainer;
      
      private var picture:DisplayObjectContainer;
      
      private var avatarHolderContainer:DisplayObjectContainer;
      
      private var captureButton:Sprite;
      
      private var photoHolder:Sprite;
      
      private var holderList:Array;
      
      private var pictureWidth:int;
      
      private var gaturro:Gaturro;
      
      public function PhotoCabinBanner()
      {
         super("photoCabinBanner","photoCabinBannerAsset");
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
         this.avatarHolderContainer = this.picture.getChildByName("avatarHolderContainer") as Sprite;
         this.setupUserAvatar();
      }
      
      private function showCharacters(param1:Event) : void
      {
         this.randomize();
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
         this.gaturroHolder = this.avatarHolderContainer.getChildByName("gaturroHolder") as DisplayObjectContainer;
         this.gaturro = new Gaturro(StubAttributeHolder.fromHolder(this._roomAPI.userAvatar));
         this.gaturroHolder.addChild(this.gaturro);
      }
      
      override protected function ready() : void
      {
         this._roomAPI.pauseBackgroundMusic();
         this._roomAPI.playSound("Fiesta_MG6_cabina");
         this.setupView();
         this.setupHolderList();
      }
      
      private function setupPictureDimension() : void
      {
         this.pictureWidth = this.photoHolder.width;
         this.pictureHeight = this.photoHolder.height;
      }
      
      override public function dispose() : void
      {
         this.holderList.length = 0;
         this.holderList = null;
         this.avatarHolderContainer.parent.removeChild(this.avatarHolderContainer);
         this.captureButton.removeEventListener(MouseEvent.CLICK,this.onClickCaptureButton);
         this.captureButton = null;
         if(this.picture.hasEventListener("LLEGA_1"))
         {
            this.picture.removeEventListener("LLEGA_1",this.showCharacters);
            this.picture.removeEventListener("LLEGA_0",this.doCapture);
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
      
      private function setupHolderList() : void
      {
         var _loc2_:DisplayObject = null;
         this.holderList = new Array();
         var _loc1_:int = this.avatarHolderContainer.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.avatarHolderContainer.getChildAt(_loc3_);
            if(_loc2_.name.indexOf("characterHolder") >= 0)
            {
               this.holderList.push(_loc2_);
               _loc2_.visible = false;
            }
            _loc3_++;
         }
      }
      
      private function randomize() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc2_:int = int(this.holderList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc1_ = this.holderList[_loc4_];
            _loc3_ = Math.random() * 10 % 2;
            _loc1_.visible = _loc3_ % 2 != 0;
            _loc4_++;
         }
      }
      
      private function onClickCaptureButton(param1:MouseEvent) : void
      {
         (this.picture as MovieClip).countdown.visible = true;
         (this.picture as MovieClip).countdown.play();
         this.picture.addEventListener("LLEGA_1",this.showCharacters);
         this.picture.addEventListener("LLEGA_0",this.doCapture);
      }
      
      private function doCapture(param1:Event) : void
      {
         var _loc2_:int = this.photoHolder.x;
         var _loc3_:int = this.photoHolder.y;
         this.photoHolder.x = 0;
         this.photoHolder.y = 0;
         var _loc4_:ImageCapture;
         var _loc5_:Bitmap = (_loc4_ = new ImageCapture()).capture(this.photoHolder,new Rectangle(0,0,this.pictureWidth,this.pictureHeight));
         this.photoHolder.x = _loc2_;
         this.photoHolder.y = _loc3_;
         this._roomAPI.showPhoto(_loc5_);
      }
   }
}
