package com.qb9.gaturro.util
{
   import com.dynamicflash.util.Base64;
   import com.qb9.flashlib.geom.Vector2D;
   import com.qb9.gaturro.util.encoders.JPGEncoder;
   import com.qb9.gaturro.util.encoders.PNGEncoder;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class ImageTool
   {
      
      public static const JPG_ENCODING:String = "JPEG";
      
      public static const PNG_ENCODING:String = "PNG";
      
      public static const BACKGROUND_COLOR:uint = 4293651949;
       
      
      public function ImageTool()
      {
         super();
      }
      
      public static function bitmapToBase64(param1:BitmapData, param2:String, param3:int = 100) : String
      {
         var _loc4_:ByteArray = null;
         var _loc5_:JPGEncoder = null;
         switch(param2)
         {
            case JPG_ENCODING:
               _loc4_ = (_loc5_ = new JPGEncoder(param3)).encode(param1);
               break;
            case PNG_ENCODING:
            default:
               _loc4_ = PNGEncoder.encode(param1);
         }
         return Base64.encodeByteArray(_loc4_);
      }
      
      public static function getAvatarBitmap(param1:Gaturro, param2:DisplayObjectContainer, param3:String, param4:int, param5:int, param6:Vector2D = null) : BitmapData
      {
         var _loc15_:int = 0;
         var _loc16_:uint = 0;
         param1.scaleX = param6 == null ? 1.2 : param6.x;
         param1.scaleY = param6 == null ? 1.2 : param6.y;
         var _loc7_:DisplayObjectContainer;
         (_loc7_ = (param2 as Object)[param3] != null ? (param2 as Object)[param3] : new MovieClip()).addChild(param1);
         var _loc8_:BitmapData = new BitmapData(400,400);
         var _loc9_:Matrix = new Matrix(1,0,0,1,40,40);
         _loc8_.draw(param2,_loc9_);
         var _loc10_:Rectangle;
         (_loc10_ = new Rectangle()).width = param4;
         _loc10_.height = param5;
         var _loc11_:BitmapData = new BitmapData(param4,param5,true,0);
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = _loc10_.x;
         while(_loc14_ < _loc10_.x + _loc10_.width)
         {
            _loc15_ = _loc10_.y;
            while(_loc15_ < _loc10_.y + _loc10_.height)
            {
               if((_loc16_ = _loc8_.getPixel32(_loc14_,_loc15_)) != BACKGROUND_COLOR)
               {
                  _loc11_.setPixel32(_loc12_,_loc13_,_loc16_);
               }
               _loc13_++;
               _loc15_++;
            }
            _loc12_++;
            _loc13_ = 0;
            _loc14_++;
         }
         _loc7_.removeChild(param1);
         return _loc11_;
      }
   }
}
