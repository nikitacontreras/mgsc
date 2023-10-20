package com.qb9.flashlib.geom
{
   public class Size
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      public function Size(param1:int = 0, param2:int = 0)
      {
         super();
         this._width = param1;
         this._height = param2;
      }
      
      public static function fromArray(param1:Array) : Size
      {
         return new Size(param1[0],param1[1]);
      }
      
      public function get area() : int
      {
         return this.width * this.height;
      }
      
      public function toArray() : Array
      {
         return [this.width,this.height];
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function toString() : String
      {
         return this.width + "x" + this.height;
      }
      
      public function get height() : int
      {
         return this._height;
      }
   }
}
