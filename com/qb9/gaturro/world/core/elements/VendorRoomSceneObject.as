package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class VendorRoomSceneObject extends RoomSceneObject
   {
       
      
      public function VendorRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get catalogName() : String
      {
         return attributes.catalog;
      }
   }
}
