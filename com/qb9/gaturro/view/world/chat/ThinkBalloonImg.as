package com.qb9.gaturro.view.world.chat
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ThinkBalloonImg extends BalloonImg
   {
       
      
      public function ThinkBalloonImg(param1:DisplayObject, param2:Sprite, param3:int, param4:int, param5:Array)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function setBackground() : void
      {
         var _loc1_:Shape = null;
         _loc1_ = new Shape();
         asset.addChildAt(_loc1_,0);
         _loc1_.graphics.beginFill(0,ChatBalloon.ALPHA);
         _loc1_.graphics.drawEllipse(0,0,repeater.width + 30 + ChatBalloon.MARGIN * 4,repeater.height + ChatBalloon.MARGIN * 1.5);
         _loc1_.graphics.endFill();
         _loc1_.x = -_loc1_.width / 2;
         _loc1_.y = repeater.y - ChatBalloon.MARGIN;
      }
      
      override protected function setupContent() : void
      {
         repeater.x = -(repeater.width / 2);
         cir = getCircle();
         var _loc1_:int = -cir.height - TEXT_FIX;
         asset.addChild(cir);
         field = getTextfield();
         this.decorateText(text.toUpperCase(),field);
         locateTextField(_loc1_);
         asset.addChild(field);
         repeater.y = -repeater.height - cir.height - MARGIN;
      }
   }
}
