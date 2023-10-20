package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class QueueRoomSceneObject extends RoomSceneObject
   {
       
      
      public function QueueRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get queue() : String
      {
         return attributes.queue;
      }
      
      public function get singlePlayerGame() : String
      {
         return attributes.singlePlayerGame;
      }
   }
}
