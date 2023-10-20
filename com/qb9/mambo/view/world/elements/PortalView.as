package com.qb9.mambo.view.world.elements
{
   import com.qb9.flashlib.color.*;
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.Circle;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.elements.Portal;
   
   public class PortalView extends RoomSceneObjectView
   {
      
      private static const COLORS:Array = [Color.BLACK,5592405,10066329];
      
      private static const TOTAL:uint = 9;
       
      
      protected var room:Room;
      
      public function PortalView(param1:Portal, param2:TwoWayLink, param3:Room)
      {
         super(param1,param2);
         this.room = param3;
      }
      
      override protected function init() : void
      {
         var _loc1_:int = int(COLORS.length - 1);
         while(_loc1_ >= 0)
         {
            addChild(new Circle((_loc1_ + 1) / COLORS.length * TOTAL,COLORS[_loc1_],Anchor.center));
            _loc1_--;
         }
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         var _loc2_:RoomLink = Portal(sceneObject).link;
         this.room.changeTo(_loc2_);
      }
   }
}
