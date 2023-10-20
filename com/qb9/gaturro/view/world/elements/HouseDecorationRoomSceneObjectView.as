package com.qb9.gaturro.view.world.elements
{
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class HouseDecorationRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      public function HouseDecorationRoomSceneObjectView(param1:RoomSceneObject, param2:TwoWayLink)
      {
         super(param1,param2);
      }
      
      override public function get captures() : Boolean
      {
         return true;
      }
      
      override public function get isActivable() : Boolean
      {
         return true;
      }
   }
}
