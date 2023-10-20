package com.qb9.flashlib.color
{
   public class Color
   {
      
      public static const WHITE:uint = 16777215;
      
      public static const BLACK:uint = 0;
      
      public static const BLUE:uint = 255;
      
      public static const GREEN:uint = 65280;
      
      public static const CYAN:uint = 2673126;
      
      public static const ORANGE:uint = 16737792;
      
      public static const RED:uint = 16711680;
      
      public static const PINK:uint = 16711932;
      
      public static const YELLOW:uint = 16776960;
      
      public static const PURPLE:uint = 9437371;
       
      
      protected var _brightness:Number;
      
      protected var _hex:uint;
      
      public function Color(param1:uint)
      {
         super();
         this._hex = param1;
         this._brightness = 1;
      }
      
      public static function interpolate(param1:Color, param2:Color, param3:Number) : Color
      {
         var _loc4_:Number = 1 - param3;
         return fromRGB(param1.r * _loc4_ + param2.r * param3,param1.g * _loc4_ + param2.g * param3,param1.b * _loc4_ + param2.b * param3);
      }
      
      protected static function limit(param1:int, param2:uint = 255) : uint
      {
         return param1 <= 0 ? 0 : (param1 >= param2 ? param2 : uint(param1));
      }
      
      public static function fromRGB(param1:uint, param2:uint, param3:uint) : Color
      {
         return new Color(rgbToHex(param1,param2,param3));
      }
      
      public static function rgbToHex(param1:uint, param2:uint, param3:uint) : uint
      {
         return limit(param1) << 16 | limit(param2) << 8 | limit(param3) << 0;
      }
      
      public static function interpolateHex(param1:uint, param2:uint, param3:Number) : uint
      {
         return interpolate(new Color(param1),new Color(param2),param3).hex;
      }
      
      public function add(param1:Color) : Color
      {
         return Color.fromRGB(this.r + param1.r,this.g + param1.g,this.b + param1.b);
      }
      
      public function set brightness(param1:Number) : void
      {
         this._brightness = param1;
      }
      
      public function get g() : uint
      {
         return this.slice(1);
      }
      
      public function get b() : uint
      {
         return this.slice(0);
      }
      
      public function sub(param1:Color) : Color
      {
         return Color.fromRGB(this.r - param1.r,this.g - param1.g,this.b - param1.b);
      }
      
      public function get brightness() : Number
      {
         return this._brightness;
      }
      
      protected function slice(param1:uint) : uint
      {
         return limit((this._hex >> param1 * 8 & 255) * this._brightness);
      }
      
      public function get r() : uint
      {
         return this.slice(2);
      }
      
      public function get hex() : uint
      {
         return limit(this._hex * this._brightness,16777215);
      }
      
      public function equals(param1:Color) : Boolean
      {
         return this.hex === param1.hex;
      }
   }
}
