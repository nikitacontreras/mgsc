package com.qb9.gaturro.commons.view.image
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class ImageCapture
   {
       
      
      public function ImageCapture()
      {
         super();
      }
      
      public function capture(param1:Sprite, param2:Rectangle) : Bitmap
      {
         var _loc3_:BitmapData = new BitmapData(param2.width,param2.height);
         _loc3_.draw(param1,null,null,null,param2,true);
         return new Bitmap(_loc3_);
      }
   }
}
