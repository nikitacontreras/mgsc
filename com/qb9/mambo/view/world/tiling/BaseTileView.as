package com.qb9.mambo.view.world.tiling
{
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.Rect;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.view.MamboView;
   import com.qb9.mambo.world.tiling.Tile;
   
   public class BaseTileView extends MamboView implements TileView
   {
       
      
      private var _tile:Tile;
      
      public function BaseTileView(param1:Tile)
      {
         super();
         this._tile = param1;
         this.setup();
         this.draw();
      }
      
      protected function setup() : void
      {
         mouseEnabled = buttonMode = !this.tile.blocked;
         mouseChildren = false;
      }
      
      protected function draw() : void
      {
         var _loc1_:Rect = null;
         var _loc2_:Coord = null;
         _loc1_ = new Rect(20,20,-1,Anchor.center);
         _loc2_ = this.tile.coord;
         x = _loc2_.x * 21 + 10;
         y = _loc2_.y * 21 + 10;
         addChild(_loc1_);
      }
      
      public function get tile() : Tile
      {
         return this._tile;
      }
   }
}
