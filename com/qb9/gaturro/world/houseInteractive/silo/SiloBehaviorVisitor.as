package com.qb9.gaturro.world.houseInteractive.silo
{
   import com.qb9.gaturro.view.world.elements.HomeInteractiveRoomSceneObjectView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   
   public class SiloBehaviorVisitor extends HomeBehavior
   {
       
      
      private var view:HomeInteractiveRoomSceneObjectView;
      
      public function SiloBehaviorVisitor()
      {
         super();
      }
      
      override protected function atStart() : void
      {
         this.view = roomAPI.getView(objectAPI.object) as HomeInteractiveRoomSceneObjectView;
         asset.tooltip.visible = false;
      }
   }
}
