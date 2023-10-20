package com.qb9.gaturro.view.world.elements
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import flash.events.Event;
   
   public class OwnedNpcRoomSceneObjectView extends NpcRoomSceneObjectView implements NamedView
   {
       
      
      public function OwnedNpcRoomSceneObjectView(param1:NpcRoomSceneObject, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink, param5:GaturroRoom, param6:GaturroRoomAPI)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function init() : void
      {
         super.init();
         this.ownedNpc.avatar.addEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.triggerOwnerWalk);
      }
      
      public function get displayHeight() : uint
      {
         return 55;
      }
      
      private function triggerOwnerWalk(param1:Event) : void
      {
         trigger(NpcBehaviorEvent.OWNER_MOVED);
      }
      
      private function get ownedNpc() : OwnedNpcRoomSceneObject
      {
         return sceneObject as OwnedNpcRoomSceneObject;
      }
      
      public function get displayName() : String
      {
         return this.ownedNpc.onwedNpcName;
      }
      
      override public function dispose() : void
      {
         if(this.ownedNpc.avatar)
         {
            this.ownedNpc.avatar.removeEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.triggerOwnerWalk);
         }
         super.dispose();
      }
   }
}
