package com.qb9.gaturro.view.world.tiling
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.BasicShapeConfig;
   import com.qb9.flashlib.prototyping.shapes.Parallelogram;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.mambo.view.world.elements.behaviors.RefreshableView;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.tiling.Tile;
   
   public final class GaturroTileView extends Parallelogram implements TileView, RefreshableView
   {
       
      
      private var _tile:Tile;
      
      public function GaturroTileView(param1:Tile, param2:uint, param3:uint, param4:int)
      {
         super(param2,param3,param4,new BasicShapeConfig(-1,0.2,!!this.data.showTiles ? 1 : 0,0,0.2),Anchor.center);
         this._tile = param1;
         this.refresh();
      }
      
      private function get data() : Object
      {
         return settings.debug;
      }
      
      protected function setup() : void
      {
         mouseEnabled = !this.tile.blocked;
      }
      
      public function refresh() : void
      {
         this.setup();
         var _loc1_:uint = Boolean(this.data.showTiles) && this.tile.blocked ? Color.RED : uint(-1);
         paint(_loc1_);
      }
      
      public function get tile() : Tile
      {
         return this._tile;
      }
   }
}
