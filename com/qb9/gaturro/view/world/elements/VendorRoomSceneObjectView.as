package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.world.core.elements.VendorRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   
   public final class VendorRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      public function VendorRoomSceneObjectView(param1:VendorRoomSceneObject, param2:TwoWayLink)
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
