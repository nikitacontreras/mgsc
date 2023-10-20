package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class ImageRoomSceneObject extends RoomSceneObject
   {
       
      
      public function ImageRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get image() : String
      {
         return attributes.image;
      }
   }
}
