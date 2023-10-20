package com.qb9.gaturro.world.houseInteractive.bosses
{
   import com.qb9.gaturro.view.world.GaturroBossRoomView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class BossRoomBehavior extends HomeBehavior
   {
       
      
      private var bossRoom:GaturroBossRoomView;
      
      private var loadCount:int;
      
      private var step:int;
      
      private var state:int;
      
      public function BossRoomBehavior()
      {
         super();
      }
      
      private function stateInitial() : void
      {
         roomAPI.libraries.fetch("bossFinal.fuego",this.onFetch);
      }
      
      private function onFrame(param1:Event) : void
      {
      }
      
      override protected function atStart() : void
      {
         super.atStart();
         this.bossRoom = roomAPI.roomView as GaturroBossRoomView;
         this.loadCount = roomAPI.getProfileAttribute(this.bossRoom.bossFinal1_KEY + "/loadCount") as int;
         this.state = roomAPI.getProfileAttribute(this.bossRoom.bossFinal1_KEY + "/state") as int;
         this.step = roomAPI.getProfileAttribute(this.bossRoom.bossFinal1_KEY + "/step") as int;
         setTimeout(this.activate,3000);
      }
      
      override public function activate() : void
      {
      }
      
      private function onFetch(param1:DisplayObject) : void
      {
         asset.addChild(param1);
         param1.x = (roomAPI.userAvatar.coord.x - 1) * param1.width;
         param1.y = (roomAPI.userAvatar.coord.y - 1) * param1.height;
      }
   }
}
