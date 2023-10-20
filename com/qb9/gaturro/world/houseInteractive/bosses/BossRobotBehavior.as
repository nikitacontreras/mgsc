package com.qb9.gaturro.world.houseInteractive.bosses
{
   import com.qb9.gaturro.view.world.GaturroBossRoomView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   
   public class BossRobotBehavior extends HomeBehavior
   {
       
      
      private var roomView:GaturroBossRoomView;
      
      private var hit:Boolean = false;
      
      public function BossRobotBehavior()
      {
         super();
         if(asset)
         {
            asset.stop();
         }
      }
      
      override public function activate() : void
      {
         if(!asset.escudo.visible)
         {
            this.toggleSize();
            this.hit = true;
            roomAPI.shakeRoom(1500,3);
            if(this.roomView.state < 3)
            {
               roomAPI.moveToTileXY(roomAPI.userAvatar.coord.x + 5,roomAPI.userAvatar.coord.y);
            }
            this.setPartStates();
         }
      }
      
      public function setSmallSize() : void
      {
         asset.escudo.visible = true;
      }
      
      override protected function atStart() : void
      {
         this.roomView = roomAPI.roomView as GaturroBossRoomView;
         asset.gotoAndStop(1);
         this.setSmallSize();
         this.setPartStates();
      }
      
      public function defeat() : void
      {
         asset.gotoAndPlay("derrotado");
      }
      
      public function toggleSize() : void
      {
         if(Boolean(asset) && Boolean(asset.escudo))
         {
            this.setSmallSize();
         }
         else
         {
            this.returnToSize();
         }
      }
      
      private function setPartStates() : void
      {
         if(this.roomView.state)
         {
            switch(this.roomView.state)
            {
               case 3:
                  asset.fuego.gotoAndPlay("golpeado");
                  asset.boca.gotoAndPlay("golpeado");
               case 2:
                  asset.lamparas.gotoAndPlay("golpeado");
                  break;
               case 1:
            }
            asset.ojos.gotoAndStop("golpeado");
            asset.rayos.gotoAndPlay("golpeado");
            return;
         }
      }
      
      public function hitThisUpdate() : Boolean
      {
         var _loc1_:Boolean = this.hit;
         this.hit = false;
         return _loc1_;
      }
      
      public function returnToSize() : void
      {
         if(Boolean(asset) && Boolean(asset.escudo))
         {
            asset.escudo.visible = false;
         }
      }
   }
}
