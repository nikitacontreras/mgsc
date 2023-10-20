package com.qb9.flashlib.prototyping.shapes
{
   public class BasicShapeConfig
   {
       
      
      private var _color:int;
      
      private var _borderAlpha:Number;
      
      private var _borderColor:int;
      
      private var _borderWidth:int;
      
      private var _alpha:Number;
      
      public function BasicShapeConfig(param1:int = -1, param2:Number = 1, param3:uint = 0, param4:uint = 0, param5:Number = 1)
      {
         super();
         this._color = param1;
         this._alpha = param2;
         this._borderWidth = param3;
         this._borderColor = param4;
         this._borderAlpha = param5;
      }
      
      public function get borderWidth() : uint
      {
         return this._borderWidth;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
   }
}
