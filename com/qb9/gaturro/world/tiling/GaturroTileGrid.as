package com.qb9.gaturro.world.tiling
{
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class GaturroTileGrid extends TileGrid
   {
       
      
      public function GaturroTileGrid()
      {
         super();
      }
      
      override protected function getNewTile() : Tile
      {
         return new GaturroTile();
      }
   }
}
