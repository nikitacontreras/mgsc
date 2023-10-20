package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.MinigameRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   
   public final class MinigameRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      private var room:GaturroRoom;
      
      public function MinigameRoomSceneObjectView(param1:MinigameRoomSceneObject, param2:TwoWayLink, param3:GaturroRoom)
      {
         super(param1,param2);
         this.room = param3;
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
      
      override public function get captures() : Boolean
      {
         return true;
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         this.room.startMinigame(this.object.minigame,this.object.returnId,this.object.returnCoord);
      }
      
      override public function get isActivable() : Boolean
      {
         return true;
      }
      
      private function get object() : MinigameRoomSceneObject
      {
         return sceneObject as MinigameRoomSceneObject;
      }
   }
}
