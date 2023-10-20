package com.qb9.gaturro.world.houseInteractive.silo
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.world.elements.HomeInteractiveRoomSceneObjectView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import flash.events.Event;
   
   public class SiloBehavior extends HomeBehavior
   {
       
      
      private var view:HomeInteractiveRoomSceneObjectView;
      
      public function SiloBehavior()
      {
         super();
      }
      
      override public function activate() : void
      {
         if(api.roomOwnedByUser)
         {
            api.showSiloModal(asset);
            asset.gotoAndStop("abierto");
         }
      }
      
      private function onMouseOut(param1:Event) : void
      {
         asset.tooltip.visible = false;
      }
      
      private function onMouseOver(param1:Event) : void
      {
         asset.tooltip.visible = true;
      }
      
      override protected function atStart() : void
      {
         this.view = roomAPI.getView(objectAPI.object) as HomeInteractiveRoomSceneObjectView;
         asset.tooltip.visible = false;
         if(isOwner)
         {
            this.view.addEventListener(HomeInteractiveRoomSceneObjectView.TOOLTIP_IN,this.onMouseOver);
            this.view.addEventListener(HomeInteractiveRoomSceneObjectView.TOOLTIP_OUT,this.onMouseOut);
         }
      }
   }
}
