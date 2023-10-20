package com.qb9.gaturro.view.gui.util
{
   import assets.WhiteListChatArrow;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.gaturro.globals.settings;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public final class GuiUtil
   {
       
      
      public function GuiUtil()
      {
         super();
      }
      
      public static function fit(param1:DisplayObject, param2:uint, param3:uint, param4:int = 0, param5:int = 0) : void
      {
         var _loc6_:MovieClip = null;
         if((Boolean(_loc6_ = param1 as MovieClip)) && "process" in _loc6_)
         {
            _loc6_.process();
            param1.x -= param4 * (_loc6_.sizeW - 1);
            param1.x += param4 * 0.3 * (_loc6_.sizeH - 1);
            param1.y -= param5 * (_loc6_.sizeH - 1);
         }
         var _loc7_:Number = param2 / param1.width;
         var _loc8_:Number = param3 / param1.height;
         var _loc9_:Number = Math.min(_loc7_,_loc8_);
         param1.scaleX = QMath.sign(param1.scaleX) * _loc9_;
         param1.scaleY = QMath.sign(param1.scaleY) * _loc9_;
      }
      
      public static function createArrow() : DisplayObject
      {
         var _loc1_:DisplayObject = new WhiteListChatArrow();
         _loc1_.alpha = settings.gui.overlay.alpha;
         return _loc1_;
      }
      
      public static function addOverlay(param1:Sprite) : void
      {
         var _loc2_:Object = settings.gui.overlay;
         var _loc3_:int = int(_loc2_.margin);
         var _loc4_:int = param1.height;
      }
   }
}
