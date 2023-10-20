package com.qb9.gaturro.view.gui.socialnet
{
   import assets.SocialNetCaptureSceneMC;
   import com.qb9.flashlib.movieclip.MovieClipManager;
   import com.qb9.flashlib.movieclip.Trigger;
   import com.qb9.flashlib.movieclip.actions.FunctionAction;
   import com.qb9.flashlib.movieclip.conditions.ChildDefinedCondition;
   import com.qb9.flashlib.movieclip.conditions.LabelCondition;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ShowPhotoModal extends BaseGuiModal
   {
       
      
      private const FILTER_NO_FOCUS:String = "noFocus";
      
      private var shareAvailable:Boolean;
      
      private var manager:MovieClipManager;
      
      private var asset:SocialNetCaptureSceneMC;
      
      private const FILTER_BLACK_N_WHITE:String = "blackAndWhite";
      
      private var photo:Bitmap;
      
      private const FILTER_BROKEN:String = "broken";
      
      private const PHOTO_SCALE:Number = 0.75;
      
      public function ShowPhotoModal(param1:Bitmap, param2:Boolean = true)
      {
         super();
         trace(param2);
         this.photo = param1;
         this.shareAvailable = param2;
         this.init();
      }
      
      private function setup() : void
      {
         this.asset.gotoAndPlay("shot");
         this.showPhoto();
         this.manager.when(new Trigger(new LabelCondition("show"),new FunctionAction(this.showPhoto)));
      }
      
      private function showPhoto() : void
      {
         this.photo.scaleX = this.PHOTO_SCALE;
         this.photo.scaleY = this.PHOTO_SCALE;
         this.photo.smoothing = true;
         this.asset.photoPh.addChild(this.photo);
         this.photo.x = -(this.photo.width / 2);
         this.photo.y = -(this.photo.height / 2);
         this.manager.when(new Trigger(new ChildDefinedCondition("send"),new FunctionAction(this.setSendListener)));
      }
      
      private function init() : void
      {
         this.asset = new SocialNetCaptureSceneMC();
         addChild(this.asset);
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         this.asset.capture.addEventListener(MouseEvent.CLICK,this.showPhoto);
         this.asset.capture.field.text = region.getText("FOTOGRAFIAR");
         this.manager = new MovieClipManager(this.asset);
         this.setup();
      }
      
      private function onClose(param1:Event) : void
      {
         close();
      }
      
      private function setSendListener() : void
      {
         this.asset.backPhoto.visible = false;
         if(!this.shareAvailable || region.country == "BR")
         {
            this.asset.text.text = "";
            this.asset.send.visible = false;
            return;
         }
         this.asset.send.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      override public function dispose() : void
      {
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         if(this.asset.capture)
         {
            this.asset.capture.removeEventListener(MouseEvent.CLICK,this.showPhoto);
         }
         if(this.asset.send)
         {
            this.asset.send.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         this.manager.dispose();
         this.manager = null;
         this.asset = null;
         super.dispose();
      }
   }
}
