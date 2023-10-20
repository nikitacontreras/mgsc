package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class TileGridPathMap implements PathFinderMap
   {
       
      
      private var grid:TileGrid;
      
      public function TileGridPathMap(param1:TileGrid)
      {
         super();
         this.grid = param1;
      }
      
      public function getEstimatedCost(param1:Coord, param2:Coord) : Number
      {
         return Math.abs(param1.x - param2.x) + Math.abs(param1.y - param2.y);
      }
      
      public function isBlocked(param1:Coord) : Boolean
      {
         var _loc2_:Tile = this.grid.getTileAtCoord(param1);
         return !_loc2_ || _loc2_.blocked || _loc2_.blockedByChildren;
      }
      
      public function getCost(param1:Coord, param2:Coord) : Number
      {
         if(param1.x === param2.x || param1.y === param2.y)
         {
            return 1;
         }
         return Math.SQRT2;
      }
   }
}
