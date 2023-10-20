package com.qb9.gaturro.world.tiling
{
   import com.qb9.flashlib.lang.any;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.path.EightWayPathFinder;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class GaturroPathFinder extends EightWayPathFinder
   {
       
      
      private var grid:TileGrid;
      
      public function GaturroPathFinder(param1:TileGrid, param2:Boolean = false, param3:int = 0)
      {
         super(param2,param3);
         this.grid = param1;
      }
      
      private function containsHomeInteractive(param1:Coord) : Boolean
      {
         var _loc2_:Tile = this.grid.getTileAtCoord(param1);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Array = _loc2_.children;
         return any(_loc3_,this.isHomeInteractive);
      }
      
      private function isHolder(param1:RoomSceneObject) : Boolean
      {
         return param1 is HolderRoomSceneObject;
      }
      
      private function isHomeInteractive(param1:RoomSceneObject) : Boolean
      {
         return param1 is HomeInteractiveRoomSceneObject;
      }
      
      private function containsHolder(param1:Coord) : Boolean
      {
         var _loc2_:Tile = this.grid.getTileAtCoord(param1);
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:Array = _loc2_.children;
         return any(_loc3_,this.isHolder);
      }
      
      override protected function isFree(param1:Coord) : Boolean
      {
         if(param1.equals(dest))
         {
            if(this.containsHomeInteractive(param1))
            {
               return false;
            }
            return this.containsHolder(param1) || super.isFree(param1);
         }
         return super.isFree(param1);
      }
   }
}
