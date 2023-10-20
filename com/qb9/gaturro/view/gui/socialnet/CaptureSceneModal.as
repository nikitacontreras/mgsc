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
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public final class CaptureSceneModal extends BaseGuiModal
   {
       
      
      private const FILTER_BROKEN:String = "broken";
      
      private const FILTER_NO_FOCUS:String = "noFocus";
      
      private var gRoom:GaturroRoomView;
      
      private var camFilters:Array;
      
      private var manager:MovieClipManager;
      
      private var asset:SocialNetCaptureSceneMC;
      
      private const FILTER_BLACK_N_WHITE:String = "blackAndWhite";
      
      private var bitmapData:BitmapData;
      
      private const PHOTO_SCALE:Number = 0.75;
      
      public function CaptureSceneModal(param1:GaturroRoomView, param2:Boolean = false, param3:Array = null)
      {
         super();
         this.gRoom = param1;
         this.init(param2);
         this.camFilters = param3;
      }
      
      private function init(param1:Boolean) : void
      {
         this.asset = new SocialNetCaptureSceneMC();
         addChild(this.asset);
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         this.asset.capture.addEventListener(MouseEvent.CLICK,this.captureScene);
         this.asset.capture.field.text = region.getText("FOTOGRAFIAR");
         this.manager = new MovieClipManager(this.asset);
         if(param1)
         {
            this.captureScene();
         }
      }
      
      private function noPicapon() : void
      {
         this.asset.gotoAndPlay("noPicapon");
         this.manager.when(new Trigger(new ChildDefinedCondition("send"),new FunctionAction(this.setSendListener)));
      }
      
      private function onClose(param1:Event) : void
      {
         close();
      }
      
      private function setSendListener() : void
      {
         if(region.country == "BR")
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
            this.asset.capture.removeEventListener(MouseEvent.CLICK,this.captureScene);
         }
         if(this.asset.send)
         {
            this.asset.send.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         this.manager.dispose();
         this.manager = null;
         this.asset = null;
         this.gRoom = null;
         super.dispose();
      }
      
      private function captureScene(param1:MouseEvent = null) : void
      {
         this.captureImage();
         this.asset.gotoAndPlay("shot");
         var _loc2_:Trigger = new Trigger(new LabelCondition("show"),new FunctionAction(this.showPhoto));
         this.manager.when(_loc2_);
      }
      
      private function applyFilters(param1:Bitmap) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc2_:Array = [];
         for each(_loc3_ in this.camFilters)
         {
            switch(_loc3_)
            {
               case this.FILTER_BLACK_N_WHITE:
                  _loc5_ = [1 / 3,1 / 3,1 / 3,0,0,1 / 3,1 / 3,1 / 3,0,0,1 / 3,1 / 3,1 / 3,0,0,0,0,0,1,0];
                  _loc2_.push(new ColorMatrixFilter(_loc5_));
                  break;
               case this.FILTER_BROKEN:
                  _loc6_ = Math.floor(Math.random() * 100);
                  _loc7_ = uint(BitmapDataChannel.RED | BitmapDataChannel.BLUE);
                  param1.bitmapData.perlinNoise(100,80,6,_loc6_,false,true,_loc7_,false,null);
                  break;
               case this.FILTER_NO_FOCUS:
                  _loc2_.push(new BlurFilter(10,10));
                  break;
            }
         }
         param1.filters = _loc2_;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            this.bitmapData.applyFilter(this.bitmapData,this.bitmapData.rect,new Point(),_loc2_[_loc4_]);
            _loc4_++;
         }
      }
      
      private function showPhoto() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = new Bitmap(this.bitmapData);
         _loc1_.scaleX = this.PHOTO_SCALE;
         _loc1_.scaleY = this.PHOTO_SCALE;
         _loc1_.smoothing = true;
         this.applyFilters(_loc1_);
         this.asset.photoPh.addChild(_loc1_);
         _loc1_.x = -(_loc1_.width / 2);
         _loc1_.y = -(_loc1_.height / 2);
         this.manager.when(new Trigger(new ChildDefinedCondition("send"),new FunctionAction(this.setSendListener)));
      }
      
      private function captureImage() : void
      {
         this.bitmapData = this.gRoom.captureScene();
      }
   }
}
