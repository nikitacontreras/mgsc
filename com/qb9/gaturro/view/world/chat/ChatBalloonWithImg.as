package com.qb9.gaturro.view.world.chat
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.libs;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ChatBalloonWithImg extends ChatBalloon
   {
      
      private static const MIDDLE_MARGIN:int = 10;
       
      
      private var contentHolder:Sprite;
      
      private var imgPath:String;
      
      public function ChatBalloonWithImg(param1:DisplayObject, param2:Sprite, param3:String, param4:String)
      {
         this.imgPath = param4;
         super(param1,param2,param3);
      }
      
      override protected function setup() : void
      {
         createAsset();
         this.createHolder();
         this.loadImg();
      }
      
      override protected function getAutosize() : String
      {
         return TextFieldAutoSize.LEFT;
      }
      
      private function locateContetnHolder() : void
      {
         this.contentHolder.y = -ChatBalloon.MARGIN - tri.height - this.contentHolder.height;
      }
      
      override public function dispose() : void
      {
         DisplayUtil.empty(asset);
         DisplayUtil.empty(this.contentHolder);
         this.contentHolder = null;
         super.dispose();
      }
      
      private function createHolder() : void
      {
         this.contentHolder = new Sprite();
         asset.addChild(this.contentHolder);
      }
      
      override protected function calculateTime(param1:String) : uint
      {
         return super.calculateTime(param1) + 4000;
      }
      
      private function setupIcon(param1:DisplayObject) : void
      {
         var _loc4_:Number = NaN;
         this.contentHolder.addChild(param1);
         var _loc2_:Rectangle = param1.getBounds(this.contentHolder);
         var _loc3_:Number = param1.x - _loc2_.x;
         _loc4_ = param1.y - _loc2_.y;
         param1.x = _loc3_ - param1.width / 2;
         param1.y = asset.getBounds(field).bottom + MIDDLE_MARGIN + _loc4_;
      }
      
      private function onFetchCompleted(param1:DisplayObject) : void
      {
         setupContent();
         this.contentHolder.addChild(field);
         this.setupIcon(param1);
         this.locateContetnHolder();
         this.setBackground();
      }
      
      override protected function locateTextField(param1:int) : void
      {
         field.x = -field.width / 2;
      }
      
      private function loadImg() : void
      {
         libs.fetch(this.imgPath,this.onFetchCompleted);
      }
      
      override protected function setBackground() : void
      {
         var _loc1_:Shape = null;
         _loc1_ = new Shape();
         asset.addChildAt(_loc1_,0);
         _loc1_.graphics.beginFill(0,ChatBalloon.ALPHA);
         _loc1_.graphics.drawRoundRect(0,0,this.contentHolder.width + ChatBalloon.MARGIN * 2,this.contentHolder.height + ChatBalloon.MARGIN * 2,ROUNDING);
         _loc1_.graphics.endFill();
         _loc1_.x = -_loc1_.width / 2;
         _loc1_.y = this.contentHolder.y - ChatBalloon.MARGIN;
      }
   }
}
