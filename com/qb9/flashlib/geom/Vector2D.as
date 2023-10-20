package com.qb9.flashlib.geom
{
   import com.qb9.flashlib.interfaces.ILocation;
   
   public class Vector2D implements ILocation
   {
       
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function Vector2D(param1:Number = 0, param2:Number = 0)
      {
         super();
         this._x = param1;
         this._y = param2;
      }
      
      public static function interpolate(param1:Number, param2:Vector2D, param3:Vector2D) : Vector2D
      {
         return param2.add(param3.sub(param2).scaled(param1));
      }
      
      public static function polar(param1:Number, param2:Number) : Vector2D
      {
         return new Vector2D(param1 * Math.cos(param2),param1 * Math.sin(param2));
      }
      
      public function sub(param1:Vector2D) : Vector2D
      {
         return new Vector2D(this._x - param1._x,this._y - param1._y);
      }
      
      public function toPhase(param1:Number) : Vector2D
      {
         return Vector2D.polar(this.norm,param1);
      }
      
      public function dot(param1:Vector2D) : Number
      {
         return this._x * param1._x + this._y * param1._y;
      }
      
      public function projectOver(param1:Vector2D) : Vector2D
      {
         var _loc2_:Number = param1.norm2;
         return param1.scaled(this.dot(param1) / _loc2_);
      }
      
      public function neg() : Vector2D
      {
         return new Vector2D(-this._x,-this._y);
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function scaled(param1:Number) : Vector2D
      {
         return new Vector2D(this._x * param1,this._y * param1);
      }
      
      public function distance2(param1:Vector2D) : Number
      {
         var _loc2_:Number = this._x - param1._x;
         var _loc3_:Number = this._y - param1._y;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_;
      }
      
      public function add(param1:Vector2D) : Vector2D
      {
         return new Vector2D(this._x + param1._x,this._y + param1._y);
      }
      
      public function normal() : Vector2D
      {
         return new Vector2D(this._y,-this._x);
      }
      
      public function rotated(param1:Number) : Vector2D
      {
         return this.toPhase(this.phase + param1);
      }
      
      public function toString() : String
      {
         return "<Vector2D x:" + this._x + " y:" + this._y + ">";
      }
      
      public function distance(param1:Vector2D) : Number
      {
         return Math.sqrt(this.distance2(param1));
      }
      
      public function get norm2() : Number
      {
         return this._x * this._x + this._y * this._y;
      }
      
      public function normalized(param1:Number = 1) : Vector2D
      {
         var _loc2_:Number = this.norm;
         param1 /= _loc2_;
         return new Vector2D(this._x * param1,this._y * param1);
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get phase() : Number
      {
         return Math.atan2(this._y,this._x);
      }
      
      public function get norm() : Number
      {
         return Math.sqrt(this.norm2);
      }
      
      public function equals(param1:Vector2D) : Boolean
      {
         return this._x == param1._x && this._y == param1._y;
      }
   }
}
