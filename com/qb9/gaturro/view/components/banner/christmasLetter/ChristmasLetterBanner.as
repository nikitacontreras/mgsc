package com.qb9.gaturro.view.components.banner.christmasLetter
{
   import com.qb9.gaturro.commons.view.image.ImageCapture;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class ChristmasLetterBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var pictureHeight:int;
      
      private var capture:Bitmap;
      
      private var intervalId:int;
      
      private var picture:DisplayObjectContainer;
      
      private var acceptButton:Sprite;
      
      private var letter:Sprite;
      
      private var pictureWidth:int;
      
      private var letterBody:TextField;
      
      private var signature:TextField;
      
      public function ChristmasLetterBanner()
      {
         super("ChristmasLetterBanner","ChristmasLetterBannerAsset");
      }
      
      private function setupView() : void
      {
         this.letter = view.getChildByName("letter") as MovieClip;
         this.letterBody = this.letter.getChildByName("letterBody") as TextField;
         this.setupPictureDimension();
         this.setupButton();
         this.setupSignature();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function doCapture() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.letter.x;
         _loc2_ = this.letter.y;
         this.letter.x = 0;
         this.letter.y = 0;
         var _loc3_:ImageCapture = new ImageCapture();
         this.capture = _loc3_.capture(this.letter,new Rectangle(0,0,this.pictureWidth,this.pictureHeight));
         this.letter.x = _loc1_;
         this.letter.y = _loc2_;
      }
      
      private function setupButton() : void
      {
         this.acceptButton = view.getChildByName("acceptButton") as Sprite;
         this.acceptButton.addEventListener(MouseEvent.CLICK,this.onClickCaptureButton);
      }
      
      override public function dispose() : void
      {
         this.acceptButton.removeEventListener(MouseEvent.CLICK,this.onClickCaptureButton);
         this.acceptButton = null;
         super.dispose();
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      private function setupPictureDimension() : void
      {
         this.pictureWidth = this.letter.width;
         this.pictureHeight = this.letter.height;
      }
      
      private function onClickCaptureButton(param1:MouseEvent) : void
      {
         if(this.letterBody.text.length)
         {
            this.doCapture();
            this._roomAPI.giveUser("navidad2016/props.carta");
            this._roomAPI.showPhoto(this.capture);
         }
      }
      
      private function setupSignature() : void
      {
         this.signature = this.letter.getChildByName("signature") as TextField;
         this.signature.text = this._roomAPI.user.username;
      }
   }
}
