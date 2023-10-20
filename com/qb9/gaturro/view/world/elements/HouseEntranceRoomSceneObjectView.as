package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.view.gui.home.HouseEntranceEvent;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class HouseEntranceRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      public function HouseEntranceRoomSceneObjectView(param1:RoomSceneObject, param2:TwoWayLink)
      {
         super(param1,param2);
      }
      
      override public function get isActivable() : Boolean
      {
         return true;
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         dispatchEvent(new HouseEntranceEvent(HouseEntranceEvent.ACTIVATE));
      }
   }
}
