package com.qb9.mambo.world.tiling
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public class TileGrid implements MobjectBuildable, IDisposable
   {
       
      
      private var _size:Size;
      
      private var matrix:Array;
      
      public function TileGrid()
      {
         super();
      }
      
      public function get tiles() : Array
      {
         return this.matrix;
      }
      
      public function get size() : Size
      {
         return this._size;
      }
      
      private function checkIntegrity() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.matrix.length)
         {
            _loc2_ = 0;
            _loc3_ = this.matrix[_loc1_];
            while(_loc2_ < _loc3_.length)
            {
               if(_loc3_[_loc2_] === null)
               {
                  throw new Error("TileGrid > Found a null tile at " + _loc1_ + "x" + _loc2_);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._size = Size.fromArray(param1.getIntegerArray("size"));
         this.createMatrix();
         foreach(param1.getMobjectArray("tiles"),this.fillWithTiles);
         this.checkIntegrity();
      }
      
      public function getTileAt(param1:uint, param2:uint) : Tile
      {
         return (this.matrix[param1] && this.matrix[param1][param2]) as Tile;
      }
      
      protected function getNewTile() : Tile
      {
         return new Tile();
      }
      
      private function fillWithTiles(param1:Mobject) : void
      {
         var _loc2_:Mobject = null;
         var _loc3_:Tile = null;
         var _loc4_:Coord = null;
         for each(_loc2_ in param1.getMobjectArray("coords"))
         {
            param1.setIntegerArray("coord",_loc2_.getIntegerArray("coord"));
            param1.setBoolean("blockingHint",_loc2_.getBoolean("blockingHint"));
            _loc3_ = this.getNewTile();
            _loc3_.buildFromMobject(param1);
            _loc4_ = _loc3_.coord;
            this.matrix[_loc4_.x][_loc4_.y] = _loc3_;
         }
      }
      
      private function createMatrix() : void
      {
         this.matrix = new Array(this.size.width);
         var _loc1_:uint = 0;
         while(_loc1_ < this.size.width)
         {
            this.matrix[_loc1_] = new Array(this.size.height);
            _loc1_++;
         }
      }
      
      public function getTileAtCoord(param1:Coord) : Tile
      {
         return this.getTileAt(param1.x,param1.y);
      }
      
      public function dispose() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Tile = null;
         for each(_loc1_ in this.matrix)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.dispose();
            }
         }
         this.matrix = null;
      }
   }
}
