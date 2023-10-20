package com.qb9.gaturro.view.world.chat
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.components.repeater.item.implementation.catalog.BaseCatalogItemRenderer;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   
   public class BaloonImgItemRenderer extends BaseCatalogItemRenderer
   {
       
      
      public function BaloonImgItemRenderer(param1:GaturroRoomAPI, param2:Class)
      {
         super(param1,param2);
      }
      
      override protected function onFetchCompleted(param1:DisplayObject) : void
      {
         imageContainer.x = this.width / 2;
         imageContainer.y = this.height / 2;
         super.onFetchCompleted(param1);
         var _loc2_:Shape = view.getChildByName("sizeReference") as Shape;
         if(imageContainer.width > imageContainer.height)
         {
            imageContainer.width = _loc2_.width;
            imageContainer.scaleY = _loc2_.scaleX;
         }
         else
         {
            imageContainer.height = _loc2_.height;
            imageContainer.scaleX = _loc2_.scaleY;
         }
         var _loc3_:Rectangle = param1.getBounds(imageContainer);
         var _loc4_:Number = -_loc3_.x;
         var _loc5_:Number = -_loc3_.y;
         param1.x = _loc4_ - param1.width / 2;
         param1.y = _loc5_ - param1.height / 2;
      }
   }
}
