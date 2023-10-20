package com.qb9.mambo.geom
{
   import com.qb9.flashlib.utils.CoordUtil;
   
   public class Coord
   {
      
      private static const CACHE:Object = {};
       
      
      protected var _x:int;
      
      protected var _y:int;
      
      protected var _z:int;
      
      public function Coord(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this._x = param1;
         this._y = param2;
         this._z = param3;
      }
      
      public static function create(param1:int = 0, param2:int = 0, param3:int = 0) : Coord
      {
         var _loc4_:String = param1 + "_" + param2 + "_" + param3;
         return CACHE[_loc4_] || (CACHE[_loc4_] = new Coord(param1,param2,param3));
      }
      
      public static function fromArray(param1:Array) : Coord
      {
         return create(param1[0],param1[1],param1[2]);
      }
      
      public function add(param1:int, param2:int, param3:int = 0) : Coord
      {
         return create(this._x + param1,this._y + param2,this._z + param3);
      }
      
      public function toString() : String
      {
         var _loc1_:Array = this.toArray();
         if(this.z === 0)
         {
            _loc1_.pop();
         }
         return "(" + _loc1_.join(", ") + ")";
      }
      
      public function neighbors(param1:Coord) : Boolean
      {
         if(this.equals(param1))
         {
            return false;
         }
         return this.isNeighborValue(this.x,param1.x) && this.isNeighborValue(this.y,param1.y) && this.isNeighborValue(this.z,param1.z);
      }
      
      private function isNeighborValue(param1:int, param2:int) : Boolean
      {
         return Math.abs(param1 - param2) <= 1;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get z() : int
      {
         return this._z;
      }
      
      public function distance(param1:Coord) : Number
      {
         return CoordUtil.distance(this,param1);
      }
      
      public function toArray() : Array
      {
         return [this.x,this.y,this.z];
      }
      
      public function equals(param1:Coord) : Boolean
      {
         return param1 === this || this.x === param1.x && this.y === param1.y && this.z === param1.z;
      }
   }
}
