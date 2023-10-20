package com.qb9.mambo.view.loading
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.mambo.view.MamboView;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BaseLoadingScreen extends MamboView
   {
       
      
      public function BaseLoadingScreen()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this._draw);
      }
      
      public function hide() : void
      {
         DisplayUtil.remove(this);
         dispose();
      }
      
      private function _draw(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this._draw);
         this.draw();
      }
      
      protected function draw() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.defaultTextFormat = new TextFormat("Century Gothic",20,Color.WHITE,true);
         _loc1_.text = "Loading...";
         _loc1_.x = (stage.stageWidth - _loc1_.textWidth) / 2;
         _loc1_.y = (stage.stageHeight - _loc1_.textHeight) / 2;
         addChild(_loc1_);
      }
   }
}
