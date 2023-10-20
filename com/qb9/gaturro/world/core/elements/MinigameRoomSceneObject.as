package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class MinigameRoomSceneObject extends RoomSceneObject
   {
       
      
      public function MinigameRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get minigame() : String
      {
         return attributes.minigame;
      }
      
      public function get returnId() : uint
      {
         return attributes.returnId;
      }
      
      public function get returnCoord() : Coord
      {
         var _loc1_:String = String(attributes.returnCoord);
         return !!_loc1_ ? Coord.fromArray(_loc1_.split(",")) : null;
      }
   }
}
