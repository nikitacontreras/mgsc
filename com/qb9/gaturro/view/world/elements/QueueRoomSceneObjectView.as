package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.view.minigames.QueueModalEvent;
   import com.qb9.gaturro.world.core.elements.QueueRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   
   public final class QueueRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      public function QueueRoomSceneObjectView(param1:QueueRoomSceneObject, param2:TwoWayLink)
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
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         dispatchEvent(new QueueModalEvent(QueueModalEvent.OPEN,this.object.queue,this.object.singlePlayerGame,this.object.id));
      }
      
      private function get object() : QueueRoomSceneObject
      {
         return sceneObject as QueueRoomSceneObject;
      }
   }
}
