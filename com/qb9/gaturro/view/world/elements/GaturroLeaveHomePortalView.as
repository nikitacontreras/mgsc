package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.view.world.cursor.Cursor;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.elements.Portal;
   
   public class GaturroLeaveHomePortalView extends GaturroPortalView
   {
       
      
      public function GaturroLeaveHomePortalView(param1:Portal, param2:TwoWayLink, param3:GaturroRoom, param4:Cursor)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         GaturroRoom(this.room).leaveHouse();
      }
   }
}
