package com.qb9.gaturro.view.gui.image
{
   import assets.ImageFrameMC;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ImageGuiModal extends BaseGuiModal
   {
       
      
      private var asset:MovieClip;
      
      private var image:DisplayObject;
      
      public function ImageGuiModal(param1:DisplayObject)
      {
         super();
         this.image = param1;
         this.init();
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               return close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function get frameHeight() : Number
      {
         return this.asset.background.height;
      }
      
      private function init() : void
      {
         this.asset = new ImageFrameMC();
         addChild(this.asset);
         this.image.width = this.frameWidth;
         this.image.height = this.frameHeight;
         this.ph.addChild(this.image);
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
      }
      
      private function get ph() : DisplayObjectContainer
      {
         return this.asset.ph;
      }
      
      private function get frameWidth() : Number
      {
         return this.asset.background.width;
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.image = null;
         super.dispose();
      }
   }
}
