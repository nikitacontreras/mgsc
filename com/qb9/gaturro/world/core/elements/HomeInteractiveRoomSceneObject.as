package com.qb9.gaturro.world.core.elements
{
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import com.qb9.gaturro.world.houseInteractive.bosses.BossRobotBehavior;
   import com.qb9.gaturro.world.houseInteractive.bosses.BossRoomBehavior;
   import com.qb9.gaturro.world.houseInteractive.buyer.BuyerBehavior;
   import com.qb9.gaturro.world.houseInteractive.buyer.BuyerBehaviorVisitor;
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import com.qb9.gaturro.world.houseInteractive.navidad.NavidadBehavior;
   import com.qb9.gaturro.world.houseInteractive.navidad.NavidadBehaviorVisitor;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloBehavior;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloBehaviorVisitor;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class HomeInteractiveRoomSceneObject extends RoomSceneObject
   {
       
      
      protected var _stateMachine:HomeBehavior;
      
      protected var _isOwner:Boolean;
      
      public function HomeInteractiveRoomSceneObject(param1:CustomAttributes, param2:TileGrid, param3:Boolean)
      {
         this._isOwner = param3;
         super(param1,param2);
         if(param1.stateMachine == "granja")
         {
            this._stateMachine = new GranjaBehavior();
         }
         if(param1.stateMachine == "silo")
         {
            if(param3)
            {
               this._stateMachine = new SiloBehavior();
            }
            else
            {
               this._stateMachine = new SiloBehaviorVisitor();
            }
         }
         if(param1.stateMachine == "buyer")
         {
            if(param3)
            {
               this._stateMachine = new BuyerBehavior();
            }
            else
            {
               this._stateMachine = new BuyerBehaviorVisitor();
            }
         }
         if(param1.stateMachine == "navidad")
         {
            if(param3)
            {
               this._stateMachine = new NavidadBehavior();
            }
            else
            {
               this._stateMachine = new NavidadBehaviorVisitor();
            }
         }
         if(param1.stateMachine == "bossRobot")
         {
            this._stateMachine = new BossRobotBehavior();
         }
         if(param1.stateMachine == "bossRoomBehavior")
         {
            this._stateMachine = new BossRoomBehavior();
         }
         if(this._stateMachine)
         {
            this._stateMachine.isOwner = this._isOwner;
         }
      }
      
      public function get stateMachine() : HomeBehavior
      {
         return this._stateMachine;
      }
      
      override public function get monitorAttributes() : Boolean
      {
         return true;
      }
      
      override public function dispose() : void
      {
         if(this._stateMachine)
         {
            this.stateMachine.dispose();
         }
         super.dispose();
      }
   }
}
