package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   
   public class Path
   {
       
      
      private var _originalDestination:Coord;
      
      private var coords:Array;
      
      public function Path(param1:Array, param2:Coord = null)
      {
         super();
         this.coords = param1;
         this._originalDestination = param2 || this.destination;
      }
      
      public function get nextCoord() : Coord
      {
         return this.coords[1];
      }
      
      public function cropAt(param1:Coord) : void
      {
         if(this.has(param1))
         {
            this.coords = this.coords.slice(0,this.index(param1) + 1);
         }
      }
      
      public function toString() : String
      {
         return this.coords.toString();
      }
      
      public function toArray() : Array
      {
         return this.coords.concat();
      }
      
      public function get destination() : Coord
      {
         return this.coords[this.coords.length - 1];
      }
      
      private function index(param1:Coord) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.coords.length)
         {
            if(param1.equals(this.coords[_loc2_]))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function get coord() : Coord
      {
         return this.coords[0];
      }
      
      public function has(param1:Coord) : Boolean
      {
         return this.index(param1) !== -1;
      }
      
      public function step() : void
      {
         this.coords.shift();
      }
      
      public function get originalDestination() : Coord
      {
         return this._originalDestination;
      }
   }
}
