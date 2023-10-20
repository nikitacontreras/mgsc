package com.qb9.gaturro.view.world.whitelist.items
{
   import com.qb9.gaturro.globals.region;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BaseWhiteListItemView extends Sprite
   {
      
      private static const MIN_FONT_SIZE:uint = 1;
      
      private static const MAX_FONT_SIZE:uint = 12;
      
      private static const MARGIN_X:uint = 5;
      
      private static const MARGIN_Y:uint = 5;
      
      private static const RE_EMPTY_VAR:RegExp = /( |^)(\.){3}( |$)/;
       
      
      protected var asset:MovieClip;
      
      private var field:TextField;
      
      public function BaseWhiteListItemView(param1:MovieClip, param2:String)
      {
         super();
         this.asset = param1;
         buttonMode = true;
         addChild(param1);
         this.init(param2);
      }
      
      public function unselect() : void
      {
         this.asset.gotoAndStop(1);
      }
      
      private function init(param1:String) : void
      {
         var _loc2_:int = 0;
         _loc2_ = width - MARGIN_X;
         var _loc3_:int = height - MARGIN_Y;
         this.field = this.asset.NO_WORK_WITH_ADDED;
         this.field.mouseEnabled = false;
         this.field.embedFonts = true;
         region.setText(this.field,param1.toUpperCase());
         this.field.width = _loc2_;
         this.field.x = MARGIN_X;
         var _loc4_:TextFormat = new TextFormat();
         var _loc5_:int = int(MAX_FONT_SIZE);
         _loc4_.size = _loc5_;
         _loc4_.color = 798783;
         _loc4_.bold = true;
         do
         {
            _loc4_.size = _loc5_--;
            this.field.setTextFormat(_loc4_);
         }
         while(_loc5_ >= MIN_FONT_SIZE && this.field.textWidth > _loc2_ - MARGIN_X);
         
         this.field.y = (_loc3_ - this.field.textHeight) / 2;
         this.field.height = this.field.textHeight;
         addChild(this.field);
      }
      
      public function select() : void
      {
         this.asset.gotoAndStop(2);
      }
      
      public function get disabled() : Boolean
      {
         return RE_EMPTY_VAR.test(this.field.text);
      }
   }
}
