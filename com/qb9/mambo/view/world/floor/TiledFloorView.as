package com.qb9.mambo.view.world.floor
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.Rect;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.view.MamboView;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import flash.display.DisplayObject;
   
   public class TiledFloorView extends MamboView
   {
       
      
      private var grid:TileGrid;
      
      public function TiledFloorView(param1:TileGrid)
      {
         super();
         this.grid = param1;
         mouseEnabled = false;
         mouseChildren = false;
         this.generate();
      }
      
      protected function createFloorTile(param1:Tile) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:uint = param1.blocked ? Color.BLUE : Color.GREEN;
         var _loc3_:Coord = param1.coord;
         (_loc4_ = new Rect(20,20,_loc2_,Anchor.center)).x = _loc3_.x * 21 + 10;
         _loc4_.y = _loc3_.y * 21 + 10;
         return _loc4_;
      }
      
      private function addTileAt(param1:int, param2:int) : void
      {
         var _loc3_:Tile = this.grid.getTileAt(param1,param2);
         var _loc4_:DisplayObject = this.createFloorTile(_loc3_);
         addChild(_loc4_);
      }
      
      private function generate() : void
      {
         var _loc4_:uint = 0;
         var _loc1_:uint = uint(this.grid.size.width);
         var _loc2_:uint = uint(this.grid.size.height);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.addTileAt(_loc3_,_loc4_);
               _loc4_++;
            }
            _loc3_++;
         }
      }
   }
}
