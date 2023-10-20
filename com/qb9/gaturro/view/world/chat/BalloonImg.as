package com.qb9.gaturro.view.world.chat
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.components.repeater.item.implementation.catalog.BaseCatalogItemRendererFactory;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BalloonImg extends ChatBalloon
   {
      
      private static const MIDDLE_MARGIN:int = 10;
       
      
      protected var repeater:Repeater;
      
      private var count:int;
      
      private var images:Array;
      
      private var rows:int;
      
      private var columns:int;
      
      public function BalloonImg(param1:DisplayObject, param2:Sprite, param3:int, param4:int, param5:Array)
      {
         this.rows = param4;
         this.columns = param3;
         this.images = param5;
         super(param1,param2,"");
      }
      
      override protected function calculateTime(param1:String) : uint
      {
         return this.images.length * 5000;
      }
      
      override protected function setup() : void
      {
         createAsset();
         this.setupRepeater();
      }
      
      private function setupRepeater() : void
      {
         var _loc1_:IIterable = IterableFactory.build(this.images);
         this.repeater = new Repeater(_loc1_);
         this.repeater.itemRendererFactory = new BaseCatalogItemRendererFactory(api,BaloonItemRendererAsset,BaloonImgItemRenderer);
         if(this.rows > -1)
         {
            this.repeater.rows = this.rows;
         }
         if(this.columns > -1)
         {
            this.repeater.columns = this.columns;
         }
         this.repeater.build();
         this.repeater.addEventListener(Event.COMPLETE,this.onLoadedComplete);
         asset.addChild(this.repeater);
      }
      
      override public function dispose() : void
      {
         DisplayUtil.empty(asset);
         this.repeater.removeEventListener(Event.COMPLETE,this.onLoadedComplete);
         super.dispose();
      }
      
      private function onLoadedComplete(param1:Event) : void
      {
         ++this.count;
         if(this.count >= this.images.length)
         {
            this.setupContent();
            this.setBackground();
         }
      }
      
      override protected function setupContent() : void
      {
         this.repeater.x = -(this.repeater.width / 2);
         super.setupContent();
         this.repeater.y = -this.repeater.height - tri.height - MARGIN;
      }
      
      override protected function setBackground() : void
      {
         var _loc1_:Shape = new Shape();
         asset.addChildAt(_loc1_,0);
         _loc1_.graphics.beginFill(0,ChatBalloon.ALPHA);
         _loc1_.graphics.drawRoundRect(0,0,this.repeater.width + ChatBalloon.MARGIN * 2,this.repeater.height + ChatBalloon.MARGIN * 2,ROUNDING);
         _loc1_.graphics.endFill();
         _loc1_.x = -_loc1_.width / 2;
         _loc1_.y = this.repeater.y - ChatBalloon.MARGIN;
      }
   }
}

import flash.display.Shape;
import flash.display.Sprite;

class BaloonItemRendererAsset extends Sprite
{
    
   
   public function BaloonItemRendererAsset()
   {
      super();
      this.setup();
   }
   
   private function setup() : void
   {
      var _loc1_:Shape = new Shape();
      _loc1_.name = "sizeReference";
      _loc1_.graphics.beginFill(1,0);
      _loc1_.graphics.drawRect(0,0,55,55);
      _loc1_.graphics.endFill();
      addChild(_loc1_);
      var _loc2_:Sprite = new Sprite();
      addChild(_loc2_);
      _loc2_.name = "imageContainer";
      graphics.beginFill(16777215,0);
      graphics.drawRect(2.5,2.5,60,60);
      graphics.endFill();
   }
}
