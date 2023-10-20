package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.mambo.view.MamboView;
   import flash.display.DisplayObject;
   
   public class TiledLayer extends MamboView
   {
       
      
      private var speed:Number;
      
      public function TiledLayer(param1:DisplayObject, param2:Number)
      {
         super();
         this.speed = param2;
         addChild(param1);
         cacheAsBitmap = true;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1 * this.speed;
      }
      
      override public function dispose() : void
      {
         cacheAsBitmap = false;
         DisplayUtil.dispose(this);
         super.dispose();
      }
   }
}
